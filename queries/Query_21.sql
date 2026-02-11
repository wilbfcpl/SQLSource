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