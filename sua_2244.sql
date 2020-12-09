select '001' VALUECD,'001' VALUE,'Chuyển khoản chứng khoán' DISPLAY,'Chuyển khoản chứng khoán' EN_DISPLAY,'Chuyển khoản chứng khoán'  DESCRIPTION from dual union
select '002' VALUECD,'002' VALUE,'Chuyển nhượng chứng khoán không qua sàn' DISPLAY,'Chuyển nhượng chứng khoán không qua sàn' EN_DISPLAY,'Chuyển nhượng chứng khoán không qua sàn'  DESCRIPTION from dual

selecT * from apptx where txcd in ('0043','0087','0051','0052','0012') and tranf = 'SETRAN';

EMKQTTY  BLOCKED -> 06 C
DCRQTTY  DCRAMT  -> 12, 12*09 C
TRADE            -> 10 C

select * from user_source where upper(text) like '%INSERT INTO SEDEPOWFTLOG%';

select * from tltx where tltxcd = '2244';
select * from search where searchcode = 'SE2244';
select * from searchfld where searchcode = 'SE2244' order by position;
select * from fldmaster where objname = '2244' order by odrnum;
select * from fldval where objname = '2244' order by odrnum; --v_se2244
select * from v_appmap_by_tltxcd where tltxcd = '2244';
FN_GETFEE2244 FN_GETTAX2244
------ 

select * from rptmaster where rptid = 'SE2255_1';
select * from rptfields where objname = 'SE2255_1' for update;

select * from search where searchcode = 'SE2255_1' for update;
select * from searchfld where searchcode = 'SE2255_1' for update;


---
select * from tlog where luser =  user order by id desc;
