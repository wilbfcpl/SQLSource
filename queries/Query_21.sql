--Bounced Email 08/26/2025
select patron.patronid from Patron_V2 patron
-- inner join ppbounced bounce on
where substr(upper(patron.email),1, 10) in (select  substr(upper(bounce.email),1,10) from ppbounced bounce) ;

-- where upper(patron.email) in (select upper(email) from ppbounced bounce) ;

select substr(upper(email),1,32) from ppbounced bounce ;

select substr(upper(email),1,32) from patron_v2 patron where email is not null ;

select patronid, upper(email), emailnotices, bty.btycode, name from patron_v2 patron
inner join bty_v2 bty on (patron.bty = bty.btynumber)
where email is not null ;

--Circulation Report for Courtney
select tx.SYSTEMTIMESTAMP ,
tx.TRANSACTIONTYPE ,
tx.ITEM ,
tx.ITEMBRANCH itembranch,
b.branchcode itembranchcode,
tx.envbranch chbranch,
b2.branchcode chbranchcode,
tx.ITEMMEDIA , m.medcode,
tx.ITEMLOCATION ,
cloc.loccode ,
cloc.locname,
tx.TXTRANSDATE ,
tx.TXDUEORNOTNEEDEDAFTERDATE ,
tx.ITEMCN
from txlog_v2 tx
inner join branch_v2 b on tx.itembranch=b.branchnumber
inner join branch_V2 b2 on tx.envbranch=b2.branchnumber
Left join item_v2 i on tx.item=i.item
Left join location_v2 cloc on tx.itemlocation=cloc.locnumber
Left join media_v2 m on tx.itemmedia=m.mednumber
where tx.transactiontype in ('CH','RN')
and trunc(tx.systemtimestamp) >= '01-SEPTEMBER-2023'
and trunc(tx.systemtimestamp) <= '01-SEPTEMBER-2025'
and tx.itemlocation in (127,130,72,73,74,140,75,76,77,78,128,129,80,82,83,84,85,86,134,87,88,89,90,131,132,133,79,91,92,93,141,94,95,96)
order by tx.itemlocation, cloc.loccode

-- Coming Due. 02/09/2026. "Cached" With/Select Common Table Expression(CTE) with select of transactions since beginning of prior month.

with trans as (
    select
        *
    from transitem_v2
    -- Beginning of last month
    where trunc(TRANSDATE) >= ADD_MONTHS(SYSDATE,-1)
)

select
    trunc(trans.DUEDATE) due,
    patron.patronid,
    trans.item,
    trans.renew,
    media.renewallimit,
    patron.ph1,
    ptype.description,
    ptype.address,
    patron.sendcomingduemsg,
    patron.sendholdavailablemsg,
    patron.emailreceipts,
    case TRANSCODE
       when 'PR' then 'PATRON REG'
       when 'C' then 'CHARGE'
       when 'DC' then 'RETURN'
        when 'H' then 'HOLD'
        when 'IH' then 'InXitHold'
        when 'L' then 'LOST'
        when 'I' then 'INTRANSIT'
        when 'O' then 'OVERDUE'
    else TRANSCODE
    end TRANSCODE,
    --transcode,
    trunc(trans.transdate)
   -- branch.branchcode thebranch

    from trans
        inner join patron_v2 patron on  trans.patronid=patron.PATRONID
        inner join item_v2 item on trans.item=item.item
        inner join media_v2 media on item.media=media.mednumber
        inner join branch_v2 branch on trans.branch = branch.BRANCHNUMBER
     inner join phonetype_v2 ptype on patron.phonetypeid1 = ptype.phonetypeid
       -- inner join branch_v2 xbranch on trans.branch =xbranch.BRANCHNUMBER
     inner join noticehistory_v2 noticehist on noticehist.item=trans.item
 --   where transcode in ('C','H','I','IH','L','O','R#','R*')
    where
        item.status='C' and
        patron.sendcomingduemsg = 'Y' and
        patron.emailreceipts = 'Y' and
        ptype.phonetypeid != 47 and
        trunc(trans.duedate) between sysdate and sysdate + 7
;
    --order by trunc(trans.TRANSDATE)  ;


   select TRANSACTIONTYPE, count (trans.TRANSACTIONTYPE), trunc(trans.SYSTEMTIMESTAMP)

    from txlog_v2 trans
        inner join patron_v2 newreg on  trans.patronid=newreg.PATRONID
        inner join branch_v2 branch on trans.envbranch = branch.BRANCHNUMBER
    where

    group by TRANSACTIONTYPE,trunc(SYSTEMTIMESTAMP)
    order by trunc(trans.SYSTEMTIMESTAMP)  ;

SELECT ITEM, CN
FROM ITEM_V2
WHERE REGEXP_LIKE(CN, '[^ -~]')
ORDER by CN;

SELECT ITEM, CN
FROM ITEM_V2
WHERE REGEXP_LIKE( CN,
 -- '[\u00C0-\u017F]'
--'[\u0300-\u036F]|[^\x00-\x7F]'
    --'[\u0300-\u036F]'
     --'[À-ÖØ-öø-ÿ]'
--  '[\u00C0-\u024F\u1E00-\u1EFF]'
-- '[:punct:]'
      --'\p{L}*\p{M}'
      );

   --          '[\u00C0-\u00FF\u0100-\u017F\u0180-\u024F]'
     -- '[^\x00-\x7F]'
  -- '[^A-Za-z]'
--  '[[:alpha:]]\p{M}'
 -- '[\u00C0-\u017F]'  -- Latin-1 Supplement + Latin Extended-A
     --   '[\u0300-\u036F]' -- Combining Diacritic Marks Block
--, 'u'
    -- '\p{M}+'

-- Example: Detect and list diacritic characters in a column
SELECT
    ITEM,
    CN,
    REGEXP_SUBSTR(
        CN,
        '[\u00C0-\u017F\u0300-\u036F]+'
    ) AS first_diacritic,
    REGEXP_REPLACE(
        CN,
        '([^\u00C0-\u017F\u0300-\u036F])',
        ''
    ) AS all_diacritics
FROM ITEM_V2
WHERE REGEXP_LIKE(
    CN,
    '[\u00C0-\u017F\u0300-\u036F]', 'i'
);
SELECT ITEM, CN
FROM ITEM_V2
WHERE length(CN) < lengthb(CN)
ORDER by CN;

-- Report 16 Circulation by Media Aggregate work alike
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

-- Search TXLOG for VAN outreach in late 2024: Oct 4, Oct 18, Nov 1, Nov 15, Dec 20
-- 01/17/2025
with trans as (
    select
        *
    from txlog_v2
    where trunc(systemtimestamp) >= '01-OCT-2024'
)
select case TRANSACTIONTYPE
       when 'PR' then 'PATRON REG'
       when 'CH' then 'CHARGE'
       when 'DC' then 'RETURN'
    else 'UNKNOWN'
    end,
       count (trans.TRANSACTIONTYPE), trunc(trans.SYSTEMTIMESTAMP)

    from trans
        inner join patron_v2 newreg on  trans.patronid=newreg.PATRONID
        inner join branch_v2 branch on trans.envbranch = branch.BRANCHNUMBER
    where

      upper(branch.BRANCHCODE)='VAN' and
        ( trunc(trans.SYSTEMTIMESTAMP) = '04-OCT-24'  OR
          trunc(trans.SYSTEMTIMESTAMP) = '18-OCT-24'  OR
          trunc(trans.SYSTEMTIMESTAMP) = '01-NOV-24'  OR
          trunc(trans.SYSTEMTIMESTAMP) = '15-NOV-24'  OR
          trunc(trans.SYSTEMTIMESTAMP) = '20-DEC-24'

            ) and
      TO_CHAR(trans.SYSTEMTIMESTAMP, 'HH24:MI:SS') BETWEEN '15:30:00' AND '16:30:00'

    group by TRANSACTIONTYPE,trunc(SYSTEMTIMESTAMP)
    order by trunc(trans.SYSTEMTIMESTAMP)  ;

-- Student transactions FY 24
SELECT p.patronid, p.name, tx.transactiontype, codes.CODETYPE,trunc(tx.systemtimestamp), trunc(p.editdate) AS editdate
FROM patron_v2 p
inner join BTY_V2 bty on bty.BTYNUMBER = p.BTY
INNER JOIN txlog_v2 tx ON p.patronguid=tx.patronguid
inner join SYSTEMCODEVALUES_V2 vals on vals.CODEVALUE=  tx.TRANSACTIONTYPE
inner join SYSTEMCODETYPES_V2 codes on codes.CODETYPE = vals.CODETYPE and codes.CODETYPE = 5
--2=GRAD, 5=JUV, 7=PUBLIC, 10=STUDNT, 11=TEMP, 12=WEBREG, 13=JVOPTO, 14=OPTOUT
WHERE bty.btycode in ('STUDNT','GRAD')

and trunc(tx.SYSTEMTIMESTAMP) between '01-JULY-2023' and '30-JUN-2024'

AND upper(tx.transactiontype) in ('CH','HP','RN')
ORDER BY p.patronguid ;

-- Search TXLOG for Bike outreach in Summer
-- 09/12/2025

with trans as (
    select log.TRANSACTIONTYPE, log.PATRONID, log.SYSTEMTIMESTAMP, log.ENVBRANCH  from txlog_v2 log
    --where trunc(systemtimestamp) = '07-SEP-2025'
     where  TO_CHAR(log.SYSTEMTIMESTAMP,'DD-MM-YY') = :OUTREACHDATE )
select
       case TRANSACTIONTYPE
       when 'PR' then 'PATRON REG'
       when 'CH' then 'CHARGE'
       when 'DC' then 'RETURN'
    else 'UNKNOWN'
    end TRANSTYPE,
       count (trans.TRANSACTIONTYPE) TXCount, trunc(trans.SYSTEMTIMESTAMP) timestamp
    from trans
        inner join patron_v2 newreg on  trans.patronid=newreg.PATRONID
        inner join branch_v2 branch on trans.envbranch = branch.BRANCHNUMBER
    where
      upper(branch.BRANCHCODE)=:BRANCHCODE and
     -- upper(branch.BRANCHCODE)='BKB' and

        (
           --  trunc(trans.SYSTEMTIMESTAMP) = '07-SEP-25'
            TO_CHAR(trans.SYSTEMTIMESTAMP, 'DD-MM-YY') = :OUTREACHDATE
--           OR trunc(trans.SYSTEMTIMESTAMP) = '31-AUG-25'
--           OR trunc(trans.SYSTEMTIMESTAMP) = '01-NOV-24'
--           OR trunc(trans.SYSTEMTIMESTAMP) = '15-NOV-24'
--           OR trunc(trans.SYSTEMTIMESTAMP) = '20-DEC-24'

            ) and
      TO_CHAR(trans.SYSTEMTIMESTAMP, 'HH24:MI:SS') BETWEEN '09:00:00' AND '13:00:00'
    group by TRANSACTIONTYPE , trunc(SYSTEMTIMESTAMP)
  --  order by trunc(trans.SYSTEMTIMESTAMP)
        ;

-- Outreach transactions for a branch on a specific date
-- 09/12/2025
with trans as (
    select log.TRANSACTIONTYPE, log.PATRONID, log.SYSTEMTIMESTAMP, log.ENVBRANCH  from txlog_v2 log
     where  TO_CHAR(log.SYSTEMTIMESTAMP,'DD-MM-YY') = :OUTREACHDATE )
select
       case TRANSACTIONTYPE
       when 'PR' then 'PATRON REG'
       when 'CH' then 'CHARGE'
       when 'DC' then 'RETURN'
    else 'UNKNOWN'
    end TRANSTYPE,
       count (trans.TRANSACTIONTYPE) TXCount, trunc(trans.SYSTEMTIMESTAMP) timestamp
    from trans
        inner join patron_v2 newreg on  trans.patronid=newreg.PATRONID
        inner join branch_v2 branch on trans.envbranch = branch.BRANCHNUMBER
    where
      upper(branch.BRANCHCODE)=:BRANCHCODE and
      TO_CHAR(trans.SYSTEMTIMESTAMP, 'DD-MM-YY') = :OUTREACHDATE
    --  and TO_CHAR(trans.SYSTEMTIMESTAMP, 'HH24:MI:SS') BETWEEN '09:00:00' AND '13:00:00'
    group by TRANSACTIONTYPE , trunc(SYSTEMTIMESTAMP)
        ;

-- In the Streets 09/13/2025  Inconsistencies with the BRANCH of registration. Also two terminals.
with trans as (
    select log.patronid patron,log.TRANSACTIONTYPE, log.PATRONID, log.SYSTEMTIMESTAMP, log.txtransdate, log.termnumber, log.usernumber, log.ENVBRANCH ,
           log.Patronbranchofregistration regbranch from txlog_v2 log
     where  TO_CHAR(log.SYSTEMTIMESTAMP,'DD-MM-YY') = '13-09-25'  and TRANSACTIONTYPE='PR' )
select

       trans.patronid patron, newreg.regby regisby,trans.termnumber,trans.SYSTEMTIMESTAMP timestamp, trans.usernumber,
       branch.branchcode,regbranch.branchcode regisbranch
    from trans
        inner join patron_v2 newreg on  trans.patronid=newreg.PATRONID
        inner join branch_v2 branch on trans.envbranch = branch.BRANCHNUMBER
    inner join branch_v2 regbranch on trans.regbranch = regbranch.BRANCHNUMBER
    where
      -- upper(branch.BRANCHCODE)=:BRANCHCODE and
      TO_CHAR(trans.SYSTEMTIMESTAMP, 'HH24:MI:SS') BETWEEN '10:30:00' AND '17:00:00'
    --group by TRANSACTIONTYPE , trunc(SYSTEMTIMESTAMP)
        ;

with trans as (
    select log.patronid patron,log.TRANSACTIONTYPE, log.PATRONID, log.SYSTEMTIMESTAMP,
           log.txtransdate, log.termnumber, log.ENVBRANCH ,
           log.Patronbranchofregistration regbranch from txlog_v2 log
     where  TO_CHAR(log.SYSTEMTIMESTAMP,'DD-MM-YY') = '13-09-25'
       --and TRANSACTIONTYPE='PR'
           and log.patronid = '1198290009513')

select
       trans.patronid patron, trans.transactiontype, newreg.regby regisby,trans.termnumber,trans.SYSTEMTIMESTAMP timestamp,
       branch.branchcode,regbranch.branchcode regisbranch
    from trans
        inner join patron_v2 newreg on  trans.patronid=newreg.PATRONID
        inner join branch_v2 branch on trans.envbranch = branch.BRANCHNUMBER
    inner join branch_v2 regbranch on trans.regbranch = regbranch.BRANCHNUMBER
    where
      -- upper(branch.BRANCHCODE)=:BRANCHCODE and
      TO_CHAR(trans.SYSTEMTIMESTAMP, 'HH24:MI:SS') BETWEEN '10:30:00' AND '17:00:00'
    --group by TRANSACTIONTYPE , trunc(SYSTEMTIMESTAMP)
        ;

-- Charged during specific timeframe
with logstuff as (select  TO_CHAR(Tx.SYSTEMTIMESTAMP, 'YYYY/MM/DD') TX_DATE, tx.patronid patron, tx.itembid, tx.item,
                          tx.itemcn, BTY.BTYNAME BORROWER_TYPE,
         L.LOCNAME,B2.BRANCHNAME BRANCH_HELD,
         TX.PATRONID, V.CODEDESCRIPTION,
         bib.title
                  from txlog_v2 tx LEFT OUTER JOIN BRANCH_V2 B1
      ON B1.BRANCHNUMBER = TX.ENVBRANCH
       LEFT OUTER JOIN BTY_V2 BTY ON BTY.BTYNUMBER=TX.PATRONBTY
       LEFT OUTER JOIN BBIBMAP_V2 BIB on BIB.BID=TX.ITEMBID
       LEFT OUTER JOIN LOCATION_V2 L ON TX.ITEMLOCATION = L.LOCNUMBER
       LEFT OUTER JOIN BRANCH_V2 B2 ON TX.ITEMBRANCH = B2.BRANCHNUMBER
       LEFT OUTER JOIN SYSTEMCODEVALUES_V2 V ON V.CODETYPE = 5
           AND V.CODEVALUE = TX.TRANSACTIONTYPE
                where  Tx.SYSTEMTIMESTAMP between '01-FEB-2026' and '30-APR-2026'
                and tx.transactiontype = 'CH')

select logstuff.TX_DATE, logstuff.branch_held, logstuff.patron, logstuff.borrower_type, logstuff.itembid, logstuff.item, title from logstuff
    group by logstuff.TX_DATE,branch_held, logstuff.patron, borrower_type,logstuff.itembid,logstuff.item, title
    order by logstuff.TX_DATE desc
;