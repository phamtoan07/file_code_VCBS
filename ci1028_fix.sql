select * from VW_CITRAN_GEN where tltxcd = '1110' and txcd = '0012' order by autoid desc;

select * from user_source where upper(text) like '%PR_CALCI1110%';
select * from allcode where cdname = 'CATYPE';
---
select instr('Số tiền lãi được hưởng','l') from dual;

select * from VW_CITRAN_GEN where tltxcd = '1110';

-------

SELECT * FROM (
 SELECT CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE, SUM(CASE WHEN CF.VAT = 'Y' then NVL(AMT,0) ELSE 0 END  ) AMT,
      SUM(CASE WHEN CF.VAT = 'Y' THEN  NVL(NAMT,0)ELSE 0 END )  NAMT,
      (CASE WHEN CF.CUSTTYPE='I' AND CF.COUNTRY='234' THEN 'IN'
      WHEN CF.CUSTTYPE='B' AND CF.COUNTRY='234' THEN 'BN'
      WHEN CF.CUSTTYPE='I' AND CF.COUNTRY<>'234' THEN 'IO'
      WHEN CF.CUSTTYPE='B' AND CF.COUNTRY<>'234' THEN 'BO' ELSE '' END ) TYPE_KH,
      CF.CUSTTYPE,
      TAX.TYPE_CI,
      max(cf.tradename) tradename
FROM (SELECT CF.*, NVL(GL.BRIDGL,CF.BRID) GLBRID , nvl(gl.tradename,gr.brname) tradename
      FROM (select nvl(t.tradename,gl.glname) tradename, gl.bridgl,GL.GRPID
           from  grpglmap gl,
                 (select tc.grpid, tp.tradename
                 from tradecareby tc, tradeplace tp
                 where tc.tradeid = tp.traid) t
           where gl.grpid = t.grpid
           and gl.status = 'A') gl,
           (SELECT * FROM CFMAST ) CF,
           brgrp gr
      WHERE CF.CAREBY=GL.GRPID(+)
      and cf.brid = gr.brid
     ) CF,
     (
      SELECT VW.CUSTID,
        (CASE WHEN VW.TLTXCD='0066' AND VW.TXCD IN ('0011','0028') THEN VW.NAMT
              WHEN  VW.TLTXCD in( '3350','1110') AND VW.TXCD='0011' THEN VW.NAMT
              WHEN  VW.TLTXCD='8894' AND VW.TXCD='0011' THEN VW.NAMT
              WHEN  VW.TLTXCD='1137' AND VW.TXCD='0012' THEN -VW.NAMT
         ELSE 0 END) AMT, VW.TLTXCD, N.NAMT,
         N.CICODE TYPE_CI
      FROM VW_CITRAN_GEN VW,
             (SELECT CUSTID, TXNUM, TXDATE, TLTXCD,
                     sum(CASE WHEN TLTXCD='0066' AND TXCD='0011'  THEN NAMT/0.001
                              WHEN  TLTXCD='3350' AND TXCD='0012' THEN NAMT
                              WHEN  TLTXCD='1110' AND TXCD='0012' AND instr (trdesc,'l')>0  THEN NAMT
                              WHEN  TLTXCD='8894' AND TXCD='0029' THEN NAMT
                         ELSE 0 END) NAMT,
                    (CASE WHEN TLTXCD IN ('0066','8894','1137') THEN 'A'
                          WHEN TLTXCD='3350'  THEN 'B'
                          WHEN TLTXCD='1110'  THEN 'D'
                          ELSE 'D' END) CICODE
              FROM VW_CITRAN_GEN
              WHERE  TLTXCD IN ('0066','3350','8894','1137','1110')
                     AND TXCD in ('0011','0012','0029','0028')
                     --AND TXDATE BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
              GROUP BY CUSTID, TXNUM, TXDATE,TLTXCD,
                     (CASE WHEN TLTXCD IN ('0066','8894','1137') THEN 'A'
                           WHEN TLTXCD='3350'  THEN 'B'
                           WHEN TLTXCD='1110'  THEN 'D'
                           ELSE 'D' END)
              UNION ALL
              SELECT DISTINCT CUSTID, TXNUM, TXDATE,TLTXCD, 0 NAMT, 'C' CICODE
              FROM VW_CITRAN_GEN 
              WHERE TLTXCD IN ('0066','8894')
                    --AND TXDATE BETWEEN TO_DATE(F_DATE,'DD/MM/YYYY') AND TO_DATE(T_DATE,'DD/MM/YYYY') 
              GROUP BY CUSTID, TXNUM, TXDATE,TLTXCD
              ) N
      WHERE VW.TLTXCD in ('0066','3350','8894','1137','1110')
              AND VW.TXCD in ('0011','0012','0028')
              AND VW.CUSTID = N.CUSTID AND VW.TXNUM = N.TXNUM AND VW.TXDATE = N.TXDATE
              AND (CASE WHEN VW.TLTXCD IN ('0066') THEN (CASE WHEN VW.TXCD = '0011' THEN 'A' ELSE 'C' END)
                        WHEN VW.TLTXCD IN ('8894') THEN (CASE WHEN VW.TXCD = '0011' AND INSTR(VW.TRDESC,'CT=CP')=0 THEN 'A' ELSE 'C' END)
                        WHEN VW.TLTXCD IN ('1137','2226') THEN 'A'
                        WHEN VW.TLTXCD IN ('3350') THEN 'B'
                   ELSE 'D' END
                   ) = N.CICODE
      UNION ALL
      SELECT af.custid,  tax  amt, '2266' tltxcd ,tax/0.001 namt, 'A' CICODE FROM sesendout se,afmast af
      WHERE substr( se.acctno,1,10) = af.acctno
            --AND TO_DATE( SUBSTR( id2266,1,10),'DD/MM/YYYY') BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
            AND deltd <>'Y'
      ) TAX
WHERE CF.CUSTID=TAX.CUSTID
      GROUP BY CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE,CF.CUSTTYPE,CF.COUNTRY,TAX.TYPE_CI )
WHERE AMT<>0
ORDER BY CUSTODYCD, AMT
