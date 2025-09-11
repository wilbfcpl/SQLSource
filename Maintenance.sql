
-- Misc Utilities
-- SHOW DATABASES;
-- SHOW TABLES IN database;
-- SHOW COLUMNS IN table;
-- DESCRIBE table;


select distinct bib.bid, bib.BIBTYPE, bib.HIDDENTYPE ,  bib.ERESOURCE,bib.CALLNUMBER,
       bib.TITLE

from CARLREPORTS.BBIBMAP_V2 bib
inner join "ItemlessBids-06132023" list on bib.bid = list.BIDS
-- inner join BIBLOG_V2 log on bib.bid = log.bid

;
-- select * from "ItemlessBids-06132023";
--
-- --select distinct bib.bid, bib.BIBTYPE, bib.HIDDENTYPE ,  bib.ERESOURCE,bib.CALLNUMBER, bib.TITLE
-- select list.BIDS
--        --, bib.BIBTYPE, bib.CALLNUMBER,bib.ERESOURCE,bib.HIDDENTYPE,
--        -- bib.ACQTYPE,bib.SUPPRESSDATE,bib.SUPPRESSTYPE, bib.title
--
-- from "ItemlessBids-06132023" list
-- -- inner join  BBIBMAP_V2 bib on bib.bid = list.BIDS
-- --left outer join GMU_BIDS_06132023 gmu on list.BIDS=gmu.BID
--  -- join GMU_BIDS_06132023 gmu on gmu.bid = list.BIDS
-- where
--     BIDS not in (select bid from ILL_06132023 ILL)
-- and
-- BIDS not in (select bid from GMU_BIDS_06132023 gmu )
-- ;
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

--08/19/2025
select item, status, branch.BRANCHCODE, description, user, trunc(statusdate)
from item_v2
inner join BRANCH_V2 branch on branch.BRANCHNUMBER = item_v2.BRANCH
inner join SYSTEMITEMCODES_V2 codes on item_v2.status = codes.code
where status = 'L' and branch.BRANCHCODE = 'BKE'
and statusdate <= sysdate - 100
order by statusdate desc
;
--items not on shelf from a week ago
select item, status, branch.BRANCHCODE, description, trunc(statusdate)
from item_v2
inner join BRANCH_V2 branch on branch.BRANCHNUMBER = item_v2.BRANCH
inner join SYSTEMITEMCODES_V2 codes on item_v2.status = codes.code
where status = 'SX'
and statusdate <= sysdate - 28
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
select distinct student.patronid, student.name, student.userid, student.zip1,student.STATUS,trunc(ACTDATE) act,
                trunc(student.SACTDATE) sactdate,trunc(student.editdate) eddate,trunc(student.birthdate) dob,note.refid,note.NOTETYPE,
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
-- select student.patronid, note.noteid, note.notetype, note.alias, note.TIMESTAMP
--        ,note.text, patron_v2.NAME,
--        student.STATUS
--     from "12toPUBLIC_VerifyBirthdateNote_1" student
--     inner join PATRON_V2 on student.PATRONID = patron_v2.PATRONID
--    inner join PATRONNOTETEXT_V2 note on student.PATRONID=note.REFID
--
--      where
--                note.NOTETYPE=501
--               -- NOT regexp_like (upper(note.text),'WE WOULD LIKE.+BIRTHDATE.+$')
--     order by PATRONID ;

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

-- New Bookmobile Items Checked out with Old publishing Date
select Title.Bid, item.item ,branch.BRANCHCODE,title.TITLE,
       title.PUBLISHINGDATE, item.STATUS, loc.LOCCODE

From BBIBMAP_V2 title

inner join ITEM_V2 item on item.bid = title.BID
    inner join MEDIA_V2 media on media.MEDNUMBER = item.media
inner join BRANCH_V2 branch on branch.BRANCHNUMBER = item.OWNINGBRANCH
inner join branch_v2 branch2 on branch2.BRANCHNUMBER = item.BRANCH
inner join LOCATION_V2 loc on loc.LOCNUMBER = item.LOCATION

where (
    (branch.BRANCHCODE = 'BKE' and branch2.BRANCHCODE = 'BKE')
    OR
     (branch.BRANCHCODE = 'BKC' and branch2.BRANCHCODE = 'BKC')
    )
and status = 'C'
and title.PUBLISHINGDATE < '2023'
and loc.LOCCODE LIKE '%NEW' ;

;
-- Patrons setup to receive SMS Text Messages
select patron.PATRONID, EMAILNOTICES, status.DESCRIPTION,patron.PHONETYPEID1
from PATRON_V2 patron
inner join bst_v2 status on status.bst = patron.STATUS
where EMAILNOTICES=1 and PHONETYPEID1 > 1 and PHONETYPEID1 !=47

;
select count(patron.PATRONID)
from PATRON_V2 patron
inner join bst_v2 status on status.bst = patron.STATUS
where EMAILNOTICES=1 and PHONETYPEID1 > 1 and PHONETYPEID1 !=47

;
-- Staff Borrower Patrons setup to receive SMS Text Messages
select patron.PATRONID, patron.name,EMAILNOTICES, status.DESCRIPTION,patron.PHONETYPEID1
from PATRON_V2 patron
inner join bst_v2 status on status.bst = patron.STATUS
inner join BTY_V2 type on type.BTYNUMBER = patron.BTY
where EMAILNOTICES=1 and PHONETYPEID1 > 1 and PHONETYPEID1 !=47 and type.BTYCODE='STFBRW'

;

-- BIDs that do not have a 655. Use CTE
with sixfivers as (select bib.bid sfbid from BBIBMAP_V2 bib, BBIBCONTENTS_V2 contents,BTAGS_V2 tags
                                       where contents.bid = bib.bid and
                                             tags.tagid=contents.tagid and
                                             contents.tagnumber=655
                                       )

select distinct bib.bid, bib.TITLE
    from bbibmap_v2 bib
        inner join CARLREPORTS.BBIBCONTENTS_V2 contents on contents.bid=bib.bid
        inner join btags_v2 tags on tags.tagid=contents.TAGID
    left outer join sixfivers on bib.bid = sixfivers.sfbid
    where
        sfbid is null
      order by bib.bid;

select distinct bib.bid, bib.TITLE
    from bbibmap_v2 bib, CARLREPORTS.BBIBCONTENTS_V2 contents, CARLREPORTS.BTAGS_V2 tags
    where contents.bid = bib.bid and
        tags.TAGID = contents.TAGID and
        bib.bid  not in (select bib.bid sfbid from BBIBMAP_V2 bib, BBIBCONTENTS_V2 contents,BTAGS_V2 tags
                                       where contents.bid = bib.bid and
                                             tags.tagid=contents.tagid and
                                             contents.tagnumber=655
                                       )
      order by bib.bid
;
with sixfivers as (select bib.bid sfbid from BBIBMAP_V2 bib, BBIBCONTENTS_V2 contents,BTAGS_V2 tags
                                       where contents.bid = bib.bid and
                                             tags.tagid=contents.tagid and
                                             contents.tagnumber=655
                                       )

select distinct bib.bid, bib.TITLE
    from bbibmap_v2 bib
        inner join CARLREPORTS.BBIBCONTENTS_V2 contents on contents.bid=bib.bid
        inner join btags_v2 tags on tags.tagid=contents.TAGID
    left outer join sixfivers on bib.bid = sixfivers.sfbid
    where
       --contents.TAGNUMBER=650 and tags.TAGDATA like '%COMPUTER%' and
        sfbid is null
      order by bib.bid;


with sixfivers as (select bib.bid sfbid from BBIBMAP_V2 bib, BBIBCONTENTS_V2 contents,BTAGS_V2 tags
                                       where contents.bid = bib.bid and
                                             tags.tagid=contents.tagid and
                                             contents.tagnumber=655
                                       )
select distinct bib.bid, bib.TITLE
    from bbibmap_v2 bib
        inner join CARLREPORTS.BBIBCONTENTS_V2 contents on contents.bid=bib.bid
        inner join btags_v2 tags on tags.tagid=contents.TAGID
    left outer join sixfivers on bib.bid = sixfivers.sfbid
    where
    contents.TAGNUMBER=650 and upper(tags.TAGDATA) like '%COMPUTER%'
      and sfbid is null
      order by bib.bid;



-- Eresource with 655 Genre
select count(bib.BID)  from BBIBMAP_V2 bib, BBIBCONTENTS_V2 contents,
                            BBIBCONTENTS_V2 c2,BTAGS_V2 tags, BTAGS_V2 tags2
                                       where bib.ERESOURCE='Y' and
                                             (contents.bid = bib.bid )and
                                             (c2.bid = bib.bid ) and

                                         (    tags.tagid=contents.tagid and
                                         ( contents.tagnumber=655 and upper(tags.TAGDATA) like '%ELECTRONIC%' )
                                     and
                                         ( tags2.tagid=c2.tagid and
                                          c2.tagnumber=650 ))
                                       ;
select distinct bib.bid, bib.TITLE from BBIBMAP_V2 bib, BBIBCONTENTS_V2 contents,
                           BTAGS_V2 tags
                                       where bib.ERESOURCE='Y' and
                                             (contents.bid = bib.bid )and

                                         (    tags.tagid=contents.tagid and
                                         ( contents.tagnumber=655 and upper(tags.TAGDATA) like '%ELECTRONIC%' ))
                                       ;




-- Media type and code don't match

SELECT i.ITEM, med.medname,tags.WORDDATA
FROM item_v2 i
join MEDIA_V2 med on med.MEDNUMBER =i.MEDIA
JOIN BBIBMAP_V2 b ON i.bid = b.bid
join BBIBCONTENTS_V2 cont on cont.bid=b.BID
join btags_v2 tags on tags.TAGID = cont.TAGID
WHERE
( med.medcode = 'BKLP' and cont.TAGNUMBER=340
AND LOWER(tags.worddata) not LIKE '%large print%' ) OR
( med.medcode != 'BKLP' and cont.TAGNUMBER=340
AND LOWER(tags.worddata)  LIKE '%large print%' )


;
SELECT i.ITEM, med.medname,tags.WORDDATA
FROM item_v2 i
join MEDIA_V2 med on med.MEDNUMBER =i.MEDIA
JOIN BBIBMAP_V2 b ON i.bid = b.bid
join BBIBCONTENTS_V2 cont on cont.bid=b.BID
join btags_v2 tags on tags.TAGID = cont.TAGID
WHERE med.medcode != 'BKLP' and cont.TAGNUMBER=340
AND LOWER(tags.worddata)  LIKE '%large print%'
;
SELECT i.ITEM, med.medname,tags.WORDDATA
FROM item_v2 i
join MEDIA_V2 med on med.MEDNUMBER =i.MEDIA
JOIN BBIBMAP_V2 b ON i.bid = b.bid
join BBIBCONTENTS_V2 cont on cont.bid=b.BID
join btags_v2 tags on tags.TAGID = cont.TAGID
WHERE med.medcode != 'BKLP' and cont.TAGNUMBER=340
AND LOWER(tags.worddata)  LIKE '%large print%'
;
SELECT i.ITEM, med.medname,tags.WORDDATA,tags.TAGDATA
FROM item_v2 i
join MEDIA_V2 med on med.MEDNUMBER =i.MEDIA
JOIN BBIBMAP_V2 b ON i.bid = b.bid
join BBIBCONTENTS_V2 cont on cont.bid=b.BID
join btags_v2 tags on tags.TAGID = cont.TAGID
WHERE
   med.medcode != 'BKLP' and
  cont.TAGNUMBER=8
  and substr(tags.worddata,23,1)='d'
;

SELECT i.ITEM, med.medname,tags.WORDDATA,tags.TAGDATA
FROM item_v2 i
join MEDIA_V2 med on med.MEDNUMBER =i.MEDIA
JOIN BBIBMAP_V2 b ON i.bid = b.bid
join BBIBCONTENTS_V2 cont on cont.bid=b.BID
join btags_v2 tags on tags.TAGID = cont.TAGID
WHERE
 med.medcode != 'BKLP' and ((cont.TAGNUMBER = 0 and substr(tags.worddata, 7, 2) = 'am')
    OR
                            (cont.TAGNUMBER = 8 and substr(tags.worddata, 23, 1) = 'd')
    )
;

-- Customers without contact information Soft Block and Note similar to FCPS Grads
select patron.patronid, patron.FIRSTNAME, patron.MIDDLENAME, patron.LASTNAME, 'Placeholder' place,
     patron.street1, patron.CITY1, patron.STATE1,patron.ZIP1,patron.STATUS,email,email2,ph1,ph2,
       trunc(regdate),trunc(editdate), trunc(actdate)
      from patron_v2 patron
     inner join bty_v2 type on patron.bty = type.BTYNUMBER
     inner join branch_v2 branch on patron.REGBRANCH = branch.BRANCHNUMBER
    -- inner join UDFPATRON_V2 udf on patron.patronid=udf.patronid
    -- where btycode = 'STUDNT' and branchcode ='SSL' and status='S' and udf.FIELDID='3' and notes is null
    where
        -- (status='S' and udf.FIELDID='3') and
       (status='G' and btycode != 'STUDNT' and branchcode !='SSL' ) and
        ( patron.email is null and patron.EMAIL2 is null ) and
        ( patron.ph1 is null and patron.ph2 is null) and
        -- Don't repeat the note again
        notes is null



     order by patron.editdate desc


-- CarlX Ad-Hoc Query group
select CLAIMEDNEVERHADATBRANCH from CXDAT.TRANSITEM ;
select INSTNAME from CXDAT.INSTITUTION ;
select ITEM from CXDAT.ITEM  ;

-- Feb 2025  Patron email notices
select sample.id,name, email, patron.emailnotices from
carlreports.nosendemail031225 sample, carlreports.PATRON_V2 patron
where sample.id = patron.patronid order by sample.id;

-- Fun and Games with CTE with select
with logstuff as ( select
    b.branchcode, l.locname,  m.medname, tx.itemstatusbefore, tx.itemstatusafter
from txlog_v2 tx
join branch_v2 b on tx.envbranch = b.branchnumber
join location_v2 l on tx.itemlocation = l.locnumber
join media_v2 m on tx.itemmedia = m.mednumber

where (tx.systemtimestamp >= sysdate - 90)
and tx.transactiontype = 'CH'
and b.branchcode = 'EMM'
and tx.patronbty not in ('3','6') --not staff-specific
--and tx.itemstatusbefore in ('H', 'S')
--and tx.itemstatusafter = 'C'
group by b.branchcode, l.locname, m.medname, tx.itemstatusbefore, tx.itemstatusafter
order by b.branchcode, l.locname, m.medname
)
select * from logstuff;


select * from phonetype_v2_2 where obsolete = '1' ;
delete * from phonetype_v2_2 where obsolete = '1' ;


select address, description from phonetype_v2_2 where obsolete !='1' and address is not null
from phonetype_v2_2 ;

select
    case when address is not null then '@e2s.messagemedia.com'
    else address end as address,
     'Sinch was ' || description || ' ' || address as description
   from phonetype_v2_2
    where obsolete !='1' and address is not null;

update PHONETYPE_V2_2
set
    description = 'Sinch. Was ' || description
-- address = '@e2s.messagemedia.com'
where obsolete !='1' and address is not null;

update PHONETYPE_BACKUP
set
    description = 'Sinch-was ' || address
    --address = '@e2s.messagemedia.com'
where obsolete !='1' and address is not null;

select * from phonetype_backup
where obsolete=0 AND address is NOT NULL AND
    regexp_instr(description, '^.+ +@e2s\.messagemedia\.com.*$') !=0 ;


update phonetype_backup
set
    description = replace(description, ' @e2s.messagemedia.com','')
where obsolete !='1' and address is not null;

COMMIT;


where address is not null and obsolete != '1' ;

create table phonetype_backup as (select * from phonetype_v2) ;

--03/14/2025 Fines and Fees WLB

-- Students blocked with Fine
    select  student.patronid Barcode, student.NAME,
           f.ITEMID ITEM,
          to_char(TO_DATE(f.CREATIONDATE),'DD-MM-YYYY') finedate,
       --   trunc(current_date),
           (f.AMOUNT / 100) amount,
           f.PAYMENTCODE,
              f.PAYMENTMETHOD,
           BRANCHCODE,
           f.TERMINAL

    from PATRON_V2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER
    JOIN PATRONFISCAL_V2 F ON student.PATRONID = F.PATRONID
    inner join branch_v2 branch on f.branch =branch.BRANCHNUMBER
    where
    BTYCODE = 'STUDNT' and
    student.status ='X' and
    F.TRANSCODE = 'FS'
   -- and F.PAYMENTCODE is NULL
    --and to_date(f.CREATIONDATE) = '20-NOV-2024'

ORDER by to_date(f.CREATIONDATE) DESC
    ;

-- 03/14/25 Original Fines Query from Aftan
--toward field order for input to the API script sscSettleFinesandFees.pl with the #177 hashoneseven as the itemid

SELECT
      P.PATRONID,
F.ITEMID hash177,
   (F.AMOUNT) /100 "FINEAMOUNT",
     trunc(F.TRANSDATE) as "FINEDATE",
  F.NOTES AS Item,
  P.NAME,
  p.status,
  t.btycode,
   trunc(p.editdate) as "EDITDATE",
  trunc(p.actdate) as "ACTDATE"
FROM PATRON_V2 P
JOIN PATRONFISCAL_V2 F ON P.PATRONID = F.PATRONID
LEFT JOIN PATRONFISCAL_V2 F2 ON F2.ITEMID = F.ITEMID and F2.PAYMENTCODE in ('C','P','W')
JOIN BTY_V2 T ON P.BTY=T.BTYNUMBER
LEFT JOIN BRANCH_V2 B ON P.DEFAULTBRANCH=B.BRANCHNUMBER
WHERE
F.TRANSCODE = 'FS' --manual fine
AND F.ITEMID LIKE '#177%'
AND F2.ITEMID IS NULL
AND F.NOTES  LIKE '_198%'
AND (F.AMOUNT/100) = '4'
--AND F.TRANSDATE < '31-JAN-23'
AND F.TRANSDATE < '31-MAR-25'
ORDER BY P.NAME, F.ITEMID;

SELECT
 count(*) as count
FROM PATRON_V2 P
JOIN PATRONFISCAL_V2 F ON P.PATRONID = F.PATRONID
LEFT JOIN PATRONFISCAL_V2 F2 ON F2.ITEMID = F.ITEMID and F2.PAYMENTCODE in ('C','P','W')
JOIN BTY_V2 T ON P.BTY=T.BTYNUMBER
LEFT JOIN BRANCH_V2 B ON P.DEFAULTBRANCH=B.BRANCHNUMBER
WHERE
F.TRANSCODE = 'FS' --manual fine
AND F.ITEMID LIKE '#177%'
AND F2.ITEMID IS NULL
AND F.NOTES  LIKE '_198%'
AND (F.AMOUNT/100) = '4'
AND F.TRANSDATE < '31-JAN-23'
--AND F.TRANSDATE < '01-MAR-25'
ORDER BY P.NAME, F.ITEMID;

-- 03/16/2025 Fines and Fees WLB toward field order for input to the API script sscSettleFinesandFees.pl

select f.patronid, f.alias, trunc(f.creationdate) as waive_date, f.paymentcode, f.itemid, f.notes, f.amount,
       f.transcode, f.processed, f.fiscaltype, trunc(f.transdate) as transdate, trunc(f.duedate) as duedate
FROM PATRON_V2 P
JOIN PATRONFISCAL_V2 F ON P.PATRONID = F.PATRONID
LEFT JOIN PATRONFISCAL_V2 F2 ON F2.ITEMID = F.ITEMID
JOIN BTY_V2 T ON P.BTY=T.BTYNUMBER
LEFT JOIN BRANCH_V2 B ON P.DEFAULTBRANCH=B.BRANCHNUMBER
join location_v2 L on F.location=l.locnumber

where
   upper(f.notes) like 'WAIVED%'
;
-- Counting
select count(f.creationdate)
FROM PATRON_V2 P
JOIN PATRONFISCAL_V2 F ON P.PATRONID = F.PATRONID
LEFT JOIN PATRONFISCAL_V2 F2 ON F2.ITEMID = F.ITEMID
JOIN BTY_V2 T ON P.BTY=T.BTYNUMBER
LEFT JOIN BRANCH_V2 B ON P.DEFAULTBRANCH=B.BRANCHNUMBER
join location_v2 L on F.location=l.locnumber

where
   upper(f.notes) like 'WAIVED%';


-- 03/27/2025 for Newbery Honors AI Prompt Pub Date 2024
select   bib.bid,bib.publishingdate, bib.isbn, bib.author,
                 bib.TITLE,bib.CALLNUMBER, format.formattext
from BBIBMAP_V2 bib

--inner join BBIBCONTENTS_V2 bc on bib.bid = bc.bid
--inner join btags_v2 tags on bc.tagid = tags.TAGID
inner join formatterm_v2 format on format.FORMATtermid = bib.FORMAT
--inner join btags_v2 tags2 on (tags2.WORDDATA = tags.worddata) and (tags.tagid != tags2.tagid)
where (

        (bib.publishingdate like '%2024%' or bib.publishingdate like '%2025%' or bib.publishingdate like '%2023%')
       -- or

        --(bc.tagnumber = 260
        --  and (tags.tagdata like '%2024%' or tags.tagdata like '%2023%' or tags.tagdata like '%2025%'))

    )

and bib.eresource != 'Y'
  -- Acqtype 0 book in house
  and acqtype = 0

     and  ( upper(formattext) like '%BOOK%' or upper(formattext) like '%PRINT%')

;
-- Streamlined version
select   bid,publishingdate, isbn, author,
                 TITLE,CALLNUMBER, formattext
from BBIBMAP_V2 bib
inner join formatterm_v2 format on format.FORMATtermid = bib.FORMAT
where
        (publishingdate like '%2024%' or publishingdate like '%2025%'
or publishingdate like '%2023%')

and  eresource != 'Y'
  -- Acqtype 0 book in house
  and acqtype = 0
  and  ( upper(formattext) like '%BOOK%' or upper(formattext) like '%PRINT%')
;

-- 03/28/2025 Delete Notes
select distinct note.noteid,note.refid, patron.name, branchcode, patron.STATUS,
                trunc(patron.ACTDATE),trunc(patron.editdate),note.NOTETYPE,
       note.text
    from patron_v2 patron

inner join PATRONNOTETEXT_V2 note on patron.PATRONID=note.REFID
inner join bty_v2 on patron.bty = bty_v2.BTYNUMBER
--inner join udfpatron_v2 udf on patron.patronid=udf.patronid
inner join branch_v2 branch on patron.preferred_branch = branch.BRANCHNUMBER

     where
                note.NOTETYPE=501
              -- NOT regexp_like (upper(note.text),'WE WOULD LIKE.+BIRTHDATE.+$')
    order by note.noteid ;

-- 05/22/2025 Delete Patron Notes using CarlXAPI DeleteNoteMCE
--https://github.com/wilbfcpl/CarlXAPIUtils-PerlSrc/blob/master/DeleteNoteMCE.pl
-- Uses NotesDelete, a local table of NoteIDs imported from an Excel file
select notes.noteid,notes.patronid,notes.notetype, notes."DateA",notes.alias
--       patron.name
from hnotestodelete052225 notes , patron_v2 patron, patronnotetext_v2 text
where notes.patronid = patron.patronid and notes.noteid = text.noteid
;

--FCPS Notes 04/29/2025
select todelete.noteid,todelete.patronid , notes.text from  sscnotestodelete043025 todelete
inner join patron_v2 patron on todelete.patronid = patron.patronid
--inner join patronnotetext_v2 notes on notes.refid = todelete.patronid
inner join patronnotetext_v2 notes on notes.noteid = todelete.noteid

;


-- DigitalMaryland Import via MarcEdit
select bid, userid, recordtype, callnumber, formattext,
    trunc(biblatestchange ) titlechange,trunc(itemslatestchange) itemchange,
    title from BBIBMAP_V2 bib,formatterm_v2 formatterm
where
--trunc(biblatestchange) like '2025-04%' and
    formatterm.formattermid = bib.format and
userid='wb0'

;
-- 06/16/2025 Global Database Name lookup for Oracle Autonomous Database loading/linking
select name from V$database;
 select * from global_name;

-- 06/16/2025 SendHoldAvailableMsg

-- List ATT tower users who have opted in to receive SMS messages about holds available for pickup

SELECT
  PATRON_V2.PATRONID,
  PATRON_V2.NAME,
  BRANCH_V2.BRANCHCODE,
  PATRON_V2.SENDHOLDAVAILABLEMSG,
  PATRON_V2.EMAILNOTICES,
  PHONETYPE_V2.address,
  PHONETYPE_V2.phonetypeid,
  PHONETYPE_V2.description

FROM  ATTUSERS073125 att inner join PATRON_V2 on PATRON_V2.PATRONID = att.patronid
INNER JOIN PHONETYPE_V2
ON  PATRON_V2.PHONETYPEID1 = PHONETYPE_V2.PHONETYPEID
INNER JOIN BRANCH_V2 ON PATRON_V2.DEFAULTBRANCH = BRANCH_V2.BRANCHNUMBER

WHERE
--PHONETYPE_V2.phonetypeid   in ('9','19','20','50','62')
(
    -- ( (PHONETYPE_V2.address LIKE '%att%') OR (PHONETYPE_V2.address LIKE '%cricket%')) AND
     (PATRON_V2.SENDHOLDAVAILABLEMSG = 'Y')
    )
ORDER BY PATRON_V2.NAME, BRANCH_V2.BRANCHCODE ;

-- Test SendHoldAvailableMsg . Test Server will have PHONETYPEID value 0

SELECT
  PATRON_V2.PATRONID,
  PATRON_V2.NAME,
  BRANCH_V2.BRANCHCODE,
  PHONETYPE_V2.phonetypeid,
  PHONETYPE_V2.address,
  PATRON_V2.SENDHOLDAVAILABLEMSG,
  PATRON_V2.EMAILNOTICES

FROM  PATRON_V2 join AT_T_USERS_250616_HEADER att on PATRON_V2.PATRONID = att.patronid
JOIN PHONETYPE_V2
ON  PATRON_V2.PHONETYPEID1 = PHONETYPE_V2.PHONETYPEID
LEFT JOIN BRANCH_V2
ON PATRON_V2.DEFAULTBRANCH = BRANCH_V2.BRANCHNUMBER

/*WHERE
--PHONETYPE_V2.phonetypeid   in ('9','19','20','50','62')
(
     ( (PHONETYPE_V2.address LIKE '%att%') OR (PHONETYPE_V2.address LIKE '%cricket%'))
    AND (PATRON_V2.SENDHOLDAVAILABLEMSG = 'N')
    )*/
ORDER BY PHONETYPE_V2.phonetypeid, BRANCH_V2.BRANCHCODE, PATRON_V2.NAME;

-- Test SendHoldAvailableMsg . Test Server will have PHONETYPEID value 0

SELECT
  PATRON_V2.PATRONID,
  PATRON_V2.NAME,
  BRANCH_V2.BRANCHCODE,
  PHONETYPE_V2.phonetypeid,
  PHONETYPE_V2.address,
  PATRON_V2.SENDHOLDAVAILABLEMSG,
  PATRON_V2.EMAILNOTICES

FROM  PATRON_V2
JOIN PHONETYPE_V2
ON  PATRON_V2.PHONETYPEID1 = PHONETYPE_V2.PHONETYPEID
LEFT JOIN BRANCH_V2
ON PATRON_V2.DEFAULTBRANCH = BRANCH_V2.BRANCHNUMBER

WHERE
--PHONETYPE_V2.phonetypeid   in ('9','19','20','50','62')

      (PHONETYPE_V2.address LIKE '%att%')
--AND (PATRON_V2.SENDHOLDAVAILABLEMSG = 'N')

ORDER BY PHONETYPE_V2.phonetypeid, BRANCH_V2.BRANCHCODE, PATRON_V2.NAME;



-- Aftan's test accounts
SELECT
  PATRON_V2.PATRONID,
  PATRON_V2.NAME,
  BRANCH_V2.BRANCHCODE,
  PHONETYPE_V2.phonetypeid,
  PATRON_V2.SENDHOLDAVAILABLEMSG
,  PATRON_V2.EMAILNOTICES

FROM  PATRON_V2
JOIN PHONETYPE_V2
ON  PATRON_V2.PHONETYPEID1 = PHONETYPE_V2.PHONETYPEID
LEFT JOIN BRANCH_V2
ON PATRON_V2.DEFAULTBRANCH = BRANCH_V2.BRANCHNUMBER
WHERE

PATRONID in ('511729','11982022263822','11982022322016','11982011126329')

ORDER BY PHONETYPE_V2.phonetypeid, BRANCH_V2.BRANCHCODE, PATRON_V2.NAME;




-- 09/05/2025 after the test server changes
select patron.patronid,patron.status,
       case patron.emailnotices when 0 then 'No Email Notices'
                         when 1 then 'Email Notices'
                         when 2 then 'bounced email'
                         when 3 then 'opt out'
                         else 'Unknown' end as emailnotices,
    note.text notetext,
       patron.email,
       bty.btycode, patron.name from bounceaccounts bounce
           inner join patron_v2 patron on patron.patronid = bounce.patronid
       inner join bty_v2 bty on (patron.bty = bty.btynumber)
       inner join PATRONNOTETEXT_V2 note on patron.PATRONID=note.REFID

     where
               note.NOTETYPE=900
;


select distinct patron.patronid, upper(patron.email),
       case emailnotices when 0 then 'No Email Notices'
                         when 1 then 'Email Notices'
                         when 2 then 'bounced email'
                         when 3 then 'opt out'
                         else 'Unknown' end as emailnotices,
       bty.btycode, birthdate, name from patron_v2 patron
     inner join bty_v2 bty on (patron.bty = bty.btynumber)
     where substr(upper(patron.email),1, 10) in (select  substr(upper(bounce.email),1,10) from ppbounced bounce) ;


-- Multibyte Characters in Patron Names
select p.patronid,substrb(p.name,1), b.btycode, p.patronguid,p.status,trunc(p.birthdate),
  trunc(p.regdate) AS Register,   trunc(p.actdate) AS Active,
  trunc(p.sactdate) AS SelfServe,   trunc(p.editdate) AS Edit
from patron_v2 p
inner join bty_v2 b on p.bty =b.btynumber
where
       length(p.name)<lengthb(p.name)
-- exclude ILL (3) and LIBUSE (6)
  -- and p.bty not in (3,6)
 -- and (trunc(p.regdate) >= trunc(sysdate-1096)
 --   or trunc(p.actdate) >= trunc(sysdate-1096)
 --   or trunc(p.editdate) >= trunc(sysdate-1096)
 --   or trunc(p.sactdate) >= trunc(sysdate-1096))
;

-- PP email bounces exact match on PatronID
select distinct patron.patronid, upper(patron.email),upper(bounce.email) as bounceemail,
       case emailnotices when 0 then 'No Email Notices'
                         when 1 then 'Email Notices'
                         when 2 then 'bounced email'
                         when 3 then 'opt out'
                         else 'Unknown' end as emailnotices,
       bty.btycode, name from patron_v2 patron
inner join bty_v2 bty on (patron.bty = bty.btynumber)
inner join ppbcomm bounce
    on patron.patronid = bounce."Patron ID (Barcode)"  ;

select * from patron_v2 pat where pat.email is not null;

-- PP email bounces
select patronid, upper(email),
       case emailnotices when 0 then 'No Email Notices'
                         when 1 then 'Email Notices'
                         when 2 then 'bounced email'
                         when 3 then 'opt out'
                         else 'Unknown' end as emailnotices,
       bty.btycode, name from patron_v2 patron
inner join bty_v2 bty on (patron.bty = bty.btynumber)
where email is not null ;



-- Bounced , also PatronID not in FCPL CarlX

select distinct patron.patronid, bounce."Patron ID (Barcode)" bounceid, bounce."DNC Comment",upper(patron.email),upper(bounce.email) as bounceemail,
       case emailnotices when 0 then 'No Email Notices'
                         when 1 then 'Email Notices'
                         when 2 then 'bounced email'
                         when 3 then 'opt out'
                         else 'Unknown' end as emailnotices,
       bty.btycode, name from patron_v2 patron
inner join bty_v2 bty on (patron.bty = bty.btynumber)

right outer join ppbcomm bounce
on   upper(patron.email) = upper(bounce.email)

where patron.emailnotices=1 or patron.patronid is null order by patron.patronid;

-- UTL_MATCH.EDIT_DISTANCE_SIMILARITY

select distinct patron.patronid, bounce."Patron ID (Barcode)" bounceid, bounce."DNC Comment",upper(patron.email),upper(bounce.email) as bounceemail,
       case emailnotices when 0 then 'No Email Notices'
                         when 1 then 'Email Notices'
                         when 2 then 'bounced email'
                         when 3 then 'opt out'
                         else 'Unknown' end as emailnotices,
       bty.btycode, name from ppbcomm bounce

left outer join patron_v2 patron
inner join bty_v2 bty on (patron.bty = bty.btynumber)
on   utl_match.edit_distance_similarity(upper(patron.email), upper(bounce.email)) > 80

where patron.emailnotices=1 or patron.patronid is null order by patron.patronid;



select distinct patron.patronid,bounce."Patron ID (Barcode)" bouncepatron, bounce."DNC Comment",upper(patron.email),upper(bounce.email) as bounceemail,
       case emailnotices when 0 then 'No Email Notices'
                         when 1 then 'Email Notices'
                         when 2 then 'bounced email'
                         when 3 then 'opt out'
                         else 'Unknown' end as emailnotices,
       bty.btycode, name from patron_v2 patron
inner join bty_v2 bty on (patron.bty = bty.btynumber)

right outer join ppbcomm bounce
--    on substr(upper(patron.email),1, 10) = substr(upper(bounce.email),1,10)
 on (
     (instr(upper(patron.email), upper(bounce.email)) != 0)
     OR
     (instr(upper(bounce.email), upper(patron.email)) != 0)
     )

    where ( ( patron.emailnotices=1)  OR patron.patronid is null) ;
     ;

-- No exact email or patronid match. Common Table Expression (CTE) Version runs faster to find similar emails
with patron as (
    select distinct patron.patronid, patron.email , patron.name,  status.description, bty.btycode
    from patron_v2 patron
        inner join bty_v2 bty on (patron.bty = bty.btynumber)
        inner join bst_v2 status on patron.status = status.bst
    where patron.emailnotices=1 and patron.actdate >=CURRENT_DATE-120 and (patron.status!='M' and patron.status!='X')
)
select patron.patronid, nested.bouncepatron, upper(patron.email), upper(nested.email) as bounceemail,
       patron.btycode, patron.name, upper(nested.bouncename) from patron,
                              ( select distinct bounce.email , bounce."Patron ID (Barcode)" bouncepatron,
                               bounce."Last Name" || ' ' || bounce."First Name" bouncename from ppbcomm bounce where bounce."DNC Comment" like '%user unknown') nested
 where (
           (nested.bouncepatron != patron.patronid) and (nested.email != patron.email) and
           (utl_match.edit_distance_similarity(upper(nested.email), upper(patron.email)) > 95)
           )
   order by patron.patronid ;


order by patron.patronid ;

-- subquery version instead of join
    select distinct patron.patronid, nested.bouncepatron, upper(patron.email), upper(nested.email) as bounceemail, nested."DNC Comment",
       case emailnotices when 0 then 'No Email Notices'
                         when 1 then 'Email Notices'
                         when 2 then 'bounced email'
                         when 3 then 'opt out'
                         else 'Unknown' end as emailnotices,
       bty.btycode, name from patron_v2 patron, bty_v2 bty,
                              (select bounce.email , bounce."Patron ID (Barcode)" bouncepatron, bounce."DNC Comment",
                                      bounce."First Name" || bounce."Last Name" bouncename from ppbcomm bounce) nested

 where (
        ((patron.bty = bty.btynumber) and  (patron.email=nested.email)  and (patron.emailnotices=1 ))
        OR
        ( (patron.bty = bty.btynumber) and  (patron.patronid is null) )
       )
  order by patron.patronid ;

--  subquery Typical case emails or patronids match
 select distinct patron.patronid, nested.bouncepatron, upper(patron.email), upper(nested.email) as bounceemail, nested.reason,

       bty.btycode, name, upper(nested.bouncename) from patron_v2 patron, bty_v2 bty,
                              (select bounce.email , bounce."Patron ID (Barcode)" bouncepatron, bounce."DNC Comment" reason,
                               bounce."Last Name" || ' ' || bounce."First Name" bouncename from ppbcomm bounce) nested
 where (
           (patron.bty = bty.btynumber) and (patron.emailnotices = 1) and
           (
               (nested.bouncepatron = patron.patronid)
                   OR (nested.email = patron.email)
               )
           )
  order by patron.patronid ;

-- Separate the slower case when the email and patronid don't exactly match
 select distinct patron.patronid, nested.bouncepatron, upper(patron.email), upper(nested.email) as bounceemail, nested.reason,

       bty.btycode, name, upper(nested.bouncename) from patron_v2 patron, bty_v2 bty,
                              (select bounce.email , bounce."Patron ID (Barcode)" bouncepatron, bounce."DNC Comment" reason,
                               bounce."Last Name" || ' ' || bounce."First Name" bouncename from ppbcomm bounce) nested
 where (
           (patron.bty = bty.btynumber) and (patron.emailnotices = 1) and
           (
                    (nested.bouncepatron != patron.patronid) and (nested.email != patron.email) and
                    (utl_match.edit_distance_similarity(upper(nested.email), upper(patron.email)) > 95)
               )
           )
   order by patron.patronid ;


-- No email address match hinted by Null PatronID.
select distinct bounce."Patron ID (Barcode)" bounceid, bounce."DNC Comment",
                upper(bounce.email) as bounceemail,
      bounce."Last Name" || ' ' || bounce."First Name" bouncename from patron_v2 patron

right outer join ppbcomm bounce
on   (
       upper(patron.email) = upper(bounce.email) or
       patron.patronid=bounce."Patron ID (Barcode)"
     )

where patron.patronid is null order by bounceid;

-- CTE version No email address match hinted by Null PatronID
with patron as (
    select patron.patronid, patron.email , patron.name
    from patron_v2 patron
    where patron.emailnotices=1 and patron.sactdate >=CURRENT_DATE-365
)
select distinct bounce.email,bounce."Patron ID (Barcode)" bouncepatron, bounce."DNC Comment" reason,
                               bounce."Last Name" || ' ' || bounce."First Name" bouncename
from ppbcomm bounce
left outer join patron on (bounce."Patron ID (Barcode)" = patron.patronid) OR (bounce.email = patron.email)
where patron.patronid is null
order by bouncepatron ;



