-- Collections Projects April 2023
--MARC Leader encoding level


-- Need Level 1 encoding
select bc.bid, bib.CALLNUMBER, substr(bt.tagdata,18,1) ENCODING_LEVEL,
case
                     when (
                                regexp_like(bib.CALLNUMBER, '^\s*(\w+s+)*LP\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*PERIODICAL\s*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[EJ]\s*RA\s+.*$')
                            )
                         then '1'
                    else substr(bt.tagdata,18,1)
end "new level",
bt.TAGDATA LEADER
from bbibcontents_v2 bc
    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
   inner join btags_v2 bt on bc.tagid=bt.tagid
where bc.tagnumber=0 and bib.ACQTYPE=0 and (
        regexp_like(bib.CALLNUMBER, '^\s*(\w+s+)*LP\s+.+$') OR
        regexp_like(bib.CALLNUMBER, '^\s*PERIODICAL\s*$') OR
        regexp_like(bib.CALLNUMBER,'^\s*[EJ]\s*RA\s+.*$')
    )
and n92.bid is null
and substr(bt.tagdata,18,1)!='1'
order by bib.bid, bib.CALLNUMBER;

--Have Level 1 Encoding
-- Outer Join with NO092 excludes BIDS without an 092 Call Number.
select bc.bid, bib.CALLNUMBER, bt.WORDDATA oldleader
--     substr(bt.tagdata,18,1) ENCODING_LEVEL,
--     bt.TAGDATA "LEADER"
from bbibcontents_v2 bc
    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid
-- where bc.tagnumber=0 and bib.ACQTYPE=0 and
where (
        regexp_like(bib.CALLNUMBER, '^\s*(\w+s+)*LP\s+.+$') OR
        regexp_like(bib.CALLNUMBER, '^\s*PERIODICAL\s*$') OR
        regexp_like(bib.CALLNUMBER,'^\s*[EJ]\s*RA\s+.*$')
     )
 and  bc.tagnumber=590
 and bib.ACQTYPE = 0
 and n92.bid is null
 and substr(bt.WORDDATA,18,1)!='1'
order by bib.bid, bib.CALLNUMBER ;

-- Need Level 2 encoding
select bc.bid, bib.CALLNUMBER, substr(bt.tagdata,18,1) ENCODING_LEVEL,
        case
            when (
                                regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*BOOK.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*E\s+MAGAZINE.*$')
                            )
                        then '2'
            else
            substr(bt.tagdata,18,1)
            end "new level",
        bt.TAGDATA LEADER

from bbibcontents_v2 bc
    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
   inner join btags_v2 bt on bc.tagid=bt.tagid
    where bc.tagnumber=0 and bib.ACQTYPE=0 and (
        regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*BOOK.*$') OR
        regexp_like(bib.CALLNUMBER, '^\s*E\s+MAGAZINE.*$')
    )
and n92.bid is null
  and substr(bt.tagdata,18,1)!='2'
order by bib.bid, bib.CALLNUMBER ;

--Have Level 2 Encoding
-- Outer Join with NO092 excludes BIDS without an 092 Call Number.
select bc.bid, bib.CALLNUMBER, bt.WORDDATA oldleader
--     substr(bt.tagdata,18,1) ENCODING_LEVEL,
--     bt.TAGDATA "LEADER"
from bbibcontents_v2 bc

    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid
-- where bc.tagnumber=0 and bib.ACQTYPE=0 and
where (
    regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*BOOK.*$') OR
        regexp_like(bib.CALLNUMBER, '^\s*E\s+MAGAZINE.*$')
     )
 and  bc.tagnumber=590
 and bib.ACQTYPE = 0
 and n92.bid is null
 and substr(bt.WORDDATA,18,1)!='2'
order by bib.bid, bib.CALLNUMBER ;

-- Need Level 3 encoding
select bc.bid, bib.CALLNUMBER,  substr(bt.tagdata,18,1) ENCODING_LEVEL,
       case
           when
            (
              regexp_like(bib.CALLNUMBER, '^\s*BOARD\s+.+$') OR
              regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*AUDIO.*$')
                  )
          then '3'
        else substr(bt.TAGDATA,18,1)
       end "New level",
    bt.TAGDATA "LEADER"
from bbibcontents_v2 bc
    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
   inner join btags_v2 bt on bc.tagid=bt.tagid
  where bc.tagnumber=0 and bib.ACQTYPE=0 and (
        regexp_like(bib.CALLNUMBER, '^\s*BOARD\s+.+$') OR
        regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*AUDIO.*$')

    )
and substr(bt.tagdata,18,1)!='3'
and n92.bid is null
order by bib.bid, bib.CALLNUMBER;

-- Have Level 3 encoding
-- Outer Join with NO092 excludes BIDS without an 092 Call Number.
select bc.bid, bib.CALLNUMBER, bt.WORDDATA oldleader
--     substr(bt.tagdata,18,1) ENCODING_LEVEL,
--     bt.TAGDATA "LEADER"
from bbibcontents_v2 bc
    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid
-- where bc.tagnumber=0 and bib.ACQTYPE=0 and
where (
        regexp_like(bib.CALLNUMBER, '^\s*BOARD\s+.+$') OR
        regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*AUDIO.*$')
     )
 and  bc.tagnumber=590
 and bib.ACQTYPE = 0
 and n92.bid is null
 and substr(bt.WORDDATA,18,1)!='3'
order by bib.bid, bib.CALLNUMBER ;

-- Have Level 3 encoding but worng 590a
-- Outer Join with NO092 excludes BIDS without an 092 Call Number.
select bc.bid, bib.CALLNUMBER, bt.WORDDATA oldleader
--     substr(bt.tagdata,18,1) ENCODING_LEVEL,
--     bt.TAGDATA "LEADER"
from bbibcontents_v2 bc
    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid
-- where bc.tagnumber=0 and bib.ACQTYPE=0 and
where (
        (regexp_like(bib.CALLNUMBER, '^\s*BOARD\s+.+$') OR
         regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*AUDIO.*$')
            )
            and
        (
            regexp_like(bt.WORDDATA, '^\s*E\s+(\w+\s*)+\-\s*VERY\s+EASY.*$')
            or bt.WORDDATA not like '0%'
            )
    )
 and  bc.tagnumber=590
 and bib.ACQTYPE = 0
 and n92.bid is null
 and substr(bt.WORDDATA,18,1)!='3'
order by bib.bid, bib.CALLNUMBER ;

-- Need Level 4 encoding
select bc.bid, bib.CALLNUMBER,  substr(bt.tagdata,18,1) ENCODING_LEVEL,
       case when (
        regexp_like(bib.CALLNUMBER, '^\s*[JY]*\s*CD\s+BOOK.+$') OR
        regexp_like(bib.CALLNUMBER, '^\s*[JY]*\s*PL\s*.+$') OR
            regexp_like(bib.CALLNUMBER,'^\s*HOOPLA\.*$')
           )
        then '4'
        else substr(bt.tagdata,18,1)
    end "New level",
    bt.TAGDATA "LEADER"
from bbibcontents_v2 bc
    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
   inner join btags_v2 bt on bc.tagid=bt.tagid
where bc.tagnumber=0 and bib.ACQTYPE=0 and (
        regexp_like(bib.CALLNUMBER, '^\s*[JY]*\s*CD\s+BOOK.+$') OR
        regexp_like(bib.CALLNUMBER, '^\s*[JY]*\s*PL\s*.+$') OR
        regexp_like(bib.CALLNUMBER,'^\s*HOOPLA\.*$')
    )
 and n92.bid is null
and substr(bt.tagdata,18,1)!='4'
order by bib.bid, bib.CALLNUMBER ;

-- Have Level 4 encoding
-- Outer Join with NO092 excludes BIDS without an 092 Call Number.
select bc.bid, bib.CALLNUMBER, bt.WORDDATA oldleader
--     substr(bt.tagdata,18,1) ENCODING_LEVEL,
--     bt.TAGDATA "LEADER"
from bbibcontents_v2 bc
    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid
-- where bc.tagnumber=0 and bib.ACQTYPE=0 and
where (
       regexp_like(bib.CALLNUMBER, '^\s*[JY]*\s*CD\s+BOOK.+$') OR
       regexp_like(bib.CALLNUMBER, '^\s*[JY]*\s*PL\s*.+$') OR
        regexp_like(bib.CALLNUMBER,'^\s*HOOPLA\.*$')
     )
 and  bc.tagnumber=590
 and bib.ACQTYPE = 0
 and n92.bid is null
 and substr(bt.WORDDATA,18,1)!='4'
order by bib.bid, bib.CALLNUMBER ;

-- Need Level 5 Full encoding
select bc.bid,  bib.CALLNUMBER, substr(bt.tagdata,18,1) ENCODING_LEVEL,
case
                     when (
                                regexp_like(bib.CALLNUMBER, '^\s*FIC.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.*$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.*$') OR
                                -- Dewey
                                regexp_like(bib.CALLNUMBER, '^\s*\d+\.?\d*.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+\d+\.?\d*.*$')
                            )
                         then '#'
                    else substr(bt.tagdata,18,1)
end "new level",
bt.TAGDATA LEADER
from bbibcontents_v2 bc
   left outer join NOO92 n92 on n92.bid = bc.BID
   inner join BBIBMAP_V2 bib on bc.bid=bib.bid
   inner join btags_v2 bt on bc.tagid=bt.tagid
where bc.tagnumber=0 and bib.ACQTYPE=0 and (
                                regexp_like(bib.CALLNUMBER, '^\s*FIC.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.*$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.*$') OR
                                -- Dewey
                                regexp_like(bib.CALLNUMBER, '^\s*\d+\.?\d*.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+\d+\.?\d*.*$')
    )
  and n92.bid is null
and NOT ( substr(bt.tagdata,18,1)=' ' OR substr(bt.tagdata,18,1)='#')
order by bib.CALLNUMBER, bib.BID;

-- Need Level 5 Redux
select bc.bid,  bib.CALLNUMBER, substr(bt.tagdata,18,1) ENCODING_LEVEL,
case
                     when (
                                regexp_like(bib.CALLNUMBER, '^\s*FIC\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.+$') OR
                                -- Dewey
                                regexp_like(bib.CALLNUMBER, '^\s*\d+\.?\d*.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+\d+\.?\d*.*$')
                            )
                         then '#'
                    else substr(bt.tagdata,18,1)
end "new level",
bt.TAGDATA LEADER
from bbibcontents_v2 bc
   left outer join NOO92 n92 on n92.bid = bc.BID
   inner join BBIBMAP_V2 bib on bc.bid=bib.bid
   inner join btags_v2 bt on bc.tagid=bt.tagid
where bc.tagnumber=0 and bib.ACQTYPE=0 and (
                                regexp_like(bib.CALLNUMBER, '^\s*FIC\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.+$') OR
                                -- Dewey
                                regexp_like(bib.CALLNUMBER, '^\s*\d+\.?\d*.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+\d+\.?\d*.*$')
    )
  and n92.bid is null
and NOT ( substr(bt.tagdata,18,1)=' ' OR substr(bt.tagdata,18,1)='#')
order by bib.CALLNUMBER, bib.BID;

-- Have Level 5 encoding
-- Have Level 5, old CN in Leader
-- Outer Join with NO092 excludes BIDS without an 092 Call Number.
select bc.bid, bib.CALLNUMBER, bt.WORDDATA oldleader
--     substr(bt.tagdata,18,1) ENCODING_LEVEL,
--     bt.TAGDATA "LEADER"
from bbibcontents_v2 bc
    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid
-- where bc.tagnumber=0 and bib.ACQTYPE=0 and
where (

     regexp_like(bib.CALLNUMBER, '^\s*FIC.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.+$') OR
                                -- Dewey
                                regexp_like(bib.CALLNUMBER, '^\s*\d+\.?\d*.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+\d+\.?\d*.*$')
     )
 and  bc.tagnumber=590
 and bib.ACQTYPE = 0
 and n92.bid is null
 and substr(bt.WORDDATA,18,1)!=' '
order by bib.bid, bib.CALLNUMBER ;

-- Levels 1 through 5
select distinct bib.bid, bib.CALLNUMBER,  substr(bt.tagdata,18,1) encoding_level,
                --tagdata, tagtype
                 case
                      when (
                                regexp_like(bib.CALLNUMBER, '^\s*FIC.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.+$') OR
                                -- Dewey
                                regexp_like(bib.CALLNUMBER, '^\s*\d+\.?\d*.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+\d+\.?\d*.*$')
                            )
                         then '#'
                     when (
                                regexp_like(bib.CALLNUMBER, '^\s*LP.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*PERIODICAL\s*$') OR
                                regexp_like(bib.CALLNUMBER, '^[EJ]\s*RA\s+.*$')
                            )
                         then '1'
                     when (
                                regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*BOOK.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*E\s+MAGAZINE.*$')
                            )
                        then '2'
                     when (
                                regexp_like(bib.CALLNUMBER, '^\s*BOARD\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*AUDIO.*$')
                            )
                     then '3'
                     when
                         (
                                 regexp_like(bib.CALLNUMBER, '^\s*[JY]*\s*CD\s+BOOK.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*[JY]*\s*PL\s*.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*HOOPLA\.*$')
                             )
                    then '4'

                         end "new level",

                bt.tagdata leader
from BBIBMAP_V2 bib
    left outer join NOO92 n92 on n92.bid = bc.BID
    inner join  bbibcontents_v2 bc on bc.bid=bib.bid
   inner join btags_v2 bt on bc.tagid=bt.tagid
where bc.tagnumber=0 and bib.ACQTYPE = 0
and (
        (
                (
                                regexp_like(bib.CALLNUMBER, '^\s*FIC.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.+$') OR
                                -- Dewey
                                regexp_like(bib.CALLNUMBER, '^\s*\d+\.?\d*.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+\d+\.?\d*.*$')
                )
                        and substr(bt.tagdata, 18, 1) != ' '
            )
            OR
                (
                        (
                                regexp_like(bib.CALLNUMBER, '^\s*LP.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*PERIODICAL\s*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[EJ]\s*RA\s+.*$')
                            )
                        and substr(bt.tagdata, 18, 1) != '1'
                    )
                OR
                (
                        (
                                regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*BOOK.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*E\s+MAGAZINE.*$')
                            )
                        and substr(bt.tagdata, 18, 1) != '2'
                    )
                OR (
                        (
                                regexp_like(bib.CALLNUMBER, '^\s*BOARD\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*AUDIO.*$')
                            )
                        and substr(bt.tagdata, 18, 1) != '3'
                    )
                OR (
                        (
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]*\s*CD\s+BOOK.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]*\s*PL\s*.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*HOOPLA\.*$')
                            )
                        and substr(bt.tagdata, 18, 1) != '4'
                    )
            )
and n92.bid is null
order by bib.CALLNUMBER , bib.BID


--Need Level 5 Full encoding, Dewey Numbers only
select bc.bid, bib.CALLNUMBER, substr(bt.tagdata,18,1) ENCODING_LEVEL,
case
                     when (

                                -- Dewey
                                regexp_like(bib.CALLNUMBER, '^\s*\d+\.?\d*.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+\d+\.?\d*.*$')
                            )
                         then '#'
                    else substr(bt.tagdata,18,1)
end "new level",
bt.TAGDATA LEADER
from bbibcontents_v2 bc
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
   inner join btags_v2 bt on bc.tagid=bt.tagid
where bc.tagnumber=0 and bib.ACQTYPE = 0 and (

                                regexp_like(bib.CALLNUMBER, '^\s*\d+\.?\d*.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+\d+\.?\d*.*$')
    )
and NOT ( substr(bt.tagdata,18,1)=' ' OR substr(bt.tagdata,18,1)='#')
order by bib.CALLNUMBER, bib.BID

--Need Level 5 Full encoding, FIC, MYS Only
select bc.bid, bib.CALLNUMBER, substr(bt.tagdata,18,1) ENCODING_LEVEL,
case
                     when (
                                -- Books
                                regexp_like(bib.CALLNUMBER, '^\s*FIC.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.+$')

                            )
                         then '#'
                    else substr(bt.tagdata,18,1)
end "new level",
bt.TAGDATA LEADER
from bbibcontents_v2 bc
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid
where bc.tagnumber=0 and bib.ACQTYPE = 0 and (

                                regexp_like(bib.CALLNUMBER, '^\s*FIC.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.+$')
    )
and NOT ( substr(bt.tagdata,18,1)=' ' OR substr(bt.tagdata,18,1)='#')
order by bib.CALLNUMBER, bib.BID ;

--05/22/2023
--Need Level 5 Full encoding, FIC, MYS Only, optional regexp char * at end for 092b
--create table BooksL5 as
select bc.bid,bib.CALLNUMBER,bt.TAGDATA "092", bt.WORDDATA word,books.ENCODING_LEVEL,
       case
                     when (
                                -- Books
                                regexp_like(bib.CALLNUMBER, '^\s*FIC.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.*$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B(\s+.*|)$')OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.*$')

                            )
                         then '#'
                    else substr(bt.tagdata,18,1)
end "new level"
from bbibcontents_v2 bc

    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid
    inner join BOOKSL5 books on books.bid = bib.bid

where bc.tagnumber=092
  and (tagdata like '%'  ||  CHR(31) || 'b%')

order by bib.CALLNUMBER, bib.BID ;

-- 05/23/2023 Experiment
select bc.bid,bib.CALLNUMBER,
       bt2.tagdata leader,
      substr(bt2.tagdata,18,1) ENCODING_LEVEL,
       bt.TAGDATA "092",
       bt.WORDDATA CallNum,
       case
                     when (
                                -- Books
                                regexp_like(bib.CALLNUMBER, '^\s*FIC.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.*$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B(\s+.*|)$')OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.*$')

                            )
                         then '#'
                    else substr(bt2.tagdata,18,1)
end "new level"
from bbibcontents_v2 bc
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid
    inner join btags_v2 bt2 on bc.TAGID=bt2.TAGID

where
      bib.ACQTYPE = 0 AND
         (
                                regexp_like(bib.CALLNUMBER, '^\s*FIC.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.+$')
       )
    AND (
        (bc.tagnumber = 092 and bt.tagdata like '%' || CHR(31) || 'b%')
         OR
        (bc.tagnumber = 0 AND substr(bt2.tagdata, 18, 1) != ' ')
    )
order by bib.CALLNUMBER, bib.BID ;

-- Make sure there's an 092
--Table No092 has bids with no 092
create table NoO92 as select  distinct bc.bid from BBIBCONTENTS_V2 bc
                    where bc.bid not in
                          (select bc.bid from BBIBCONTENTS_V2 bc where bc.tagnumber=92)
                       order by bc.bid ;

-- Bid 37952_ does not have 092
select * from BBIBCONTENTS_V2 bc
where bc.bid like '37952_'
  and bc.tagnumber=92
  ;

-- Start to look for the IID and Trusted record
-- Level 5
select

    bib.CALLNUMBER,  iid.iid, bc.bid, substr(bt.tagdata,18,1) ENCODING_LEVEL,
       -- bt.TAGDATA LEADER,
       --iidx.flag
--        iidlog.action,
--        iidlog.MANUAL,
--        trunc(iidlog.CHANGEDATE),
           bib.title

       --, iid.TITLECODE

from bbibcontents_v2 bc
    --left outer join NOO92 n92 on n92.bid = bc.BID
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
   -- inner join IIDMASTER_V2 iid on iid.bid = bc.bid
    --inner join IIDXREF_V2 iidx on iid.bid = bc.bid
    inner join IIDMASTER_V2 iid on iid.bid = bc.bid
    -- inner join IIDLOG_V2 iidlog on iidlog.bid = bc.bid
   inner join btags_v2 bt on bc.tagid=bt.tagid
    where bc.tagnumber=0 and bib.ACQTYPE=0 and
    regexp_like(substr(bt.tagdata,18,1),'[^Itu1-9 ]') and
       (
      regexp_like(bib.CALLNUMBER, '^\s*FIC\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*MYS.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*SF.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+FIC.+$') OR
                                 regexp_like(bib.CALLNUMBER, '^\s*B\s+.+$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+B\s+.+$') OR
                                -- Dewey
                                regexp_like(bib.CALLNUMBER, '^\s*\d+\.?\d*.*$') OR
                                regexp_like(bib.CALLNUMBER, '^\s*[JY]\s+\d+\.?\d*.*$')
    )
 -- Don't use records that do not have an 092
-- and n92.bid is null
order by substr(bt.tagdata,18,1) desc,
         -- trunc(iidlog.CHANGEDATE) desc,
         bib.bid
         ;

-- Level 2
select bc.bid,  iidx.iid,
       --bib.CALLNUMBER,
       substr(bt.tagdata,18,1) ENCODING_LEVEL,
        -- bt.TAGDATA LEADER,
       iidx.flag
       --iidlog.action,
       --iidlog.MANUAL,
       --trunc(iidlog.CHANGEDATE),
        --bib.title
       --, iid.TITLECODE

from bbibcontents_v2 bc
    --left outer join NOO92 n92 on n92.bid = bc.BID
    inner join "TestHasL2" tl2 on tl2.bid=bc.bid
    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join IIDXREF_V2 iidx on iidx.bid = bc.bid
    inner join IIDMASTER_V2 iid on iid.iid = iidx.iid
    --inner join IIDLOG_V2 iidlog on iidlog.bid = bc.bid
   inner join btags_v2 bt on bc.tagid=bt.tagid
    where bc.tagnumber=0 and bib.ACQTYPE=0
      --and
       -- (
       -- regexp_like(bib.CALLNUMBER, '^\s*OVERDRIVE\s+E\s*BOOK.*$') OR
        --regexp_like(bib.CALLNUMBER, '^\s*E\s+MAGAZINE.*$')
    --)
--and n92.bid is null
-- order by bib.bid
;

-- OReilly
select  bc.bid,bib.title, regexp_substr(WORDDATA,'https://learning\.oreilly\.com/library/view/[\~\-]/[0-9]+') "URL"
 ,bt.WORDDATA "856"

from bbibcontents_v2 bc

    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid

where
 -- bib.CALLNUMBER like 'E REFERENCE%'  AND
  upper(bib.ERESOURCE)='Y' AND
  bc.tagnumber=856
  and regexp_like(bt.WORDDATA,'^.+learning\.oreilly\.com.+$')

order by bib.BID , title;
select  bc.bid,bib.title, regexp_substr(WORDDATA,'https://learning\.oreilly\.com/library/view/[\~\-]/[0-9]+') "URL"
 ,bt.WORDDATA "856"

from bbibcontents_v2 bc

    inner join BBIBMAP_V2 bib on bc.bid=bib.bid
    inner join btags_v2 bt on bc.tagid=bt.tagid

where
 -- bib.CALLNUMBER like 'E REFERENCE%'  AND
  upper(bib.ERESOURCE)='Y' AND
  bc.tagnumber=856
  and regexp_like(bt.WORDDATA,'^.+learning\.oreilly\.com.+$')

order by bib.BID , title;

-- List bibs with no 092 that are not ILL's, on-orders or attached to Maryland
-- Room items
select bbm.bid, bbm.title, bbm.author, bbm.callnumber, bbc.bid
from bbibmap_v2 bbm
left join bbibcontents_v2 bbc on bbm.bid=bbc.bid and bbc.tagnumber=92
where bbc.bid is null    --bid doesn't have 092 tag
and bbm.bibtype=0 and bbm.acqtype=0 -- not temporary (ILL) and not on order
and bbm.bid in
  (select distinct i.bid from item_v2 i where i.cn not like 'M %') -- non-MDROOM items attached
order by bbm.bid