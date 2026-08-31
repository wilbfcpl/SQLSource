
/**************************************************************************************************
CARLX AD-HOC REPORT LIBRARY- SSC Updates for FCPS Start of School Year Import
Version: 1.0
Owner: FCPL
Database: CARL.X Oracle
Date: 07/10/2026
Note: Consistently sort the CSV / XLS file for simplified testing.
Note: CSV columns patronid,first,middle,last,grade,schooladdr,city,state,zip,status,regdate,dob,
****************************************************************************************************/

-- Student Barcodes with a DOB and borrower type not STUDNT or GRAD
select patronid,name,street1,birthdate, btycode, branchcode,userid,editdate,actdate, regdate,status from patron_v2
inner join bty_v2 on patron_v2.bty=bty_v2.btynumber
inner join branch_v2 branch on branch.branchnumber=patron_v2.regbranch
where (btycode!='STUDNT' AND btycode != 'GRAD')  and PATRONID like '119829%' and birthdate is not null
order by name ;


--StudentsDOB has the accounts from the above SQL
select student.patronid,student.name,student.street1,student.birthdate, student.regdate, student.editdate,student.status
from patron_v2 student inner join "StudentsDOB" dob on student.patronid=dob.patronid ;


-- Emails with MyFCPS.org
select * from patron_v2 patron where patron.email like '%my.fcps.org' and patronid like '______';


select patron.patronid ,patron.NAME,patron.email, patron.EMAILNOTICES,type.BTYCODE, branch.BRANCHCODE,trunc(patron.REGDATE) from patron_v2 patron
         inner join BTY_V2 type on patron.bty=BTYNUMBER
         inner join BRANCH_V2 branch on patron.REGBRANCH = branch.BRANCHNUMBER
         where patron.email like '%my.fcps.org' and BTYCODE = 'STUDNT'
;

-- 01/01/2026 Last Month New Student Cards from FCPS, e.g. trunc(regdate)='31-DEC-25'
-- Calculates last day of previous month.
-- Last Month: trunc(regdate)  between ADD_MONTHS(trunc(sysdate,'MM') ,-1 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,-1 ))

select student.patronid, student.firstname, student.lastname, student.middlename,udf.VALUENAME grade,
       street1, student.city1, student.state1, student.zip1, student.status,btycode, branchcode,
       trunc(regdate),trunc(editdate), trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
        inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID
    where branchcode ='SSL' and btycode='STUDNT' and upper(label.label)='GRADE'
      --and upper(street1)  like 'MARYLAND%'
 and  trunc(regdate)  between ADD_MONTHS(trunc(sysdate,'MM') ,-1 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,-1 ))

    order by student.lastname ;

--Last Month New Student Cards from FCPS,
select count(student.patronid)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
        inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID
    where branchcode ='SSL' and btycode='STUDNT' and upper(label.label)='GRADE'
      --and upper(street1)  like 'MARYLAND%'
 and  trunc(regdate)  between ADD_MONTHS(trunc(sysdate,'MM') ,-1 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,-1 ))

    order by student.lastname ;


-- Updated FCPS Cards Last Month
select count(student.patronid)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
        inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID
    where branchcode ='SSL' and btycode='STUDNT' and upper(label.label)='GRADE'
      --and upper(street1)  like 'MARYLAND%'
 and  trunc(editdate)  between ADD_MONTHS(trunc(sysdate,'MM') ,-1 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,-1 ))

    order by student.lastname ;

-- If run on the last day of the month
-- Newly added students run on the last day of the month
select count(student.patronid)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
        inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID
    where branchcode ='SSL' and btycode='STUDNT' and upper(label.label)='GRADE'
      --and upper(street1)  like 'MARYLAND%'
 and  trunc(regdate)  between ADD_MONTHS(trunc(sysdate,'MM') ,0 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,0 ))

    order by student.lastname ;

-- Updated Students run on the last day of the month
select count(student.patronid)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
        inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID
    where branchcode ='SSL' and btycode='STUDNT' and upper(label.label)='GRADE'
      --and upper(street1)  like 'MARYLAND%'
 and  trunc(editdate)  between ADD_MONTHS(trunc(sysdate,'MM') ,0 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,0 ))
  order by student.lastname ;

select student.patronid, student.firstname, student.lastname, student.middlename,udf.VALUENAME grade,
       street1, student.city1, student.state1, student.zip1, student.status,btycode, branchcode,
       trunc(regdate),trunc(editdate), trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
        inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID
    where branchcode ='SSL' and btycode='STUDNT' and upper(label.label)='GRADE'
      --and upper(street1)  like 'MARYLAND%'
 and  trunc(editdate)  between ADD_MONTHS(trunc(sysdate,'MM') ,-1 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,-1 ))

    order by student.lastname ;
