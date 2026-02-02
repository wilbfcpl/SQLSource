with bblogger as (select distinct biblog_v2.bid,
                                  systemcodevalues_v2.codedescription,
                                  bbibmap_v2.title,
                                  biblog_v2.actiontimestamp as actiontimestamp
                  from bbibmap_v2,
                       biblog_v2,
                       systemcodetypes_v2,
                       systemcodevalues_v2
                  where biblog_v2.actioncode = 11
                    and biblog_v2.bid = bbibmap_v2.bid
                    and biblog_v2.actioncode = systemcodevalues_v2.codetype
                    and systemcodetypes_v2.codetype = systemcodevalues_v2.codetype
                    and trunc(biblog_v2.actiontimestamp) > trunc(sysdate) - 30)

select bblogger.bid,
       bblogger.codedescription,
       bblogger.actiontimestamp
from bblogger
order by bblogger.actiontimestamp desc
;


-- 06/16/2025 Global Database Name lookup
select name from V$database;
 select * from global_name;

-- List ATT tower users who have opted in to receive SMS messages about holds available for pickup

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
-- PHONETYPE_V2.phonetypeid   in ('9','19','20','50','62')
 --   PHONETYPE_V2.phonetypeid = 0
  --AND --AT&T towers, 5,700 users
-- OR PHONETYPE_V2.phonetypeid   in ('14','34','55','57','51','61','21','63','66','58')  --TMobile towers, 6,600 users
-- OR PHONETYPE_V2.phonetypeid  in ('31','38','39','53','65')  --Verizon towers, 10,000 users
--PHONETYPE_V2.phonetypeid  in ('22','27','28','30','32','36','37','42','43','45','49','52','59','60','64') AND --MISC towers, 2,300 users
--PHONETYPE_V2.phonetypeid   in ('69') AND --TEST users
--PHONETYPE_V2.phonetypeid   in ('9') AND --AT&T only
--PHONETYPE_V2.phonetypeid not in ('0','1','67','47') AND --no SMS
 PATRON_V2.SENDHOLDAVAILABLEMSG = 'Y'
--AND NOT PATRON_V2.EMAILNOTICES IN '1'
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

-- List all bibs with Juneteenth in the 245 or 520 tags, but not in the 650 tag
with JuneteenthBids as ( select distinct bib.bid,
       bib.CALLNUMBER,
       bib.title,
marc.TAGNUMBER,
tags.tagdata,
tags.WORDDATA

from bbibmap_v2 bib
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid

where (marc.TAGNUMBER = '245'
           and upper(tags.WORDDATA) like '%JUNETEENTH%'
    OR
       marc.tagnumber = '520' and upper(tags.WORDDATA) like '%JUNETEENTH%'
          )
)
--create index indy on JuneteenthBids (bid);

select  bid,
        CALLNUMBER,
        title
from JuneteenthBids
where  bid not in

( select bid2.bid

   from JuneteenthBids bid2
   inner join bbibcontents_v2 marc on bid2.bid = marc.bid
   inner join btags_v2 tags on tags.tagid = marc.tagid
   inner join bbibmap_v2 bib on bid2.bid = bib.bid
    where marc.tagnumber = '650' and upper(tags.worddata) like '%JUNETEENTH%'

    )
;
create materialized view mv as select * from bbibcontents_v2;
create index indy on mv(bid);
 select distinct bib.bid,
       bib.CALLNUMBER,
       bib.title,
marc.TAGNUMBER,
tags.tagdata,
tags.WORDDATA

from bbibmap_v2 bib
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid

where (marc.TAGNUMBER = '245'
           and upper(tags.WORDDATA) like '%JUNETEENTH%'
    OR
       marc.tagnumber = '520' and upper(tags.WORDDATA) like '%JUNETEENTH%'
          )
);