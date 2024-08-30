-- Report 16 Aggregate work alike
select

cloc.LOCNAME,
count(cloc.LOCNAME)

from txlog_v2 tx
join location_v2 cloc on tx.itemlocation=cloc.locnumber
join BRANCH_V2 branch on branch.BRANCHNUMBER = tx.ENVBRANCH
join BTY_V2 btype on btype.BTYNUMBER = tx.PATRONBTY

where
 trunc(tx.TXTRANSDATE) BETWEEN '01-MAY-2023' and '01-MAY-2024'
   and tx.transactiontype in ('CH','RN')
and branch.BRANCHCODE=     :BRANCH
and btype.BTYCODE not in ('ILL','LIBUSE')

group by cloc.LOCNAME
order by cloc.LOCNAME
;
-- Low Level Report 15/16 work alike
select
    'Frederick County Public Library' AS Institution,
    :begin as begin,
    :end as end,
    TO_DATE(tx.TXTRANSDATE) as TransDate,
    branch.branchcode ,
    transtypes.CODEDESCRIPTION,
    cloc.LOCNAME,
    media.MEDNAME,
    btype.BTYNAME,
 'Frederick County Public Libraries' as BRANCHGROUP,
 count(media.MEDNAME)
from txlog_v2 tx
join SYSTEMCODEVALUES_V2 transtypes on transtypes.CODEVALUE=tx.TRANSACTIONTYPE
join location_v2 cloc on tx.itemlocation=cloc.locnumber
join MEDIA_V2 media on tx.ITEMMEDIA=media.MEDNUMBER
join BRANCH_V2 branch on branch.BRANCHNUMBER = tx.ENVBRANCH
join BTY_V2 btype on btype.BTYNUMBER = tx.PATRONBTY
where

TO_DATE(tx.TXTRANSDATE) BETWEEN :begin and :end
   and transtypes.CODEDESCRIPTION in ('Renew','Discharge (Return)','Charge')
and branch.BRANCHCODE=     :BRANCH
and btype.BTYCODE not in ('ILL','LIBUSE')

group by TO_DATE(tx.TXTRANSDATE),branchcode,transtypes.CODEDESCRIPTION,cloc.LOCNAME,media.MEDNAME,btype.BTYNAME
order by TO_DATE(tx.TXTRANSDATE)
;



-- Report 15 Work alike
select

cloc.LOCNAME,
count(cloc.LOCNAME),
codes.CODEDESCRIPTION

from txlog_v2 tx
join location_v2 cloc on tx.itemlocation=cloc.locnumber
join CARLREPORTS.SYSTEMCODEVALUES_V2 codes on codes.CODEVALUE= tx.TRANSACTIONTYPE
join BRANCH_V2 branch on branch.BRANCHNUMBER = tx.ENVBRANCH
join BTY_V2 btype on btype.BTYNUMBER = tx.PATRONBTY

where
 trunc(tx.TXTRANSDATE) BETWEEN '01-MAY-2023' and '01-MAY-2024'
   and tx.transactiontype in ('CH','DC','RN')
    and codes.CODEDESCRIPTION not like 'Received%'
  -- and codes.CODETYPE in (1,2,3,4,5,8)
    --and

 --codes.CODEDESCRIPTION like 'Return%'
-- (
--      codes.codetype = 2 and codes.CODEVALUE like 'C%'
--          OR
--      codes.codetype = 5 and codes.CODEVALUE like 'C%'
--          or
--      codes.CODETYPE = 4 and codes.CODEVALUE like 'C%'
--          or
--      codes.CODETYPE = 5 and codes.CODEVALUE ='RN'
--          or
--      codes.CODETYPE = 3 and codes.CODEVALUE = 'RT'
--          or
--      codes.CODETYPE = 8 and codes.CODEVALUE = 'R'
--         or
--       codes.CODETYPE = 5 and codes.CODEVALUE = 'DC'
-- --
--      )
  and branch.BRANCHCODE=     :BRANCH
and btype.BTYCODE not in ('ILL','LIBUSE')

group by cloc.LOCNAME, codes.CODEDESCRIPTION
order by cloc.LOCNAME
;

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
         and trunc(regdate) between '30-APRIL-24' and '31-MAY-24'

    order by student.lastname ;

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

-- Hoopla usage
select bib.bid, bib.callnumber, bib.ERESOURCE, log.PATRONID, log.CHARGEHISTORYID, log.itemid, media.MEDCODE, log.isid, trunc(log.RETURNDATE) from BBIBMAP_V2 bib
inner join chargehistory_v2 log on bib.bid = log.BID
inner join MEDIA_V2 media on log.media = media.MEDNUMBER
--where media.MEDCODE like 'ERES'
where bib.ERESOURCE='Y'
;

select bib.bid, bib.callnumber, bib.ERESOURCE from BBIBMAP_V2 bib

where bib.CALLNUMBER like 'HOOPLA%'
;



-- Email at County email address
select count(patronid)  from PATRON_V2 PATRON  where EMAILNOTICES=1 and upper(EMAIL) like '%FREDERICKCOUNTYMD.GOV';
-- Newsletter and County Email address
select patron.PATRONID , udf.VALUENAME , patron.email, udf.numcode, val.VALUEINDEX from PATRON_V2 PATRON
                        inner join UDFPATRON_V2 udf on Patron.PATRONID = udf.patronid and (udf.fieldid=1 and udf.NUMCODE=1 and udf.VALUENAME='Yes')
                        inner join UDFVALUE_V2 val on val.fieldid=udf.FIELDID and val.VALUEINDEX=1
                        where patron.EMAILNOTICES=1 and Upper(patron.email) like '%FREDERICKCOUNTYMD.GOV'   ;
-- Newsletter and email not at County Address
select count(patron.PATRONID ) from PATRON_V2 patron
                        inner join UDFPATRON_V2 udf on Patron.PATRONID = udf.patronid and (udf.fieldid=1 and udf.NUMCODE=1 and udf.VALUENAME='Yes')
                        inner join UDFVALUE_V2 val on val.fieldid=udf.FIELDID and val.VALUEINDEX=1
                        where patron.EMAILNOTICES=1 and Upper(patron.email) not like '%FREDERICKCOUNTYMD.GOV'   ;
-- Newsletter
select count(patron.patronid)  from PATRON_V2 patron
                        inner join UDFPATRON_V2 udf on Patron.PATRONID = udf.patronid and (udf.fieldid=1 and udf.NUMCODE=1 and udf.VALUENAME='Yes')
                        inner join UDFVALUE_V2 val on val.fieldid=udf.FIELDID and val.VALUEINDEX=1
                        where patron.EMAILNOTICES=1 ;
-- Newsletter
select patron.patronid , email from PATRON_V2 patron
                        inner join UDFPATRON_V2 udf on Patron.PATRONID = udf.patronid and (udf.fieldid=1 and udf.NUMCODE=1 and udf.VALUENAME='Yes')
                        inner join UDFVALUE_V2 val on val.fieldid=udf.FIELDID and val.VALUEINDEX=1
                        where patron.EMAILNOTICES=1 ;
-- Staff email not at County email
select patron.patronid , type.BTYNAME ,email from PATRON_V2 patron
                        inner join BTY_V2 type on patron.bty= type.BTYNUMBER and type.btycode='STFBRW'
                        where patron.EMAILNOTICES=1 and upper(email) not like '%FREDERICKCOUNTYMD.GOV' ;
-- Staff Email at County email
select patron.patronid , type.BTYNAME ,email from PATRON_V2 patron
                        inner join BTY_V2 type on patron.bty= type.BTYNUMBER and type.btycode='STFBRW'
                        where patron.EMAILNOTICES=1 and upper(email) like '%FREDERICKCOUNTYMD.GOV' ;

-- Staff Email not at County email
select patron.patronid , type.BTYNAME ,email from PATRON_V2 patron
                        inner join BTY_V2 type on patron.bty= type.BTYNUMBER and type.btycode='STFBRW'
                        where  upper(email) not like '%FREDERICKCOUNTYMD.GOV' ;

-- Staff Newsletter not at County email address
select count(patron.PATRONID ) from PATRON_V2 patron
                        inner join BTY_V2 type on patron.bty= type.BTYNUMBER and type.btycode='STFBRW'
                        inner join UDFPATRON_V2 udf on Patron.PATRONID = udf.patronid and (udf.fieldid=1 and udf.NUMCODE=1 and udf.VALUENAME='Yes')
                        inner join UDFVALUE_V2 val on val.fieldid=udf.FIELDID and val.VALUEINDEX=1
                        where Upper(patron.email) not like '%FREDERICKCOUNTYMD.GOV'   ;
--Staff Newsletter at county address
select count(patron.PATRONID ) from PATRON_V2 patron
                        inner join BTY_V2 type on patron.bty= type.BTYNUMBER and type.btycode='STFBRW'
                        inner join UDFPATRON_V2 udf on Patron.PATRONID = udf.patronid and (udf.fieldid=1 and udf.NUMCODE=1 and udf.VALUENAME='Yes')
                        inner join UDFVALUE_V2 val on val.fieldid=udf.FIELDID and val.VALUEINDEX=1
                        where Upper(patron.email) like '%FREDERICKCOUNTYMD.GOV'   ;

-- Staff not county email
select patron.patronid , type.BTYNAME ,email from PATRON_V2 patron
                        inner join BTY_V2 type on patron.bty= type.BTYNUMBER and type.btycode='STFBRW'
                        where Upper(patron.email) not like '%FREDERICKCOUNTYMD.GOV'
                         ;
-- Staff
select patron.patronid , type.BTYNAME ,email from PATRON_V2 patron
                        inner join BTY_V2 type on patron.bty= type.BTYNUMBER and type.btycode='STFBRW'
                        where Upper(patron.email) like '%FREDERICKCOUNTYMD.GOV' ;
-- FCPL Notices and County Email
select patron.patronid ,type.btyname, name, email from PATRON_V2 patron
                        inner join BTY_V2 type on patron.bty= type.BTYNUMBER and type.btynumber!=12
                        where patron.EMAILNOTICES=1 and Upper(patron.email) like '%FREDERICKCOUNTYMD.GOV'
                 order by btyname
;

-- Staff get email
select patron.patronid , type.BTYNAME ,email from PATRON_V2 patron

                        inner join BTY_V2 type on patron.bty= type.BTYNUMBER and type.btycode='STFBRW'
                        where patron.EMAILNOTICES=1

;
-- All Get email
select count(patronid)  from PATRON_V2 PATRON  where EMAILNOTICES=1
                                                -- and upper(EMAIL) like '%FREDERICKCOUNTYMD.GOV'
;
-- Staff email other
select patron.patronid , type.BTYNAME ,email from PATRON_V2 patron

                        inner join BTY_V2 type on patron.bty= type.BTYNUMBER and type.btycode='STFBRW'
                        where patron.EMAILNOTICES=1 and upper(EMAIL) not like '%FREDERICKCOUNTYMD.GOV'


;
--  Outreach new registrations

select distinct newreg.patronid, newreg.name , branch.BRANCHCODE regbranch,newreg.USERID,type.BTYNAME,newreg.REGDATE

    from patron_v2 newreg
    --inner join UDFVALUE_V2 udfvalue on (udfvalue.numcode = udfpatron.numcode) and (udfvalue.fieldid = udfpatron.fieldid)
     inner join bty_v2 type on newreg.bty = type.BTYNUMBER
   inner join branch_v2 branch on newreg.REGBRANCH = branch.BRANCHNUMBER
    inner join TXLOG_V2 trans on trans.patronid=newreg.PATRONID
    where
        newreg.USERID='cc0' and
        upper(trans.TRANSACTIONTYPE)= 'PR' and
         -- newreg.REGBRANCH = 18 and
       -- branch.BRANCHCODE='VAN' and
       trans.termnumber='$ZT0.#EC' and
        trunc(regdate) ='14-Sep-24'

    order by trunc(REGDATE) desc ;

select patronid,name from PATRON_V2 where name like ('%PROGRAM%');

select distinct newreg.patronid, /*newreg.name,*/ branch.BRANCHCODE regbranch,
                type.BTYNAME,trans.TERMNUMBER,newreg.REGDATE

    from patron_v2 newreg
    --inner join UDFVALUE_V2 udfvalue on (udfvalue.numcode = udfpatron.numcode) and (udfvalue.fieldid = udfpatron.fieldid)
     inner join bty_v2 type on newreg.bty = type.BTYNUMBER
     inner join branch_v2 branch on newreg.REGBRANCH = branch.BRANCHNUMBER
     inner join TXLOG_V2 trans on trans.patronid=newreg.PATRONID
    where
         -- newreg.REGBRANCH = 18 and
        branch.BRANCHCODE='VAN' AND
       --trans.termnumber='$ZT0.#EC' and
        trunc(newreg.regdate) = '31-JAN-24'

    order by trunc(newreg.REGDATE) desc ;

-- All New Reg
select distinct newreg.patronid, newreg.name , branch.BRANCHCODE regbranch,newreg.USERID,type.BTYNAME,
                trunc(newreg.REGDATE)

    from patron_v2 newreg
    --inner join UDFVALUE_V2 udfvalue on (udfvalue.numcode = udfpatron.numcode) and (udfvalue.fieldid = udfpatron.fieldid)
   inner join bty_v2 type on newreg.bty = type.BTYNUMBER
   inner join branch_v2 branch on newreg.REGBRANCH = branch.BRANCHNUMBER
    --inner join TXLOG_V2 trans on trans.patronid=newreg.PATRONID
    where

        trunc(regdate) LIKE '%SEP-24'
    --and BTYNAME not like 'Web Registration%'

    order by trunc(REGDATE) asc  ;


select patronid,name from PATRON_V2 where name like ('%PROGRAM%');

-- New checkouts at outreach
select   newreg.patronid, /*trans.item,
                book.bid, */ bib.title, book.cn,
              trunc(trans.TRANSDATE) LoanDate, branch.BRANCHCODE,  codes.CODEVALUE


    from patron_v2 newreg

    inner join bty_v2 type on newreg.bty = type.BTYNUMBER
    inner join TRANSITEM_V2 trans on trans.patronid=newreg.PATRONID
    inner join branch_v2 branch on trans.BRANCH = branch.BRANCHNUMBER
    inner join SYSTEMCODEVALUES_V2 codes on trans.TRANSCODE = codes.CODEVALUE
    inner join ITEM_V2 book on trans.ITEM = book.ITEM
    inner join BBIBMAP_V2 bib on book.BID = bib.BID

    where

        branch.BRANCHCODE='VAN' and
        (codes.CODETYPE=2 OR codes.CODETYPE=4 OR codes.CODETYPE=5) and
        trunc(trans.TRANSDATE)='31-JAN-24'

    order by trunc(trans.TRANSDATE) desc ;

-- Patrons No EMail
Select * from Patron_v2 patrons
where emailnotices=1 and (email is null or email like '' or regexp_like(email,'^\s+'));

-- Items circulating
select count(*)
    from ITEM_V2 item inner JOIN SYSTEMITEMCODES_V2 itemstatus
        on Item.status=itemstatus.code
    inner join MEDIA_V2 media on Item.media = media.MEDNUMBER
where
    media.medcode='RABK'
    and
    SUPPRESSED='N'
AND
(
DESCRIPTION Like 'On Shelf%'
OR
DESCRIPTION Like '%Hold%'
OR
DESCRIPTION LIKE 'In Transit%'
OR
DESCRIPTION LIKE 'Checked Out%'
OR
DESCRIPTION LIKE 'Received'
OR
DESCRIPTION LIKE 'Display'
-- OR
-- DESCRIPTION LIKE '%DELAY'
)
--group by item.item
;

--Hip Hop Collection
select bib.bid,  bib.CALLNUMBER,marc.TAGNUMBER,tags.worddata,tags.TAGDATA
from bbibmap_v2 bib
inner join bbibcontents_v2 marc on bib.bid = marc.bid
inner join btags_v2 tags on tags.tagid=marc.tagid
where ((marc.tagnumber='245' or marc.tagnumber='650' or marc.tagnumber='520' ) and
regexp_like(upper(tags.worddata),'HIP-HOP') );

select bib.bid,  bib.CALLNUMBER,marc.TAGNUMBER,tags.worddata,tags.TAGDATA
from bbibmap_v2 bib
inner join bbibcontents_v2 marc on bib.bid = marc.bid
inner join btags_v2 tags on tags.tagid=marc.tagid
where ((marc.tagnumber='245' or marc.tagnumber='650' or marc.tagnumber='520' ) and
(upper(tags.worddata) like '%HIP-HOP%') );



-- Instr function 17 s
select i.item, i.bid, bc.tagid, bc.tagnumber, bt.tagdata
from item_v2 i, bbibmap_v2 b,bbibcontents_v2 bc, btags_v2 bt
where i.instbit = 1770
and bc.instbit = 1770
and i.bid = b.bid
and bc.bid = b.bid
and bc.tagid = bt.tagid
and (bc.tagnumber = 650 or bc.TAGNUMBER=520 or bc.TAGNUMBER=245)
and instr(upper(bt.tagdata),'HIP-HOP')>0
order by i.bid, i.item, bc.tagid, bc.tagnumber;

-- Like version takes 20 seconds
select item.item, bib.bid,  bib.CALLNUMBER,marc.TAGNUMBER,tags.worddata,tags.TAGDATA
from bbibmap_v2 bib
inner join item_v2 item on item.bid = bib.BID
inner join bbibcontents_v2 marc on bib.bid = marc.bid
inner join btags_v2 tags on tags.tagid=marc.tagid and ((marc.tagnumber='245') or ( marc.tagnumber='650') or (marc.tagnumber='520' ))
where (upper(tags.worddata) like '%HIP_HOP%') ;

--Regexp version takes minutes to run
select bib.bid,  bib.CALLNUMBER,marc.TAGNUMBER,tags.worddata
from bbibmap_v2 bib
inner join bbibcontents_v2 marc on bib.bid = marc.bid
inner join btags_v2 tags on tags.tagid=marc.tagid and ((marc.tagnumber='245') or ( marc.tagnumber='650') or (marc.tagnumber='520' ))
where regexp_like(upper(tags.worddata),'^.*HIP.HOP.*$') ;

-- Ad Hoc Titles using TransBid- Only Holds
SELECT COUNT(t.bid),t.TRANSCODE,b.bid, t.MEDIA, b.title, b.author
FROM TRANSBID_V2 t
JOIN bbibmap_v2 b on b.bid=t.bid
WHERE
--t.TRANSCODE LIKE 'C%' or t.TRANSCODE='DC' or t.TRANSCODE='RN' AND
jts.todate(t.TRANSDATE) > ADD_MONTHS(sysdate, -3)
  --AND jts.todate(t.TRANSDATE) < sysdate
--AND b.format <> 47
AND t.MEDIA IN (6,7,8,9,10,11,12,20,21,25,26,28,40,42,49,50,52) --
GROUP BY b.bid, t.TRANSCODE, t.media, b.title, b.author
ORDER BY COUNT(t.bid) DESC, MEDIA
--FETCH FIRST 100 ROWS ONLY
;
-- Ad Hoc Titles using TransItem
SELECT COUNT(t.item),t.TRANSCODE,i.bid, i.MEDIA, b.title, b.author
FROM TRANSITEM_V2 t
Join ITEM_V2 i on i.item=t.ITEM
JOIN bbibmap_v2 b on b.bid=i.bid
WHERE
--t.TRANSCODE LIKE 'C%' or t.TRANSCODE='DC' or t.TRANSCODE='RN' AND
jts.todate(t.TRANSDATE) > ADD_MONTHS(sysdate, -3)
  --AND jts.todate(t.TRANSDATE) < sysdate
--AND b.format <> 47
AND i.MEDIA IN (6,7,8,9,10,11,12,20,21,25,26,28,40,42,49,50,52) --
GROUP BY i.bid, t.TRANSCODE, i.media, b.title, b.author
ORDER BY COUNT(t.item) DESC, MEDIA
--FETCH FIRST 100 ROWS ONLY
;
-- Ad Hoc Title Count
SELECT COUNT(t.item), t.envbranch, t.itembid, t.TRANSACTIONTYPE,t.ITEMMEDIA, b.title, b.author
FROM txlog_v2 t
join TRANSITEM_V2 ti on ti.ITEM = t.ITEM
JOIN bbibmap_v2 b
ON t.itembid = b.bid
WHERE t.transactiontype in ('C', 'CH','CT','R*')
AND jts.todate(t.systemtimestamp) > ADD_MONTHS(sysdate, -3) AND jts.todate(t.systemtimestamp) < sysdate
AND b.format <> 47 AND
t.itemmedia IN (6,7,8,9,10, 11, 12,20,21,25,26,28,40,42,50,52) -- this is currently just print
GROUP BY t.envbranch, t.itembid, t.TRANSACTIONTYPE,t.ITEMMEDIA, b.title, b.author
ORDER BY COUNT(t.item) DESC
FETCH FIRST 200 ROWS ONLY;

-- Popular Title Ad-Hoc Count

SELECT (b.title || ' ' || b.author) "title author" ,COUNT(t.item)
FROM txlog_v2 t
JOIN bbibmap_v2 b
ON t.itembid = b.bid
WHERE t.transactiontype = 'CH'
AND jts.todate(t.systemtimestamp) > ADD_MONTHS(sysdate, -3) AND jts.todate(t.systemtimestamp) < sysdate
AND b.format <> 47 AND
t.itemmedia IN (6,8,9,12,20,21,25,26,28,40,42,50,52) -- this is currently just print
GROUP BY b.title, b.author
ORDER BY COUNT(t.item) DESC
FETCH FIRST 25 ROWS ONLY;

--Top Titles by Branch:

SELECT
  COUNT(TXLOG_V2.ITEMBID),
  BBIBMAP_V2.TITLE,
  BBIBMAP_V2.PUBLISHINGDATE,
  FORMATTERM_V2.FORMATTEXT
FROM
  TXLOG_V2
LEFT JOIN branch_V2 ON txlog_V2.envbranch = branch_V2.branchnumber
LEFT JOIN BBIBMAP_V2
ON  TXLOG_V2.ITEMBID = BBIBMAP_V2.BID
LEFT JOIN FORMATTERM_V2
ON  BBIBMAP_V2.FORMAT = FORMATTERM_V2.FORMATTERMID
WHERE  TXLOG_V2.TRANSACTIONTYPE = 'CH'
AND branch_V2.branchcode = :BRANCH
AND  ( TXLOG_V2.SYSTEMTIMESTAMP   >= (TO_DATE('01-JAN-2024'))
  AND TXLOG_V2.SYSTEMTIMESTAMP <= (SYSDATE)  )
GROUP BY
  BBIBMAP_V2.TITLE,
  BBIBMAP_V2.PUBLISHINGDATE,
  FORMATTERM_V2.FORMATTEXT;

-- Item fuel gauge

SELECT
ITEM_V2.ITEM,
BBIBMAP_V2.CALLNUMBER,
BBIBMAP_V2.TITLE,
BBIBMAP_V2.AUTHOR,
ITEM_V2.STATUS,
BRANCH_V2.BRANCHCODE      AS BRANCH,
LOCATION_V2.LOCCODE       AS LOCATION

FROM         BBIBMAP_V2
LEFT JOIN ITEM_V2 ON BBIBMAP_V2.BID = ITEM_V2.BID
LEFT JOIN BRANCH_V2 ON ITEM_V2.BRANCH = BRANCH_V2.BRANCHNUMBER
LEFT JOIN LOCATION_V2 ON ITEM_V2.LOCATION = LOCATION_V2.LOCNUMBER
LEFT JOIN MEDIA_V2 ON ITEM_V2.MEDIA = MEDIA_V2.MEDNUMBER
LEFT JOIN
  (SELECT     BID, COUNT(ITEM) AS TCNT
   FROM          ITEM_V2 ITEM_V2_1
   WHERE         (ITEM_V2_1.STATUS = 'S')
   GROUP BY BID)
    TOTCIRC_SYS ON BBIBMAP_V2.BID = TOTCIRC_SYS.BID
LEFT JOIN
  (SELECT     ITEM_V2_2.BID, COUNT(ITEM_V2_2.ITEM) AS BCNT
   FROM          BRANCH_V2 BRANCH_V2_1
   LEFT JOIN ITEM_V2 ITEM_V2_2 ON BRANCH_V2_1.BRANCHNUMBER = ITEM_V2_2.BRANCH
   WHERE     (BRANCH_V2_1.BRANCHCODE = 'CBA')
   AND         (ITEM_V2_2.STATUS = 'S')
   GROUP BY ITEM_V2_2.BID)
    TOTCIRC_BRA ON BBIBMAP_V2.BID = TOTCIRC_BRA.BID

WHERE (
    -- (BRANCH_V2.BRANCHCODE = 'CBA') AND
--(ITEM_V2.STATUS = 'S') and
(LOCATION_V2.LOCCODE LIKE 'AP%')
AND (TOTCIRC_BRA.BCNT > 3)
AND (TOTCIRC_SYS.TCNT = TOTCIRC_BRA.BCNT))
;

-- Nested Gauge
SELECT ITEM_V2.ITEM,
                    BBIBMAP_V2.BID,
                    BBIBMAP_V2.CALLNUMBER,
                    BBIBMAP_V2.TITLE,
                    BBIBMAP_V2.AUTHOR,
                    ITEM_V2.STATUS,
                    BRANCH_V2.BRANCHCODE AS BRANCH,
                    LOCATION_V2.LOCCODE  AS LOCATION

             FROM BBIBMAP_V2
                      LEFT JOIN ITEM_V2 ON BBIBMAP_V2.BID = ITEM_V2.BID
                      LEFT JOIN BRANCH_V2 ON ITEM_V2.BRANCH = BRANCH_V2.BRANCHNUMBER
                      LEFT JOIN LOCATION_V2 ON ITEM_V2.LOCATION = LOCATION_V2.LOCNUMBER
                      LEFT JOIN MEDIA_V2 ON ITEM_V2.MEDIA = MEDIA_V2.MEDNUMBER
                      LEFT JOIN
                  (SELECT BID, COUNT(ITEM) AS TCNT
                   FROM ITEM_V2 ITEM_V2_1
                    WHERE (ITEM_V2_1.STATUS = 'S')
                   GROUP BY BID) TOTCIRC_SYS ON BBIBMAP_V2.BID = TOTCIRC_SYS.BID
                      LEFT JOIN
                  (SELECT ITEM_V2_2.BID, COUNT(ITEM_V2_2.ITEM) AS BCNT
                   FROM BRANCH_V2 BRANCH_V2_1
                            LEFT JOIN ITEM_V2 ITEM_V2_2 ON BRANCH_V2_1.BRANCHNUMBER = ITEM_V2_2.BRANCH
                   WHERE (BRANCH_V2_1.BRANCHCODE = :branch)
                   AND (ITEM_V2_2.STATUS = 'S')
                   GROUP BY ITEM_V2_2.BID) TOTCIRC_BRA ON BBIBMAP_V2.BID = TOTCIRC_BRA.BID

             WHERE (
                       (BRANCH_V2.BRANCHCODE = :branch) AND
                        ITEM_V2.STATUS = 'S' AND
                           (LOCATION_V2.LOCCODE LIKE 'AP%')
                           AND (TOTCIRC_BRA.BCNT > 3)
                           AND (TOTCIRC_SYS.TCNT = TOTCIRC_BRA.BCNT)
                       )

        ;

-- None belong to other branches
SELECT
ITEM_V2.ITEM,
ITEM_V2.STATUS,
BBIBMAP_V2.CALLNUMBER,
BBIBMAP_V2.TITLE,
BBIBMAP_V2.AUTHOR,
ITEM_V2.STATUS,
OTHER_BRA.NOCNT,
BRANCH_V2.BRANCHCODE      AS BRANCH,
LOCATION_V2.LOCCODE       AS LOCATION

FROM         BBIBMAP_V2
LEFT JOIN ITEM_V2 ON BBIBMAP_V2.BID = ITEM_V2.BID
LEFT JOIN BRANCH_V2 ON ITEM_V2.BRANCH = BRANCH_V2.BRANCHNUMBER
LEFT JOIN LOCATION_V2 ON ITEM_V2.LOCATION = LOCATION_V2.LOCNUMBER
LEFT JOIN MEDIA_V2 ON ITEM_V2.MEDIA = MEDIA_V2.MEDNUMBER
LEFT JOIN
  (SELECT     BID, COUNT(ITEM) AS TCNT
   FROM          ITEM_V2 ITEM_V2_1
   WHERE         (ITEM_V2_1.STATUS = 'S')
   GROUP BY BID)
    TOTCIRC_SYS ON BBIBMAP_V2.BID = TOTCIRC_SYS.BID
LEFT JOIN
  (SELECT     ITEM_V2_2.BID, COUNT(ITEM_V2_2.ITEM) AS BCNT
   FROM          BRANCH_V2 BRANCH_V2_1
   LEFT JOIN ITEM_V2 ITEM_V2_2 ON BRANCH_V2_1.BRANCHNUMBER = ITEM_V2_2.BRANCH
   WHERE     (BRANCH_V2_1.BRANCHCODE = :branch )
   AND         (ITEM_V2_2.STATUS = 'S')
   GROUP BY ITEM_V2_2.BID)
    TOTCIRC_BRA ON BBIBMAP_V2.BID = TOTCIRC_BRA.BID
LEFT JOIN
  (SELECT     ITEM_V2_3.BID, COUNT(ITEM_V2_3.ITEM) AS NOCNT
   FROM          BRANCH_V2 BRANCH_V2_2
   LEFT JOIN ITEM_V2 ITEM_V2_3 ON BRANCH_V2_2.BRANCHNUMBER = ITEM_V2_3.BRANCH
   WHERE     (BRANCH_V2_2.BRANCHCODE != :branch)
   GROUP BY ITEM_V2_3.BID)
    OTHER_BRA ON BBIBMAP_V2.BID = OTHER_BRA.BID


WHERE (
    -- (BRANCH_V2.BRANCHCODE = 'CBA') AND
   -- (ITEM_V2.STATUS = 'S') AND
(LOCATION_V2.LOCCODE LIKE 'AP%')
AND (TOTCIRC_BRA.BCNT > 3)
AND (TOTCIRC_SYS.TCNT = TOTCIRC_BRA.BCNT)
-- AND OTHER_BRA.NOCNT = 0
    )

GROUP BY ITEM_V2.ITEM,
BBIBMAP_V2.CALLNUMBER,
BBIBMAP_V2.TITLE,
BBIBMAP_V2.AUTHOR,
ITEM_V2.STATUS,
OTHER_BRA.NOCNT,
BRANCH_V2.BRANCHCODE,
LOCATION_V2.LOCCODE

--ORDER BY ITEM_V2.BRANCH, ITEM_V2.STATUS
;
-- Patrons born since 1/1/2000
select count(PATRONID)
    from CARLREPORTS.PATRON_V2 patron
    inner join BTY_V2 type on type.BTYNUMBER = patron.BTY
    where
        trunc(patron.BIRTHDATE) >= '1-JAN-2000'
       OR
     upper(type.BTYCODE) in ('STUDNT', 'GRAD')

;
-- Grad accounts activity since 9/1/2021
select count(PATRONID)
    from CARLREPORTS.PATRON_V2 patron
    inner join BTY_V2 type on type.BTYNUMBER = patron.BTY
    where
     upper(type.BTYCODE)= 'GRAD'
and
        trunc(patron.ACTDATE) > '01-SEP-2021'

;
-- All Grad accounts
select count(PATRONID)
    from CARLREPORTS.PATRON_V2 patron
    inner join BTY_V2 type on type.BTYNUMBER = patron.BTY
    where
     upper(type.BTYCODE)= 'GRAD'
    and
    trunc(patron.actdate) < '09-SEP-2021'


;


-- All Student accounts
select count(PATRONID)
    from CARLREPORTS.PATRON_V2 patron
    inner join BTY_V2 type on type.BTYNUMBER = patron.BTY
    where
     upper(type.BTYCODE)= 'STUDNT'

;

-- All Student accounts
select count(PATRONID)
    from CARLREPORTS.PATRON_V2 patron
    inner join BTY_V2 type on type.BTYNUMBER = patron.BTY
    where
     patron.status != 'G' OR (
        upper(type.BTYCODE) in ('GRAD', 'STUDNT') and
        trunc(patron.ACTDATE) < '01-SEP-2021' and
        trunc(patron.EDITDATE) < '01-SEP-2021' and
        trunc(patron.REGDATE) < '01-SEP-2021'
        )
;

select patron.PATRONID, patron.NAME, type.BTYCODE , patron.STATUS,
       trunc(patron.ACTDATE), trunc(patron.REGDATE), trunc(patron.EDITDATE)
    from CARLREPORTS.PATRON_V2 patron
    inner join BTY_V2 type on type.BTYNUMBER = patron.BTY
    --where upper(type.BTYCODE) in ('GRAD', 'STUDNT')
    where upper(type.BTYCODE) in ('GRAD')
          and
          trunc(patron.ACTDATE) < '09-SEP-2021'
       --  trunc(patron.EDITDATE) < '01-SEP-2021' and
        --  trunc(patron.REGDATE) < '01-SEP-2021'
order by trunc(patron.EDITDATE) asc
    ;

select count(patron.PATRONID)
    from CARLREPORTS.PATRON_V2 patron
    inner join BTY_V2 type on type.BTYNUMBER = patron.BTY
    where upper(type.BTYCODE) in ('GRAD', 'STUDNT')
        and
          trunc(patron.ACTDATE) < '01-SEP-2021' and
          trunc(patron.EDITDATE) < '01-SEP-2021' and
          trunc(patron.REGDATE) < '01-SEP-2021'

    ;
-- Attempt to recreate Canned Report 33
select trunc(current_date),BR.BRANCHCODE, BR.BRANCHNAME, BTYNAME,Count(*)
from CARLREPORTS.PATRON_V2 P, BRANCH_V2 BR , BTY_V2 BT
where P.DEFAULTBRANCH= BR.BRANCHNUMBER
and trunc(P.REGDATE) < trunc(current_date)
and P.BTY= BT.BTYNUMBER
group by br.BRANCHCODE, trunc(current_date), BR.BRANCHNAME, BTYNAME
order by BR.BRANCHCODE, BR.BRANCHNAME, BTYNAME
       ;