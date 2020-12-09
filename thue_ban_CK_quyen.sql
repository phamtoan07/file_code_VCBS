select * from tltx where tltxcd like '%8878%' order by tltxcd ;
select * from fldmaster where objname like '%8878%' order by objname, odrnum;
select * from fldval where objname like '%8878%' order by objname, odrnum;

fn_get_semast_avl_withdraw = least(se.trade - V_GETSELLORDERINFO.secureamt + V_GETSELLORDERINFO.sereceiving, txpks_check.fn_sewithdrawcheck.AVLSEWITHDRAW);
fn_GetCKLL_AF = MOD( se.trade - NVL (b.secureamt, 0) + NVL(b.sereceiving,0) / Số lô GD ) -> Số lô lẻ = chia dư của số dư CK/Số lô theo tiểu khoản
fn_GetCKLL = Sum (số lô lẻ của từng tiểu khoản)
fn_GetCKLL_CA: Số lô lẻ của CK quyền = Sum (số dư CK quyền của TK CK/tradelot) trong sepitlog

select * from user_source where upper(text) like '%INSERT INTO SEPITLOG%'

select * from user_source where upper(text) like '%FN_EXECUTECONTRACTCAEVENT%';


CSPKS_CAPROC	PACKAGE BODY	505
CSPKS_CAPROC	PACKAGE BODY	542
CSPKS_CAPROC	PACKAGE BODY	2091
CSPKS_CAPROC	PACKAGE BODY	2119


select * from tltx where tltxcd in ('2242','2268'); -- chuyển CK nội bộ

--codeid 01, tiều khoản 02, số LK 88, số TK CK bán 03
--23 số dư hiện tại -> fn_get_semast_avl_withdraw(02,01)
--số CK lẻ tiểu khoản 94 -> fn_GetCKLL_AF(02,01)
--số CK lẻ tài khoản 93 ->  fn_GetCKLL (88,01)
--số lượng 10 -> tự nhập
--giá 11: FLOORPRICE theo codeid
--Đơn vị giao dịch tradelot 13 
--Thuế, Thuế TNCN 14,15 : 14 = fn_Get_TAX (10,11,88), 15  = 03TAXAMT
--CK quyền 18: fn_GetCKLL_CA (02,01)
--Thuế bán CK quyền = fn_Get_TAXLL (10,11,88,02,01)



select  * from txmapglrules
where tltxcd =v_tltxcd
select * from fldmaster where objname like '%TXMAPGLRULES';
select * from grmaster where grname like '%TXMAPGLRULES';
SELECT *
FROM FLDAMTEXP WHERE MODCODE='SA' AND OBJNAME='SA.TXMAPGLRULES' AND FLDNAME='8894' ORDER BY ODRNUM


SELECT * FROM FLDMASTER WHERE OBJNAME = '8894';

SELECT * FROM APPMAP WHERE TLTXCD= '8894';

SELECT * FROM V_APPMAP_BY_TLTXCD WHERE TLTXCD = '0066';

-- 4 loại A,B,C,D
-- A: Thu nhập từ chuyển nhượng CK
-- B: Thu nhập từ chuyển nhượng, đáo hạn, hủy niêm yết chứng quyền
-- C: Thu nhập từ đầu tư vốn (chuyển nhượng cổ phiếu quyền)
-- D: Thu nhập từ đầu tư vốn khác

SELECT * FROM TLTX WHERE TLTXCD IN('0066','3350','1110','8894','1137','2226');
select * from fldmaster where objname = '0066';
select * from appmap where tltxcd = '0066'; -- 0011 0028
 
select * from fldmaster where objname = '3350';
select * from appmap where tltxcd = '3350';

select * from fldmaster where objname = '1110';
select * from appmap where tltxcd = '1110';

select * from fldmaster where objname = '1137';
select * from appmap where tltxcd = '1137';

select * from fldmaster where objname = '8894';
select * from appmap where tltxcd = '8894';

SELECT CUSTID,(CASE WHEN TLTXCD='0066' AND TXCD='0011' THEN NAMT
           WHEN  TLTXCD in( '3350','1110') AND TXCD='0011' THEN NAMT
           WHEN  TLTXCD='8894' AND TXCD='0011' THEN NAMT
           WHEN  TLTXCD='1137' AND TXCD='0012' THEN -NAMT
           ELSE 0 END) AMT, TLTXCD,
          (CASE WHEN TLTXCD='0066'  AND TXCD='0011'  THEN NAMT/0.001
           WHEN  TLTXCD='3350' AND TXCD='0012' THEN NAMT
           WHEN  TLTXCD='1110' AND TXCD='0012' AND instr (trdesc,'l')>0  THEN NAMT
           WHEN  TLTXCD='8894' AND TXCD='0029' THEN NAMT
           ELSE 0 END) NAMT,
           (CASE WHEN TLTXCD='0066' AND TXCD='0011' THEN 'A'
                 WHEN TLTXCD IN ('3350','1110') AND TXCD='0011' THEN 'A'
                 WHEN TLTXCD='1137' AND TXCD='0011' THEN 'A',
                 WHEN TLTXCD='8894' AND TXCD='0011' THEN 
                      (CASE WHEN instr (trdesc,'l')>0 THEN 'A'
                            WHEN instr (trdesc,'l')>0
            END) TYPE_CI
        FROM VW_CITRAN_GEN
        WHERE TLTXCD in ('0066','3350','8894','1137','1110')
              AND TXCD in ('0011','0012','0029')
              AND TXDATE BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
      UNION ALL
         SELECT af.custid,  tax  amt, '2266' tltxcd ,tax/0.001 namt  FROM sesendout se,afmast af
         WHERE substr( se.acctno,1,10) = af.acctno
          AND TO_DATE( SUBSTR( id2266,1,10),'DD/MM/YYYY') BETWEEN to_date(F_DATE,'DD/MM/YYYY') AND to_date(T_DATE,'DD/MM/YYYY')
          AND deltd <>'Y'
          
          
 select * from sesendout;
