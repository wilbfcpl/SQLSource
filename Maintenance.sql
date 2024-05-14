
select distinct bib.bid, bib.BIBTYPE, bib.HIDDENTYPE ,  bib.ERESOURCE,bib.CALLNUMBER,
       bib.TITLE

from CARLREPORTS.BBIBMAP_V2 bib
inner join "ItemlessBids-06132023" list on bib.bid = list.BIDS
-- inner join BIBLOG_V2 log on bib.bid = log.bid

;
select * from "ItemlessBids-06132023";

--select distinct bib.bid, bib.BIBTYPE, bib.HIDDENTYPE ,  bib.ERESOURCE,bib.CALLNUMBER, bib.TITLE
select list.BIDS
       --, bib.BIBTYPE, bib.CALLNUMBER,bib.ERESOURCE,bib.HIDDENTYPE,
       -- bib.ACQTYPE,bib.SUPPRESSDATE,bib.SUPPRESSTYPE, bib.title

from "ItemlessBids-06132023" list
-- inner join  BBIBMAP_V2 bib on bib.bid = list.BIDS
--left outer join GMU_BIDS_06132023 gmu on list.BIDS=gmu.BID
 -- join GMU_BIDS_06132023 gmu on gmu.bid = list.BIDS
where
    BIDS not in (select bid from ILL_06132023 ILL)
and
BIDS not in (select bid from GMU_BIDS_06132023 gmu )
;
-- Need some view of the Logs after Delete Bibs runs.

-- Look for the Delete Bibs Remove String

select bc.bid, bib.CALLNUMBER, bt.WORDDATA removestring

from bbibcontents_v2 bc
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid
where (
       regexp_like(bt.WORDDATA, '^\s*Remove Empty.+$')
    )
 and  bc.tagnumber=590
 --and bib.ACQTYPE = 0
order by bib.bid, bib.CALLNUMBER ;

-- Patrons No EMail
Select * from Patron_v2 patrons
where emailnotices=1 and (email is null or email like '' or regexp_like(email,'^\s+'));

-- Items Not On Shelf Thirty Days
select item.item, item.bid , status , statusdate

    from item_v2 item
inner join BBIBMAP_V2 bib on item.bid = bib.BID
where trunc(STATUSDATE) < CURRENT_DATE-30
;

-- Item Status queries from CarlX Ad-Hoc Basecamp
--items not on shelf from a week ago
select item, status, branch.BRANCHCODE, description, trunc(statusdate)
from item_v2
inner join BRANCH_V2 branch on branch.BRANCHNUMBER = item_v2.BRANCH
inner join SYSTEMITEMCODES_V2 codes on item_v2.status = codes.code
where status = 'SX'
and statusdate <= sysdate - 28
;

select a.item, a.status, b.description, a.statusdate from item_v2 a
join systemitemcodes_v2 b
on a.status = b.code
where a.status = 'SW' or (a.status = 'SM' and a.statusdate <= sysdate-182.5) or (a.status = 'SX' and a.statusdate <= sysdate-30)
;

--  Outreach new registrations
select distinct newreg.patronid, /*newreg.name,*/ branch.BRANCHCODE regbranch,type.BTYNAME,/*trans.TERMNUMBER,*/newreg.REGDATE

    from patron_v2 newreg
    --inner join UDFVALUE_V2 udfvalue on (udfvalue.numcode = udfpatron.numcode) and (udfvalue.fieldid = udfpatron.fieldid)
     inner join bty_v2 type on newreg.bty = type.BTYNUMBER
   inner join branch_v2 branch on newreg.REGBRANCH = branch.BRANCHNUMBER
    inner join TXLOG_V2 trans on trans.patronid=newreg.PATRONID
    where
         -- newreg.REGBRANCH = 18 and
        branch.BRANCHCODE='CBA' and
        trans.termnumber='$ZT0.#EC' and
        trunc(regdate) ='09-Sep-23'

    order by trunc(REGDATE) desc ;

select patronid,name from PATRON_V2 where name like ('%PROGRAM%');


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

-- Items circulating, experiment for Shelving Delay and Display status
select count(*)
    from ITEM_V2 item inner JOIN SYSTEMITEMCODES_V2 itemstatus
        on Item.status=itemstatus.code
    inner join MEDIA_V2 media on Item.media = media.MEDNUMBER
where
    --media.medcode='RABK'
    --and
    SUPPRESSED='N'
AND
(
-- DESCRIPTION Like 'On Shelf%'
-- OR
-- DESCRIPTION Like '%Hold%'
-- OR
-- DESCRIPTION LIKE 'In Transit%'
-- OR
--upper(DESCRIPTION) LIKE 'CHECKED OUT%'
-- OR
-- DESCRIPTION LIKE 'Received'
-- OR
upper(DESCRIPTION) LIKE 'DISPLAY'
OR
upper(DESCRIPTION) LIKE 'SHELVING DELAY'
)
--group by item.item
;

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

-- Experiment converting Students101823.csv to Teen Borrower Type

select patron.PATRONID, patron.name, type.BTYCODE, patron.STREET1 , branch.BRANCHCODE
    from CARLREPORTS.PATRON_V2 patron
    inner join CARLREPORTS.BTY_V2 type on Patron.BTY = type.BTYNUMBER
     inner join CARLREPORTS.BRANCH_V2 branch on patron.DEFAULTBRANCH = branch.BRANCHNUMBER
where upper(type.BTYCODE) = 'TEEN' ;

-- 11/08/2023 Uncertain DOB, new 501 Note
select distinct student.patronid, student.name, student.userid, student.zip1,student.STATUS,trunc(ACTDATE) act,trunc(student.SACTDATE) sactdate,trunc(student.editdate) eddate,trunc(student.birthdate) dob,note.refid,note.NOTETYPE,
       note.text
    from patron_v2 student
   -- inner join "12toPUBLIC_VerifyBirthdateNote_1" on student.patronid="12toPUBLIC_VerifyBirthdateNote_1".PATRONID
    inner join PATRONNOTETEXT_V2 note on student.PATRONID=note.REFID

     where
               note.NOTETYPE=501 AND
              regexp_like (upper(note.text),'^VERIFY BIRTHDATE.*$')
    order by PATRONID ;

select distinct student.patronid, student.name, student.zip1,student.STATUS,
                trunc(ACTDATE),trunc(student.editdate),note.refid,note.NOTETYPE,
       note.text
    from patron_v2 student

 inner join PATRONNOTETEXT_V2 note on student.PATRONID=note.REFID

     where
                note.NOTETYPE=501
              -- NOT regexp_like (upper(note.text),'WE WOULD LIKE.+BIRTHDATE.+$')
    order by PATRONID ;

-- Get the notes to remove as cleanup.
select student.patronid, note.noteid, note.notetype, note.alias, note.TIMESTAMP
       ,note.text, patron_v2.NAME,
       student.STATUS
    from "12toPUBLIC_VerifyBirthdateNote_1" student
    inner join PATRON_V2 on student.PATRONID = patron_v2.PATRONID
   inner join PATRONNOTETEXT_V2 note on student.PATRONID=note.REFID

     where
               note.NOTETYPE=501
              -- NOT regexp_like (upper(note.text),'WE WOULD LIKE.+BIRTHDATE.+$')
    order by PATRONID ;

-- Circulation float maintenance
SELECT     ITEM_V2.BID,
  ITEM_V2.ITEM,
  TRIM (TRAILING '.' FROM BBIBMAP_V2.AUTHOR) AS AUTHOR,
  BBIBMAP_V2.TITLE,
  '="'||BBIBMAP_V2.ISBN||'"' AS ISBN,
  BBIBMAP_V2.PUBLISHINGDATE      AS PUB,
  BBIBMAP_V2.CALLNUMBER          AS "CALLNO",
  SYSTEMITEMCODES_V2.DESCRIPTION AS STATUS,
  BRANCH_V2.BRANCHCODE      AS BRANCH,
  LOCATION_V2.LOCCODE       AS LOCATION,
  '="'||MEDIA_V2.MEDCODE||'"' AS MEDIA,
  to_char((TRUNC(ITEM_V2.STATUSDATE)),'mm-dd-yyyy') AS "LAST DATE",
  to_char((ITEM_V2.CREATIONDATE),'mm-dd-yyyy')      AS "CREATION DATE",
TOTCIRC_SYS.TCNT,
TOTCIRC_BRA.BCNT,
FORMATTERM_V2.FORMATTEXT
FROM         BBIBMAP_V2
LEFT JOIN ITEM_V2 ON BBIBMAP_V2.BID = ITEM_V2.BID AND (ITEM_V2.STATUS = 'S')
LEFT JOIN FORMATTERM_V2 ON BBIBMAP_V2.FORMAT = FORMATTERM_V2.FORMATTERMID
LEFT JOIN BRANCH_V2 ON ITEM_V2.BRANCH = BRANCH_V2.BRANCHNUMBER
LEFT JOIN LOCATION_V2 ON ITEM_V2.LOCATION = LOCATION_V2.LOCNUMBER
LEFT JOIN MEDIA_V2 ON ITEM_V2.MEDIA = MEDIA_V2.MEDNUMBER
LEFT JOIN SYSTEMITEMCODES_V2
ON ITEM_V2.STATUS   = SYSTEMITEMCODES_V2.CODE
AND ITEM_V2.INSTBIT = SYSTEMITEMCODES_V2.INSTBIT
LEFT JOIN
  (SELECT     BID, COUNT(ITEM) AS TCNT
   FROM          ITEM_V2 ITEM_V2_1
   GROUP BY BID)
TOTCIRC_SYS ON BBIBMAP_V2.BID = TOTCIRC_SYS.BID
LEFT JOIN
  (SELECT     ITEM_V2_2.BID, COUNT(ITEM_V2_2.ITEM) AS BCNT
   FROM          BRANCH_V2 BRANCH_V2_1
   LEFT JOIN ITEM_V2 ITEM_V2_2 ON BRANCH_V2_1.BRANCHNUMBER = ITEM_V2_2.BRANCH
   WHERE      (BRANCH_V2_1.BRANCHCODE = 'CBA')
   GROUP BY ITEM_V2_2.BID)
TOTCIRC_BRA ON BBIBMAP_V2.BID = TOTCIRC_BRA.BID
WHERE ((BRANCH_V2.BRANCHCODE = 'CBA')
--AND (ITEM_V2.STATUS = 'S')
AND (TOTCIRC_BRA.BCNT > 3)
AND (TOTCIRC_SYS.TCNT  = TOTCIRC_BRA.BCNT)
    AND CALLNUMBER not like ( '%PERIODICAL')
    AND LOCATION_V2.LOCCODE NOT LIKE '%MDRM%'
    AND LOCATION_V2.LOCCODE NOT LIKE '%REF%'
    )
ORDER BY BID;

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

;
select count(txi.patronid)
from transitem_v2 txi
left join branch_v2 br on txi.pickupbranch=br.branchnumber
join patron_v2 p on txi.patronid=p.patronid
left join bty_v2 bty on p.bty=bty.btynumber
join item_v2 i on txi.item=i.item
join bbibmap_v2 b on i.bid=b.bid
where txi.transcode='H'
and trunc(txi.transdate) between trunc(sysdate)-365 and trunc(sysdate)-1
and p.bty not in (6,8,9)
and (p.ph1 is not null or p.ph2 is not null)
and (p.emailnotices!=1 or p.email is null or p.email=' ')
  and (p.sendholdavailablemsg='N' or p.phonetypeid1 in (0,1,47)) ;

--938 Duplicates
select bib.bid, tags.tagid, bib.CALLNUMBER,tags.worddata,tags.tagdata, count(marc.tagnumber)
from bbibmap_v2 bib
inner join bbibcontents_v2 marc on bib.bid = marc.bid
inner join btags_v2 tags on tags.tagid=marc.tagid

where marc.tagnumber='938'
group by bib.bid, tags.tagid, bib.CALLNUMBER, tags.worddata, tags.TAGDATA
having count(marc.TAGNUMBER) > 1
;

--938 Duplicates
select bib.bid, tags.tagid, tags2.tagid, tags.worddata,tags2.WORDDATA
from bbibcontents_v2 marc
inner join btags_v2 tags on marc.TAGID = tags.TAGID
inner join BBIBCONTENTS_V2 bib on bib.bid = marc.bid
inner join btags_v2 tags2 on (tags2.WORDDATA = tags.worddata) and (tags.tagid != tags2.tagid)


where marc.tagnumber='938'
group by bib.bid, tags.tagid, tags2.tagid, tags.worddata,tags2.WORDDATA ;

-- From the Basecamp but not clear how results for 590 differ from '590'
select bid,tagnumber,cont.tagid,cont.tagnumber,cont.folder,count(tagnumber)
FROM BBIBCONTENTS_V2 cont
WHERE TAGNUMBER = '590'
group by bid,tagnumber, cont.tagid,cont.tagnumber,cont.folder
HAVING COUNT(*) > 1;

select marc.bid,marc.tagnumber,marc.tagid,count(marc.tagnumber),tags.worddata,tags.TAGDATA
FROM BBIBCONTENTS_V2 marc

inner join btags_v2 tags on marc.TAGID = tags.TAGID
--inner join btags_v2 tags2 on (tags2.tagdata = tags.tagdATA) and (tags.tagid != tags2.tagid)
WHERE marc.TAGNUMBER = 590
group by marc. bid,marc.tagnumber,marc.tagid,tags.worddata,tags.TAGDATA
having count(*) > 1
;

--590 Duplicates Feb 3 No easy way to match tagdata.
select marc.bid, tags.tagid, tags2.tagid, tags.worddata,tags2.WORDDATA,tags.TAGDATA,tags2.TAGDATA
from bbibcontents_v2 marc
inner join btags_v2 tags on marc.TAGID = tags.TAGID
--inner join BBIBCONTENTS_V2 bib on bib.bid = marc.bid
inner join btags_v2 tags2 on (tags2.tagdata = tags.tagDATA)
                                 --and (tags.tagid != tags2.tagid)
--inner join BBIBCONTENTS_V2 marc2 on marc2.bid = bib.bid

where marc.tagnumber=590 and marc.bid=31598
group by  marc.bid, tags.tagid, tags2.tagid, tags.worddata,tags2.worddata,tags.TAGDATA,tags2.TAGDATA

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

-  Outreach new registrations
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

-- Rogue CR
select bib.bid, bib.CALLNUMBER, item.cn, bib.title
    from BBIBMAP_V2 bib
inner join ITEM_V2 item on bib.bid = item.bid
 --   inner join LOCATION_V2 loc on loc.LOCNUMBER = item.LOCATION

where ( bib.bid =157736) or (bib. bid = 182594) or (bib.bid = 162121)or (bib.bid =79863);

--157736(BRU, CBA)
--182594(HQ, CBA)
--162121 (WAL)
--5699 (URL)
--79863 (MYE)

select bib.bid, bib.CALLNUMBER, item.cn,regexp_replace(item.cn,'\r','RRR' ) crreplace, replace(item.cn,chr(13),'RRR') replacement ,
       bib.title from BBIBMAP_V2 bib
inner join ITEM_V2 item on bib.bid = item.bid
 --   inner join LOCATION_V2 loc on loc.LOCNUMBER = item.LOCATION

where ( bib.bid =157736) or (bib. bid = 182594) or (bib.bid = 162121)or (bib.bid =79863);

select bib.bid, bib.CALLNUMBER, replace(item.cn,chr(13),'RRR') replacement ,
       bib.title from BBIBMAP_V2 bib
inner join ITEM_V2 item on bib.bid = item.bid
 --   inner join LOCATION_V2 loc on loc.LOCNUMBER = item.LOCATION

-- where ( bib.bid =157736) or (bib. bid = 182594) or (bib.bid = 162121)or (bib.bid =79863)
 where instr(item.cn,chr(13))> 0
;

-- Oracle Multibyte Character error ORA-29275 patron name has diacritic
select trunc(sysdate-1096) as cutoff, p.patronguid,p.status, p.name, trunc(p.birthdate), p.patronid, b.btycode,
  trunc(p.regdate) AS Register,   trunc(p.actdate) AS Active,
  trunc(p.sactdate) AS SelfServe,   trunc(p.editdate) AS Edit
from patron_v2 p, bty_v2 b
-- exclude ILL (3) and LIBUSE (6)

where
       length(p.name)<lengthb(p.name) AND
     p.bty=b.btynumber and p.bty not in (3,6)
  and (trunc(p.regdate) >= trunc(sysdate-1096)
    or trunc(p.actdate) >= trunc(sysdate-1096)
    or trunc(p.editdate) >= trunc(sysdate-1096)
    or trunc(p.sactdate) >= trunc(sysdate-1096))
;
--Fix with substrb. Find the Patron accounts with multibyte names
select trunc(sysdate-1096) as cutoff, p.patronguid,p.status, substrb(p.name,1), trunc(p.birthdate), p.patronid, b.btycode,
  trunc(p.regdate) AS Register,   trunc(p.actdate) AS Active,
  trunc(p.sactdate) AS SelfServe,   trunc(p.editdate) AS Edit
from patron_v2 p, bty_v2 b
-- exclude ILL (3) and LIBUSE (6)

where
       length(p.name)<lengthb(p.name) AND
     p.bty=b.btynumber and p.bty not in (3,6)
  and (trunc(p.regdate) >= trunc(sysdate-1096)
    or trunc(p.actdate) >= trunc(sysdate-1096)
    or trunc(p.editdate) >= trunc(sysdate-1096)
    or trunc(p.sactdate) >= trunc(sysdate-1096))
;


-- Determine Oracle Client Version
SELECT
  DISTINCT
  s.client_version
FROM
  v$session_connect_info s
WHERE
  s.sid = SYS_CONTEXT('USERENV', 'SID');

ALTER SESSION SET NLS_LANGUAGE='AMERICAN_AMERICA.AL16UTF16';
-- Determine Client Version
SELECT
  DISTINCT
  s.client_version
FROM
  v$session_connect_info s
WHERE
  s.sid = SYS_CONTEXT('USERENV', 'SID');

-- Language Params
SELECT * FROM V$NLS_PARAMETERS;
SELECT * FROM NLS_DATABASE_PARAMETERS;

-- dup name and email. First is not a webreg
select student.patronid, patron.PATRONID, student.email, student.name , student.BIRTHDATE,patron.BIRTHDATE,student.status, type.btycode, branchcode,
       trunc(student.regdate),trunc(student.editdate), trunc(student.actdate),trunc(student.SACTDATE)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join patron_v2 patron on (
                                        patron.email = student.email) and (patron.name=student.name)
                                        and (student.patronid!=patron.PATRONID)
                                        and student.status='G' and patron.status='G'

    where btycode!='WEBREG' and ( trunc(student.actdate)>trunc(sysdate)-1000 OR
                                trunc(patron.actdate)>trunc(sysdate)-1000 )
      group by student.patronid, patron.patronid,student.email, student.name ,student.BIRTHDATE,patron.BIRTHDATE,
 student.status,btycode, branchcode,
       trunc(student.regdate),trunc(student.editdate), trunc(student.actdate),trunc(student.SACTDATE)

      ;

-- 02/20/2024 Look for Multiple webregs. Work in Progress
select  patron.email, patron.birthdate, count(*)
    from patron_v2 patron
    inner join bty_v2 type on patron.bty = type.BTYNUMBER
    inner join branch_v2 branch on patron.REGBRANCH = branch.BRANCHNUMBER

   where  ( trunc(patron.actdate)>add_months(trunc(sysdate),-12*3)
        and patron.email is not null
        and patron.BIRTHDATE is not null
             )
      group by patron.email, patron.birthdate
      having count(*) > 1
order by count(*) desc
      ;

-- From the CarlX Ad-Hoc Query Basecamp, find Patron accounts with similar names
--https://3.basecamp.com/3903967/buckets/17115720/messages/4834351264#__recording_7101447189

select upper(p1.lastname), upper(p1.firstname),upper(p2.lastname), upper(p2.firstname),
UTL_MATCH.JARO_WINKLER_SIMILARITY(upper(p1.lastname),upper(p2.lastname)) as JWS_LASTNAME,
UTL_MATCH.JARO_WINKLER_SIMILARITY(upper(p1.firstname),upper(p2.firstname)) as JWS_FIRSTNAME,
p1.patronid,
y1.btyname,
b1.branchcode,
to_char(jts.todate(p1.actdate),'YYYY-MM-DD') as act1,
to_char(jts.todate(p1.sactdate),'YYYY-MM-DD') as sact1,
--to_char(jts.todate(p1.expdate),'YYYY-MM-DD') as exp1,
p2.patronid as patronid_2,
y2.btyname as btyname_2,
b2.branchcode as branchcode_2,
to_char(jts.todate(p2.actdate),'YYYY-MM-DD') as act2,
to_char(jts.todate(p2.sactdate),'YYYY-MM-DD') as sact2,
to_char(jts.todate(p2.expdate),'YYYY-MM-DD') as exp2
from patron_v p1
left join bty_v y1
on p1.bty = y1.btynumber
left join branch_v b1
on p1.defaultbranch = b1.branchnumber
inner join patron_v p2
on p1.patronid < p2.patronid
and p1.birthdate = p2.birthdate
and UTL_MATCH.JARO_WINKLER_SIMILARITY(upper(p1.lastname),upper(p2.lastname)) > 95
and UTL_MATCH.JARO_WINKLER_SIMILARITY(upper(p1.firstname), upper(p2.firstname)) > 90
left join bty_v y2
on p2.bty = y2.btynumber
left join branch_v b2
on p2.defaultbranch = b2.branchnumber
where upper(p1.lastname) like 'A%' -- this is so big that it is best to do one letter of the alphabet at a time!
and regexp_like(p1.patronid, '^[0-9]{9}$') --change to match a patronid type if you have many. In this case he was looking to find MNPS students who already had NPL cards.
and p1.birthdate > 0
order by p1.lastname
;

--Tableau Circulation Stats
SELECT DISTINCT "BRANCH_V2"."ACQBRANCH" AS "ACQBRANCH",
  "t0"."ACQTYPE" AS "ACQTYPE",
  "SYSTEMITEMCODES_V2"."ADMIN" AS "ADMIN",
  "BRANCH_V2"."ALLOWFLOATINGCOLLECTION" AS "ALLOWFLOATINGCOLLECTION _BRANC",
  "MEDIA_V2"."ALLOWFLOATINGCOLLECTION" AS "ALLOWFLOATINGCOLLECTION _MEDIA",
  "LOCATION_V2"."ALLOWFLOATINGCOLLECTION" AS "ALLOWFLOATINGCOLLECTION",
  "BRANCH_V2"."ALLOWHOLDS" AS "ALLOWHOLDS _BRANCH_V2_",
  "MEDIA_V2"."ALLOWHOLDS" AS "ALLOWHOLDS _MEDIA_V2_",
  "LOCATION_V2"."ALLOWHOLDS" AS "ALLOWHOLDS",
  "BRANCH_V2"."ALLOWRECALL" AS "ALLOWRECALL _BRANCH_V2_",
  "MEDIA_V2"."ALLOWRECALL" AS "ALLOWRECALL _MEDIA_V2_",
  "LOCATION_V2"."ALLOWRECALL" AS "ALLOWRECALL",
  "ITEM_V2"."ALTERNATESTATUS" AS "ALTERNATESTATUS",
  "SYSTEMITEMCODES_V2"."ARCHIVED" AS "ARCHIVED",
  "BRANCH_V2"."ASSESSGST" AS "ASSESSGST",
  "t0"."AUTHOR" AS "AUTHOR",
  "BRANCH_V2"."AUXLOANPERIODUNITINTERVAL" AS "AUXLOANPERIODUNITINTERVAL",
  "BRANCH_V2"."AUXLOANPERIODUNITTYPE" AS "AUXLOANPERIODUNITTYPE",
  "t0"."BIBLATESTCHANGE" AS "BIBLATESTCHANGE",
  "t0"."BIBTYPE" AS "BIBTYPE",
  "t0"."BID" AS "BID _BBIBMAP_V21_",
  "t1"."BID" AS "BID _Custom SQL Query_",
  ("ITEM_V2"."BID" + 0.0) AS "BID",
  "BRANCH_V2"."BRAFINEPAYMENT" AS "BRAFINEPAYMENT",
  "BRANCH_V2"."BRANCHADDRESS1" AS "BRANCHADDRESS1",
  "BRANCH_V2"."BRANCHADDRESS2" AS "BRANCHADDRESS2",
  "BRANCH_V2"."BRANCHCITY" AS "BRANCHCITY",
  "BRANCH_V2"."BRANCHCODE" AS "BRANCHCODE",
  "BRANCH_V2"."BRANCHGROUP" AS "BRANCHGROUP",
  "BRANCH_V2"."BRANCHNAME" AS "BRANCHNAME",
  "BRANCH_V2"."BRANCHNUMBER" AS "BRANCHNUMBER",
  "BRANCH_V2"."BRANCHPHONE" AS "BRANCHPHONE",
  "BRANCH_V2"."BRANCHRECEIPT" AS "BRANCHRECEIPT",
  "BRANCH_V2"."BRANCHZIPCODE" AS "BRANCHZIPCODE",
  "ITEM_V2"."BRANCH" AS "BRANCH",
  "BRANCH_V2"."BRCBRANCH" AS "BRCBRANCH",
  "BRANCH_V2"."BRCCODE" AS "BRCCODE",
  "t0"."CALLNUMBER" AS "CALLNUMBER _BBIBMAP_V21_",
  "t1"."CALLNUMBER" AS "CALLNUMBER",
  "BRANCH_V2"."CHARGELIMIT" AS "CHARGELIMIT _BRANCH_V2_",
  "MEDIA_V2"."CHARGELIMIT" AS "CHARGELIMIT _MEDIA_V2_",
  "LOCATION_V2"."CHARGELIMIT" AS "CHARGELIMIT",
  "BRANCH_V2"."CHARGELOANPERIOD" AS "CHARGELOANPERIOD _BRANCH_V2_",
  "MEDIA_V2"."CHARGELOANPERIOD" AS "CHARGELOANPERIOD _MEDIA_V2_",
  "LOCATION_V2"."CHARGELOANPERIOD" AS "CHARGELOANPERIOD",
  "ITEM_V2"."CIRCHISTORY" AS "CIRCHISTORY",
  "LOCATION_V2"."CIRCULATION_LEVEL" AS "CIRCULATION_LEVEL",
  "BRANCH_V2"."CLAIMBLOCKTYPE" AS "CLAIMBLOCKTYPE",
  "BRANCH_V2"."CLAIMHISTORYDAYS" AS "CLAIMHISTORYDAYS",
  "ITEM_V2"."CNFORMATTED" AS "CNFORMATTED",
  "ITEM_V2"."CNFULL" AS "CNFULL",
  "ITEM_V2"."CNLABEL" AS "CNLABEL",
  "ITEM_V2"."CN" AS "CN",
  "SYSTEMITEMCODES_V2"."CODE" AS "CODE",
  "MEDIA_V2"."CONTROLDISCHARGE" AS "CONTROLDISCHARGE",
  "BRANCH_V2"."CONTROLLINGBRANCH" AS "CONTROLLINGBRANCH",
  "ITEM_V2"."CREATEDBY" AS "CREATEDBY",
  "ITEM_V2"."CREATIONDATE" AS "CREATIONDATE",
  "ITEM_V2"."CUMULATIVEHISTORY" AS "CUMULATIVEHISTORY",
  "BRANCH_V2"."DEFAULTBTYNUMBER" AS "DEFAULTBTYNUMBER",
  "BRANCH_V2"."DEFAULTLOCATIONNUMBER" AS "DEFAULTLOCATIONNUMBER",
  "BRANCH_V2"."DEFAULTMEDIANUMBER" AS "DEFAULTMEDIANUMBER",
  "SYSTEMITEMCODES_V2"."DESCRIPTION" AS "DESCRIPTION",
  "MEDIA_V2"."DISPLAY" AS "DISPLAY",
  "BRANCH_V2"."DOESNOTCIRCULATEFLAG" AS "DOESNOTCIRCULATEFLAG _BRANCH_V",
  "MEDIA_V2"."DOESNOTCIRCULATEFLAG" AS "DOESNOTCIRCULATEFLAG _MEDIA_V2",
  "LOCATION_V2"."DOESNOTCIRCULATEFLAG" AS "DOESNOTCIRCULATEFLAG",
  "ITEM_V2"."DUEDATE" AS "DUEDATE",
  "ITEM_V2"."EDITDATE" AS "EDITDATE",
  "t0"."ERESOURCE" AS "ERESOURCE",
  "t0"."EXTERNALCONTROLNUMBER" AS "EXTERNALCONTROLNUMBER",
  "BRANCH_V2"."FINEASSESSMENTTYPE" AS "FINEASSESSMENTTYPE _BRANCH_V2_",
  "MEDIA_V2"."FINEASSESSMENTTYPE" AS "FINEASSESSMENTTYPE _MEDIA_V2_",
  "LOCATION_V2"."FINEASSESSMENTTYPE" AS "FINEASSESSMENTTYPE",
  "BRANCH_V2"."FINEGRACEPERIOD" AS "FINEGRACEPERIOD _BRANCH_V2_",
  "MEDIA_V2"."FINEGRACEPERIOD" AS "FINEGRACEPERIOD _MEDIA_V2_",
  "LOCATION_V2"."FINEGRACEPERIOD" AS "FINEGRACEPERIOD",
  "BRANCH_V2"."FINELIMIT" AS "FINELIMIT _BRANCH_V2_",
  "MEDIA_V2"."FINELIMIT" AS "FINELIMIT _MEDIA_V2_",
  "LOCATION_V2"."FINELIMIT" AS "FINELIMIT",
  "BRANCH_V2"."FINERATE" AS "FINERATE _BRANCH_V2_",
  "MEDIA_V2"."FINERATE" AS "FINERATE _MEDIA_V2_",
  "LOCATION_V2"."FINERATE" AS "FINERATE",
  "BRANCH_V2"."FINESNOTICEDAYS_0" AS "FINESNOTICEDAYS_0 _BRANCH_V2_",
  "MEDIA_V2"."FINESNOTICEDAYS_0" AS "FINESNOTICEDAYS_0 _MEDIA_V2_",
  "LOCATION_V2"."FINESNOTICEDAYS_0" AS "FINESNOTICEDAYS_0",
  "BRANCH_V2"."FINESNOTICEDAYS_1" AS "FINESNOTICEDAYS_1 _BRANCH_V2_",
  "MEDIA_V2"."FINESNOTICEDAYS_1" AS "FINESNOTICEDAYS_1 _MEDIA_V2_",
  "LOCATION_V2"."FINESNOTICEDAYS_1" AS "FINESNOTICEDAYS_1",
  "BRANCH_V2"."FINESNOTICEDAYS_2" AS "FINESNOTICEDAYS_2 _BRANCH_V2_",
  "MEDIA_V2"."FINESNOTICEDAYS_2" AS "FINESNOTICEDAYS_2 _MEDIA_V2_",
  "LOCATION_V2"."FINESNOTICEDAYS_2" AS "FINESNOTICEDAYS_2",
  "BRANCH_V2"."FINESNOTICEFEES_0" AS "FINESNOTICEFEES_0 _BRANCH_V2_",
  "MEDIA_V2"."FINESNOTICEFEES_0" AS "FINESNOTICEFEES_0 _MEDIA_V2_",
  "LOCATION_V2"."FINESNOTICEFEES_0" AS "FINESNOTICEFEES_0",
  "BRANCH_V2"."FINESNOTICEFEES_1" AS "FINESNOTICEFEES_1 _BRANCH_V2_",
  "MEDIA_V2"."FINESNOTICEFEES_1" AS "FINESNOTICEFEES_1 _MEDIA_V2_",
  "LOCATION_V2"."FINESNOTICEFEES_1" AS "FINESNOTICEFEES_1",
  "BRANCH_V2"."FINESNOTICEFEES_2" AS "FINESNOTICEFEES_2 _BRANCH_V2_",
  "MEDIA_V2"."FINESNOTICEFEES_2" AS "FINESNOTICEFEES_2 _MEDIA_V2_",
  "LOCATION_V2"."FINESNOTICEFEES_2" AS "FINESNOTICEFEES_2",
  "t0"."FOLDER" AS "FOLDER",
  "t0"."FORMAT" AS "FORMAT",
  "MEDIA_V2"."GRACEPERIOD" AS "GRACEPERIOD",
  "t0"."HIDDENTYPE" AS "HIDDENTYPE",
  "BRANCH_V2"."HOLDNOTICEFEE" AS "HOLDNOTICEFEE _BRANCH_V2_",
  "MEDIA_V2"."HOLDNOTICEFEE" AS "HOLDNOTICEFEE _MEDIA_V2_",
  "LOCATION_V2"."HOLDNOTICEFEE" AS "HOLDNOTICEFEE",
  "BRANCH_V2"."HOLDSERVICEFEE" AS "HOLDSERVICEFEE",
  "ITEM_V2"."HOLDSHISTORY" AS "HOLDSHISTORY",
  "ITEM_V2"."INHOUSECIRC" AS "INHOUSECIRC",
  "MEDIA_V2"."INITIALFINERATE" AS "INITIALFINERATE",
  "MEDIA_V2"."INITIALLIMIT" AS "INITIALLIMIT",
  "MEDIA_V2"."INITIALPERMINUTES" AS "INITIALPERMINUTES",
  "t0"."INSTBIT" AS "INSTBIT _BBIBMAP_V21_",
  "BRANCH_V2"."INSTBIT" AS "INSTBIT _BRANCH_V2_",
  "LOCATION_V2"."INSTBIT" AS "INSTBIT _LOCATION_V2_",
  "MEDIA_V2"."INSTBIT" AS "INSTBIT _MEDIA_V2_",
  "SYSTEMITEMCODES_V2"."INSTBIT" AS "INSTBIT _SYSTEMITEMCODES_V2_",
  "ITEM_V2"."INSTBIT" AS "INSTBIT",
  "LOCATION_V2"."INTELLECTUAL_LEVEL" AS "INTELLECTUAL_LEVEL",
  "t0"."INTERLIBRARY_LOAN" AS "INTERLIBRARY_LOAN",
  "t0"."ISBN" AS "ISBN",
  "ITEM_V2"."ISID" AS "ISID",
  "ITEM_V2"."ITEMGUID" AS "ITEMGUID",
  (TO_NCHAR("t0"."ITEMSLATESTCHANGE", 'YYYY-MM-DD HH24:MI:SS')) AS "ITEMSLATESTCHANGE",
  "ITEM_V2"."ITEM" AS "ITEM",
  "t0"."LANGUAGE" AS "LANGUAGE",
  "BRANCH_V2"."LIBRARYDEFINEDFIELD" AS "LIBRARYDEFINEDFIELD",
  "SYSTEMITEMCODES_V2"."LOAD" AS "LOAD",
  "ITEM_V2"."LOCATION" AS "LOCATION",
  "LOCATION_V2"."LOCCODE" AS "LOCCODE",
  "LOCATION_V2"."LOCNAME" AS "LOCNAME",
  "LOCATION_V2"."LOCNUMBER" AS "LOCNUMBER",
  "BRANCH_V2"."LOSTBOOKCHARGE" AS "LOSTBOOKCHARGE _BRANCH_V2_",
  "MEDIA_V2"."LOSTBOOKCHARGE" AS "LOSTBOOKCHARGE _MEDIA_V2_",
  "LOCATION_V2"."LOSTBOOKCHARGE" AS "LOSTBOOKCHARGE",
  "BRANCH_V2"."LOSTNOTICEDAYS_0" AS "LOSTNOTICEDAYS_0 _BRANCH_V2_",
  "MEDIA_V2"."LOSTNOTICEDAYS_0" AS "LOSTNOTICEDAYS_0 _MEDIA_V2_",
  "LOCATION_V2"."LOSTNOTICEDAYS_0" AS "LOSTNOTICEDAYS_0",
  "BRANCH_V2"."LOSTNOTICEDAYS_1" AS "LOSTNOTICEDAYS_1 _BRANCH_V2_",
  "MEDIA_V2"."LOSTNOTICEDAYS_1" AS "LOSTNOTICEDAYS_1 _MEDIA_V2_",
  "LOCATION_V2"."LOSTNOTICEDAYS_1" AS "LOSTNOTICEDAYS_1",
  "BRANCH_V2"."LOSTNOTICEDAYS_2" AS "LOSTNOTICEDAYS_2 _BRANCH_V2_",
  "MEDIA_V2"."LOSTNOTICEDAYS_2" AS "LOSTNOTICEDAYS_2 _MEDIA_V2_",
  "LOCATION_V2"."LOSTNOTICEDAYS_2" AS "LOSTNOTICEDAYS_2",
  "BRANCH_V2"."LOSTNOTICEFEES_0" AS "LOSTNOTICEFEES_0 _BRANCH_V2_",
  "MEDIA_V2"."LOSTNOTICEFEES_0" AS "LOSTNOTICEFEES_0 _MEDIA_V2_",
  "LOCATION_V2"."LOSTNOTICEFEES_0" AS "LOSTNOTICEFEES_0",
  "BRANCH_V2"."LOSTNOTICEFEES_1" AS "LOSTNOTICEFEES_1 _BRANCH_V2_",
  "MEDIA_V2"."LOSTNOTICEFEES_1" AS "LOSTNOTICEFEES_1 _MEDIA_V2_",
  "LOCATION_V2"."LOSTNOTICEFEES_1" AS "LOSTNOTICEFEES_1",
  "BRANCH_V2"."LOSTNOTICEFEES_2" AS "LOSTNOTICEFEES_2 _BRANCH_V2_",
  "MEDIA_V2"."LOSTNOTICEFEES_2" AS "LOSTNOTICEFEES_2 _MEDIA_V2_",
  "LOCATION_V2"."LOSTNOTICEFEES_2" AS "LOSTNOTICEFEES_2",
  "BRANCH_V2"."LOSTRNOTICEDAYS_0" AS "LOSTRNOTICEDAYS_0",
  "BRANCH_V2"."LOSTRNOTICEDAYS_1" AS "LOSTRNOTICEDAYS_1",
  "BRANCH_V2"."LOSTRNOTICEFEES_0" AS "LOSTRNOTICEFEES_0",
  "BRANCH_V2"."LOSTRNOTICEFEES_1" AS "LOSTRNOTICEFEES_1",
  "BRANCH_V2"."MAGNETICMEDIA" AS "MAGNETICMEDIA _BRANCH_V2_",
  "MEDIA_V2"."MAGNETICMEDIA" AS "MAGNETICMEDIA _MEDIA_V2_",
  "LOCATION_V2"."MAGNETICMEDIA" AS "MAGNETICMEDIA",
  "BRANCH_V2"."MAXCLAIMRETURNLIMIT" AS "MAXCLAIMRETURNLIMIT",
  "BRANCH_V2"."MAXFINELIMIT" AS "MAXFINELIMIT",
  "MEDIA_V2"."MAXFINE" AS "MAXFINE",
  "BRANCH_V2"."MAXLOSTLIMIT" AS "MAXLOSTLIMIT",
  "BRANCH_V2"."MAXOVERDUELIMIT" AS "MAXOVERDUELIMIT",
  "BRANCH_V2"."MAXOVERDUERECALL" AS "MAXOVERDUERECALL",
  "BRANCH_V2"."MAXOVERDUEREQUEST" AS "MAXOVERDUEREQUEST",
  "MEDIA_V2"."MEDCODE" AS "MEDCODE",
  "ITEM_V2"."MEDIA" AS "MEDIA",
  "MEDIA_V2"."MEDNAME" AS "MEDNAME",
  "MEDIA_V2"."MEDNUMBER" AS "MEDNUMBER",
  "BRANCH_V2"."NEWITEMALLOWHOLDS" AS "NEWITEMALLOWHOLDS",
  "BRANCH_V2"."NEWITEMHOLDRULEDAYS" AS "NEWITEMHOLDRULEDAYS",
  "t0"."NORMALIZEDCALLNUMBER" AS "NORMALIZEDCALLNUMBER",
  "BRANCH_V2"."NOTICEDAYS_0" AS "NOTICEDAYS_0 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEDAYS_0" AS "NOTICEDAYS_0 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEDAYS_0" AS "NOTICEDAYS_0",
  "BRANCH_V2"."NOTICEDAYS_1" AS "NOTICEDAYS_1 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEDAYS_1" AS "NOTICEDAYS_1 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEDAYS_1" AS "NOTICEDAYS_1",
  "BRANCH_V2"."NOTICEDAYS_2" AS "NOTICEDAYS_2 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEDAYS_2" AS "NOTICEDAYS_2 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEDAYS_2" AS "NOTICEDAYS_2",
  "BRANCH_V2"."NOTICEDAYS_3" AS "NOTICEDAYS_3 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEDAYS_3" AS "NOTICEDAYS_3 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEDAYS_3" AS "NOTICEDAYS_3",
  "BRANCH_V2"."NOTICEDAYS_4" AS "NOTICEDAYS_4 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEDAYS_4" AS "NOTICEDAYS_4 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEDAYS_4" AS "NOTICEDAYS_4",
  "BRANCH_V2"."NOTICEDAYS_5" AS "NOTICEDAYS_5 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEDAYS_5" AS "NOTICEDAYS_5 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEDAYS_5" AS "NOTICEDAYS_5",
  "BRANCH_V2"."NOTICEFEES_0" AS "NOTICEFEES_0 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEFEES_0" AS "NOTICEFEES_0 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEFEES_0" AS "NOTICEFEES_0",
  "BRANCH_V2"."NOTICEFEES_1" AS "NOTICEFEES_1 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEFEES_1" AS "NOTICEFEES_1 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEFEES_1" AS "NOTICEFEES_1",
  "BRANCH_V2"."NOTICEFEES_2" AS "NOTICEFEES_2 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEFEES_2" AS "NOTICEFEES_2 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEFEES_2" AS "NOTICEFEES_2",
  "BRANCH_V2"."NOTICEFEES_3" AS "NOTICEFEES_3 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEFEES_3" AS "NOTICEFEES_3 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEFEES_3" AS "NOTICEFEES_3",
  "BRANCH_V2"."NOTICEFEES_4" AS "NOTICEFEES_4 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEFEES_4" AS "NOTICEFEES_4 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEFEES_4" AS "NOTICEFEES_4",
  "BRANCH_V2"."NOTICEFEES_5" AS "NOTICEFEES_5 _BRANCH_V2_",
  "MEDIA_V2"."NOTICEFEES_5" AS "NOTICEFEES_5 _MEDIA_V2_",
  "LOCATION_V2"."NOTICEFEES_5" AS "NOTICEFEES_5",
  "ITEM_V2"."NUMBER_" AS "NUMBER_",
  "ITEM_V2"."OCCUR" AS "OCCUR",
  "BRANCH_V2"."OCLCCODE" AS "OCLCCODE",
  "BRANCH_V2"."OCLCLOC" AS "OCLCLOC",
  "MEDIA_V2"."OVERRIDENOFINE" AS "OVERRIDENOFINE _MEDIA_V2_",
  "LOCATION_V2"."OVERRIDENOFINE" AS "OVERRIDENOFINE",
  "ITEM_V2"."OWNINGBRANCH" AS "OWNINGBRANCH",
  "ITEM_V2"."OWNINGLOCATION" AS "OWNINGLOCATION",
  "ITEM_V2"."PART" AS "PART",
  "ITEM_V2"."PRICE" AS "PRICE",
  "BRANCH_V2"."PROCESSDELAY" AS "PROCESSDELAY",
  "BRANCH_V2"."PROCESSINGFEE" AS "PROCESSINGFEE _BRANCH_V2_",
  "MEDIA_V2"."PROCESSINGFEE" AS "PROCESSINGFEE _MEDIA_V2_",
  "LOCATION_V2"."PROCESSINGFEE" AS "PROCESSINGFEE",
  "t0"."PUBLISHINGDATE" AS "PUBLISHINGDATE",
  "BRANCH_V2"."RECALLLOANPERIOD" AS "RECALLLOANPERIOD _BRANCH_V2_",
  "MEDIA_V2"."RECALLLOANPERIOD" AS "RECALLLOANPERIOD _MEDIA_V2_",
  "LOCATION_V2"."RECALLLOANPERIOD" AS "RECALLLOANPERIOD",
  "BRANCH_V2"."RECALLNOTICEDAYS_0" AS "RECALLNOTICEDAYS_0 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEDAYS_0" AS "RECALLNOTICEDAYS_0 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_0" AS "RECALLNOTICEDAYS_0",
  "BRANCH_V2"."RECALLNOTICEDAYS_1" AS "RECALLNOTICEDAYS_1 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEDAYS_1" AS "RECALLNOTICEDAYS_1 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_1" AS "RECALLNOTICEDAYS_1",
  "BRANCH_V2"."RECALLNOTICEDAYS_2" AS "RECALLNOTICEDAYS_2 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEDAYS_2" AS "RECALLNOTICEDAYS_2 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_2" AS "RECALLNOTICEDAYS_2",
  "BRANCH_V2"."RECALLNOTICEDAYS_3" AS "RECALLNOTICEDAYS_3 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEDAYS_3" AS "RECALLNOTICEDAYS_3 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_3" AS "RECALLNOTICEDAYS_3",
  "BRANCH_V2"."RECALLNOTICEDAYS_4" AS "RECALLNOTICEDAYS_4 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEDAYS_4" AS "RECALLNOTICEDAYS_4 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_4" AS "RECALLNOTICEDAYS_4",
  "BRANCH_V2"."RECALLNOTICEDAYS_5" AS "RECALLNOTICEDAYS_5 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEDAYS_5" AS "RECALLNOTICEDAYS_5 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_5" AS "RECALLNOTICEDAYS_5",
  "BRANCH_V2"."RECALLNOTICEFEES_0" AS "RECALLNOTICEFEES_0 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEFEES_0" AS "RECALLNOTICEFEES_0 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_0" AS "RECALLNOTICEFEES_0",
  "BRANCH_V2"."RECALLNOTICEFEES_1" AS "RECALLNOTICEFEES_1 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEFEES_1" AS "RECALLNOTICEFEES_1 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_1" AS "RECALLNOTICEFEES_1",
  "BRANCH_V2"."RECALLNOTICEFEES_2" AS "RECALLNOTICEFEES_2 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEFEES_2" AS "RECALLNOTICEFEES_2 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_2" AS "RECALLNOTICEFEES_2",
  "BRANCH_V2"."RECALLNOTICEFEES_3" AS "RECALLNOTICEFEES_3 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEFEES_3" AS "RECALLNOTICEFEES_3 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_3" AS "RECALLNOTICEFEES_3",
  "BRANCH_V2"."RECALLNOTICEFEES_4" AS "RECALLNOTICEFEES_4 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEFEES_4" AS "RECALLNOTICEFEES_4 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_4" AS "RECALLNOTICEFEES_4",
  "BRANCH_V2"."RECALLNOTICEFEES_5" AS "RECALLNOTICEFEES_5 _BRANCH_V2_",
  "MEDIA_V2"."RECALLNOTICEFEES_5" AS "RECALLNOTICEFEES_5 _MEDIA_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_5" AS "RECALLNOTICEFEES_5",
  "t0"."RECORDTYPE" AS "RECORDTYPE",
  "BRANCH_V2"."RENEWALLIMIT" AS "RENEWALLIMIT _BRANCH_V2_",
  "MEDIA_V2"."RENEWALLIMIT" AS "RENEWALLIMIT _MEDIA_V2_",
  "LOCATION_V2"."RENEWALLIMIT" AS "RENEWALLIMIT",
  "MEDIA_V2"."RENEWALSALLOWED" AS "RENEWALSALLOWED _MEDIA_V2_",
  "LOCATION_V2"."RENEWALSALLOWED" AS "RENEWALSALLOWED",
  "BRANCH_V2"."RENEWLOANPERIOD" AS "RENEWLOANPERIOD _BRANCH_V2_",
  "MEDIA_V2"."RENEWLOANPERIOD" AS "RENEWLOANPERIOD _MEDIA_V2_",
  "LOCATION_V2"."RENEWLOANPERIOD" AS "RENEWLOANPERIOD",
  "MEDIA_V2"."RENTALFLAG" AS "RENTALFLAG",
  "BRANCH_V2"."REQUESTCHARGELOANPERIOD" AS "REQUESTCHARGELOANPERIOD _BRANC",
  "MEDIA_V2"."REQUESTCHARGELOANPERIOD" AS "REQUESTCHARGELOANPERIOD _MEDIA",
  "LOCATION_V2"."REQUESTCHARGELOANPERIOD" AS "REQUESTCHARGELOANPERIOD",
  "BRANCH_V2"."REQUESTFINEASSESSMENTTYPE" AS "REQUESTFINEASSESSMENTTYPE _BRA",
  "MEDIA_V2"."REQUESTFINEASSESSMENTTYPE" AS "REQUESTFINEASSESSMENTTYPE _MED",
  "LOCATION_V2"."REQUESTFINEASSESSMENTTYPE" AS "REQUESTFINEASSESSMENTTYPE",
  "BRANCH_V2"."REQUESTFINEGRACEPERIOD" AS "REQUESTFINEGRACEPERIOD _BRANCH",
  "MEDIA_V2"."REQUESTFINEGRACEPERIOD" AS "REQUESTFINEGRACEPERIOD _MEDIA_",
  "LOCATION_V2"."REQUESTFINEGRACEPERIOD" AS "REQUESTFINEGRACEPERIOD",
  "BRANCH_V2"."REQUESTFINELIMIT" AS "REQUESTFINELIMIT _BRANCH_V2_",
  "MEDIA_V2"."REQUESTFINELIMIT" AS "REQUESTFINELIMIT _MEDIA_V2_",
  "LOCATION_V2"."REQUESTFINELIMIT" AS "REQUESTFINELIMIT",
  "BRANCH_V2"."REQUESTFINERATE" AS "REQUESTFINERATE _BRANCH_V2_",
  "MEDIA_V2"."REQUESTFINERATE" AS "REQUESTFINERATE _MEDIA_V2_",
  "LOCATION_V2"."REQUESTFINERATE" AS "REQUESTFINERATE",
  "BRANCH_V2"."REQUESTRECALLLOANPERIOD" AS "REQUESTRECALLLOANPERIOD _BRANC",
  "MEDIA_V2"."REQUESTRECALLLOANPERIOD" AS "REQUESTRECALLLOANPERIOD _MEDIA",
  "LOCATION_V2"."REQUESTRECALLLOANPERIOD" AS "REQUESTRECALLLOANPERIOD",
  "BRANCH_V2"."REQUESTRENEWLOANPERIOD" AS "REQUESTRENEWLOANPERIOD _BRANCH",
  "MEDIA_V2"."REQUESTRENEWLOANPERIOD" AS "REQUESTRENEWLOANPERIOD _MEDIA_",
  "LOCATION_V2"."REQUESTRENEWLOANPERIOD" AS "REQUESTRENEWLOANPERIOD",
  "ITEM_V2"."RESERVEBRANCH" AS "RESERVEBRANCH",
  "ITEM_V2"."RESERVECN" AS "RESERVECN",
  "ITEM_V2"."RESERVELOCATION" AS "RESERVELOCATION",
  "ITEM_V2"."RESERVETYPE" AS "RESERVETYPE",
  "MEDIA_V2"."RETURNFEEFLAG" AS "RETURNFEEFLAG",
  "MEDIA_V2"."RETURNFEE" AS "RETURNFEE",
  "BRANCH_V2"."RFINESNOTICEDAYS_0" AS "RFINESNOTICEDAYS_0",
  "BRANCH_V2"."RFINESNOTICEDAYS_1" AS "RFINESNOTICEDAYS_1",
  "BRANCH_V2"."RFINESNOTICEFEES_0" AS "RFINESNOTICEFEES_0",
  "BRANCH_V2"."RFINESNOTICEFEES_1" AS "RFINESNOTICEFEES_1",
  "BRANCH_V2"."RNOTICEDAYS_0" AS "RNOTICEDAYS_0",
  "BRANCH_V2"."RNOTICEDAYS_1" AS "RNOTICEDAYS_1",
  "BRANCH_V2"."RNOTICEFEES_0" AS "RNOTICEFEES_0",
  "BRANCH_V2"."RNOTICEFEES_1" AS "RNOTICEFEES_1",
  "BRANCH_V2"."RSENDRFINESNOTICE" AS "RSENDRFINESNOTICE",
  "BRANCH_V2"."SCHOOL" AS "SCHOOL",
  "BRANCH_V2"."SENDFINENOTICE" AS "SENDFINENOTICE _BRANCH_V2_",
  "MEDIA_V2"."SENDFINENOTICE" AS "SENDFINENOTICE _MEDIA_V2_",
  "LOCATION_V2"."SENDFINENOTICE" AS "SENDFINENOTICE",
  "BRANCH_V2"."SENDLOSTNOTICE" AS "SENDLOSTNOTICE _BRANCH_V2_",
  "MEDIA_V2"."SENDLOSTNOTICE" AS "SENDLOSTNOTICE _MEDIA_V2_",
  "LOCATION_V2"."SENDLOSTNOTICE" AS "SENDLOSTNOTICE",
  "BRANCH_V2"."SENDLOSTRNOTICE" AS "SENDLOSTRNOTICE",
  "BRANCH_V2"."SENDNOTICE" AS "SENDNOTICE _BRANCH_V2_",
  "MEDIA_V2"."SENDNOTICE" AS "SENDNOTICE _MEDIA_V2_",
  "LOCATION_V2"."SENDNOTICE" AS "SENDNOTICE",
  "BRANCH_V2"."SENDRECALLNOTICE" AS "SENDRECALLNOTICE _BRANCH_V2_",
  "MEDIA_V2"."SENDRECALLNOTICE" AS "SENDRECALLNOTICE _MEDIA_V2_",
  "LOCATION_V2"."SENDRECALLNOTICE" AS "SENDRECALLNOTICE",
  "BRANCH_V2"."SENDRNOTICE" AS "SENDRNOTICE",
  "SYSTEMITEMCODES_V2"."SHELF" AS "SHELF",
  "BRANCH_V2"."SHELVINGDELAY" AS "SHELVINGDELAY",
  "MEDIA_V2"."SPECIALFEE" AS "SPECIALFEE _MEDIA_V2_",
  "LOCATION_V2"."SPECIALFEE" AS "SPECIALFEE",
  "ITEM_V2"."STATUSDATE" AS "STATUSDATE",
  "ITEM_V2"."STATUS" AS "STATUS",
  "MEDIA_V2"."SUBSEQUENTFINERATE" AS "SUBSEQUENTFINERATE",
  "MEDIA_V2"."SUBSEQUENTPERMINUTES" AS "SUBSEQUENTPERMINUTES",
  "ITEM_V2"."SUFFIX" AS "SUFFIX",
  "t0"."SUPPRESSDATE" AS "SUPPRESSDATE",
  "SYSTEMITEMCODES_V2"."SUPPRESSED" AS "SUPPRESSED",
  "t0"."SUPPRESSTYPE" AS "SUPPRESSTYPE _BBIBMAP_V21_",
  "ITEM_V2"."SUPPRESSTYPE" AS "SUPPRESSTYPE",
  "ITEM_V2"."SUPPRESS" AS "SUPPRESS",
  "t1"."SYSDATE" AS "SYSDATE",
  "t1"."TAGNUMBER" AS "TAGNUMBER",
  "t0"."TERMINAL" AS "TERMINAL",
  "t0"."TITLE" AS "TITLE _BBIBMAP_V21_",
  "t0"."TITLEINDICATORS" AS "TITLEINDICATORS",
  "t1"."TITLE" AS "TITLE",
  "SYSTEMITEMCODES_V2"."TYPE" AS "TYPE _SYSTEMITEMCODES_V2_",
  "ITEM_V2"."TYPE" AS "TYPE",
  "t0"."UPC" AS "UPC",
  "t0"."USERID" AS "USERID _BBIBMAP_V21_",
  "ITEM_V2"."USERID" AS "USERID",
  "ITEM_V2"."VOLUME" AS "VOLUME",
  "t1"."WORDDATA" AS "WORDDATA"
FROM "CARLREPORTS"."ITEM_V2" "ITEM_V2"
  LEFT JOIN (
  SELECT "BBIBMAP_V21"."BID" AS "BID",
    "BBIBMAP_V21"."NORMALIZEDCALLNUMBER" AS "NORMALIZEDCALLNUMBER",
    "BBIBMAP_V21"."CALLNUMBER" AS "CALLNUMBER",
    "BBIBMAP_V21"."INSTBIT" AS "INSTBIT",
    "BBIBMAP_V21"."SUPPRESSDATE" AS "SUPPRESSDATE",
    "BBIBMAP_V21"."AUTHOR" AS "AUTHOR",
    "BBIBMAP_V21"."FOLDER" AS "FOLDER",
    "BBIBMAP_V21"."TITLE" AS "TITLE",
    "BBIBMAP_V21"."PUBLISHINGDATE" AS "PUBLISHINGDATE",
    "BBIBMAP_V21"."LANGUAGE" AS "LANGUAGE",
    "BBIBMAP_V21"."RECORDTYPE" AS "RECORDTYPE",
    "BBIBMAP_V21"."FORMAT" AS "FORMAT",
    "BBIBMAP_V21"."TITLEINDICATORS" AS "TITLEINDICATORS",
    "BBIBMAP_V21"."BIBTYPE" AS "BIBTYPE",
    "BBIBMAP_V21"."HIDDENTYPE" AS "HIDDENTYPE",
    "BBIBMAP_V21"."SUPPRESSTYPE" AS "SUPPRESSTYPE",
    "BBIBMAP_V21"."ACQTYPE" AS "ACQTYPE",
    "BBIBMAP_V21"."ISBN" AS "ISBN",
    "BBIBMAP_V21"."EXTERNALCONTROLNUMBER" AS "EXTERNALCONTROLNUMBER",
    "BBIBMAP_V21"."INTERLIBRARY_LOAN" AS "INTERLIBRARY_LOAN",
    "BBIBMAP_V21"."UPC" AS "UPC",
    "BBIBMAP_V21"."BIBLATESTCHANGE" AS "BIBLATESTCHANGE",
    "BBIBMAP_V21"."ITEMSLATESTCHANGE" AS "ITEMSLATESTCHANGE",
    "BBIBMAP_V21"."ERESOURCE" AS "ERESOURCE",
    "BBIBMAP_V21"."USERID" AS "USERID",
    "BBIBMAP_V21"."TERMINAL" AS "TERMINAL",
    ROUND(TRUNC("BBIBMAP_V21"."BID"),0) AS "$temp1"
  FROM "CARLREPORTS"."BBIBMAP_V2" "BBIBMAP_V21"
) "t0" ON (("ITEM_V2"."BID") = "t0"."$temp1")
  INNER JOIN (
  SELECT
      "Genre"."CALLNUMBER" AS "CALLNUMBER",
    "Genre"."SYSDATE" AS "SYSDATE",
    "Genre"."TAGNUMBER" AS "TAGNUMBER",
    "Genre"."BID" AS "BID",
    "Genre"."TITLE" AS "TITLE",
    "Genre"."WORDDATA" AS "WORDDATA",
    ROUND(TRUNC("Genre"."BID"),0) AS "$temp3"
  FROM (
    select sysdate,contents.bid, bib.title, bib.callnumber, contents.tagnumber, tags.worddata
        from  BTAGS_V2 tags
        inner join BBIBCONTENTS_V2 contents on contents.TAGID = tags.TAGID
        inner join BBIBMAP_V2 bib on bib.bid=contents.bid
    where (contents.tagnumber=655 ) order by bib.bid
  ) "Genre"
) "t1" ON (("ITEM_V2"."BID") = "t1"."$temp3")
  LEFT JOIN "CARLREPORTS"."SYSTEMITEMCODES_V2" "SYSTEMITEMCODES_V2" ON ("ITEM_V2"."STATUS" = "SYSTEMITEMCODES_V2"."CODE")
  LEFT JOIN "CARLREPORTS"."LOCATION_V2" "LOCATION_V2" ON ("ITEM_V2"."LOCATION" = "LOCATION_V2"."LOCNUMBER")
  LEFT JOIN "CARLREPORTS"."MEDIA_V2" "MEDIA_V2" ON ("ITEM_V2"."MEDIA" = "MEDIA_V2"."MEDNUMBER")
  LEFT JOIN "CARLREPORTS"."BRANCH_V2" "BRANCH_V2" ON ("ITEM_V2"."BRANCH" = "BRANCH_V2"."BRANCHNUMBER")
WHERE (
       BRANCHCODE='POR' AND
        LOCCODE ='APF' AND
       ("ITEM_V2"."STATUS" NOT IN ('L', 'N', 'O', 'R', 'RF', 'SG', 'SM', 'SW', 'SX'))
           AND ("t1"."SYSDATE" > TO_DATE('2024-02-24 23:00:56', 'YYYY-MM-DD HH24:MI:SS'))
    ) ;

select count(*) from item_v2
  INNER JOIN BBIBMAP_V2 on ITEM_V2.BID=BBIBMAP_V2.BID
  INNER JOIN BBIBCONTENTS_V2 on BBIBMAP_V2.BID = BBIBCONTENTS_V2.BID
  INNER JOIN BTAGS_V2 on (BBIBCONTENTS_V2.TAGID=BTAGS_V2.TAGID AND BBIBCONTENTS_V2.TAGNUMBER=655)
  LEFT JOIN "CARLREPORTS"."SYSTEMITEMCODES_V2" "SYSTEMITEMCODES_V2" ON ("ITEM_V2"."STATUS" = "SYSTEMITEMCODES_V2"."CODE")
  LEFT JOIN "CARLREPORTS"."LOCATION_V2" "LOCATION_V2" ON ("ITEM_V2"."LOCATION" = "LOCATION_V2"."LOCNUMBER")
  LEFT JOIN "CARLREPORTS"."MEDIA_V2" "MEDIA_V2" ON ("ITEM_V2"."MEDIA" = "MEDIA_V2"."MEDNUMBER")
  LEFT JOIN "CARLREPORTS"."BRANCH_V2" "BRANCH_V2" ON ("ITEM_V2"."BRANCH" = "BRANCH_V2"."BRANCHNUMBER")
WHERE (
        BRANCHCODE='POR' AND
        LOCCODE ='APF' AND
          --STATUS='C'  AND
        ("ITEM_V2"."STATUS" NOT IN ('L', 'N', 'O', 'R', 'RF', 'SG', 'SM', 'SW', 'SX'))
        --AND (SYSDATE > TO_DATE('2024-02-24 23:00:56', 'YYYY-MM-DD HH24:MI:SS'))
    ) ;
-- All Item Info
select  distinct ITEM_V2.BID, ITEM_V2.ITEM,ITEM_V2.CN,LOCATION_V2.LOCCODE,BRANCH_V2.BRANCHCODE, SYSTEMITEMCODES_V2.CODE,BBIBCONTENTS_V2.TAGID, BTAGS_V2.WORDDATA,TAGINDICATORS,TITLE
from item_v2
  INNER JOIN BBIBMAP_V2 on ITEM_V2.BID=BBIBMAP_V2.BID
  INNER JOIN BBIBCONTENTS_V2 on BBIBMAP_V2.BID = BBIBCONTENTS_V2.BID
  INNER JOIN BTAGS_V2 on (BBIBCONTENTS_V2.TAGID=BTAGS_V2.TAGID AND BBIBCONTENTS_V2.TAGNUMBER=655 and TAGINDICATORS=7)
  LEFT JOIN "CARLREPORTS"."SYSTEMITEMCODES_V2" "SYSTEMITEMCODES_V2" ON ("ITEM_V2"."STATUS" = "SYSTEMITEMCODES_V2"."CODE")
  LEFT JOIN "CARLREPORTS"."LOCATION_V2" "LOCATION_V2" ON ("ITEM_V2"."LOCATION" = "LOCATION_V2"."LOCNUMBER")
  LEFT JOIN "CARLREPORTS"."MEDIA_V2" "MEDIA_V2" ON ("ITEM_V2"."MEDIA" = "MEDIA_V2"."MEDNUMBER")
  LEFT JOIN "CARLREPORTS"."BRANCH_V2" "BRANCH_V2" ON ("ITEM_V2"."BRANCH" = "BRANCH_V2"."BRANCHNUMBER")
WHERE (
        BRANCHCODE='POR' AND
        LOCCODE ='APF' AND
          --STATUS='C'  AND
        ("ITEM_V2"."STATUS" NOT IN ('L', 'N', 'O', 'R', 'RF', 'SG', 'SM', 'SW', 'SX'))
        --AND (SYSDATE > TO_DATE('2024-02-24 23:00:56', 'YYYY-MM-DD HH24:MI:SS'))
    ) ORDER BY BBIBCONTENTS_V2.TAGID DESC
;

-- Genre Subquery All Item Info
select  ITEM_V2.BID,ITEM_V2.ITEM, ITEM_V2.CN,LOCATION_V2.LOCCODE,BRANCH_V2.BRANCHCODE,
                    -- SYSTEMITEMCODES_V2.CODE,TAGINDICATORS,BTAGS_V2.TAGID, WORDDATA, TITLE
                    SYSTEMITEMCODES_V2.CODE,TITLE
from ITEM_V2

  INNER JOIN BBIBMAP_V2 on ITEM_V2.BID=BBIBMAP_V2.BID
  INNER JOIN BBIBCONTENTS_V2 on BBIBMAP_V2.BID = BBIBCONTENTS_V2.BID AND BBIBCONTENTS_V2.TAGNUMBER=655 AND BBIBCONTENTS_V2.TAGINDICATORS=7
  INNER JOIN BTAGS_V2 on (BBIBCONTENTS_V2.TAGID=BTAGS_V2.TAGID )
--   INNER JOIN (SELECT WORDDATA FROM BTAGS_V2
--         INNER JOIN BBIBCONTENTS_V2 ON BTAGS_V2.TAGID=BBIBCONTENTS_V2.TAGID AND BBIBCONTENTS_V2.TAGNUMBER=655 AND BBIBCONTENTS_V2.TAGINDICATORS=7
--                               ORDER BY TAGID DESC
--                               ) GENRE
  LEFT JOIN "CARLREPORTS"."SYSTEMITEMCODES_V2" "SYSTEMITEMCODES_V2" ON ("CARLREPORTS"."ITEM_V2"."STATUS" = "SYSTEMITEMCODES_V2"."CODE")
  LEFT JOIN "CARLREPORTS"."LOCATION_V2" "LOCATION_V2" ON ("CARLREPORTS"."ITEM_V2"."LOCATION" = "LOCATION_V2"."LOCNUMBER")
  LEFT JOIN "CARLREPORTS"."MEDIA_V2" "MEDIA_V2" ON ("CARLREPORTS"."ITEM_V2"."MEDIA" = "MEDIA_V2"."MEDNUMBER")
  LEFT JOIN "CARLREPORTS"."BRANCH_V2" "BRANCH_V2" ON ("CARLREPORTS"."ITEM_V2"."BRANCH" = "BRANCH_V2"."BRANCHNUMBER")

WHERE (
        BRANCHCODE='POR' AND
        LOCCODE ='APF' AND
          --STATUS='C'  AND
        ("ITEM_V2"."STATUS" NOT IN ('L', 'N', 'O', 'R', 'RF', 'SG', 'SM', 'SW', 'SX'))
        --AND (SYSDATE > TO_DATE('2024-02-24 23:00:56', 'YYYY-MM-DD HH24:MI:SS'))
    )
    GROUP BY ITEM_V2.BID,ITEM_V2.ITEM, ITEM_V2.CN,LOCATION_V2.LOCCODE,BRANCH_V2.BRANCHCODE,
                 SYSTEMITEMCODES_V2.CODE,TAGINDICATORS,TITLE,BTAGS_V2.TAGID, WORDDATA

ORDER BY BID;

-- Oracle KEEPs the genre
SELECT
    bib.bid,
    MIN(ITEM) KEEP ( DENSE_RANK FIRST ORDER BY bib.bid ) item,
    MIN(WORDDATA) KEEP ( DENSE_RANK FIRST ORDER BY bib.bid  ) genre,
    MIN(TITLE) KEEP ( DENSE_RANK FIRST ORDER BY bib.bid ) title
from BTAGS_V2 tag
inner join BBIBCONTENTS_V2 contents on contents.TAGID=tag.TAGID AND contents.TAGNUMBER=655
inner join BBIBMAP_V2 bib on bib.BID = contents.BID
inner join ITEM_V2 item on item.BID=contents.BID
inner join LOCATION_V2 loc on loc.LOCNUMBER = item.LOCATION
inner join BRANCH_V2 branch on branch.BRANCHNUMBER=item.BRANCH

WHERE (
          BRANCHCODE = 'POR' AND
          LOCCODE = 'APF' AND
          item.STATUS NOT IN ('L', 'N', 'O', 'R', 'RF', 'SG', 'SM', 'SW', 'SX')
          )
GROUP BY bib.bid
order by bid
;

-- Better result using ORACLE SQL KEEP
SELECT
 ITEM,
 STATUS,
    MAX(bib.BID) KEEP ( DENSE_RANK LAST ORDER BY tag.TAGID ) bib,
count(bib.BID),
    MAX(WORDDATA) KEEP ( DENSE_RANK LAST ORDER BY tag.TAGID ) genre,


   -- contents.TAGINDICATORS,
    MAX(TITLE) KEEP ( DENSE_RANK LAST ORDER BY tag.TAGID) title
from BTAGS_V2 tag
inner join BBIBCONTENTS_V2 contents on
    contents.TAGID=tag.TAGID AND contents.TAGNUMBER=655
        --AND contents.TAGINDICATORS=7
inner join BBIBMAP_V2 bib on bib.BID = contents.BID
inner join ITEM_V2 item on item.BID=contents.BID
inner join LOCATION_V2 loc on loc.LOCNUMBER = item.LOCATION
inner join BRANCH_V2 branch on branch.BRANCHNUMBER=item.BRANCH

WHERE (
          BRANCHCODE = 'CBA' AND
          LOCCODE = 'APNEW' AND
          STATUS='C'
         -- item.STATUS NOT IN ('L', 'N', 'O', 'R', 'RF', 'SG', 'SM', 'SW', 'SX')
          )
GROUP BY bib.bid, item,STATUS
--having count(bib.bid)>1
order by ITEM
;

-- Tableau Circ Stats
SELECT "Item Branch"."ACQBRANCH" AS "ACQBRANCH _BRANCH_V2_",
  "Transaction Branch"."ACQBRANCH" AS "ACQBRANCH",
  "BBIBMAP_V2"."ACQTYPE" AS "ACQTYPE",
  "PATRON_V2"."ACTBRANCH" AS "ACTBRANCH",
  "PATRON_V2"."ACTDATE" AS "ACTDATE",
  "PATRON_V2"."ADDR" AS "ADDR",
  "SYSTEMITEMCODES_V2"."ADMIN" AS "ADMIN",
  "BTY_V2"."AGELIMIT" AS "AGELIMIT",
  "BTY_V2"."ALLOWEDTOBORROW" AS "ALLOWEDTOBORROW",
  "Item Branch"."ALLOWFLOATINGCOLLECTION" AS "ALLOWFLOATINGCOLLECTION _BRANC",
  "LOCATION_V2"."ALLOWFLOATINGCOLLECTION" AS "ALLOWFLOATINGCOLLECTION _LOCAT",
  "MEDIA_V2"."ALLOWFLOATINGCOLLECTION" AS "ALLOWFLOATINGCOLLECTION _MEDIA",
  "Transaction Branch"."ALLOWFLOATINGCOLLECTION" AS "ALLOWFLOATINGCOLLECTION",
  "Item Branch"."ALLOWHOLDS" AS "ALLOWHOLDS _BRANCH_V2_",
  "BTY_V2"."ALLOWHOLDS" AS "ALLOWHOLDS _BTY_V2_",
  "LOCATION_V2"."ALLOWHOLDS" AS "ALLOWHOLDS _LOCATION_V2_",
  "MEDIA_V2"."ALLOWHOLDS" AS "ALLOWHOLDS _MEDIA_V2_",
  "Transaction Branch"."ALLOWHOLDS" AS "ALLOWHOLDS",
  "Item Branch"."ALLOWRECALL" AS "ALLOWRECALL _BRANCH_V2_",
  "BTY_V2"."ALLOWRECALL" AS "ALLOWRECALL _BTY_V2_",
  "LOCATION_V2"."ALLOWRECALL" AS "ALLOWRECALL _LOCATION_V2_",
  "MEDIA_V2"."ALLOWRECALL" AS "ALLOWRECALL _MEDIA_V2_",
  "Transaction Branch"."ALLOWRECALL" AS "ALLOWRECALL",
  "BTY_V2"."ALLOWRENEWAL" AS "ALLOWRENEWAL",
  "PATRON_V2"."ALTERNATEID" AS "ALTERNATEID",
  "ITEM_V2"."ALTERNATESTATUS" AS "ALTERNATESTATUS",
  "SYSTEMITEMCODES_V2"."ARCHIVED" AS "ARCHIVED",
  "Item Branch"."ASSESSGST" AS "ASSESSGST _BRANCH_V2_",
  "Transaction Branch"."ASSESSGST" AS "ASSESSGST",
  "BBIBMAP_V2"."AUTHOR" AS "AUTHOR",
  "Item Branch"."AUXLOANPERIODUNITINTERVAL" AS "AUXLOANPERIODUNITINTERVAL _BRA",
  "Transaction Branch"."AUXLOANPERIODUNITINTERVAL" AS "AUXLOANPERIODUNITINTERVAL",
  "Item Branch"."AUXLOANPERIODUNITTYPE" AS "AUXLOANPERIODUNITTYPE _BRANCH_",
  "Transaction Branch"."AUXLOANPERIODUNITTYPE" AS "AUXLOANPERIODUNITTYPE",
  "PATRON_V2"."BALANCEDUENOTICESTATUS" AS "BALANCEDUENOTICESTATUS",
  "BBIBMAP_V2"."BIBLATESTCHANGE" AS "BIBLATESTCHANGE",
  "BBIBMAP_V2"."BIBTYPE" AS "BIBTYPE",
  "ITEM_V2"."BID" AS "BID _ITEM_V2_",
  "BBIBMAP_V2"."BID" AS "BID",
  "PATRON_V2"."BIRTHDATE" AS "BIRTHDATE",
  "Item Branch"."BRAFINEPAYMENT" AS "BRAFINEPAYMENT _BRANCH_V2_",
  "Transaction Branch"."BRAFINEPAYMENT" AS "BRAFINEPAYMENT",
  "ITEM_V2"."BRANCH" AS "BRANCH _ITEM_V2_",
  "Item Branch"."BRANCHADDRESS1" AS "BRANCHADDRESS1 _BRANCH_V2_",
  "Transaction Branch"."BRANCHADDRESS1" AS "BRANCHADDRESS1",
  "Item Branch"."BRANCHADDRESS2" AS "BRANCHADDRESS2 _BRANCH_V2_",
  "Transaction Branch"."BRANCHADDRESS2" AS "BRANCHADDRESS2",
  "Item Branch"."BRANCHCITY" AS "BRANCHCITY _BRANCH_V2_",
  "Transaction Branch"."BRANCHCITY" AS "BRANCHCITY",
  "Item Branch"."BRANCHCODE" AS "BRANCHCODE _BRANCH_V2_",
  "Transaction Branch"."BRANCHCODE" AS "BRANCHCODE",
  "Item Branch"."BRANCHGROUP" AS "BRANCHGROUP _BRANCH_V2_",
  "Transaction Branch"."BRANCHGROUP" AS "BRANCHGROUP",
  "Item Branch"."BRANCHNAME" AS "BRANCHNAME _BRANCH_V2_",
  "Transaction Branch"."BRANCHNAME" AS "BRANCHNAME",
  "Item Branch"."BRANCHNUMBER" AS "BRANCHNUMBER _BRANCH_V2_",
  "Transaction Branch"."BRANCHNUMBER" AS "BRANCHNUMBER",
  "Item Branch"."BRANCHPHONE" AS "BRANCHPHONE _BRANCH_V2_",
  "Transaction Branch"."BRANCHPHONE" AS "BRANCHPHONE",
  "Item Branch"."BRANCHRECEIPT" AS "BRANCHRECEIPT _BRANCH_V2_",
  "Transaction Branch"."BRANCHRECEIPT" AS "BRANCHRECEIPT",
  "Item Branch"."BRANCHZIPCODE" AS "BRANCHZIPCODE _BRANCH_V2_",
  "Transaction Branch"."BRANCHZIPCODE" AS "BRANCHZIPCODE",
  "Item Branch"."BRCBRANCH" AS "BRCBRANCH _BRANCH_V2_",
  "Transaction Branch"."BRCBRANCH" AS "BRCBRANCH",
  "Item Branch"."BRCCODE" AS "BRCCODE _BRANCH_V2_",
  "Transaction Branch"."BRCCODE" AS "BRCCODE",
  "BTY_V2"."BTYCODE" AS "BTYCODE",
  "BTY_V2"."BTYNAME" AS "BTYNAME",
  "BTY_V2"."BTYNUMBER" AS "BTYNUMBER",
  "PATRON_V2"."BTY" AS "BTY",
  "BBIBMAP_V2"."CALLNUMBER" AS "CALLNUMBER",
  "Item Branch"."CHARGELIMIT" AS "CHARGELIMIT _BRANCH_V2_",
  "BTY_V2"."CHARGELIMIT" AS "CHARGELIMIT _BTY_V2_",
  "LOCATION_V2"."CHARGELIMIT" AS "CHARGELIMIT _LOCATION_V2_",
  "MEDIA_V2"."CHARGELIMIT" AS "CHARGELIMIT _MEDIA_V2_",
  "Transaction Branch"."CHARGELIMIT" AS "CHARGELIMIT",
  "Item Branch"."CHARGELOANPERIOD" AS "CHARGELOANPERIOD _BRANCH_V2_",
  "BTY_V2"."CHARGELOANPERIOD" AS "CHARGELOANPERIOD _BTY_V2_",
  "LOCATION_V2"."CHARGELOANPERIOD" AS "CHARGELOANPERIOD _LOCATION_V2_",
  "MEDIA_V2"."CHARGELOANPERIOD" AS "CHARGELOANPERIOD _MEDIA_V2_",
  "Transaction Branch"."CHARGELOANPERIOD" AS "CHARGELOANPERIOD",
  "ITEM_V2"."CIRCHISTORY" AS "CIRCHISTORY",
  "LOCATION_V2"."CIRCULATION_LEVEL" AS "CIRCULATION_LEVEL",
  "PATRON_V2"."CITY1" AS "CITY1",
  "PATRON_V2"."CITY2" AS "CITY2",
  "Item Branch"."CLAIMBLOCKTYPE" AS "CLAIMBLOCKTYPE _BRANCH_V2_",
  "BTY_V2"."CLAIMBLOCKTYPE" AS "CLAIMBLOCKTYPE _BTY_V2_",
  "Transaction Branch"."CLAIMBLOCKTYPE" AS "CLAIMBLOCKTYPE",
  "Item Branch"."CLAIMHISTORYDAYS" AS "CLAIMHISTORYDAYS _BRANCH_V2_",
  "BTY_V2"."CLAIMHISTORYDAYS" AS "CLAIMHISTORYDAYS _BTY_V2_",
  "Transaction Branch"."CLAIMHISTORYDAYS" AS "CLAIMHISTORYDAYS",
  "ITEM_V2"."CNFORMATTED" AS "CNFORMATTED",
  "ITEM_V2"."CNFULL" AS "CNFULL",
  "ITEM_V2"."CNLABEL" AS "CNLABEL",
  "ITEM_V2"."CN" AS "CN",
  "Transaction Code Type"."CODEDESCRIPTION" AS "CODEDESCRIPTION",
  "Transaction Code Type"."CODETYPE" AS "CODETYPE",
  "Transaction Code Type"."CODEVALUE" AS "CODEVALUE",
  "SYSTEMITEMCODES_V2"."CODE" AS "CODE",
  "PATRON_V2"."COLLECTIONSTATUS" AS "COLLECTIONSTATUS",
  "MEDIA_V2"."CONTROLDISCHARGE" AS "CONTROLDISCHARGE",
  "Item Branch"."CONTROLLINGBRANCH" AS "CONTROLLINGBRANCH _BRANCH_V2_",
  "Transaction Branch"."CONTROLLINGBRANCH" AS "CONTROLLINGBRANCH",
  "ITEM_V2"."CREATEDBY" AS "CREATEDBY",
  "ITEM_V2"."CREATIONDATE" AS "CREATIONDATE",
  "BTY_V2"."CREDITFEELOSTRETURN" AS "CREDITFEELOSTRETURN",
  "BTY_V2"."CREDITFINELOSTRETURN" AS "CREDITFINELOSTRETURN",
  "ITEM_V2"."CUMULATIVEHISTORY" AS "CUMULATIVEHISTORY",
  "BTY_V2"."DEFAULTADDR" AS "DEFAULTADDR",
  "PATRON_V2"."DEFAULTBRANCH" AS "DEFAULTBRANCH",
  "Item Branch"."DEFAULTBTYNUMBER" AS "DEFAULTBTYNUMBER _BRANCH_V2_",
  "Transaction Branch"."DEFAULTBTYNUMBER" AS "DEFAULTBTYNUMBER",
  "Item Branch"."DEFAULTLOCATIONNUMBER" AS "DEFAULTLOCATIONNUMBER _BRANCH_",
  "Transaction Branch"."DEFAULTLOCATIONNUMBER" AS "DEFAULTLOCATIONNUMBER",
  "Item Branch"."DEFAULTMEDIANUMBER" AS "DEFAULTMEDIANUMBER _BRANCH_V2_",
  "Transaction Branch"."DEFAULTMEDIANUMBER" AS "DEFAULTMEDIANUMBER",
  "PATRON_V2"."DEPOSITBALANCE" AS "DEPOSITBALANCE",
  "SYSTEMITEMCODES_V2"."DESCRIPTION" AS "DESCRIPTION",
  "MEDIA_V2"."DISPLAY" AS "DISPLAY",
  "Item Branch"."DOESNOTCIRCULATEFLAG" AS "DOESNOTCIRCULATEFLAG _BRANCH_V",
  "LOCATION_V2"."DOESNOTCIRCULATEFLAG" AS "DOESNOTCIRCULATEFLAG _LOCATION",
  "MEDIA_V2"."DOESNOTCIRCULATEFLAG" AS "DOESNOTCIRCULATEFLAG _MEDIA_V2",
  "Transaction Branch"."DOESNOTCIRCULATEFLAG" AS "DOESNOTCIRCULATEFLAG",
  "BTY_V2"."DUEDATELIMIT" AS "DUEDATELIMIT",
  "ITEM_V2"."DUEDATE" AS "DUEDATE",
  "PATRON_V2"."EDITBRANCH" AS "EDITBRANCH",
  "PATRON_V2"."EDITDATE" AS "EDITDATE _PATRON_V2_",
  "ITEM_V2"."EDITDATE" AS "EDITDATE",
  "PATRON_V2"."EMAIL2" AS "EMAIL2",
  "PATRON_V2"."EMAILNOTICES" AS "EMAILNOTICES",
  "PATRON_V2"."EMAILRECEIPTS" AS "EMAILRECEIPTS",
  "PATRON_V2"."EMAIL" AS "EMAIL",
  "BTY_V2"."ENDOFSEMESTER" AS "ENDOFSEMESTER",
  "TXLOG_V2"."ENVBRANCH" AS "ENVBRANCH",
  "BBIBMAP_V2"."ERESOURCE" AS "ERESOURCE",
  "BTY_V2"."EXCLUDEDFROMBLOCKS" AS "EXCLUDEDFROMBLOCKS",
  "BTY_V2"."EXCLUDEDFROMFEES" AS "EXCLUDEDFROMFEES",
  "BTY_V2"."EXCLUDEDFROMFINES" AS "EXCLUDEDFROMFINES",
  "BTY_V2"."EXCLUDEFROMBALANCEDUENOTICE" AS "EXCLUDEFROMBALANCEDUENOTICE",
  "PATRON_V2"."EXPDATE" AS "EXPDATE",
  "BTY_V2"."EXPIREDATE" AS "EXPIREDATE",
  "BTY_V2"."EXPIREDAYS" AS "EXPIREDAYS",
  "BBIBMAP_V2"."EXTERNALCONTROLNUMBER" AS "EXTERNALCONTROLNUMBER",
  "Item Branch"."FINEASSESSMENTTYPE" AS "FINEASSESSMENTTYPE _BRANCH_V2_",
  "BTY_V2"."FINEASSESSMENTTYPE" AS "FINEASSESSMENTTYPE _BTY_V2_",
  "LOCATION_V2"."FINEASSESSMENTTYPE" AS "FINEASSESSMENTTYPE _LOCATION_V",
  "MEDIA_V2"."FINEASSESSMENTTYPE" AS "FINEASSESSMENTTYPE _MEDIA_V2_",
  "Transaction Branch"."FINEASSESSMENTTYPE" AS "FINEASSESSMENTTYPE",
  "Item Branch"."FINEGRACEPERIOD" AS "FINEGRACEPERIOD _BRANCH_V2_",
  "BTY_V2"."FINEGRACEPERIOD" AS "FINEGRACEPERIOD _BTY_V2_",
  "LOCATION_V2"."FINEGRACEPERIOD" AS "FINEGRACEPERIOD _LOCATION_V2_",
  "MEDIA_V2"."FINEGRACEPERIOD" AS "FINEGRACEPERIOD _MEDIA_V2_",
  "Transaction Branch"."FINEGRACEPERIOD" AS "FINEGRACEPERIOD",
  "Item Branch"."FINELIMIT" AS "FINELIMIT _BRANCH_V2_",
  "BTY_V2"."FINELIMIT" AS "FINELIMIT _BTY_V2_",
  "LOCATION_V2"."FINELIMIT" AS "FINELIMIT _LOCATION_V2_",
  "MEDIA_V2"."FINELIMIT" AS "FINELIMIT _MEDIA_V2_",
  "Transaction Branch"."FINELIMIT" AS "FINELIMIT",
  "Item Branch"."FINERATE" AS "FINERATE _BRANCH_V2_",
  "BTY_V2"."FINERATE" AS "FINERATE _BTY_V2_",
  "LOCATION_V2"."FINERATE" AS "FINERATE _LOCATION_V2_",
  "MEDIA_V2"."FINERATE" AS "FINERATE _MEDIA_V2_",
  "Transaction Branch"."FINERATE" AS "FINERATE",
  "Item Branch"."FINESNOTICEDAYS_0" AS "FINESNOTICEDAYS_0 _BRANCH_V2_",
  "BTY_V2"."FINESNOTICEDAYS_0" AS "FINESNOTICEDAYS_0 _BTY_V2_",
  "LOCATION_V2"."FINESNOTICEDAYS_0" AS "FINESNOTICEDAYS_0 _LOCATION_V2",
  "MEDIA_V2"."FINESNOTICEDAYS_0" AS "FINESNOTICEDAYS_0 _MEDIA_V2_",
  "Transaction Branch"."FINESNOTICEDAYS_0" AS "FINESNOTICEDAYS_0",
  "Item Branch"."FINESNOTICEDAYS_1" AS "FINESNOTICEDAYS_1 _BRANCH_V2_",
  "BTY_V2"."FINESNOTICEDAYS_1" AS "FINESNOTICEDAYS_1 _BTY_V2_",
  "LOCATION_V2"."FINESNOTICEDAYS_1" AS "FINESNOTICEDAYS_1 _LOCATION_V2",
  "MEDIA_V2"."FINESNOTICEDAYS_1" AS "FINESNOTICEDAYS_1 _MEDIA_V2_",
  "Transaction Branch"."FINESNOTICEDAYS_1" AS "FINESNOTICEDAYS_1",
  "Item Branch"."FINESNOTICEDAYS_2" AS "FINESNOTICEDAYS_2 _BRANCH_V2_",
  "BTY_V2"."FINESNOTICEDAYS_2" AS "FINESNOTICEDAYS_2 _BTY_V2_",
  "LOCATION_V2"."FINESNOTICEDAYS_2" AS "FINESNOTICEDAYS_2 _LOCATION_V2",
  "MEDIA_V2"."FINESNOTICEDAYS_2" AS "FINESNOTICEDAYS_2 _MEDIA_V2_",
  "Transaction Branch"."FINESNOTICEDAYS_2" AS "FINESNOTICEDAYS_2",
  "Item Branch"."FINESNOTICEFEES_0" AS "FINESNOTICEFEES_0 _BRANCH_V2_",
  "BTY_V2"."FINESNOTICEFEES_0" AS "FINESNOTICEFEES_0 _BTY_V2_",
  "LOCATION_V2"."FINESNOTICEFEES_0" AS "FINESNOTICEFEES_0 _LOCATION_V2",
  "MEDIA_V2"."FINESNOTICEFEES_0" AS "FINESNOTICEFEES_0 _MEDIA_V2_",
  "Transaction Branch"."FINESNOTICEFEES_0" AS "FINESNOTICEFEES_0",
  "Item Branch"."FINESNOTICEFEES_1" AS "FINESNOTICEFEES_1 _BRANCH_V2_",
  "BTY_V2"."FINESNOTICEFEES_1" AS "FINESNOTICEFEES_1 _BTY_V2_",
  "LOCATION_V2"."FINESNOTICEFEES_1" AS "FINESNOTICEFEES_1 _LOCATION_V2",
  "MEDIA_V2"."FINESNOTICEFEES_1" AS "FINESNOTICEFEES_1 _MEDIA_V2_",
  "Transaction Branch"."FINESNOTICEFEES_1" AS "FINESNOTICEFEES_1",
  "Item Branch"."FINESNOTICEFEES_2" AS "FINESNOTICEFEES_2 _BRANCH_V2_",
  "BTY_V2"."FINESNOTICEFEES_2" AS "FINESNOTICEFEES_2 _BTY_V2_",
  "LOCATION_V2"."FINESNOTICEFEES_2" AS "FINESNOTICEFEES_2 _LOCATION_V2",
  "MEDIA_V2"."FINESNOTICEFEES_2" AS "FINESNOTICEFEES_2 _MEDIA_V2_",
  "Transaction Branch"."FINESNOTICEFEES_2" AS "FINESNOTICEFEES_2",
  "PATRON_V2"."FIRSTNAME" AS "FIRSTNAME",
  "BBIBMAP_V2"."FOLDER" AS "FOLDER",
  "BBIBMAP_V2"."FORMAT" AS "FORMAT",
  "MEDIA_V2"."GRACEPERIOD" AS "GRACEPERIOD",
  "BBIBMAP_V2"."HIDDENTYPE" AS "HIDDENTYPE",
  "Item Branch"."HOLDNOTICEFEE" AS "HOLDNOTICEFEE _BRANCH_V2_",
  "LOCATION_V2"."HOLDNOTICEFEE" AS "HOLDNOTICEFEE _LOCATION_V2_",
  "MEDIA_V2"."HOLDNOTICEFEE" AS "HOLDNOTICEFEE _MEDIA_V2_",
  "Transaction Branch"."HOLDNOTICEFEE" AS "HOLDNOTICEFEE",
  "Item Branch"."HOLDSERVICEFEE" AS "HOLDSERVICEFEE _BRANCH_V2_",
  "Transaction Branch"."HOLDSERVICEFEE" AS "HOLDSERVICEFEE",
  "BTY_V2"."HOLDSEXPIRATIONPERIOD" AS "HOLDSEXPIRATIONPERIOD",
  "ITEM_V2"."HOLDSHISTORY" AS "HOLDSHISTORY",
  "BTY_V2"."HOLDSLIMIT" AS "HOLDSLIMIT",
  "BTY_V2"."HOLDSREQUESTFEE" AS "HOLDSREQUESTFEE",
  "PATRON_V2"."INFO" AS "INFO",
  "ITEM_V2"."INHOUSECIRC" AS "INHOUSECIRC",
  "MEDIA_V2"."INITIALFINERATE" AS "INITIALFINERATE",
  "MEDIA_V2"."INITIALLIMIT" AS "INITIALLIMIT",
  "MEDIA_V2"."INITIALPERMINUTES" AS "INITIALPERMINUTES",
  "BBIBMAP_V2"."INSTBIT" AS "INSTBIT _BBIBMAP_V2_",
  "Item Branch"."INSTBIT" AS "INSTBIT _BRANCH_V2_ #1",
  "Transaction Branch"."INSTBIT" AS "INSTBIT _BRANCH_V2_",
  "BTY_V2"."INSTBIT" AS "INSTBIT _BTY_V2_",
  "ITEM_V2"."INSTBIT" AS "INSTBIT _ITEM_V2_",
  "LOCATION_V2"."INSTBIT" AS "INSTBIT _LOCATION_V2_",
  "MEDIA_V2"."INSTBIT" AS "INSTBIT _MEDIA_V2_",
  "PATRON_V2"."INSTBIT" AS "INSTBIT _PATRON_V2_",
  "SYSTEMITEMCODES_V2"."INSTBIT" AS "INSTBIT _SYSTEMITEMCODES_V2_",
  "TXLOG_V2"."INSTBIT" AS "INSTBIT",
  "LOCATION_V2"."INTELLECTUAL_LEVEL" AS "INTELLECTUAL_LEVEL",
  "BBIBMAP_V2"."INTERLIBRARY_LOAN" AS "INTERLIBRARY_LOAN",
  "BBIBMAP_V2"."ISBN" AS "ISBN",
  "ITEM_V2"."ISID" AS "ISID",
  "ITEM_V2"."ITEM" AS "ITEM _ITEM_V2_",
  "TXLOG_V2"."ITEMBID" AS "ITEMBID",
  "TXLOG_V2"."ITEMBRANCH" AS "ITEMBRANCH",
  "TXLOG_V2"."ITEMCN" AS "ITEMCN",
  "TXLOG_V2"."ITEMCREATIONDATE" AS "ITEMCREATIONDATE",
  "ITEM_V2"."ITEMGUID" AS "ITEMGUID",
  "TXLOG_V2"."ITEMLOCATION" AS "ITEMLOCATION",
  "TXLOG_V2"."ITEMMEDIA" AS "ITEMMEDIA",
  "BTY_V2"."ITEMSGOLOST" AS "ITEMSGOLOST",
  "BBIBMAP_V2"."ITEMSLATESTCHANGE" AS "ITEMSLATESTCHANGE",
  "TXLOG_V2"."ITEMSTATUSAFTER" AS "ITEMSTATUSAFTER",
  "TXLOG_V2"."ITEMSTATUSBEFORE" AS "ITEMSTATUSBEFORE",
  "TXLOG_V2"."ITEMSTATUS" AS "ITEMSTATUS",
  "TXLOG_V2"."ITEM" AS "ITEM",
  "PATRON_V2"."KEEPCARDHISTORY" AS "KEEPCARDHISTORY",
  "PATRON_V2"."LANGUAGE" AS "LANGUAGE _PATRON_V2_",
  "BBIBMAP_V2"."LANGUAGE" AS "LANGUAGE",
  "PATRON_V2"."LASTNAME" AS "LASTNAME",
  "PATRON_V2"."LEGALNAME" AS "LEGALNAME",
  "Item Branch"."LIBRARYDEFINEDFIELD" AS "LIBRARYDEFINEDFIELD _BRANCH_V2",
  "Transaction Branch"."LIBRARYDEFINEDFIELD" AS "LIBRARYDEFINEDFIELD",
  "SYSTEMITEMCODES_V2"."LOAD" AS "LOAD",
  "PATRON_V2"."LOANHISTORYOPTIN" AS "LOANHISTORYOPTIN",
  "ITEM_V2"."LOCATION" AS "LOCATION _ITEM_V2_",
  "LOCATION_V2"."LOCCODE" AS "LOCCODE",
  "LOCATION_V2"."LOCNAME" AS "LOCNAME",
  "LOCATION_V2"."LOCNUMBER" AS "LOCNUMBER",
  "Item Branch"."LOSTBOOKCHARGE" AS "LOSTBOOKCHARGE _BRANCH_V2_",
  "BTY_V2"."LOSTBOOKCHARGE" AS "LOSTBOOKCHARGE _BTY_V2_",
  "LOCATION_V2"."LOSTBOOKCHARGE" AS "LOSTBOOKCHARGE _LOCATION_V2_",
  "MEDIA_V2"."LOSTBOOKCHARGE" AS "LOSTBOOKCHARGE _MEDIA_V2_",
  "Transaction Branch"."LOSTBOOKCHARGE" AS "LOSTBOOKCHARGE",
  "Item Branch"."LOSTNOTICEDAYS_0" AS "LOSTNOTICEDAYS_0 _BRANCH_V2_",
  "BTY_V2"."LOSTNOTICEDAYS_0" AS "LOSTNOTICEDAYS_0 _BTY_V2_",
  "LOCATION_V2"."LOSTNOTICEDAYS_0" AS "LOSTNOTICEDAYS_0 _LOCATION_V2_",
  "MEDIA_V2"."LOSTNOTICEDAYS_0" AS "LOSTNOTICEDAYS_0 _MEDIA_V2_",
  "Transaction Branch"."LOSTNOTICEDAYS_0" AS "LOSTNOTICEDAYS_0",
  "Item Branch"."LOSTNOTICEDAYS_1" AS "LOSTNOTICEDAYS_1 _BRANCH_V2_",
  "BTY_V2"."LOSTNOTICEDAYS_1" AS "LOSTNOTICEDAYS_1 _BTY_V2_",
  "LOCATION_V2"."LOSTNOTICEDAYS_1" AS "LOSTNOTICEDAYS_1 _LOCATION_V2_",
  "MEDIA_V2"."LOSTNOTICEDAYS_1" AS "LOSTNOTICEDAYS_1 _MEDIA_V2_",
  "Transaction Branch"."LOSTNOTICEDAYS_1" AS "LOSTNOTICEDAYS_1",
  "Item Branch"."LOSTNOTICEDAYS_2" AS "LOSTNOTICEDAYS_2 _BRANCH_V2_",
  "BTY_V2"."LOSTNOTICEDAYS_2" AS "LOSTNOTICEDAYS_2 _BTY_V2_",
  "LOCATION_V2"."LOSTNOTICEDAYS_2" AS "LOSTNOTICEDAYS_2 _LOCATION_V2_",
  "MEDIA_V2"."LOSTNOTICEDAYS_2" AS "LOSTNOTICEDAYS_2 _MEDIA_V2_",
  "Transaction Branch"."LOSTNOTICEDAYS_2" AS "LOSTNOTICEDAYS_2",
  "Item Branch"."LOSTNOTICEFEES_0" AS "LOSTNOTICEFEES_0 _BRANCH_V2_",
  "BTY_V2"."LOSTNOTICEFEES_0" AS "LOSTNOTICEFEES_0 _BTY_V2_",
  "LOCATION_V2"."LOSTNOTICEFEES_0" AS "LOSTNOTICEFEES_0 _LOCATION_V2_",
  "MEDIA_V2"."LOSTNOTICEFEES_0" AS "LOSTNOTICEFEES_0 _MEDIA_V2_",
  "Transaction Branch"."LOSTNOTICEFEES_0" AS "LOSTNOTICEFEES_0",
  "Item Branch"."LOSTNOTICEFEES_1" AS "LOSTNOTICEFEES_1 _BRANCH_V2_",
  "BTY_V2"."LOSTNOTICEFEES_1" AS "LOSTNOTICEFEES_1 _BTY_V2_",
  "LOCATION_V2"."LOSTNOTICEFEES_1" AS "LOSTNOTICEFEES_1 _LOCATION_V2_",
  "MEDIA_V2"."LOSTNOTICEFEES_1" AS "LOSTNOTICEFEES_1 _MEDIA_V2_",
  "Transaction Branch"."LOSTNOTICEFEES_1" AS "LOSTNOTICEFEES_1",
  "Item Branch"."LOSTNOTICEFEES_2" AS "LOSTNOTICEFEES_2 _BRANCH_V2_",
  "BTY_V2"."LOSTNOTICEFEES_2" AS "LOSTNOTICEFEES_2 _BTY_V2_",
  "LOCATION_V2"."LOSTNOTICEFEES_2" AS "LOSTNOTICEFEES_2 _LOCATION_V2_",
  "MEDIA_V2"."LOSTNOTICEFEES_2" AS "LOSTNOTICEFEES_2 _MEDIA_V2_",
  "Transaction Branch"."LOSTNOTICEFEES_2" AS "LOSTNOTICEFEES_2",
  "Item Branch"."LOSTRNOTICEDAYS_0" AS "LOSTRNOTICEDAYS_0 _BRANCH_V2_",
  "Transaction Branch"."LOSTRNOTICEDAYS_0" AS "LOSTRNOTICEDAYS_0",
  "Item Branch"."LOSTRNOTICEDAYS_1" AS "LOSTRNOTICEDAYS_1 _BRANCH_V2_",
  "Transaction Branch"."LOSTRNOTICEDAYS_1" AS "LOSTRNOTICEDAYS_1",
  "Item Branch"."LOSTRNOTICEFEES_0" AS "LOSTRNOTICEFEES_0 _BRANCH_V2_",
  "Transaction Branch"."LOSTRNOTICEFEES_0" AS "LOSTRNOTICEFEES_0",
  "Item Branch"."LOSTRNOTICEFEES_1" AS "LOSTRNOTICEFEES_1 _BRANCH_V2_",
  "Transaction Branch"."LOSTRNOTICEFEES_1" AS "LOSTRNOTICEFEES_1",
  "Item Branch"."MAGNETICMEDIA" AS "MAGNETICMEDIA _BRANCH_V2_",
  "LOCATION_V2"."MAGNETICMEDIA" AS "MAGNETICMEDIA _LOCATION_V2_",
  "MEDIA_V2"."MAGNETICMEDIA" AS "MAGNETICMEDIA _MEDIA_V2_",
  "Transaction Branch"."MAGNETICMEDIA" AS "MAGNETICMEDIA",
  "Item Branch"."MAXCLAIMRETURNLIMIT" AS "MAXCLAIMRETURNLIMIT _BRANCH_V2",
  "BTY_V2"."MAXCLAIMRETURNLIMIT" AS "MAXCLAIMRETURNLIMIT _BTY_V2_",
  "Transaction Branch"."MAXCLAIMRETURNLIMIT" AS "MAXCLAIMRETURNLIMIT",
  "BTY_V2"."MAXDEPOSIT" AS "MAXDEPOSIT",
  "Item Branch"."MAXFINELIMIT" AS "MAXFINELIMIT _BRANCH_V2_",
  "BTY_V2"."MAXFINELIMIT" AS "MAXFINELIMIT _BTY_V2_",
  "Transaction Branch"."MAXFINELIMIT" AS "MAXFINELIMIT",
  "MEDIA_V2"."MAXFINE" AS "MAXFINE",
  "Item Branch"."MAXLOSTLIMIT" AS "MAXLOSTLIMIT _BRANCH_V2_",
  "BTY_V2"."MAXLOSTLIMIT" AS "MAXLOSTLIMIT _BTY_V2_",
  "Transaction Branch"."MAXLOSTLIMIT" AS "MAXLOSTLIMIT",
  "Item Branch"."MAXOVERDUELIMIT" AS "MAXOVERDUELIMIT _BRANCH_V2_",
  "BTY_V2"."MAXOVERDUELIMIT" AS "MAXOVERDUELIMIT _BTY_V2_",
  "Transaction Branch"."MAXOVERDUELIMIT" AS "MAXOVERDUELIMIT",
  "Item Branch"."MAXOVERDUERECALL" AS "MAXOVERDUERECALL _BRANCH_V2_",
  "BTY_V2"."MAXOVERDUERECALL" AS "MAXOVERDUERECALL _BTY_V2_",
  "Transaction Branch"."MAXOVERDUERECALL" AS "MAXOVERDUERECALL",
  "Item Branch"."MAXOVERDUEREQUEST" AS "MAXOVERDUEREQUEST _BRANCH_V2_",
  "BTY_V2"."MAXOVERDUEREQUEST" AS "MAXOVERDUEREQUEST _BTY_V2_",
  "Transaction Branch"."MAXOVERDUEREQUEST" AS "MAXOVERDUEREQUEST",
  "MEDIA_V2"."MEDCODE" AS "MEDCODE",
  "ITEM_V2"."MEDIA" AS "MEDIA _ITEM_V2_",
  "MEDIA_V2"."MEDNAME" AS "MEDNAME",
  "MEDIA_V2"."MEDNUMBER" AS "MEDNUMBER",
  "PATRON_V2"."MIDDLENAME" AS "MIDDLENAME",
  "PATRON_V2"."NAME" AS "NAME",
  "Item Branch"."NEWITEMALLOWHOLDS" AS "NEWITEMALLOWHOLDS _BRANCH_V2_",
  "Transaction Branch"."NEWITEMALLOWHOLDS" AS "NEWITEMALLOWHOLDS",
  "Item Branch"."NEWITEMHOLDRULEDAYS" AS "NEWITEMHOLDRULEDAYS _BRANCH_V2",
  "Transaction Branch"."NEWITEMHOLDRULEDAYS" AS "NEWITEMHOLDRULEDAYS",
  "BBIBMAP_V2"."NORMALIZEDCALLNUMBER" AS "NORMALIZEDCALLNUMBER",
  "PATRON_V2"."NOTES" AS "NOTES _PATRON_V2_",
  "Item Branch"."NOTICEDAYS_0" AS "NOTICEDAYS_0 _BRANCH_V2_",
  "BTY_V2"."NOTICEDAYS_0" AS "NOTICEDAYS_0 _BTY_V2_",
  "LOCATION_V2"."NOTICEDAYS_0" AS "NOTICEDAYS_0 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEDAYS_0" AS "NOTICEDAYS_0 _MEDIA_V2_",
  "Transaction Branch"."NOTICEDAYS_0" AS "NOTICEDAYS_0",
  "Item Branch"."NOTICEDAYS_1" AS "NOTICEDAYS_1 _BRANCH_V2_",
  "BTY_V2"."NOTICEDAYS_1" AS "NOTICEDAYS_1 _BTY_V2_",
  "LOCATION_V2"."NOTICEDAYS_1" AS "NOTICEDAYS_1 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEDAYS_1" AS "NOTICEDAYS_1 _MEDIA_V2_",
  "Transaction Branch"."NOTICEDAYS_1" AS "NOTICEDAYS_1",
  "Item Branch"."NOTICEDAYS_2" AS "NOTICEDAYS_2 _BRANCH_V2_",
  "BTY_V2"."NOTICEDAYS_2" AS "NOTICEDAYS_2 _BTY_V2_",
  "LOCATION_V2"."NOTICEDAYS_2" AS "NOTICEDAYS_2 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEDAYS_2" AS "NOTICEDAYS_2 _MEDIA_V2_",
  "Transaction Branch"."NOTICEDAYS_2" AS "NOTICEDAYS_2",
  "Item Branch"."NOTICEDAYS_3" AS "NOTICEDAYS_3 _BRANCH_V2_",
  "BTY_V2"."NOTICEDAYS_3" AS "NOTICEDAYS_3 _BTY_V2_",
  "LOCATION_V2"."NOTICEDAYS_3" AS "NOTICEDAYS_3 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEDAYS_3" AS "NOTICEDAYS_3 _MEDIA_V2_",
  "Transaction Branch"."NOTICEDAYS_3" AS "NOTICEDAYS_3",
  "Item Branch"."NOTICEDAYS_4" AS "NOTICEDAYS_4 _BRANCH_V2_",
  "BTY_V2"."NOTICEDAYS_4" AS "NOTICEDAYS_4 _BTY_V2_",
  "LOCATION_V2"."NOTICEDAYS_4" AS "NOTICEDAYS_4 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEDAYS_4" AS "NOTICEDAYS_4 _MEDIA_V2_",
  "Transaction Branch"."NOTICEDAYS_4" AS "NOTICEDAYS_4",
  "Item Branch"."NOTICEDAYS_5" AS "NOTICEDAYS_5 _BRANCH_V2_",
  "BTY_V2"."NOTICEDAYS_5" AS "NOTICEDAYS_5 _BTY_V2_",
  "LOCATION_V2"."NOTICEDAYS_5" AS "NOTICEDAYS_5 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEDAYS_5" AS "NOTICEDAYS_5 _MEDIA_V2_",
  "Transaction Branch"."NOTICEDAYS_5" AS "NOTICEDAYS_5",
  "Item Branch"."NOTICEFEES_0" AS "NOTICEFEES_0 _BRANCH_V2_",
  "BTY_V2"."NOTICEFEES_0" AS "NOTICEFEES_0 _BTY_V2_",
  "LOCATION_V2"."NOTICEFEES_0" AS "NOTICEFEES_0 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEFEES_0" AS "NOTICEFEES_0 _MEDIA_V2_",
  "Transaction Branch"."NOTICEFEES_0" AS "NOTICEFEES_0",
  "Item Branch"."NOTICEFEES_1" AS "NOTICEFEES_1 _BRANCH_V2_",
  "BTY_V2"."NOTICEFEES_1" AS "NOTICEFEES_1 _BTY_V2_",
  "LOCATION_V2"."NOTICEFEES_1" AS "NOTICEFEES_1 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEFEES_1" AS "NOTICEFEES_1 _MEDIA_V2_",
  "Transaction Branch"."NOTICEFEES_1" AS "NOTICEFEES_1",
  "Item Branch"."NOTICEFEES_2" AS "NOTICEFEES_2 _BRANCH_V2_",
  "BTY_V2"."NOTICEFEES_2" AS "NOTICEFEES_2 _BTY_V2_",
  "LOCATION_V2"."NOTICEFEES_2" AS "NOTICEFEES_2 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEFEES_2" AS "NOTICEFEES_2 _MEDIA_V2_",
  "Transaction Branch"."NOTICEFEES_2" AS "NOTICEFEES_2",
  "Item Branch"."NOTICEFEES_3" AS "NOTICEFEES_3 _BRANCH_V2_",
  "BTY_V2"."NOTICEFEES_3" AS "NOTICEFEES_3 _BTY_V2_",
  "LOCATION_V2"."NOTICEFEES_3" AS "NOTICEFEES_3 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEFEES_3" AS "NOTICEFEES_3 _MEDIA_V2_",
  "Transaction Branch"."NOTICEFEES_3" AS "NOTICEFEES_3",
  "Item Branch"."NOTICEFEES_4" AS "NOTICEFEES_4 _BRANCH_V2_",
  "BTY_V2"."NOTICEFEES_4" AS "NOTICEFEES_4 _BTY_V2_",
  "LOCATION_V2"."NOTICEFEES_4" AS "NOTICEFEES_4 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEFEES_4" AS "NOTICEFEES_4 _MEDIA_V2_",
  "Transaction Branch"."NOTICEFEES_4" AS "NOTICEFEES_4",
  "Item Branch"."NOTICEFEES_5" AS "NOTICEFEES_5 _BRANCH_V2_",
  "BTY_V2"."NOTICEFEES_5" AS "NOTICEFEES_5 _BTY_V2_",
  "LOCATION_V2"."NOTICEFEES_5" AS "NOTICEFEES_5 _LOCATION_V2_",
  "MEDIA_V2"."NOTICEFEES_5" AS "NOTICEFEES_5 _MEDIA_V2_",
  "Transaction Branch"."NOTICEFEES_5" AS "NOTICEFEES_5",
  "ITEM_V2"."NUMBER_" AS "NUMBER_",
  "ITEM_V2"."OCCUR" AS "OCCUR _ITEM_V2_",
  "Item Branch"."OCLCCODE" AS "OCLCCODE _BRANCH_V2_",
  "Transaction Branch"."OCLCCODE" AS "OCLCCODE",
  "Item Branch"."OCLCLOC" AS "OCLCLOC _BRANCH_V2_",
  "Transaction Branch"."OCLCLOC" AS "OCLCLOC",
  "BTY_V2"."OUTREACH" AS "OUTREACH",
  "MEDIA_V2"."OVERRIDENOFINE" AS "OVERRIDENOFINE _MEDIA_V2_",
  "LOCATION_V2"."OVERRIDENOFINE" AS "OVERRIDENOFINE",
  "ITEM_V2"."OWNINGBRANCH" AS "OWNINGBRANCH",
  "ITEM_V2"."OWNINGLOCATION" AS "OWNINGLOCATION",
  "ITEM_V2"."PART" AS "PART",
  "TXLOG_V2"."PATRONBRANCHOFREGISTRATION" AS "PATRONBRANCHOFREGISTRATION",
  "TXLOG_V2"."PATRONBTY" AS "PATRONBTY",
  "TXLOG_V2"."PATRONGUID" AS "PATRONGUID _TXLOG_V2_",
  "PATRON_V2"."PATRONGUID" AS "PATRONGUID",
  "PATRON_V2"."PATRONID" AS "PATRONID _PATRON_V2_",
  "TXLOG_V2"."PATRONID" AS "PATRONID",
  "TXLOG_V2"."PATRONZIP1" AS "PATRONZIP1",
  "PATRON_V2"."PH1" AS "PH1",
  "PATRON_V2"."PH2" AS "PH2",
  "PATRON_V2"."PHONETYPEID1" AS "PHONETYPEID1",
  "PATRON_V2"."PREFERRED_BRANCH" AS "PREFERRED_BRANCH",
  "ITEM_V2"."PRICE" AS "PRICE",
  "Item Branch"."PROCESSDELAY" AS "PROCESSDELAY _BRANCH_V2_",
  "Transaction Branch"."PROCESSDELAY" AS "PROCESSDELAY",
  "Item Branch"."PROCESSINGFEE" AS "PROCESSINGFEE _BRANCH_V2_",
  "BTY_V2"."PROCESSINGFEE" AS "PROCESSINGFEE _BTY_V2_",
  "LOCATION_V2"."PROCESSINGFEE" AS "PROCESSINGFEE _LOCATION_V2_",
  "MEDIA_V2"."PROCESSINGFEE" AS "PROCESSINGFEE _MEDIA_V2_",
  "Transaction Branch"."PROCESSINGFEE" AS "PROCESSINGFEE",
  "BTY_V2"."PROHIBITRECALL" AS "PROHIBITRECALL",
  "BBIBMAP_V2"."PUBLISHINGDATE" AS "PUBLISHINGDATE",
  "TXLOG_V2"."PWD" AS "PWD",
  "Item Branch"."RECALLLOANPERIOD" AS "RECALLLOANPERIOD _BRANCH_V2_",
  "BTY_V2"."RECALLLOANPERIOD" AS "RECALLLOANPERIOD _BTY_V2_",
  "LOCATION_V2"."RECALLLOANPERIOD" AS "RECALLLOANPERIOD _LOCATION_V2_",
  "MEDIA_V2"."RECALLLOANPERIOD" AS "RECALLLOANPERIOD _MEDIA_V2_",
  "Transaction Branch"."RECALLLOANPERIOD" AS "RECALLLOANPERIOD",
  "Item Branch"."RECALLNOTICEDAYS_0" AS "RECALLNOTICEDAYS_0 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_0" AS "RECALLNOTICEDAYS_0 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEDAYS_0" AS "RECALLNOTICEDAYS_0 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEDAYS_0" AS "RECALLNOTICEDAYS_0",
  "Item Branch"."RECALLNOTICEDAYS_1" AS "RECALLNOTICEDAYS_1 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_1" AS "RECALLNOTICEDAYS_1 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEDAYS_1" AS "RECALLNOTICEDAYS_1 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEDAYS_1" AS "RECALLNOTICEDAYS_1",
  "Item Branch"."RECALLNOTICEDAYS_2" AS "RECALLNOTICEDAYS_2 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_2" AS "RECALLNOTICEDAYS_2 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEDAYS_2" AS "RECALLNOTICEDAYS_2 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEDAYS_2" AS "RECALLNOTICEDAYS_2",
  "Item Branch"."RECALLNOTICEDAYS_3" AS "RECALLNOTICEDAYS_3 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_3" AS "RECALLNOTICEDAYS_3 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEDAYS_3" AS "RECALLNOTICEDAYS_3 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEDAYS_3" AS "RECALLNOTICEDAYS_3",
  "Item Branch"."RECALLNOTICEDAYS_4" AS "RECALLNOTICEDAYS_4 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_4" AS "RECALLNOTICEDAYS_4 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEDAYS_4" AS "RECALLNOTICEDAYS_4 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEDAYS_4" AS "RECALLNOTICEDAYS_4",
  "Item Branch"."RECALLNOTICEDAYS_5" AS "RECALLNOTICEDAYS_5 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEDAYS_5" AS "RECALLNOTICEDAYS_5 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEDAYS_5" AS "RECALLNOTICEDAYS_5 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEDAYS_5" AS "RECALLNOTICEDAYS_5",
  "Item Branch"."RECALLNOTICEFEES_0" AS "RECALLNOTICEFEES_0 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_0" AS "RECALLNOTICEFEES_0 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEFEES_0" AS "RECALLNOTICEFEES_0 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEFEES_0" AS "RECALLNOTICEFEES_0",
  "Item Branch"."RECALLNOTICEFEES_1" AS "RECALLNOTICEFEES_1 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_1" AS "RECALLNOTICEFEES_1 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEFEES_1" AS "RECALLNOTICEFEES_1 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEFEES_1" AS "RECALLNOTICEFEES_1",
  "Item Branch"."RECALLNOTICEFEES_2" AS "RECALLNOTICEFEES_2 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_2" AS "RECALLNOTICEFEES_2 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEFEES_2" AS "RECALLNOTICEFEES_2 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEFEES_2" AS "RECALLNOTICEFEES_2",
  "Item Branch"."RECALLNOTICEFEES_3" AS "RECALLNOTICEFEES_3 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_3" AS "RECALLNOTICEFEES_3 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEFEES_3" AS "RECALLNOTICEFEES_3 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEFEES_3" AS "RECALLNOTICEFEES_3",
  "Item Branch"."RECALLNOTICEFEES_4" AS "RECALLNOTICEFEES_4 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_4" AS "RECALLNOTICEFEES_4 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEFEES_4" AS "RECALLNOTICEFEES_4 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEFEES_4" AS "RECALLNOTICEFEES_4",
  "Item Branch"."RECALLNOTICEFEES_5" AS "RECALLNOTICEFEES_5 _BRANCH_V2_",
  "LOCATION_V2"."RECALLNOTICEFEES_5" AS "RECALLNOTICEFEES_5 _LOCATION_V",
  "MEDIA_V2"."RECALLNOTICEFEES_5" AS "RECALLNOTICEFEES_5 _MEDIA_V2_",
  "Transaction Branch"."RECALLNOTICEFEES_5" AS "RECALLNOTICEFEES_5",
  "BBIBMAP_V2"."RECORDTYPE" AS "RECORDTYPE",
  "PATRON_V2"."REGBRANCH" AS "REGBRANCH",
  "PATRON_V2"."REGBY" AS "REGBY",
  "PATRON_V2"."REGDATE" AS "REGDATE",
  "BTY_V2"."REMOVEONHOLD" AS "REMOVEONHOLD",
  "BTY_V2"."RENEWALFEE" AS "RENEWALFEE",
  "Item Branch"."RENEWALLIMIT" AS "RENEWALLIMIT _BRANCH_V2_",
  "BTY_V2"."RENEWALLIMIT" AS "RENEWALLIMIT _BTY_V2_",
  "LOCATION_V2"."RENEWALLIMIT" AS "RENEWALLIMIT _LOCATION_V2_",
  "MEDIA_V2"."RENEWALLIMIT" AS "RENEWALLIMIT _MEDIA_V2_",
  "Transaction Branch"."RENEWALLIMIT" AS "RENEWALLIMIT",
  "MEDIA_V2"."RENEWALSALLOWED" AS "RENEWALSALLOWED _MEDIA_V2_",
  "LOCATION_V2"."RENEWALSALLOWED" AS "RENEWALSALLOWED",
  "Item Branch"."RENEWLOANPERIOD" AS "RENEWLOANPERIOD _BRANCH_V2_",
  "BTY_V2"."RENEWLOANPERIOD" AS "RENEWLOANPERIOD _BTY_V2_",
  "LOCATION_V2"."RENEWLOANPERIOD" AS "RENEWLOANPERIOD _LOCATION_V2_",
  "MEDIA_V2"."RENEWLOANPERIOD" AS "RENEWLOANPERIOD _MEDIA_V2_",
  "Transaction Branch"."RENEWLOANPERIOD" AS "RENEWLOANPERIOD",
  "MEDIA_V2"."RENTALFLAG" AS "RENTALFLAG",
  "Item Branch"."REQUESTCHARGELOANPERIOD" AS "REQUESTCHARGELOANPERIOD _BRANC",
  "BTY_V2"."REQUESTCHARGELOANPERIOD" AS "REQUESTCHARGELOANPERIOD _BTY_V",
  "LOCATION_V2"."REQUESTCHARGELOANPERIOD" AS "REQUESTCHARGELOANPERIOD _LOCAT",
  "MEDIA_V2"."REQUESTCHARGELOANPERIOD" AS "REQUESTCHARGELOANPERIOD _MEDIA",
  "Transaction Branch"."REQUESTCHARGELOANPERIOD" AS "REQUESTCHARGELOANPERIOD",
  "Item Branch"."REQUESTFINEASSESSMENTTYPE" AS "REQUESTFINEASSESSMENTTYPE _BRA",
  "LOCATION_V2"."REQUESTFINEASSESSMENTTYPE" AS "REQUESTFINEASSESSMENTTYPE _LOC",
  "MEDIA_V2"."REQUESTFINEASSESSMENTTYPE" AS "REQUESTFINEASSESSMENTTYPE _MED",
  "Transaction Branch"."REQUESTFINEASSESSMENTTYPE" AS "REQUESTFINEASSESSMENTTYPE",
  "Item Branch"."REQUESTFINEGRACEPERIOD" AS "REQUESTFINEGRACEPERIOD _BRANCH",
  "BTY_V2"."REQUESTFINEGRACEPERIOD" AS "REQUESTFINEGRACEPERIOD _BTY_V2",
  "LOCATION_V2"."REQUESTFINEGRACEPERIOD" AS "REQUESTFINEGRACEPERIOD _LOCATI",
  "MEDIA_V2"."REQUESTFINEGRACEPERIOD" AS "REQUESTFINEGRACEPERIOD _MEDIA_",
  "Transaction Branch"."REQUESTFINEGRACEPERIOD" AS "REQUESTFINEGRACEPERIOD",
  "Item Branch"."REQUESTFINELIMIT" AS "REQUESTFINELIMIT _BRANCH_V2_",
  "BTY_V2"."REQUESTFINELIMIT" AS "REQUESTFINELIMIT _BTY_V2_",
  "LOCATION_V2"."REQUESTFINELIMIT" AS "REQUESTFINELIMIT _LOCATION_V2_",
  "MEDIA_V2"."REQUESTFINELIMIT" AS "REQUESTFINELIMIT _MEDIA_V2_",
  "Transaction Branch"."REQUESTFINELIMIT" AS "REQUESTFINELIMIT",
  "Item Branch"."REQUESTFINERATE" AS "REQUESTFINERATE _BRANCH_V2_",
  "BTY_V2"."REQUESTFINERATE" AS "REQUESTFINERATE _BTY_V2_",
  "LOCATION_V2"."REQUESTFINERATE" AS "REQUESTFINERATE _LOCATION_V2_",
  "MEDIA_V2"."REQUESTFINERATE" AS "REQUESTFINERATE _MEDIA_V2_",
  "Transaction Branch"."REQUESTFINERATE" AS "REQUESTFINERATE",
  "Item Branch"."REQUESTRECALLLOANPERIOD" AS "REQUESTRECALLLOANPERIOD _BRANC",
  "BTY_V2"."REQUESTRECALLLOANPERIOD" AS "REQUESTRECALLLOANPERIOD _BTY_V",
  "LOCATION_V2"."REQUESTRECALLLOANPERIOD" AS "REQUESTRECALLLOANPERIOD _LOCAT",
  "MEDIA_V2"."REQUESTRECALLLOANPERIOD" AS "REQUESTRECALLLOANPERIOD _MEDIA",
  "Transaction Branch"."REQUESTRECALLLOANPERIOD" AS "REQUESTRECALLLOANPERIOD",
  "Item Branch"."REQUESTRENEWLOANPERIOD" AS "REQUESTRENEWLOANPERIOD _BRANCH",
  "BTY_V2"."REQUESTRENEWLOANPERIOD" AS "REQUESTRENEWLOANPERIOD _BTY_V2",
  "LOCATION_V2"."REQUESTRENEWLOANPERIOD" AS "REQUESTRENEWLOANPERIOD _LOCATI",
  "MEDIA_V2"."REQUESTRENEWLOANPERIOD" AS "REQUESTRENEWLOANPERIOD _MEDIA_",
  "Transaction Branch"."REQUESTRENEWLOANPERIOD" AS "REQUESTRENEWLOANPERIOD",
  "BTY_V2"."REQUIREDOB" AS "REQUIREDOB",
  "ITEM_V2"."RESERVEBRANCH" AS "RESERVEBRANCH",
  "ITEM_V2"."RESERVECN" AS "RESERVECN",
  "ITEM_V2"."RESERVELOCATION" AS "RESERVELOCATION",
  "ITEM_V2"."RESERVETYPE" AS "RESERVETYPE",
  "BTY_V2"."RETAINCHARGEHISTORY" AS "RETAINCHARGEHISTORY",
  "MEDIA_V2"."RETURNFEEFLAG" AS "RETURNFEEFLAG",
  "MEDIA_V2"."RETURNFEE" AS "RETURNFEE",
  "Item Branch"."RFINESNOTICEDAYS_0" AS "RFINESNOTICEDAYS_0 _BRANCH_V2_",
  "Transaction Branch"."RFINESNOTICEDAYS_0" AS "RFINESNOTICEDAYS_0",
  "Item Branch"."RFINESNOTICEDAYS_1" AS "RFINESNOTICEDAYS_1 _BRANCH_V2_",
  "Transaction Branch"."RFINESNOTICEDAYS_1" AS "RFINESNOTICEDAYS_1",
  "Item Branch"."RFINESNOTICEFEES_0" AS "RFINESNOTICEFEES_0 _BRANCH_V2_",
  "Transaction Branch"."RFINESNOTICEFEES_0" AS "RFINESNOTICEFEES_0",
  "Item Branch"."RFINESNOTICEFEES_1" AS "RFINESNOTICEFEES_1 _BRANCH_V2_",
  "Transaction Branch"."RFINESNOTICEFEES_1" AS "RFINESNOTICEFEES_1",
  "Item Branch"."RNOTICEDAYS_0" AS "RNOTICEDAYS_0 _BRANCH_V2_",
  "Transaction Branch"."RNOTICEDAYS_0" AS "RNOTICEDAYS_0",
  "Item Branch"."RNOTICEDAYS_1" AS "RNOTICEDAYS_1 _BRANCH_V2_",
  "Transaction Branch"."RNOTICEDAYS_1" AS "RNOTICEDAYS_1",
  "Item Branch"."RNOTICEFEES_0" AS "RNOTICEFEES_0 _BRANCH_V2_",
  "Transaction Branch"."RNOTICEFEES_0" AS "RNOTICEFEES_0",
  "Item Branch"."RNOTICEFEES_1" AS "RNOTICEFEES_1 _BRANCH_V2_",
  "Transaction Branch"."RNOTICEFEES_1" AS "RNOTICEFEES_1",
  "Item Branch"."RSENDRFINESNOTICE" AS "RSENDRFINESNOTICE _BRANCH_V2_",
  "Transaction Branch"."RSENDRFINESNOTICE" AS "RSENDRFINESNOTICE",
  "PATRON_V2"."SACTBRANCH" AS "SACTBRANCH",
  "PATRON_V2"."SACTDATE" AS "SACTDATE",
  "Item Branch"."SCHOOL" AS "SCHOOL _BRANCH_V2_",
  "Transaction Branch"."SCHOOL" AS "SCHOOL",
  "PATRON_V2"."SENDCOMINGDUEMSG" AS "SENDCOMINGDUEMSG",
  "Item Branch"."SENDFINENOTICE" AS "SENDFINENOTICE _BRANCH_V2_",
  "BTY_V2"."SENDFINENOTICE" AS "SENDFINENOTICE _BTY_V2_",
  "LOCATION_V2"."SENDFINENOTICE" AS "SENDFINENOTICE _LOCATION_V2_",
  "MEDIA_V2"."SENDFINENOTICE" AS "SENDFINENOTICE _MEDIA_V2_",
  "Transaction Branch"."SENDFINENOTICE" AS "SENDFINENOTICE",
  "PATRON_V2"."SENDHOLDAVAILABLEMSG" AS "SENDHOLDAVAILABLEMSG",
  "Item Branch"."SENDLOSTNOTICE" AS "SENDLOSTNOTICE _BRANCH_V2_",
  "BTY_V2"."SENDLOSTNOTICE" AS "SENDLOSTNOTICE _BTY_V2_",
  "LOCATION_V2"."SENDLOSTNOTICE" AS "SENDLOSTNOTICE _LOCATION_V2_",
  "MEDIA_V2"."SENDLOSTNOTICE" AS "SENDLOSTNOTICE _MEDIA_V2_",
  "Transaction Branch"."SENDLOSTNOTICE" AS "SENDLOSTNOTICE",
  "Item Branch"."SENDLOSTRNOTICE" AS "SENDLOSTRNOTICE _BRANCH_V2_",
  "Transaction Branch"."SENDLOSTRNOTICE" AS "SENDLOSTRNOTICE",
  "Item Branch"."SENDNOTICE" AS "SENDNOTICE _BRANCH_V2_",
  "BTY_V2"."SENDNOTICE" AS "SENDNOTICE _BTY_V2_",
  "LOCATION_V2"."SENDNOTICE" AS "SENDNOTICE _LOCATION_V2_",
  "MEDIA_V2"."SENDNOTICE" AS "SENDNOTICE _MEDIA_V2_",
  "Transaction Branch"."SENDNOTICE" AS "SENDNOTICE",
  "Item Branch"."SENDRECALLNOTICE" AS "SENDRECALLNOTICE _BRANCH_V2_",
  "LOCATION_V2"."SENDRECALLNOTICE" AS "SENDRECALLNOTICE _LOCATION_V2_",
  "MEDIA_V2"."SENDRECALLNOTICE" AS "SENDRECALLNOTICE _MEDIA_V2_",
  "Transaction Branch"."SENDRECALLNOTICE" AS "SENDRECALLNOTICE",
  "Item Branch"."SENDRNOTICE" AS "SENDRNOTICE _BRANCH_V2_",
  "Transaction Branch"."SENDRNOTICE" AS "SENDRNOTICE",
  "SYSTEMITEMCODES_V2"."SHELF" AS "SHELF",
  "Item Branch"."SHELVINGDELAY" AS "SHELVINGDELAY _BRANCH_V2_",
  "Transaction Branch"."SHELVINGDELAY" AS "SHELVINGDELAY",
  "BTY_V2"."SPECIALFEE" AS "SPECIALFEE _BTY_V2_",
  "MEDIA_V2"."SPECIALFEE" AS "SPECIALFEE _MEDIA_V2_",
  "LOCATION_V2"."SPECIALFEE" AS "SPECIALFEE",
  "PATRON_V2"."SPONSOR" AS "SPONSOR",
  "PATRON_V2"."STATE1" AS "STATE1",
  "PATRON_V2"."STATE2" AS "STATE2",
  "PATRON_V2"."STATUS" AS "STATUS _PATRON_V2_",
  "ITEM_V2"."STATUSDATE" AS "STATUSDATE",
  "ITEM_V2"."STATUS" AS "STATUS",
  "PATRON_V2"."STREET1" AS "STREET1",
  "PATRON_V2"."STREET2" AS "STREET2",
  "BTY_V2"."SUBMITTOUNIQUE" AS "SUBMITTOUNIQUE",
  "MEDIA_V2"."SUBSEQUENTFINERATE" AS "SUBSEQUENTFINERATE",
  "MEDIA_V2"."SUBSEQUENTPERMINUTES" AS "SUBSEQUENTPERMINUTES",
  "PATRON_V2"."SUFFIXNAME" AS "SUFFIXNAME",
  "ITEM_V2"."SUFFIX" AS "SUFFIX",
  "BBIBMAP_V2"."SUPPRESSDATE" AS "SUPPRESSDATE",
  "SYSTEMITEMCODES_V2"."SUPPRESSED" AS "SUPPRESSED",
  "ITEM_V2"."SUPPRESSTYPE" AS "SUPPRESSTYPE _ITEM_V2_",
  "BBIBMAP_V2"."SUPPRESSTYPE" AS "SUPPRESSTYPE",
  "ITEM_V2"."SUPPRESS" AS "SUPPRESS",
  "TXLOG_V2"."SYSTEMTIMESTAMP" AS "SYSTEMTIMESTAMP",
  "BBIBMAP_V2"."TERMINAL" AS "TERMINAL",
  "TXLOG_V2"."TERMNUMBER" AS "TERMNUMBER",
  "BBIBMAP_V2"."TITLEINDICATORS" AS "TITLEINDICATORS",
  "BBIBMAP_V2"."TITLE" AS "TITLE",
  "TXLOG_V2"."TRANSACTIONTYPE" AS "TRANSACTIONTYPE",
  "TXLOG_V2"."TXAMOUNTDEBITED" AS "TXAMOUNTDEBITED",
  "TXLOG_V2"."TXAMOUNTPAID" AS "TXAMOUNTPAID",
  "TXLOG_V2"."TXDUEORNOTNEEDEDAFTERDATE" AS "TXDUEORNOTNEEDEDAFTERDATE",
  "TXLOG_V2"."TXLASTACTIONDATE" AS "TXLASTACTIONDATE",
  "TXLOG_V2"."TXPICKUPBRANCH" AS "TXPICKUPBRANCH",
  "TXLOG_V2"."TXRENEW" AS "TXRENEW",
  "TXLOG_V2"."TXRETURNDATE" AS "TXRETURNDATE",
  "TXLOG_V2"."TXTRANSDATE" AS "TXTRANSDATE",
  "ITEM_V2"."TYPE" AS "TYPE _ITEM_V2_",
  "SYSTEMITEMCODES_V2"."TYPE" AS "TYPE",
  "BBIBMAP_V2"."UPC" AS "UPC",
  "BTY_V2"."USEEOS" AS "USEEOS",
  "BBIBMAP_V2"."USERID" AS "USERID _BBIBMAP_V2_",
  "PATRON_V2"."USERID" AS "USERID _PATRON_V2_",
  "ITEM_V2"."USERID" AS "USERID",
  "TXLOG_V2"."USERNUMBER" AS "USERNUMBER",
  "ITEM_V2"."VOLUME" AS "VOLUME",
  "BTY_V2"."WISHLIST" AS "WISHLIST",
  "PATRON_V2"."ZIP1" AS "ZIP1",
  "PATRON_V2"."ZIP2" AS "ZIP2"
FROM "CARLREPORTS"."TXLOG_V2" "TXLOG_V2"
  LEFT JOIN "CARLREPORTS"."BRANCH_V2" "Transaction Branch" ON ("TXLOG_V2"."ENVBRANCH" = "Transaction Branch"."BRANCHNUMBER")
  LEFT JOIN "CARLREPORTS"."LOCATION_V2" "LOCATION_V2" ON ("TXLOG_V2"."ITEMLOCATION" = "LOCATION_V2"."LOCNUMBER")
  LEFT JOIN "CARLREPORTS"."MEDIA_V2" "MEDIA_V2" ON ("TXLOG_V2"."ITEMMEDIA" = "MEDIA_V2"."MEDNUMBER")
  LEFT JOIN "CARLREPORTS"."ITEM_V2" "ITEM_V2" ON ("TXLOG_V2"."ITEM" = "ITEM_V2"."ITEM")
  LEFT JOIN "CARLREPORTS"."SYSTEMITEMCODES_V2" "SYSTEMITEMCODES_V2" ON (("ITEM_V2"."STATUS" = "SYSTEMITEMCODES_V2"."CODE") AND ('Y' = "SYSTEMITEMCODES_V2"."ADMIN"))
  LEFT JOIN "CARLREPORTS"."BBIBMAP_V2" "BBIBMAP_V2" ON ("ITEM_V2"."BID" = "BBIBMAP_V2"."BID")
  LEFT JOIN "CARLREPORTS"."PATRON_V2" "PATRON_V2" ON ("TXLOG_V2"."PATRONID" = "PATRON_V2"."PATRONID")
  LEFT JOIN "CARLREPORTS"."SYSTEMCODEVALUES_V2" "Transaction Code Type" ON ((N'5' = "Transaction Code Type"."CODETYPE") AND ("TXLOG_V2"."TRANSACTIONTYPE" = "Transaction Code Type"."CODEVALUE"))
  LEFT JOIN "CARLREPORTS"."BRANCH_V2" "Item Branch" ON ("ITEM_V2"."BRANCH" = "Item Branch"."BRANCHNUMBER")
  LEFT JOIN "CARLREPORTS"."BTY_V2" "BTY_V2" ON ("PATRON_V2"."BTY" = "BTY_V2"."BTYNUMBER")

SELECT COUNT(t.item), t.itembid, b.title, b.author
FROM txlog_v2 t
JOIN bbibmap_v2 b
ON t.itembid = b.bid
WHERE t.transactiontype = 'CH'
AND jts.todate(t.systemtimestamp) > ADD_MONTHS(sysdate, -3) AND jts.todate(t.systemtimestamp) < sysdate
AND b.format <> 47 AND
t.itemmedia IN (6,8,9,12,20,21,25,26,28,40,42,50,52) -- this is currently just print
GROUP BY t.itembid, b.title, b.author
ORDER BY COUNT(t.item) DESC
FETCH FIRST 25 ROWS ONLY;

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