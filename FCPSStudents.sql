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

--First Student Update August 8 2022
select patron.patronid, patron.name, patron.street1, patron.regdate from patron_v2 patron inner join students080822 students on patron.patronid=students.patronid ;
select patron.patronid, patron.name, patron.street1, patron.regdate from patron_v2 patron inner join students083122 students on patron.patronid=students.patronid ;

-- CarlX Ticket research
select * from patron_v2 patron where patronid='11982021783390' ;

--MSD
select patron.patronid,patron.name, bty, street1,regdate, actdate, editdate,patron.status , regbranch from patron_v2 patron  where upper(street1) like '%CLARKE%' order by actdate desc ;