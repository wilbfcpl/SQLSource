---------------------PATRON COUNT OF FINES, LOST AND OVERDUE ITEMS----------------------------
*/query gives a count of patron who HAVE LOST ITEMS and FINES)*/
select count(patronid) total_patron, sum(total_fine/100) total_amount
from (select patronid, sum(fines_owed) total_fine
from (select patronid, amountdebited, amountpaid, amountdebited - amountpaid  as fines_owed
from transitem_v2
where transcode IN ('L', 'FS', 'F'))  t1
group by patronid) t2
where total_fine > 0

*/query gives a count of patron who HAVE LOST ITEMS)*/
select count(patronid) total_patron, sum(total_fine/100) total_amount
from (select patronid, sum(fines_owed) total_fine
from (select patronid, amountdebited, amountpaid, amountdebited - amountpaid  as fines_owed
from transitem_v2
where transcode IN ('L', 'FS','F'))  t1
group by patronid) t2
where total_fine >=501

*/Count of patron who HAVE FINES)*/
select count(patronid) total_patron, sum(total_fine/100) total_amount
from (select patronid, sum(fines_owed) total_fine
from (select patronid, amountdebited, amountpaid, amountdebited - amountpaid  as fines_owed
from transitem_v2
where transcode IN ('F', 'FS','L'))  t1
group by patronid) t2
where total_fine <=500

/*Count of Overdue Patrons and Count of Total Items Overdue
SELECT
---count (distinct PATRON_V2.patronid)/*Count of Patrons*/
count(TRANSITEM_V2.ITEM)/*Count of Items*/
FROM
TRANSITEM_V2
JOIN patron_v2 ON TRANSITEM_V2.PATRONID = PATRON_V2.PATRONID
JOIN item_v2 ON TRANSITEM_V2.item = ITEM_V2.item
JOIN BBIBMAP_V2 ON ITEM_V2.bid = BBIBMAP_V2.bid
WHERE
TRANSCODE IN ('O')
ORDER BY
TRANSITEM_V2.PATRONID

--------------------FINES AND LOST ITEM FINES BEFORE MIGRATION-------------------------
*/Count of patron who HAVE FINES before Migration)*/
select  count(patronid) total_patron, sum(total_fine/100) total_amount
from (select patronid, sum(fines_owed) total_fine
from (
select patronid, amountdebited, amountpaid, amountdebited - amountpaid  as fines_owed
from transitem_v2
where instbit = '1400' 
and transcode IN ('L', 'FS', 'F')
---and amountdebited > 0 /*Total of all Fines*/
---and amountdebited >= 501  /*Total of all Lost Items*/
and amountdebited <= 500  /*Total of all Fines*/
and transdate < 'MAR-27-2016')  t1
group by patronid) t2

-----------------------FINES BY BRANCH-----------------------
/*Count Borrowers with Fines By Branch*/
SELECT count(distinct ti.patronid), b.branchcode
FROM TRANSITEM_V2 TI, PATRON_V2 P, BRANCH_V2 B
WHERE ti.patronid=p.patronid
AND ti.transcode in ('F','FS','L') /*CHANGE FINE CODE(F=FINE, FS=MANUAL FINE, L=LOST)*/
--AND p.defaultbranch in ('5') /*--COMMENT OUT TO QUERY ALL BRANCHES*/
AND p.defaultbranch=b.branchnumber
GROUP BY  b.branchcode
HAVING SUM (ti.amountdebited-ti.amountpaid)>1000
ORDER BY b.branchcode

/*Count and amount of patrons with fines by branch/*
SELECT count(distinct ti.patronid) Number_of_Patrons, b.branchcode, sum(ti.amountdebited-ti.amountpaid) Amount_Owed
FROM TRANSITEM_V2 TI, PATRON_V2 P, BRANCH_V2 B
WHERE ti.patronid=p.patronid
AND ti.transcode in ('F','FS') /*CHANGE FINE CODE(F=FINE, FS=MANUAL FINE, L=LOST)*/
--AND ti.amountdebited <=500
--AND p.defaultbranch in ('5') /*--COMMENT OUT TO QUERY ALL BRANCHES*/
AND p.defaultbranch=b.branchnumber
GROUP BY  p.defaultbranch, b.branchcode
HAVING SUM (ti.amountdebited-ti.amountpaid)>0
ORDER BY b.branchcode

---------------------Renewal Info-----------------------
/*Gives the number of patrons and items who have renewed*/
select b.branchcode, count(t.item)
from transitem_v2 t, branch_v2 b
where t.transcode in ('C','O')
and t.branch=b.branchnumber
--and renew >=7
--and renew >=5
--and renew >=3
and t.renew >=1
and t.transdate > 'AUG-29-19'
group by b.branchcode
order by b.branchcode
--and patronid = '21696006471981' */used for testing results/*

/*Renewal Item List*/
select item, sum(renew) from transitem_v2
where transcode in ('C', 'O')
and renew ='1'
group by item, renew
order by renew DESC

/*Patron with Renewal List*/
select distinct patronid, count(item) from transitem_v2
where transcode in ('C', 'O')
and renew >'0'
group by patronid

/*Automated Renewal Branch*/
select patronid from transitem_v2
where transcode in ('C', 'O')
and renew >='1'
group by patronid

-------------------------Borrowers cko count-------------------------
select patronid, count(item)
from transitem_v2
where transcode = 'C'
and borrowertype not in ('2','12')
group by patronid
having count(*) >=50

/*COUNT OF TOTAL CKOS*/
Select count(item)
from transitem_v2
where transcode = 'C'

/*COUNT OF TOTAL OVERDUE CKOS*/
Select count(item)
from transitem_v2
where transcode = 'O'

/*COUNT OF TOTAL LOST Items*/
Select count(item)
from transitem_v2
where transcode = 'L'

-------------------------Total Card Holders----------------------
/*COUNT OF ALL PATRONS EXCEPT ONLINE REG*/
SELECT COUNT(PATRONID) FROM PATRON_V2
WHERE BTY NOT IN ('10') /*ONLINE REGISTRAION*/

/*COUNT OF ALL PATRONS ACTIVE WITHIN PAST YEAR EXCLUDES ONLINE REG*/
SELECT COUNT(DISTINCT PATRONID) 
FROM PATRON_V2
WHERE ACTDATE BETWEEN 'JUL-1-2017' AND 'AUG-27-2019'
AND BTY NOT IN ('10') /*ONLINE REGISTRAION*/

-------------------------Juvenile Data---------------------------
/**COUNT OF TOTAL JUVENILE BORROWERS**/
Select count (distinct patronid)
from patron_v2 
where birthdate >= ('JUN-01-01')

/**TOTAL ITEMS CHECKED OUT TO JUVENILE BORROWERS**/
Select count(i.item)
from patron_v2 p, transitem_v2 tx, item_v2 i
where p.patronid= tx.patronid
and i.item=tx.item
and p.birthdate >= ('JAN-01-00')
and p.bty not in ('2','12')
and i.status = 'C'

/**COUNT NUMBER OF JUV BORROWERS WITH CHECKOUTS**/
Select count (distinct p.patronid)
from patron_v2 p, transitem_v2 tx, item_v2 i
where p.patronid= tx.patronid  
and tx.item=i.item
and p.birthdate >= ('JUN-14-01')
and p.bty not in ('2','12')
and i.status = 'C'

*/COUNT OF DELINQUENT PATRONS-EXCLUDING STAFF/*
SELECT COUNT(PATRONID)  FROM PATRON_V2
WHERE STATUS = 'X'
AND BTY NOT IN ('2','4','6','12')

*/COUNT OF DELINQUENT YOUTH PATRONS-EXCLUDING STAFF/*
SELECT COUNT(PATRONID)  FROM PATRON_V2
WHERE STATUS = 'X'
AND BIRTHDATE >= 'JUN-01-01'
AND BTY NOT IN ('2','4','6','12')

*COUNT OF YOUTHS WITH LOST ITEM)*/
SELECT COUNT(DISTINCT T.PATRONID)
FROM TRANSITEM_V2 T, PATRON_V2 P
WHERE T.PATRONID=P.PATRONID 
AND T.TRANSCODE IN ('L','FS')
AND T.PATRONID IS NOT NULL
--AND P.STATUS = 'X'
AND T.AMOUNTDEBITED > 500
--AND T.PATRONID LIKE '21696%'
AND P.BIRTHDATE >= 'MAY-14-2001 12.00.00.000000000 AM'
AND BORROWERTYPE NOT IN ('2','4','6','12')

/*COUNT OF YOUTHS WITH FINES THAT ARE BLOCKED)*/
SELECT COUNT(DISTINCT T.PATRONID)
FROM TRANSITEM_V2 T, PATRON_V2 P
WHERE T.PATRONID=P.PATRONID 
---AND P.BIRTHDATE >= 'MAY-14-2001 12.00.00.000000000 AM'
AND T.TRANSCODE in ('F')
AND P.STATUS = 'X'
AND T.PATRONID IS NOT NULL
AND BORROWERTYPE NOT IN ('2','4','6','12')


/*LIST OF DELINQUENT YOUTHS WHO OWE MORE THAN 10.00 IN FINES\MANUAL*/
SELECT DISTINCT (T.PATRONID), sum(t.amountdebited-t.amountpaid)/100 as Fine
FROM TRANSITEM_V2 T, PATRON_V2 P
WHERE T.PATRONID=P.PATRONID AND P.BIRTHDATE >= 'MAY-14-2001 12.00.00.000000000 AM'
AND T.TRANSCODE IN ('F','FS')
AND P.STATUS = 'X'
AND BIRTHDATE >= 'MAY-14-01'
AND T.PATRONID IS NOT NULL
AND BORROWERTYPE NOT IN ('2','4','6','12')
HAVING sum(t.amountdebited-t.amountpaid) >1000
group by t.patronid

/*COUNT OF DELINQUENT YOUTHS WHO OWE MORE THAN 10.00 IN FINES\MANUAL*/
SELECT COUNT(DISTINCT T.PATRONID), sum(t.amountdebited-t.amountpaid)/100 as Fine
FROM TRANSITEM_V2 T, PATRON_V2 P
WHERE T.PATRONID=P.PATRONID 
--AND P.BIRTHDATE >= 'MAY-14-2001 12.00.00.000000000 AM'
AND T.TRANSCODE IN ('F','FS')
AND P.STATUS = 'X'
--AND BIRTHDATE >= 'MAY-14-01'
AND T.PATRONID IS NOT NULL
AND BORROWERTYPE NOT IN ('2','4','6','12')
HAVING sum(t.amountdebited-t.amountpaid) >1000


-----------------------------------

/*COUNT OF EVERYONE WITH LOST ITEM)*/
SELECT COUNT (DISTINCT T.PATRONID)
FROM TRANSITEM_V2 T, PATRON_V2 P
WHERE T.PATRONID=P.PATRONID 
AND T.TRANSCODE IN ('FS', 'L')
AND T.PATRONID IS NOT NULL
AND T.AMOUNTDEBITED > 500
--AND T.PATRONID LIKE '21696%'
AND BORROWERTYPE NOT IN ('2','4','6','12')


/*COUNT OF YOUTHS WITH LOST ITEM)*/
SELECT COUNT(DISTINCT T.PATRONID)
FROM TRANSITEM_V2 T, PATRON_V2 P
WHERE T.PATRONID=P.PATRONID 
AND T.TRANSCODE IN ('L','FS')
AND T.PATRONID IS NOT NULL
--AND P.STATUS = 'X'
AND T.AMOUNTDEBITED > 500
--AND T.PATRONID LIKE '21696%'
AND P.BIRTHDATE > 'AUG-27-2001 12.00.00.000000000 AM'
AND BORROWERTYPE NOT IN ('2','4','6','12')

/*COUNT OF YOUTHS WITH FINES THAT ARE BLOCKED)*/
SELECT COUNT(DISTINCT T.PATRONID)
FROM TRANSITEM_V2 T, PATRON_V2 P
WHERE T.PATRONID=P.PATRONID 
AND P.BIRTHDATE >= 'AUG-27-2001 12.00.00.000000000 AM'
AND T.TRANSCODE = 'F'
AND P.STATUS = 'X'
AND T.PATRONID IS NOT NULL
AND BORROWERTYPE NOT IN ('2','4','6','12')


----------------------Checkout Counts--------------------------

/*COUNTS HOW MANY BORROWERS HAVE CKOS AND HOW MANY TOTAL CKOS*/
SELECT COUNT (DISTINCT patronid) from transitem_v2 WHERE transcode = 'C' 
UNION
SELECT COUNT(*) FROM transitem_v2 WHERE transcode = 'C'

select count(distinct patronid), count(item)
from transitem_v2
where transcode = 'C'











