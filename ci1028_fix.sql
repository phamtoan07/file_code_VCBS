select * from VW_CITRAN_GEN where tltxcd = '1110' and txcd = '0012' order by autoid desc;

select * from user_source where upper(text) like '%PR_CALCI1110%';
select * from allcode where cdname = 'CATYPE';
---
select instr('Số tiền lãi được hưởng','l') from dual;

select * from VW_CITRAN_GEN where tltxcd = '1110';

-------

SELECT CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE, SUM(CASE WHEN CF.VAT = 'Y' then NVL(AMT,0) ELSE 0 END  ) AMT,
      SUM(CASE WHEN CF.VAT = 'Y' THEN  NVL(NAMT,0)ELSE 0 END )  NAMT,
      (CASE WHEN CF.CUSTTYPE='I' AND CF.COUNTRY='234' THEN 'IN'
      WHEN CF.CUSTTYPE='B' AND CF.COUNTRY='234' THEN 'BN'
      WHEN CF.CUSTTYPE='I' AND CF.COUNTRY<>'234' THEN 'IO'
      WHEN CF.CUSTTYPE='B' AND CF.COUNTRY<>'234' THEN 'BO' ELSE '' END ) TYPE_KH,
      CF.CUSTTYPE,
      (CASE WHEN TAX.TLTXCD IN ('0066') THEN (CASE WHEN TAX.TXCD = '0011' THEN 'A' ELSE 'C' END)
            WHEN TAX.TLTXCD IN ('8894') THEN (CASE WHEN TAX.TXCD = '0011' AND INSTR(TAX.TRDESC,'CT=CP')=0 THEN 'A' ELSE 'C' END)
            WHEN TAX.TLTXCD IN ('1137','2226') THEN 'A'
            WHEN TAX.TLTXCD IN ('3350') THEN 'B'
            ELSE 'D'
       END
      ) TYPE_CI,
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
        SELECT VW.CUSTID,(CASE WHEN VW.TLTXCD='0066' AND VW.TXCD IN ('0011','0028') THEN VW.NAMT
           WHEN  VW.TLTXCD in( '3350','1110') AND VW.TXCD='0011' THEN VW.NAMT
           WHEN  VW.TLTXCD='8894' AND VW.TXCD='0011' THEN VW.NAMT
           WHEN  VW.TLTXCD='1137' AND VW.TXCD='0012' THEN -VW.NAMT
           ELSE 0 END) AMT, VW.TLTXCD, N.NAMT, VW.TXCD,VW.TRDESC,
           --
           N.TXNUM, N.TXDATE 
        FROM VW_CITRAN_GEN VW,
             (SELECT CUSTID,
                         SUM(CASE WHEN TLTXCD='0066' AND TXCD='0011'  THEN NAMT/0.001
                              WHEN  TLTXCD='3350' AND TXCD='0012' THEN NAMT
                              WHEN  TLTXCD='1110' AND TXCD='0012' AND instr (trdesc,'l')>0  THEN NAMT
                              WHEN  TLTXCD='8894' AND TXCD='0029' THEN NAMT
                       ELSE 0 END) NAMT, TXNUM, TXDATE           
              FROM VW_CITRAN_GEN
              WHERE TLTXCD in ('0066','3350','8894','1137','1110')
                    AND TXCD in ('0011','0012','0029','0028')
                    --AND TXDATE BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
                    AND (CASE WHEN TLTXCD='0066'  AND TXCD='0011'  THEN NAMT/0.001
                              WHEN  TLTXCD='3350' AND TXCD='0012' THEN NAMT
                              WHEN  TLTXCD='1110' AND TXCD='0012' AND instr (trdesc,'l')>0  THEN NAMT
                              WHEN  TLTXCD='8894' AND TXCD='0029' THEN NAMT
                       ELSE 0 END) > 0
                    --
                    AND TLTXCD = '1110' AND CUSTID = '0001000102'
              GROUP BY CUSTID, TXNUM, TXDATE 
                    
              SELECT DISTINCT CUSTID TXNUM, TXDATE
                     
              FROM VW_CITRAN_GEN 
              WHERE TLTXCD IN ('8894','0066')
              ) N
        WHERE VW.TLTXCD in ('0066','3350','8894','1137','1110')
              AND VW.TXCD in ('0011','0012','0028')
              --AND TXDATE BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
              AND VW.CUSTID = N.CUSTID AND VW.TXNUM = N.TXNUM AND VW.TXDATE = N.TXDATE
      UNION ALL
         SELECT af.custid,  tax  amt, '2266' tltxcd ,tax/0.001 namt, 'x' TXCD, 'x' TRDESC, SE.TXNUM, SE.TXDATE FROM sesendout se,afmast af
         WHERE substr( se.acctno,1,10) = af.acctno
          --AND TO_DATE( SUBSTR( id2266,1,10),'DD/MM/YYYY') BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
          AND deltd <>'Y'
      ) TAX
WHERE CF.CUSTID=TAX.CUSTID
      GROUP BY CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE,CF.CUSTTYPE,CF.COUNTRY,
      (CASE WHEN TAX.TLTXCD IN ('0066') THEN (CASE WHEN TAX.TXCD = '0011' THEN 'A' ELSE 'C' END)
            WHEN TAX.TLTXCD IN ('8894') THEN (CASE WHEN TAX.TXCD = '0011' AND INSTR(TAX.TRDESC,'CT=CP')=0 THEN 'A' ELSE 'C' END)
            WHEN TAX.TLTXCD IN ('1137','2226') THEN 'A'
            WHEN TAX.TLTXCD IN ('3350') THEN 'B'
            ELSE 'D'
       END
      )
