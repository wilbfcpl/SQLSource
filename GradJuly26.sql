
/**************************************************************************************************
CARLX AD-HOC REPORT LIBRARY- SSC Updates for FCPS 12th Grade GRADUATES
Version: 1.0
Owner: FCPL
Database: CARL.X Oracle
Date: 07/10/2026
Note: Consistently sort the CSV / XLS file for simplified testing.
Note: CSV columns patronid,first,middle,last,grade,schooladdr,city,state,zip,status,regdate,dob,
****************************************************************************************************/


-- GRAD Students from FCPS in table GRADS not found in Patron table

select
       grads.patronid, grads.first, grads.last, grads.grade,
       grads.schooladdr, grads.status,
       grads.status,
       trunc(grads.regdate)
    from patron_v2 student
   left outer join GRAD grads ON grads.patronid=student.patronid
    --join GRAD grads ON grads.patronid=student.patronid
    where student.patronid is null
    order by grads.regdate desc, LASTNAME;

-- GRAD table records matched with STUDENT borrowers in Patron Table
-- before the Patron Loader updates the borrower type to GRAD
select
       grads.patronid, student.name, bstatus.description status,btycode,udf.valuename grade,
       jts.todate(student.regdate)reg,trunc(editDate)edit, student.street1
       -- ,grads.schooladdr
       -- ,note.text

    from patron_v2 student
    inner join GRAD grads ON grads.patronid=student.patronid
    inner join bty_v2 profile on student.bty=profile.BTYNUMBER
    inner join BRANCH_V2 branch on defaultbranch=BRANCHNUMBER
    inner join bst_v2 bstatus on student.status = bstatus.bst
    inner join udfpatron_v2 udf on student.patronid=udf.patronid
    inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID and upper(label.label)='GRADE'
    order by grads.regdate desc, LASTNAME;

-- Fixes for GRAD grade having decimal value 12.0. Perhaps a display issue in DataGrip
UPDATE GRAD
set GRADE= FLOOR(GRADE)
;
select floor(GRADE) from GRAD;
select round(GRADE,0) from GRAD;
select GRADE from Grad;


--Before PatronLoader run
--GRAD table PATRON_V2 info before PatronLoader .

select student.patronid , student.name, udf.valuename grade,student.street1,
       student.city1, student.state1, student.zip1, student.status, bstatus.description status, bty, BTYCODE,
       jts.todate(student.regDATE) todate_regdate,trunc(editDate), ','  dob

from patron_v2 student
    inner join GRAD grads ON grads.patronid=student.patronid
    inner join bty_v2 profile on student.bty=profile.BTYNUMBER
    inner join BRANCH_V2 branch on defaultbranch=BRANCHNUMBER
    inner join bst_v2 bstatus on student.status = bstatus.bst
    inner join udfpatron_v2 udf on student.patronid=udf.patronid
    inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID and upper(label.label)='GRADE'
--inner join patronnotetext_v2 note on student.patronid=note.refid
--where  btycode ='GRAD'
;

-- Graduated Students with REGDATE/EDITDATE 07/08/2026
select student.patronid , student.name, bstatus.description status, BTYCODE,
       jts.todate(student.regDATE) regdate,editDate,note.text
from patron_v2 student
    inner join bty_v2 profile on student.bty=profile.BTYNUMBER
    inner join BRANCH_V2 branch on defaultbranch=BRANCHNUMBER
    inner join bst_v2 bstatus on student.status = bstatus.bst
inner join patronnotetext_v2 note on student.patronid=note.refid
where  btycode ='GRAD' and jts.todate(regdate)='08-JUL-2026' and note.text is null ;


--Graduated with note added
select
     student.patronid , student.name, udf.valuename grade, bstatus.description status, branch.branchcode branch, BTYCODE,
     editDate,note.text
    from patron_v2 student
    inner join GRAD grads ON grads.patronid=student.patronid
    inner join bty_v2 profile on student.bty=profile.BTYNUMBER
    inner join BRANCH_V2 branch on defaultbranch=BRANCHNUMBER
    inner join bst_v2 bstatus on student.status = bstatus.bst
    inner join udfpatron_v2 udf on student.patronid=udf.patronid
    inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID and upper(label.label)='GRADE'
    inner join patronnotetext_v2 note on student.patronid=note.refid
    where upper(note.text) like 'GRADUATED%'
    order by patronid;

-- Select Notes to Delete for testing, cleanup, etc.
select patronid, noteid, status,bty, name,street1 ,  notetext.text from patron_v2
    inner join patronnotetext_v2 notetext on patronid = refid

             where ( patronid in ( select patronid from GRAD )
and upper(notetext.text) like 'GRADUATED%' );

