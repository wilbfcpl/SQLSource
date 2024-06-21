--08/08/2023 Adult Graphic Call Number Change
select item.item,
       bib.bid,
       bib.CALLNUMBER "bib call",
       item.cn "olditem call",
        case
            when regexp_like(item.cn, '^FIC (.+)\s*-\s*GRAPHIC FORMAT\s*$')
                then regexp_replace(item.cn,'^FIC (.+)\s*-\s*GRAPHIC FORMAT\s*$','GRAPHIC FIC \1')
            else 'No Match. Default: '||item.cn end "newitem call",
       branch.BRANCHCODE,
       LOCATION.LOCCODE,
       title
-- trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    --inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.BRANCH=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where (
         regexp_like(bib.CALLNUMBER, '^FIC (.+)\s*-\s*GRAPHIC\s+FORMAT\s*$') or
         regexp_like(ITEM.CN, '^FIC (.+)\s*-\s*GRAPHIC\s+FORMAT\s*$')
    )
    group by
    item.item,
       bib.bid,
       bib.CALLNUMBER,
       item.cn,
        case
            when regexp_like(item.cn, '^FIC (.+)+\s*-\s*GRAPHIC\s+FORMAT\s*$')
                then regexp_replace(item.cn,'^FIC (.+)+\s*-\s*GRAPHIC\s+FORMAT\s*$','GRAPHIC FIC \1')
            else 'No Match. Default: '||item.cn end,
       branch.BRANCHCODE,
       LOCATION.LOCCODE,
       title
        order by bib.bid;

--10/04/2023 Adult Graphic Reverse
select item.item,
       bib.bid,
       bib.CALLNUMBER "bib call",
       item.cn "olditem call",
       branch.BRANCHCODE,
       LOCATION.LOCCODE,
       title
-- trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    --inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.BRANCH=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where (
         regexp_like(bib.CALLNUMBER, '^GRAPHIC FIC') or
         regexp_like(ITEM.CN, '^GRAPHIC FIC')
    )
    group by
    item.item,
       bib.bid,
       bib.CALLNUMBER,
       item.cn,
       branch.BRANCHCODE,
       LOCATION.LOCCODE,
       title
        order by bib.bid;

--10/04/23 Remnants of GRAPHIC FORMAT
select item.item,
       bib.bid,
       bib.CALLNUMBER "bib call",
       item.cn "olditem call",
       branch.BRANCHCODE,
       LOCATION.LOCCODE,
       title
-- trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    --inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.BRANCH=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where (
         regexp_like(bib.CALLNUMBER, '^.*GRAPHIC FORMAT$') or
         regexp_like(ITEM.CN, '^.*GRAPHIC FORMAT$')
    )
    group by
    item.item,
       bib.bid,
       bib.CALLNUMBER,
       item.cn,
       branch.BRANCHCODE,
       LOCATION.LOCCODE,
       title
        order by bib.bid;

-- eResource Volume information from 245b into 490a.
select distinct bib.bid,
       bib.CALLNUMBER,
title,
marc.TAGNUMBER,
tags.WORDDATA

from bbibmap_v2 bib
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid

where
    --bib.CALLNUMBER like 'OVERDRIVE%'
    --AND
     bib.ERESOURCE ='Y'
    --and
   -- marc.TAGNUMBER='092' and upper(tags.WORDDATA) like 'OVERDRIVE'
    and
    marc.tagnumber='245' and upper(tags.WORDDATA) like '%SERIES, BOOK%'
;

--Double series, book from Undo Macro script applied twice
select distinct bib.bid,
       bib.CALLNUMBER,
title,
marc.TAGNUMBER,
tags.TAGDATA,
tags.WORDDATA

from bbibmap_v2 bib
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid

where

     bib.ERESOURCE ='Y'

    and

    marc.TAGNUMBER='245' and regexp_like (upper(tags.WORDDATA) ,'SERIES, BOOK.+SERIESw')
;

select distinct count(bib.bid)

from bbibmap_v2 bib
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid

where
    --bib.CALLNUMBER like 'OVERDRIVE%'
    --AND
    upper(bib.ERESOURCE) ='Y'
    and
   -- marc.TAGNUMBER='092' and upper(tags.WORDDATA) like 'OVERDRIVE'
   -- and
    marc.tagnumber='245' and upper(tags.WORDDATA) like '%SERIES, BOOK%'
;

-- After modification
select distinct bib.bid,
       bib.CALLNUMBER,
title,
marc.TAGNUMBER,
tags.WORDDATA

from bbibmap_v2 bib
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid
    -- inner join btags_v2 tags2 on tags.tagid = marc.tagid
where
    --bib.CALLNUMBER like 'OVERDRIVE%'
    --AND
     bib.ERESOURCE ='Y'
    --and
   -- marc.TAGNUMBER='092' and upper(tags.WORDDATA) like 'OVERDRIVE'
    and
    (marc.tagnumber = '590' and upper(tags.WORDDATA) like '%SERIES, BOOK%'
    --OR
         --marc.tagnumber = '490' and regexp_like(upper(tags2.WORDDATA),'BOOK\s+[0-9]+\s*/$')
    )
;

select distinct count(bib.bid)



from bbibmap_v2 bib
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid
where
    --bib.CALLNUMBER like 'OVERDRIVE%'
    --AND
     bib.ERESOURCE ='Y'
    --and
   -- marc.TAGNUMBER='092' and upper(tags.WORDDATA) like 'OVERDRIVE'
    and
    marc.tagnumber = '590' and upper(tags.WORDDATA) like '%SERIES, BOOK%'


;

--ILL For Sam / Aftan
SELECT
    item_v2.item,
    --item_v2.status,
    systemitemcodes_v2.description,
    item_v2.statusdate,
    LOCATION_V2.LOCCODE,
    MEDIA_V2.MEDCODE,
    transitem_v2.patronid,
    BRANCH_V2.branchcode,
    transitem_v2.lastactiondate,
    patronnote.TEXT
   -- ITEMNOTETEXT_V2.TEXT AS ITEMNOTE

FROM item_v2
LEFT JOIN TRANSITEM_V2 ON ITEM_V2.ITEM = TRANSITEM_V2.ITEM
JOIN LOCATION_V2 ON ITEM_V2.LOCATION = LOCATION_V2.LOCNUMBER
JOIN BRANCH_V2 ON ITEM_V2.BRANCH = BRANCH_V2.BRANCHNUMBER
JOIN MEDIA_V2 ON ITEM_V2.MEDIA = MEDIA_V2.MEDNUMBER
LEFT JOIN SYSTEMITEMCODES_V2 ON ITEM_V2.STATUS = SYSTEMITEMCODES_V2.CODE
-- LEFT JOIN ITEMNOTETEXT_V2 ON ITEM_V2.ITEM = ITEMNOTETEXT_V2.REFID
LEFT JOIN PATRON_V2 patron on patron.PATRONID=TRANSITEM_V2.PATRONID
LEFT JOIN PATRONNOTETEXT_V2 patronnote on patronnote.REFID = patron.PATRONID
WHERE location_v2.loccode = 'ILL' and patronnote.alias='sv0'
;
