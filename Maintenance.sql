
-- Misc Utilities
SHOW DATABASES;
SHOW TABLES IN database;
SHOW COLUMNS IN table;
DESCRIBE table; 


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


-- ILL Titles have INTERLIBRARY_LOAN ==Y in BBIBMAP_V2, ITEM MEDIA / MEDIA_V2 MEDCODE value of 19 or 23

select title.BID, INTERLIBRARY_LOAN, title.TITLE,  MEDNAME
    from ITEM_V2 item
        inner join BBIBMAP_V2 title on item.bid = title.bid
        inner join MEDIA_V2 media on media.MEDNUMBER = item.MEDIA

    where
        --INTERLIBRARY_LOAN = 'Y'
      ( MEDIA = 19 OR MEDIA = 23)
;