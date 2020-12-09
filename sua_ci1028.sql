select * from tltx where tltxcd in ('0066','3350','1110','1137','8894');

select * from user_source where upper(text) like '%TXPKS_#0066EX%';

select * from tltx where tltxcd = '0066';
select * from fldmaster where objname= '0066';
select tltxcd, apptype, tblname, apptxcd, amtexp, txtype, field, trdesc from v_appmap_by_tltxcd where tltxcd =  '0066';

select * from tltx where tltxcd = '3350';
select * from fldmaster where objname= '3350';
select tltxcd, apptype, tblname, apptxcd, amtexp, txtype, field, trdesc from v_appmap_by_tltxcd where tltxcd =  '3350';

select * from tltx where tltxcd = '1110'; -- goij auto tu ciproc
select * from fldmaster where objname= '1110';
select tltxcd, apptype, tblname, apptxcd, amtexp, txtype, field, trdesc from v_appmap_by_tltxcd where tltxcd =  '1110';

3350 -> chuyển thành mục 2
1110 -> chuyển thành mục 4
thu nhập từ chuyển nhượng CP quyền
