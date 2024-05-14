select patronid,name,street1,regdate, editdate,status  from patron_v2 where bty=10 and regdate like '07-APR-22%' order by patronid ;
select count(students022522.patronid)  from students022522 inner join patron_v2 on students022522.patronid = patron_v2.patronid  ;
select students022522.patronid, patron_v2.regdate, name , street1 from students022522 inner join patron_v2 on students022522.patronid = patron_v2.patronid  ;
select patronid, status, bty,name ,userid, regby, patronnotetext_v2.text from patron_v2 inner join patronnotetext_v2 on patronid = refid where bty =10 and status ='S' ; 
select patronid, status,bty, name,street1 , noteid, patronnotetext_v2.text from patron_v2 inner join patronnotetext_v2 on patronid = refid where patronid in ( select patronid from students032522) ;
select patronid,name,street1,regdate, editdate  from patron_v2 where bty=10 and regdate like '25-MAR-22%' order by patronid ;
select patronid, status,bty, name,street1 , noteid, patronnotetext_v2.text from patron_v2 inner join patronnotetext_v2 on patronid = refid where patronid in ( select patronid from students021522) ;
select patronid, status, bty,name ,userid, regby, patronnotetext_v2.text from patron_v2 inner join patronnotetext_v2 on patronid = refid where bty =10 and status ='S' ; 
select patronid, status,bty, name,street1, regdate from patron_v2 where patronid in ( select patronid from students021522 ) order by patronid asc fetch next 600 rows only;
select students022522.patronid, patron_v2.regdate, name , street1 from students022522 inner join patron_v2 on students022522.patronid = patron_v2.patronid  ;
select count(students022522.patronid)  from students022522 inner join patron_v2 on students022522.patronid = patron_v2.patronid  ;
--Null Values in various name, address fields
select patron.patronid,patron.name, street1,regdate, editdate,patron.status , regbranch from patron_v2 patron  where bty=10  and ((name is null )  or (firstname is null) or (middlename is null) or (lastname is null) or (patron.status is null) or ( street1 IS NULL) or (city1 is null ) or (State1 Is Null) )order by patronid ;
select patron.patronid,patron.name, street1,regdate, editdate,patron.status , regbranch from patron_v2 patron  
where  bty=10 AND ( middlename LIKE '%NULL%' or street1 like '%NULL%')
order by patronid ;

select  patron.patronid,patron.name,udf.valuename grade, street1,regdate,patron.status from patron_v2 patron inner join udfpatron_v2 udf on patron.patronid=udf.patronid  where bty=10 and regdate like '%-22%' and udf.fieldid=3 order by patronid desc fetch next 500 rows only;
select  patron.patronid,patron.name,udf.valuename grade, street1,regdate,patron.status from patron_v2 patron inner join udfpatron_v2 udf on patron.patronid=udf.patronid  where bty=10 and (patron.patronid is null or patron.name is null or patron.street1 is null or patron.regbranch is null or patron.status is null) and udf.fieldid=3 order by patronid desc fetch next 500 rows only;
select  patron.patronid,patron.name, middlename, street1,patron.status,regdate, editdate, regby from patron_v2 patron  where name like '%NULL%' order by regdate desc ;
select  patron.patronid,patron.name, middlename, street1,patron.status,regdate, editdate, regby from patron_v2 patron  where street1 like 'NULL%' order by regdate desc ; 
select patronid,name,street1,regdate, editdate,status  from patron_v2 where bty=10 and regdate like '19-APR-22%' order by patronid ;
select patronid,name,street1,regdate, editdate,status  from patron_v2 where bty=10 and regdate like '27-APR-22%' order by patronid ;

-- Issues with Default Branch 0 instead of 11 for SSL, Regby NULL, Regdate 0
#Null Regby
select patronid , bty, name, defaultbranch , userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where (bty=10 and ((regby is null) or (regdate is null) ) ) order by patronid ; 
#Null Defaultbranch
select patronid , bty, name, defaultbranch , userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where (bty=10 and defaultbranch!=11 ) order by patronid ; 
select patronid , bty, name, defaultbranch , userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where (bty=10 and regdate like '11-MAY-22%') order by regdate desc ; 
select patronid , bty, name, defaultbranch , userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where patronid='11982920076845' order by regdate desc ;
#create date after July 2022
select patronid , bty, name, defaultbranch , userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where (bty=10 and ((regby is null) or (regdate is null) ) ) order by patronid ; 

#Firstname in PH1
select patronid , bty, ph1, firstname first, name, defaultbranch , status, userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where (bty=10 and  INSTR(PH1,firstname )>0 ) order by editdate desc ; 
select patronid , bty, ph1, firstname first, name, defaultbranch , status, userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where ( INSTR(PH1,firstname )>0 ) order by editdate desc ; 
select patronid , bty, ph1, firstname first, name, defaultbranch , status, userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where (bty=10 and  PH1 IS NULL) order by editdate desc ; 
select patronid , bty, ph1, firstname first, name, defaultbranch , status, userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where (  INSTR(PH1,firstname )>0  AND patronid in (select patronid from STUDENTS060222) ) order by editdate desc ;
select patronid , bty, ph1, firstname first, name, defaultbranch , status, userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where patronid in (select patronid from STUDENTS060222 ) order by patronid ;
select patronid , bty, ph1, firstname first, name, defaultbranch , status, userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where patronid in (select patronid from STUDENTS060722 ) order by patronid ;
select patronid , bty, ph1, firstname first, name, defaultbranch , status, userid, regby, regdate, editdate,defaultbranch from patron_v2 patron where patronid = '&patronid' order by patronid ;

#Date of Birth has data 
select patronid,name,street1,regdate, editdate,status  from patron_v2 where bty=10 and birthdate is not null order by patronid ;
# Name has nonascii
select patronid,firstname, name,street1,regdate, editdate,status  from patron_v2 where (bty=10 and regexp_like(name,'[[::]]')) ;
select patronid,firstname, name,asciistr(name) converted_name, street1,regdate, editdate,status  from patron_v2 where length(asciistr(name)) != length(name);
#every one
select patronid,firstname, name,street1,regdate, editdate,status  from patron_v2 where bty=10 and trunc(regdate,'DD')='23-AUG-2022' order by regdate desc;
select * from patron_v2 where bty=10 order by patronid fetch next 1000 rows only  ;
select patronid, name, street1, regdate from patron_v2 where bty=10 and upper(street1) like '%BLEND%' and trunc(regdate,'DD')='27-JUL-2022';
# Blended virtual issue Aug 24
select students.patronid , last, first, schooladdr, street1, students.regdate from STUDENTSFULL2022 students inner join patron_v2 patron on students.patronid=patron.patronid where students.schooladdr like '%Blend%' ;
#Inactive
--List "inactive" Students based on Registration, Edit, Activity, & Self Serve dates 
--more than 3 years (1096 days) ago
SELECT p.patronguid, p.patronid, trunc(p.regdate) AS regdate, trunc(p.actdate) AS actdate, 
trunc(p.sactdate) AS sactdate, trunc(p.editdate) AS editdate, p.USERID
FROM patron_v2 p
--2=GRAD, 5=JUV, 7=PUBLIC, 10=STUDNT, 11=TEMP, 12=WEBREG, 13=JVOPTO, 14=OPTOUT
--Update date on each run to 3 yrs ago
WHERE p.bty =10 
AND p.regdate < sysdate-1096 
--null is greater than the date so any with null values would be excluded!
AND (p.actdate IS NULL OR p.actdate < sysdate-1096)
AND (p.editdate IS NULL OR p.editdate < sysdate-1096)
AND (p.sactdate IS NULL OR p.sactdate< sysdate-1096)
ORDER BY p.patronguid;

-- Null Editdate Activity Date
SELECT p.patronguid, p.patronid, p.regby as registrar, p.userid as editor,trunc(p.regdate) AS regdate, trunc(p.actdate) AS actdate, 
trunc(p.sactdate) AS sactdate, trunc(p.editdate) AS editdate
FROM patron_v2 p
--2=GRAD, 5=JUV, 7=PUBLIC, 10=STUDNT, 11=TEMP, 12=WEBREG, 13=JVOPTO, 14=OPTOUT
--Update date on each run to 3 yrs ago
--WHERE p.bty =10 
WHERE
 (p.actdate IS NULL)
AND (p.editdate IS NULL)
--null is not less than the date so any with null values will be excluded!
AND (p.sactdate IS NULL)
ORDER BY p.patronguid
--Another Experiment
SELECT p.patronguid, p.patronid, trunc(p.actdate) AS actdate, trunc(p.editdate) AS editdate, 
userid, p.regby, tx.pwd, tx.transactiontype, tx.systemtimestamp
FROM patron_v2 p
LEFT JOIN txlog_v2 tx ON p.patronguid=tx.patronguid
--2=GRAD, 5=JUV, 7=PUBLIC, 10=STUDNT, 11=TEMP, 12=WEBREG, 13=JVOPTO, 14=OPTOUT
WHERE p.bty =10 
AND p.actdate<p.editdate AND p.actdate<sysdate-1096 
AND (p.sactdate IS NULL OR p.sactdate<sysdate-1096)
--list only those with transactions
AND tx.transactiontype IS NOT NULL
ORDER BY p.patronguid ;
select patronid,name,street1,regdate, editdate,status ,userid from patron_v2 where patronid='11982920028271'  ;
select patronid , bty, name, birthdate,street1, defaultbranch , userid, regby, regdate, editdate,actdate, defaultbranch from patron_v2 patron where (bty=10 and defaultbranch=11 and birthdate is not null ) order by patronid ; 

--Beginning of School Year Import July 2022
select student.patronid ,name, street1,student.regdate,actdate,editdate,userid,regby,birthdate,defaultbranch,editbranch,actbranch,sactdate from patron_v2 student inner join student_rejects_072722 rejects on student.patronid =rejects.patronid ;
select * from patron_v2 student inner join student_rejects_072722 rejects on student.patronid =rejects.patronid and student.birthdate is null;
select student.patronid ,name, street1,student.regdate,actdate,editdate,userid,regby,birthdate,defaultbranch,editbranch,actbranch,sactdate from patron_v2 student inner join student_rejects_072722 rejects on student.patronid =rejects.patronid where birthdate is null;

--Sept 15 2022 Student Accounts Deleted in July and subsequently recreated
-- I cannot recall why I did these
select deleted.patronid ,deleted.name, street1,trunc(student.regdate),trunc(actdate),trunc(editdate),userid,regby,birthdate,defaultbranch,editbranch,actbranch,sactdate from patron_v2 student inner join deletedstudents0822 deleted on student.patronid =deleted.patronid ;
select deleted.patronid ,deleted.name, student1.schooladdr,(student1.regdate) from STUDENTS090922 student1 inner join deletedstudents0822 deleted on student1.patronid =deleted.patronid ;
select deleted.patronid ,deleted.name, student2.schooladdr,(student2.regdate) from STUDENTS083122 student2 inner join deletedstudents0822 deleted on student2.patronid =deleted.patronid ;
select deleted.patronid ,deleted.name, student3.schooladdr,(student3.regdate) from STUDENTS082422 student3 inner join deletedstudents0822 deleted on student3.patronid =deleted.patronid ;
select deleted.patronid ,deleted.name, student4.schooladdr,(student4.regdate) from STUDENTS081722 student4 inner join deletedstudents0822 deleted on student4.patronid =deleted.patronid ;
select deleted.patronid ,deleted.name, student5.schooladdr,(student5.regdate) from STUDENTS080822 student5 inner join deletedstudents0822 deleted on student5.patronid =deleted.patronid ;

select added.patronid ,student.name, udf.valuename grade, student.street1,trunc(student.regdate), trunc(student.editdate), student.userid, student.sactdate, student.notes
from STUDENTSADDEDAUGSEPT2022 added inner join patron_v2 student on student.patronid =added.patronid
inner join udfpatron_v2 udf on added.patronid=udf.patronid 
left join deletedstudents0822 deleted on added.patronid = deleted.patronid ;

select added.patronid ,student.name, udf.valuename grade, student.street1,trunc(student.regdate), trunc(student.editdate), student.userid, student.sactdate, student.notes
from STUDENTSADDEDAUGSEPT2022 added inner join patron_v2 student on student.patronid =added.patronid
inner join udfpatron_v2 udf on added.patronid=udf.patronid
left join deletedstudents0822 deleted on added.patronid = deleted.patronid
where deleted.patronid is null ;

--This makes more sense, comparing the full 2022 student roster to the deleted students

select added.patronid ,student.name, udf.valuename grade, student.street1,trunc(student.regdate), trunc(student.editdate), student.userid, student.sactdate, student.notes
from STUDENTSFULL2022 added inner join patron_v2 student on student.patronid =added.patronid
inner join udfpatron_v2 udf on added.patronid=udf.patronid
inner join deletedstudents0822 deleted on added.patronid = deleted.patronid ;

-- 2021 roster vs 2022 deletions
select deleted.patronid, lastyear.STUDENT_ID , lastyear."First_Name",lastyear."Last_Name" from DELETEDSTUDENTS0822 deleted inner join "FCPSStudents081021" lastyear on SUBSTR(deleted.PATRONID,7)=lastyear.STUDENT_ID; ;

-- Some counts
--1862
select count(*) from STUDENTSADDEDAUGSEPT2022 ;

--29,000
select count(*) from DELETEDSTUDENTS0822 ;

-- Grade UDF Issue 9/15/2022
select students.patronid ,students.last, students.first, students.regdate, students.grade newgrade, udf.valuename grade from STUDENTS080822 students
inner join patron_v2 patron on students.patronid=patron.patronid
inner join udfpatron_v2 udf on students.patronid=udf.patronid
where udf.fieldid= 3
;
-- Emails with MyFCPS.org
select * from patron_v2 patron where patron.email like '%my.fcps.org' and patronid like '______';

--First Student Update August 8 2022
select patron.patronid, patron.name, patron.street1, patron.regdate from patron_v2 patron inner join students080822 students on patron.patronid=students.patronid ;
select patron.patronid, patron.name, patron.street1, patron.regdate from patron_v2 patron inner join students083122 students on patron.patronid=students.patronid ;

-- CarlX Ticket research
select * from patron_v2 patron where patronid='11982021783390' ;

--MSD
select patron.patronid,patron.name, bty, street1,regdate, actdate, editdate,patron.status , regbranch from patron_v2 patron  where upper(street1) like '%CLARKE%' order by actdate desc ;

-- Graduated Students 10/20/2022
select student.patronid , student.name, bstatus.description status, BTYCODE, branch.BRANCHCODE , jts.todate(regDATE) regdate_trunc  from patron_v2 student inner join bty_v2 profile on student.bty=profile.BTYNUMBER inner join BRANCH_V2 branch on defaultbranch=BRANCHNUMBER  inner join bst_v2 bstatus on student.status = bstatus.bst where btycode='GRAD' order by regdate_trunc desc ;
select student.patronid , student.name, bstatus.description status, BTYCODE, branch.BRANCHCODE , jts.todate(regDATE) regdate_trunc  from patron_v2 student inner join bty_v2 profile on student.bty=profile.BTYNUMBER inner join BRANCH_V2 branch on defaultbranch=BRANCHNUMBER  inner join bst_v2 bstatus on student.status = bstatus.bst where  btycode ='GRAD' and jts.todate(regdate)>'04-JUL-2022' order by regdate_trunc desc ;
select student.patronid , student.name, bstatus.description status, BTYCODE, branch.BRANCHCODE , jts.todate(student.regDATE) regdate_trunc  from FCPS_GRADUATED_070522 grads inner join patron_v2 student on grads.patronid=student.patronid inner join bty_v2 profile on student.bty=profile.BTYNUMBER inner join BRANCH_V2 branch on defaultbranch=BRANCHNUMBER  inner join bst_v2 bstatus on student.status = bstatus.bst   ;
select deleted.patronid , deleted.name , deleted.activedate from FCPS_GRADUATED_070522 grads inner join DELETEDSTUDENTS0822 deleted on grads.patronid = deleted.PATRONID   ;

select name, patronid, status, bty, patron_v2.street1 from PATRON_V2 where name like 'Kirk%' and bty='10' ;

-- Student Success Card Patron Accounts with DOB or Email my.fcps.org
select student.patronid, student.name, REGBRANCH , BRANCHCODE, student.BIRTHDATE,
       student.EMAIL, student.STREET1
from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
   where btycode = 'STUDNT' and branchcode ='SSL' ;

-- 7/26/2023 Student Success Card Patron Accounts with DOB or Email my.fcps.org

select student.patronid, student.name, BTYCODE , BRANCHCODE, student.BIRTHDATE, student.EMAIL,status,
       student.STREET1,trunc(ACTDATE)
  from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
      inner join branch_v2 branch on student.DEFAULTBRANCH= branch.BRANCHNUMBER
      where btycode = 'STUDNT' and branchcode ='SSL' and
    (birthdate is not NULL)  order by ACTDATE asc   ;

-- The final version Student Success Card Patron Accounts with DOB or Email my.fcps.org
select student.patronid, student.name, BTYCODE , BRANCHCODE, student.BIRTHDATE, student.EMAIL,status,
       student.STREET1,trunc(ACTDATE)
  from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
      inner join branch_v2 branch on student.DEFAULTBRANCH = branch.BRANCHNUMBER
      where btycode = 'STUDNT' and branchcode ='SSL' and
    (birthdate is not NULL or email like '%my.fcps%')  order by ACTDATE asc   ;

-- 10/31/2023 Patron ID does not start with 119829
-- Suggests merging a SSC card with a Public card
select student.patronid, student.name, BTYCODE , BRANCHCODE, student.userid editor, student.BIRTHDATE, student.EMAIL,status,
       student.STREET1,trunc(ACTDATE)
  from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
      inner join branch_v2 branch on student.DEFAULTBRANCH = branch.BRANCHNUMBER
      where btycode = 'STUDNT' and branchcode ='SSL' and
    (patronid not like '119829%')  order by ACTDATE asc   ;

select student.patronid, student.firstname, MIDDLENAME, lastname, '07' as Grade,
       street1, city1, state1,zip1, status, editdate, student.BIRTHDATE
  from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
      inner join branch_v2 branch on student.DEFAULTBRANCH = branch.BRANCHNUMBER
      where btycode = 'STUDNT' and branchcode ='SSL' and
    (patronid like '119820%')  order by ACTDATE asc   ;

-- For use with Admin Client Patron Loader SSCTeen2 Parameter set
-- 10/31/2023
select patronid, firstname, MIDDLENAME, lastname, '07' as Grade,
       street1, city1, state1,zip1, status, editdate, BIRTHDATE
  from patron_v2 teen
    inner join bty_v2 type on teen.bty = type.BTYNUMBER
      inner join branch_v2 branch on teen.DEFAULTBRANCH = branch.BRANCHNUMBER
      where type.BTYCODE='CHILD' and  birthdate < sysdate - interval '12' year and branchcode ='EMM'
   order by BIRTHDATE desc
;
-- yields 15 patrons younger than 12
select
bty,
patronid,
firstname,
middlename,
lastname,
street1,
city1,
zip1,
regdate,
birthdate



from patron_v2


where bty = '5' and (birthdate < (sysdate -(365*12)));
--where bty = '5' and (birthdate) < current_date - interval '12' year;

-- where bty = '5' and (birthdate) < current_date - (365*12);


-- Blocked Patrons
select patron.patronid, patron.name, type.btycode, stat.DESCRIPTION, patron.EMAIL,trunc(patron.ACTDATE), patron.BALANCEDUENOTICESTATUS from patron_v2 patron
inner join bty_v2 type on patron.bty=type.btynumber
inner join bst_v2 stat on patron.status = stat.bst where patron.status= 'X';

-- Soft Blocked Students
select student.patronid, student.name, status, notes, BRANCHCODE,trunc(regdate),trunc(editdate), trunc(actdate) , student.STREET1 from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    where btycode = 'STUDNT' and branchcode ='SSL' and status='S'  and notes is null
     order by student.editdate desc
;
-- 12/16/2022 For fcpsAddNote.pl script Soft Blocked students that need the StaffNote and do not already have it

select student.patronid, student.FIRSTNAME, student.MIDDLENAME, student.LASTNAME, VALUENAME grade,
       student.street1, student.CITY1, student.STATE1,student.ZIP1,student.STATUS,notes,
       trunc(regdate),trunc(editdate), trunc(actdate)
      from patron_v2 student
     inner join bty_v2 type on student.bty = type.BTYNUMBER
     inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
     inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    where btycode = 'STUDNT' and branchcode ='SSL' and status='S' and udf.FIELDID='3' and notes is null
     order by student.editdate desc
;
-- 02/15/2023 For fcpsAddNote.pl script Soft Blocked students that need the StaffNote and do not already have it

select student.patronid, student.name, status, notes, note.NOTETYPE, text, BRANCHCODE, student.STREET1,
       student.ZIP1, notes , trunc(regdate),trunc(editdate),
       trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    left outer join PATRONNOTETEXT_V2 note on student.PATRONID=note.REFID
    where (

            (
                (btycode = 'STUDNT' and branchcode ='SSL' and status='S')
                OR
                (btycode = 'GRAD' )
            )
                and note.REFID is null )    ;

-- 03/17/23 for use with fcpsAddNote_min.pl
select student.patronid, student.FIRSTNAME, student.MIDDLENAME, student.lastname, udf.VALUENAME grade,Student.STREET1,
       student.CITY1, student.STATE1, student.zip1,student.STATUS,current_date edittime
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join UDFPATRON_V2 udf on udf.PATRONID = student.PATRONID
    inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    left outer join PATRONNOTETEXT_V2 note on student.PATRONID=note.REFID
    where (
            udf.FIELDID = 3
            and
            (
                (type.btycode = 'STUDNT' and branch.branchcode ='SSL' and student.status='S')
                OR
                (type.btycode = 'GRAD' )
            )
                and note.REFID is  null )
    order by PATRONID ;

-- 2/16/2023 Soft Block Need the staff note, pairs with perl script FcpsAddNote_min.pl
select student.patronid, student.name, status, BTYCODE, student.STREET1,notes,trunc(regdate),trunc(editdate),
       trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    left outer join PATRONNOTETEXT_V2 note on student.PATRONID=note.REFID
    where (btycode = 'STUDNT' or btycode='GRAD') and branchcode ='SSL' and status='S' and note.REFID is null    ;

select student.patronid, student.name, status, BTYCODE, student.STREET1,notes,trunc(regdate),trunc(editdate),
       trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    left outer join PATRONNOTETEXT_V2 note on student.PATRONID=note.REFID
    where (btycode='GRAD')
      --and branchcode ='SSL'
      and status='S'
      and note.REFID is null    ;

-- 11/9/2023 Informational Note


-- Latest Update from FCPS, e.g. trunc(regdate)='30-NOV-22'
select student.patronid, student.firstname, student.lastname, student.middlename,udf.VALUENAME grade,
       street1, student.city1, student.state1, student.zip1, student.status,trunc(sysdate) edittime,btycode, branchcode,
       trunc(regdate),trunc(editdate), trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER inner join branch_v2 branch on student.DEFAULTBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    where
        branchcode ='SSL' and
        udf.FIELDID='3' and
         -- (trunc(regdate) = '26-APR-23' OR
          trunc(regdate) = '26-JUL-23' --)
    order by student.lastname ;

-- July 26 2023 Fall 2023 Import
select distinct student.patronid, student.firstname, student.lastname, student.middlename,
       student.street1,  student.status,BTYCODE,BRANCHCODE,
       trunc(student.regdate),trunc(student.editdate), trunc(student.actdate)
    from PATRON_V2 student
   left outer join "Students072623Full" on student.PATRONID = "Students072623Full".PATRONID
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join branch_v2 branch on student.DEFAULTBRANCH = branch.BRANCHNUMBER
    where
       branchcode ='SSL' and
     trunc(student.regdate) = '26-JUL-23' and
     "Students072623Full".patronid is null
    order by student.PATRONID ;

-- PREFERREDBRANCH not always SSL, REGBRANCH should be SSL. Instead use Borrower Type STUDNT, possibly GRAD .
-- Query will now result in all 46,597 imported students.
select   student.patronid, student.FIRST, student.last,
         student.status,BTYCODE,patron.REGBRANCH,patron.DEFAULTBRANCH
        --BRANCHCODE
       --trunc(student.regdate)
       --student.SCHOOLADDR
    --,trunc(student.editdate), trunc(student.actdate)
    from "Students072623Full" student
    --left outer join  PATRON_V2 patron on student.PATRONID = patron.PATRONID
    inner join  PATRON_V2 patron on student.PATRONID = patron.PATRONID
    inner join bty_v2 type on patron.bty = type.BTYNUMBER
    --inner join branch_v2 branch on patron.REGBRANCH = branch.BRANCHNUMBER
    where
    -- BTYCODE = 'STUDNT'
      --branchcode ='SSL'
      --and
      trunc(student.regdate) = '26-JUL-23'

      --and
     --"Students072623Full".patronid is null
     --patron.PATRONID is null
     -- order by student.PATRONID
      order by patron.DEFAULTBRANCH
     ;

-- Count mismatch so determine why "missing" success card records do not match the outer join table FCPS_JOIN_RESULT
-- Generate the missing students
-- Branch Code edited from SSL. Instead use Borrower Type STUDNT, possibly GRAD
select  * from "Students072623Full" student
    where student.patronid not in (select patronid from FCPS_JOIN_RESULT) ;


select patron.patronid,
       --missing.patronid,
       case missing.patronid
           when patron.patronid then 'MATCH'
           else 'NOT MATCH'
           end,
       btycode,
       patron.name,
       --missing.last||' '||missing.first||' '||missing.MIDDLE,

       trunc(patron.regdate), trunc(patron.EDITDATE) , trunc(patron.SACTDATE)
from patron_v2 patron
inner join BTY_V2 type on patron.bty = type.BTYNUMBER
inner join "MissingStudents073123" missing on missing.PATRONID = patron.PATRONID;




--MSD Back online Feb 2024

select student.patronid, student.firstname, student.lastname,udf.VALUENAME grade,
       street1, student.city1, student.state1, student.zip1, student.status,trunc(sactdate) selfactivity,trunc(sysdate) edittime,btycode, branchcode,
       trunc(regdate),trunc(editdate), trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join branch_v2 branch on student.DEFAULTBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    where
     branchcode ='SSL' and
      udf.fieldid='3' and
       upper(student.street1) like '%DEAF%'
      -- and trunc(student.EDITDATE)>='05-MARCH-2024'
    and trunc(student.SACTDATE)>='1-FEB-2024'
    order by SACTDATE desc, LASTNAME;

-- Feb 18, 2024 Street1 30 Character limit results in different addresses for MSD students
select student.patronid, student.firstname, student.MIDDLENAME,student.lastname,
       udf.VALUENAME grade, 'Maryland School for Deaf 101 Clarke Pl' Street,
        student.city1, student.state1, student.zip1, student.status,regdate,'' DOB
--        trunc(editdate), trunc(actdate),trunc(SACTDATE),
--        trunc(sysdate) edittime,btycode, branchcode
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    --where (branchcode ='SSL' OR BTYCODE='STUDNT') and udf.fieldid='3' and upper(student.street1) like '%CLARKE%' and
    where  udf.fieldid='3' and btycode='STUDNT' and
   upper(student.street1) like '%101 CLARK%'
          --and trunc(ACTDATE)>='01-July-2023'
    order by trunc(ACTDATE) DESC ,lastname;

select student.patronid, student.firstname, student.lastname,
       --udf.VALUENAME grade,
       street1, student.city1, student.state1, student.zip1, student.status,trunc(sysdate) edittime,btycode, branchcode,
       trunc(regdate),trunc(editdate), trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    --inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    --where (branchcode ='SSL' OR BTYCODE='STUDNT') and udf.fieldid='3' and upper(student.street1) like '%CLARKE%' and
    -- where  udf.fieldid='3' and
        where patronid  like '119829219%'
          --and trunc(ACTDATE)>='01-July-2023'
    order by trunc(ACTDATE) DESC ,lastname;

select student.patronid, student.firstname, student.lastname,udf.VALUENAME grade,
       street1, student.city1, student.state1, student.zip1, student.status,trunc(sysdate) edittime,btycode, branchcode,
       trunc(regdate),trunc(editdate), trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    where
        -- branchcode ='SSL' and udf.fieldid='3' and
        upper(student.street1) like '%DEAF%'
      and (trunc(actdate)>='01-July-2023' OR trunc(regdate)>='01-July-2023' OR trunc(editdate)>='01-July-2023' )
    order by lastname;

select patron.Patronid,patron.REGBRANCH, patron.PREFERRED_BRANCH, patron.ACTBRANCH, btype.BTYCODE from patron_v2 patron
    inner join bty_v2 btype on patron.bty=btype.BTYNUMBER
     where patron.bty=12 ;

-- Edit date of 05-DEC-22
select student.patronid, student.firstname, student.lastname,udf.VALUENAME grade,
       street1, student.city1, student.state1, student.zip1, student.status,trunc(sysdate) edittime,btycode, branchcode,
       trunc(regdate),trunc(editdate), trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    where branchcode ='SSL' and udf.fieldid='3' and student.street1 like '%Deaf%' and trunc(editdate) like '05-DEC-22' order by lastname;

-- Sort by most recent activity date, edit date, reg date
select student.patronid, student.firstname, student.lastname,udf.VALUENAME grade,
       street1, student.city1, student.state1, student.zip1, student.status,trunc(sysdate) edittime,btycode, branchcode,
       trunc(actdate), trunc(editdate) , trunc(regdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    where branchcode ='SSL' and udf.fieldid='3' and student.street1 like '101 Clark%' order by ACTDATE, EDITDATE, REGDATE desc;

--  02/14/2023 Students with recent ACTDATE but old REGDATE, e.g. no longer part of FCPS data imports
select student.patronid, student.firstname, student.lastname,trunc(actdate), trunc(editdate) , trunc(regdate),
       udf.VALUENAME grade, street1, student.city1, student.state1, student.zip1, student.status,trunc(sysdate) edittime,btycode, branchcode
    noteid, patronnotetext_v2.text
    from patron_v2 student inner join patronnotetext_v2 on patronid = refid
    inner join bty_v2 type on student.bty = type.BTYNUMBER inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    where student.patronid like '119829%' and BTYCODE='STUDNT' and branchcode ='SSL' and STATUS !='M' and udf.fieldid='3' and trunc(ACTDATE)>'01-JUL-19' and ( trunc(REGDATE)<'01-JAN-19' or REGDATE is null)
    order by trunc(ACTDATE) desc, trunc(EDITDATE) desc ,trunc(REGDATE) desc;

-- 04/14/23 want to find redundant notes to delete them interactively or via the API deletePatronNote
select student.patronid, student.FIRSTNAME, student.MIDDLENAME, student.lastname, udf.VALUENAME grade,Student.STREET1,
       student.CITY1, student.STATE1, student.zip1,student.STATUS,current_date edittime,note.text
    from patron_v2 student

    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join UDFPATRON_V2 udf on udf.PATRONID = student.PATRONID
    inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    left outer join PATRONNOTETEXT_V2 note on student.PATRONID=note.REFID

    where (
            udf.FIELDID = 3
            and
            (
                (type.btycode = 'STUDNT' and branch.branchcode ='SSL' and student.status='S')
                OR
                (type.btycode = 'GRAD' )
            )
                and note.REFID is Not null )
    order by PATRONID ;

-- REGDATE / Count newly registered Student Success Cards For Most Recent Month
-- 02/29/24

select student.patronid, trunc(student.REGDATE), trunc(student.EDITDATE), student.street1 school
    , udfpatron.VALUENAME grade
    from patron_v2 student
    inner join UDFPATRON_V2 udfpatron on ((udfpatron.PATRONID = student.PATRONID) and
                                          (udfpatron.fieldid=3) )
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER

    where (
             (type.btycode = 'STUDNT' and branch.branchcode = 'SSL')
                OR
             (type.btycode = 'GRAD')
        )
    AND trunc(student.regdate) > '31-JAN-24' and trunc(student.regdate)<'01-MAR-24'
--AND trunc(student.editdate) > :regDate
      --AND trunc(regdate)<'01-NOV-23'
    order by school , trunc(REGDATE) desc ;

-- REGDATE before Start of School Imports July 2022
select substr(student.patronid,7), student.name, trunc(student.REGDATE), student.street1 school
    , udfpatron.VALUENAME grade
    from patron_v2 student
    inner join UDFPATRON_V2 udfpatron on ((udfpatron.PATRONID = student.PATRONID) and (udfpatron.fieldid=3) )
    --inner join UDFVALUE_V2 udfvalue on (udfvalue.numcode = udfpatron.numcode) and (udfvalue.fieldid = udfpatron.fieldid)
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER

    where (
          --  (
             (type.btycode = 'STUDNT' and branch.branchcode = 'SSL')
                OR
             (type.btycode = 'GRAD')
          --  )


--                  valuename ='PK'
        )
      AND trunc(regdate)<'01-JUL-22'

    -- order by student.REGDATE desc  ;
    order by school , trunc(REGDATE) desc ;

--Reviewed List of Potential Deletions. Reviewed by FCPS.
select patron.patronid, patron.name, review."Current_Status", patron.regdate,patron.editdate,patron.ACTDATE

    From Patron_v2 patron inner join FCPS_ACTIVITY_REVIEW review
        on patron.patronid=review."PatronID"
order by review."Current_Status", patron.regdate,patron.editdate,patron.ACTDATE
;

select patron.patronid, patron.name, review."Current_Status", trunc (patron.regdate),trunc(patron.editdate),trunc(patron.ACTDATE),
       patron.STREET1, patron.status, udfpatron.VALUENAME

    From Patron_v2 patron inner join FCPS_ACTIVITY_REVIEW review
        on patron.patronid=review."PatronID"
    inner join UDFPATRON_V2 udfpatron on ((udfpatron.PATRONID = patron.PATRONID) and (udfpatron.fieldid=3) )
order by review."Current_Status", patron.regdate,patron.editdate,patron.ACTDATE
;

--For Import prior to delete. Update the Regdate for the Actives.
select patron.patronid, FIRSTNAME, MIDDLENAME, LASTNAME, udfpatron.VALUENAME as grade, STREET1, city1, state1, zip1,
       review."Current_Status",trunc(sysdate)

    From Patron_v2 patron inner join FCPS_ACTIVITY_REVIEW review
        on patron.patronid=review."PatronID"
    inner join UDFPATRON_V2 udfpatron on ((udfpatron.PATRONID = patron.PATRONID) and (udfpatron.fieldid=3) )
    where "Current_Status" = 'A'
order by review."Current_Status", patron.regdate,patron.editdate,patron.ACTDATE*
;
select patron.patronid, name, trunc(regdate), trunc(editdate), trunc(patron.ACTDATE),
       review."Current_Status",trunc(sysdate)

    From Patron_v2 patron inner join FCPS_ACTIVITY_REVIEW review
        on patron.patronid=review."PatronID"
    inner join UDFPATRON_V2 udfpatron on ((udfpatron.PATRONID = patron.PATRONID) and (udfpatron.fieldid=3) )
    where "Current_Status" = 'A'
order by review."Current_Status", patron.regdate,patron.editdate,patron.ACTDATE
;
-- Deleted has a Report Mode run of Delete Patrons for Student Success Cards STUDENT borrowers (not GRADUATED)
-- FCPS_ACTIVITY_REVIEW has the feedback from FCPS on the initial list of cards with REGDATE < 7/1/2022

select deleted."Patron ID", deleted."Patron Name",deleted."Date", patron.STREET1 from "DeletePatrons" deleted
inner join PATRON_V2 patron on deleted."Patron ID" = patron.PATRONID
Left outer join FCPS_ACTIVITY_REVIEW review on deleted."Patron ID" = review."PatronID"

where review."PatronID" is NULL
;

select Status."Patron ID", Status."Status", Deleted."Date"
from "DeletePatrons" Deleted inner join CARLREPORTS."DeletePatrons-101023_Status" Status
on Deleted."Patron ID"=Status."Patron ID"
where Status."Status"='I' and Deleted."Patron ID" Like '119829%';

-- Last Month New Student Cards from FCPS, e.g. trunc(regdate)='30-NOV-22'
select student.patronid, student.firstname, student.lastname, student.middlename,udf.VALUENAME grade,
       street1, student.city1, student.state1, student.zip1, student.status,trunc(sysdate) edittime,btycode, branchcode,
       trunc(regdate),trunc(editdate), trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
        inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID
    where branchcode ='SSL' and btycode='STUDNT' and upper(label.label)='GRADE'
      --and upper(street1)  like 'MARYLAND%'
         and trunc(regdate) between '31-MAR-24' and '01-MAY-24'

    order by student.lastname