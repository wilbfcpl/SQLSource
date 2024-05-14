--- Patron Point January 20, 2023
-- Annual Notice Query

select patron.PATRONID, patron.FIRSTNAME,patron.DEFAULTBRANCH,patron.LANGUAGE,bstatus.DESCRIPTION patronstatus,
       patron.COLLECTIONSTATUS,patron.email,patron.EMAIL2,patron.ph1,patron.PH2,patron.EMAILNOTICES,
       items.status itemstatus, items.duedate ,loc.LOCCODE,
       bib.TITLE,bib.author,bib.UPC,bib.ISBN,branch.BRANCHCODE

    from item_v2 items
    inner join BBIBMAP_V2 bib on items.bid = bib.BID
    inner join transitem_V2 trans on items.item = trans.item
    inner join BRANCH_V2 branch on trans.BRANCH = branch.BRANCHNUMBER
    inner join LOCATION_V2 loc on trans.LOCATION = loc.LOCNUMBER
    inner join patron_v2 patron on trans.PATRONID = patron.PATRONID
    inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
    where patron.EMAILNOTICES=0 and (EMAIL is not null or EMAIL2 is not null) order by items.DUEDATE desc
    ;
-- First Pass
select patron.PATRONID, patron.FIRSTNAME,patron.DEFAULTBRANCH,patron.LANGUAGE,bstatus.DESCRIPTION patronstatus,
       patron.COLLECTIONSTATUS,patron.email,patron.EMAIL2,patron.ph1,patron.PH2,patron.EMAILNOTICES,
       items.status itemstatus, items.duedate ,loc.LOCCODE,
       bib.TITLE,bib.author,bib.UPC,bib.ISBN,branch.BRANCHCODE

    from item_v2 items
    inner join BBIBMAP_V2 bib on items.bid = bib.BID
    inner join transitem_V2 trans on items.item = trans.item
    inner join BRANCH_V2 branch on trans.BRANCH = branch.BRANCHNUMBER
    inner join LOCATION_V2 loc on trans.LOCATION = loc.LOCNUMBER
    inner join patron_v2 patron on trans.PATRONID = patron.PATRONID
    inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
    where trunc(items.DUEDATE)<trunc(sysdate)-365 and patron.EMAILNOTICES=0 and (patron.email is not null or patron.email2 is not null) order by items.DUEDATE desc
    ;

select patron.PATRONID, patron.FIRSTNAME,STREET1,branch.BRANCHCODE,patron.LANGUAGE,bstatus.DESCRIPTION patronstatus,
       patron.email,patron.EMAIL2,patron.ph1,patron.PH2,patron.EMAILNOTICES,
       items.status itemstatus, trunc(items.duedate) ,loc.LOCCODE,
       bib.TITLE,bib.author,bib.UPC,bib.ISBN,branch.BRANCHCODE
    from item_v2 items
    inner join BBIBMAP_V2 bib on items.bid = bib.BID
    inner join transitem_V2 trans on items.item = trans.item
    inner join BRANCH_V2 branch on trans.BRANCH = branch.BRANCHNUMBER
    inner join LOCATION_V2 loc on trans.LOCATION = loc.LOCNUMBER
    inner join patron_v2 patron on trans.PATRONID = patron.PATRONID
    inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
    where trunc(items.DUEDATE)<(trunc(sysdate)-365)
    order by items.DUEDATE asc
    ;

select patron.PATRONID, btype.BTYCODE, patron.NAME,branch.BRANCHCODE,patron.LANGUAGE,bstatus.DESCRIPTION patronstatus,
       patron.email,patron.EMAIL2,patron.ph1,patron.PH2,patron.EMAILNOTICES,
       items.status itemstatus, trunc(items.duedate) ,loc.LOCCODE,
       bib.TITLE,bib.author,bib.UPC,bib.ISBN,branch.BRANCHCODE
    from item_v2 items
    inner join BBIBMAP_V2 bib on items.bid = bib.BID
    inner join transitem_V2 trans on items.item = trans.item
    inner join BRANCH_V2 branch on trans.BRANCH = branch.BRANCHNUMBER
    inner join LOCATION_V2 loc on trans.LOCATION = loc.LOCNUMBER
    inner join patron_v2 patron on trans.PATRONID = patron.PATRONID
    inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
    inner join BTY_V2 btype on patron.bty = btype.BTYNUMBER
    where trunc(items.DUEDATE)<(trunc(sysdate)-60) and EMAILNOTICES=0 and btycode !='LIBUSE'
    order by items.DUEDATE desc
    ;

-- Patron Point extract format

select patron.FIRSTNAME, Patron.EMAIL, patron.PATRONID, patron.PATRONGUID, bib.AUTHOR, bib.TITLE,bib.ISBN,
       trunc(items.duedate), branch2.BRANCHNAME homebranch, branch3.BRANCHNAME pickupbranch,
       trunc(trans.TRANSDATE) checkoutdate, branch.BRANCHNAME CheckoutBranch, loc.LOCNAME,
       trunc(trans.DUEORNOTNEEDEDAFTERDATE) pickupby, 'billtotal',trans.item transid,'60Overdue' as NoticeType, syscodes.CODEDESCRIPTION trans_code
    from item_v2 items
    inner join BBIBMAP_V2 bib on items.bid = bib.BID
    inner join transitem_V2 trans on items.item = trans.item
    inner join BRANCH_V2 branch on trans.BRANCH = branch.BRANCHNUMBER
    inner join BRANCH_V2 branch3 on trans.PICKUPBRANCH = branch3.BRANCHNUMBER
    inner join LOCATION_V2 loc on trans.LOCATION = loc.LOCNUMBER
    inner join patron_v2 patron on trans.PATRONID = patron.PATRONID
    inner join branch_v2 branch2 on patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER
    inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
    inner join BTY_V2 btype on patron.bty = btype.BTYNUMBER
    inner join SYSTEMCODEVALUES_V2 syscodes on trans.TRANSCODE = syscodes.CODEVALUE
    where trunc(items.DUEDATE)<(trunc(sysdate)-60) and EMAILNOTICES=0 and btycode !='LIBUSE'
    order by items.DUEDATE desc
    ;

-- Patron Point extract format, txlog
--select '"' || FirstName || '"|"' || Email || '"|"' || PatronID  ||  '"|"'   || Author  || '"|"' || Title  || '"|"' || ISBN  || '"|"' || DueDate  || '"|"' || PickupLocation  || '"|"' || CheckoutLocation || '"|"' || PickupBy || '"|"' || BillTotal || '"|"' || TransactionID ||  '"|"' || NoticeType || '"'
--from (
select patron.FIRSTNAME,
             Patron.EMAIL,
             patron.PATRONGUID PATRONID,
             bib.AUTHOR,
             bib.TITLE,
             bib.ISBN,
             trunc(items.duedate) DueDate,
             branch2.BRANCHNAME                   homebranch,
             branch3.BRANCHNAME                   PickupLocation,
             trunc(trans.TXTRANSDATE)               checkoutdate,
             branch.BRANCHNAME                    CheckoutLocation,
             loc.LOCNAME,
             trunc(trans.TXDUEORNOTNEEDEDAFTERDATE) pickupby,
             'billtotal' as BillTotal,
             trans.item                           TransactionID,
             '60Overdue' as NoticeType,
             syscodes.CODEDESCRIPTION             trans_code
      from item_v2 items
               inner join BBIBMAP_V2 bib on items.bid = bib.BID
               inner join txlog_V2 trans on items.item = trans.item
               inner join BRANCH_V2 branch on trans.ITEMBRANCH = branch.BRANCHNUMBER
               inner join BRANCH_V2 branch3 on trans.TXPICKUPBRANCH = branch3.BRANCHNUMBER
               inner join LOCATION_V2 loc on trans.ITEMLOCATION = loc.LOCNUMBER
               inner join patron_v2 patron on trans.PATRONID = patron.PATRONID
               inner join branch_v2 branch2 on patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER
               inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
               inner join BTY_V2 btype on patron.bty = btype.BTYNUMBER
               inner join SYSTEMCODEVALUES_V2 syscodes on trans.TRANSACTIONTYPE = syscodes.CODEVALUE
      where trunc(items.DUEDATE) < (trunc(sysdate) - 60)
        and EMAILNOTICES = 0
        and btycode != 'LIBUSE'
     order by items.DUEDATE desc
;

    --)
--;
select patron.FIRSTNAME,
             --Patron.EMAIL,
            patron.PATRONID,
             --patron.PATRONGUID PATRONID,
            -- bib.AUTHOR,
             bib.TITLE,
            -- bib.ISBN,
             trunc(items.duedate) ItemDueDate,
            -- branch2.BRANCHNAME                   homebranch,
           --  branch3.BRANCHNAME                   PickupLocation,
             trunc(trans.TRANSDATE)               checkoutdate,
             branch.BRANCHNAME                    CheckoutLocation,
             --loc.LOCNAME,
            -- trunc(trans.DUEORNOTNEEDEDAFTERDATE) pickupby,
             --'billtotal' as billtotal,
             trans.item                           ItemID,
             --'365DaysOverdue' as NoticeType,
             bstatus.DESCRIPTION PatronStatus,
             items.status as ItemStatus,
             syscodes.CODEDESCRIPTION             trans_code,
             trans.AMOUNTDEBITED,
              trans.AMOUNTPAID
             --trans.NOTES

            -- syscodes2.CODEDESCRIPTION fiscalcode,
            -- fiscal.amount fiscalamount,
             --fiscal.PAYMENTCODE,
             --fiscal.partialpayment

               from  TRANSITEM_V2 trans

               inner join item_V2 items on items.item = trans.item
               inner join BBIBMAP_V2 bib on items.bid = bib.BID
               inner join BRANCH_V2 branch on trans.BRANCH = branch.BRANCHNUMBER
               inner join BRANCH_V2 branch3 on trans.PICKUPBRANCH = branch3.BRANCHNUMBER
               inner join LOCATION_V2 loc on trans.LOCATION = loc.LOCNUMBER
               inner join patron_v2 patron on trans.PATRONID = patron.PATRONID
               --inner join PATRONFISCAL_V2 fiscal on (fiscal.PATRONID = trans.PATRONID and fiscal.ITEMID = trans.ITEM)
               --inner join SYSTEMCODEVALUES_V2 syscodes2 on fiscal.TRANSCODE = syscodes2.CODEVALUE
               inner join branch_v2 branch2 on patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER
               inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
               inner join BTY_V2 btype on patron.bty = btype.BTYNUMBER
               inner join SYSTEMCODEVALUES_V2 syscodes on trans.TRANSCODE = syscodes.CODEVALUE
        where ((items.STATUS='L') and trunc(items.DUEDATE) <= (trunc(sysdate) - 180 ) )
        and btycode != 'LIBUSE'


     order by items.DUEDATE desc
;
-- inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
-- and (      trans.TRANSCODE='W'
--                        OR trans.TRANSCODE='C'
--                        OR trans.TRANSCODE like 'F%'
--                        OR trans.TRANSCODE like 'L%'
--                        OR trans.TRANSCODE ='P'
--                        OR TRANSCODE='R')

-- Annual Notice
select
            trans.PATRONID,
            trans.ITEMID,
            sum(
                case trans.FISCALTYPE
                    when 'C' then
                    trans.AMOUNT
                    when 'D' then
                    -trans.AMOUNT
                    else
                     trans.AMOUNT
                end
                ) as total_amount,
            trunc(items.DUEDATE)
            from  PATRONFISCAL_V2 trans
               inner join item_V2 items on items.item = trans.ITEMID
               inner join patron_v2 patron on trans.PATRONID = patron.PATRONID

        where (
               (items.STATUS='L')
               and ((patron.STATUS='M') or (patron.STATUS='X') )
               and (
                      trunc(items.DUEDATE) <= (current_date - :numberofdays )
                   and
                      trunc(items.DUEDATE) >= (current_date - 2*:numberofdays)
                   )
            )
    group by (trans.PATRONID,trans.ITEMID,items.DUEDATE)
    having sum(
                case trans.FISCALTYPE
                    when 'C' then
                    trans.AMOUNT
                    when 'D' then
                    -trans.AMOUNT
                    else
                     trans.AMOUNT
                end
                ) <0

    order by trans.PATRONID;

--Holds Extract

-- LA Public Holds


-- select '"FirstName"|"Email"|"PatronID"|"Author"|"Title"|"ISBN"|"DueDate"|"PickupLocation"|"CheckoutLocation"|"PickupBy"' ||
--        '|"BillTotal"|"TransactionID"|"NoticeType"|"PickupLocationLabel"' from dual;
-- select '"' || FirstName || '"|"' || Email  ||  '"|"' || PatronID  ||  '"|"'   || Author  || '"|"' || Title
--            || '"|"' || ISBN  || '"|"' || DueDate  || '"|"' || PickupLocation  || '"|"' || CheckoutLocation
--            || '"|"' || PickupBy || '"|"' || BillTotal || '"|"' || TransactionID ||  '"|"' || NoticeType
--            ||  '"|"' || PickupLocationLabel || '"'
-- from
-- (

-- Magic Number 78 days just to find an Available Hold on the Test Server.

 select  FirstName , 'wil.blake@fcpl.org' as Email  , null as Mobile, 'email' as Method,PatronID , Language, Author , Title, ISBN  ,  UPC,
         null as OCLC, DueDate ,HomeLibrary, PickupLocation,PickupLocationLabel, null as CheckoutDate, Checkoutlocation,
            ItemLocation,PickupBy ,null As ReplacementCost, null as  ProcessingFee, null as OverdueCharge,null As ChargeReason, null as Total, null as TotalDue,
            TransactionID, 'hold' As NoticeType
from (
select  t.patronid as PatronID, p.firstname as FirstName, p.email as Email,
          case p.LANGUAGE
           when 2 then 'spanish'
           else 'english'
          end
       as Language,
       bm.author as Author,  bm.title as Title, bm.isbn as ISBN, bm.UPC as UPC,  b.branchcode as PickupLocation,
       b.branchname as PickupLocationLabel, to_char(jts.todate(t.DUEORNOTNEEDEDAFTERDATE),'YYYY-MM-DD') as PickupBy,
       t.item as TransactionID, '' as Checkoutlocation, b.BRANCHCODE as ItemLocation, c.BRANCHCODE as HomeLibrary,'' as DueDate

from transitem_v2 t, branch_v2 b, branch_v2 c, bbibmap_v2 bm, item_v2 i, patron_v2 p,BTY_V2 type
where
--  b.branchcode = 'EMM'
type.BTYNUMBER = p.BTY
--and BTYNAME = 'STFBRW'
and  bm.bid = i.bid
and i.item = t.item
and t.transcode = 'H'
and t.pickupbranch = b.branchnumber
and p.DEFAULTBRANCH = c.BRANCHNUMBER

--and to_char(jts.todate(t.transDATE),'YYYY-MM-DD') = to_char(sysdate,'YYYY-MM-DD')
-- Previous line is the right date search
-- Magic Number 78 days prior empirical value used to find an Available Hold on the Test Server.

and (trunc(t.transdate)>sysdate -78 and trunc(t.TRANSDATE)<sysdate)
and t.patronid = p.patronid
--and p.email IS NOT NULL
order by b.branchcode, t.DUEORNOTNEEDEDAFTERDATE, bm.author fetch next 5 rows only
) ;

select p.patronid as PatronID, p.name as Name, p.email as Email,
          case p.LANGUAGE
           when 1 then 'english'
           when 2 then 'spanish'
           else 'english'
          end
       as Language,
       p.LANGUAGE,
        b.branchcode as PickupLocation,
       b.branchname as PickupLocationLabel,
       b.BRANCHCODE as ItemLocation, c.BRANCHNAME as HomeLibrary,'' as DueDate

from branch_v2 b, branch_v2 c, patron_v2 p
where
p.LANGUAGE !=1
--and  bm.bid = i.bid
--and i.item = t.item
--and t.transcode = 'H'
--and t.pickupbranch = b.branchnumber
--and p.DEFAULTBRANCH = c.BRANCHNUMBER
--and to_char(jts.todate(t.transDATE),'YYYY-MM-DD') = to_char(sysdate,'YYYY-MM-DD')
--and (trunc(t.transdate)>sysdate -78 and trunc(t.TRANSDATE)<sysdate)
--and t.patronid = p.patronid
--and p.email IS NOT NULL
order by b.branchcode
 ;

-- From Rita Jensen via Slack for Lost Items
SELECT trans.patronid, email, trans.AMOUNTDEBITED amount,trans.AMOUNTPAID amount
FROM patron_v2 patron,TRANSITEM_V2 trans
WHERE patron.patronid IN (
    SELECT DISTINCT patronid
    FROM transitem_v2
    WHERE transcode = 'L' and  ( trans.AMOUNTDEBITED > 0  or trans.AMOUNTPAID > 0)
        AND dueornotneededafterdate < (sysdate - :PastDays))

;



-- 04/11/2023 Patron Point extract format, Items, NoticeHistory, Patrons
-- First Overdue- received courtesy
select
             NOTICEHISTORYID,
             --NOTICEID,
          --   history.CREATIONDATE,
            -- RECEIPTID,
            history.CREATIONDATE,
            PROCESSEDDATE,
             trunc(items.duedate) DueDate,
             items.status,
            -- history.EMAIL,
             codes.DESCRIPTION,
             patron.FIRSTNAME,
             --Patron.EMAIL,
            -- patron.PATRONGUID,
             bib.AUTHOR,
             bib.TITLE,
           --  bib.ISBN,

        --     branch2.BRANCHNAME                   homebranch,
        --  branch3.BRANCHNAME                   PickupLocation,
        --   trunc(trans.TXTRANSDATE)               checkoutdate,
        --     branch.BRANCHNAME                    CheckoutLocation,
        --   loc.LOCNAME,
             --trunc(trans.TXDUEORNOTNEEDEDAFTERDATE) pickupby,
             --'billtotal' as BillTotal,
             Items.item         ,
             'Overdue1' as NoticeType
              -- syscodes.CODEDESCRIPTION
               from item_v2 items
               inner join BBIBMAP_V2 bib on items.bid = bib.BID
               --inner join txlog_V2 trans on items.item = trans.item
               --inner join NOTICES_V2 notices on items.item = notices.ITEM


            inner join NOTICEHISTORY_V2 history on (history.ITEM = items.item)
              inner join CARLREPORTS.SYSTEMNOTICECODES_V2 codes on codes.CODE = history.NOTICETYPE
               inner join PATRON_V2 patron on patron.patronid = history.PATRONID
              -- inner join BRANCH_V2 branch on trans.ITEMBRANCH = branch.BRANCHNUMBER
               --inner join BRANCH_V2 branch3 on trans.TXPICKUPBRANCH = branch3.BRANCHNUMBER
               -- inner join LOCATION_V2 loc on trans.ITEMLOCATION = loc.LOCNUMBER

               inner join branch_v2 branch2 on patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER
               inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
               inner join BTY_V2 btype on patron.bty = btype.BTYNUMBER
              --inner join SYSTEMCODEVALUES_V2 syscodes on trans.TRANSACTIONTYPE = syscodes.CODEVALUE
      where
          Items.status like 'C%' AND
          history.NOTICETYPE ='CO' and
          trunc(PROCESSEDDATE)=trunc(sysdate)-3 and
          trunc(items.DUEDATE) = trunc(sysdate)
       -- and btycode != 'LIBUSE'
          and btycode = 'STFBRW'
     order by items.DUEDATE  ;
-- 04/11/2023 Patron Point extract format, Items Notice History, Patrons.
-- Generate list of 1 Day Overdue recipients that have received the 3 Days Prior/Coming Due.

select
          distinct patron.PATRONID,
              --NOTICEHISTORYID,
--             NOTICEID,
--           --   history.CREATIONDATE,
--             -- RECEIPTID,
--             history.CREATIONDATE,
          --   trunc(PROCESSEDDATE),
--              trunc(items.duedate) DueDate,
--              items.status,
--             -- history.EMAIL,
--              codes.DESCRIPTION,
             patron.FIRSTNAME,
             Patron.EMAIL,
             patron.PATRONGUID,
             bib.AUTHOR,
             bib.TITLE,
             bib.ISBN,
             trunc(items.duedate) DueDate,
             branch2.BRANCHNAME                   homebranch,
             branch3.BRANCHNAME                   PickupLocation,
             --trunc(trans.TXTRANSDATE)               checkoutdate,
             branch.BRANCHNAME                    CheckoutLocation,
             loc.LOCNAME,
             --trunc(trans.TXDUEORNOTNEEDEDAFTERDATE) pickupby,
             --'billtotal' as BillTotal,
           history.item ,
             'Overdue1' as NoticeType
              --syscodes.CODEDESCRIPTION
               from NOTICEHISTORY_V2 history

            inner join txlog_V2 trans on history.item = trans.item
               --inner join NOTICES_V2 notices on items.item = notices.ITEM
            inner join  item_v2 items on (history.ITEM = items.item)
            inner join BBIBMAP_V2 bib on items.bid = bib.BID
            inner join CARLREPORTS.SYSTEMNOTICECODES_V2 codes on codes.CODE = history.NOTICETYPE
            inner join "SupportStaffNoticeTesters" testers on testers.PATRON_ID = history.PATRONID
            inner join PATRON_V2 patron on patron.patronid = history.PATRONID
            inner join BRANCH_V2 branch on items.BRANCH = branch.BRANCHNUMBER
            inner join BRANCH_V2 branch3 on patron.PREFERRED_BRANCH = branch3.BRANCHNUMBER
            inner join LOCATION_V2 loc on items.LOCATION = loc.LOCNUMBER

               inner join branch_v2 branch2 on patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER
               inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
               inner join BTY_V2 btype on patron.bty = btype.BTYNUMBER
             -- inner join SYSTEMCODEVALUES_V2 syscodes on trans.TRANSACTIONTYPE = syscodes.CODEVALUE
      where
          Items.status like 'C%' AND
          history.NOTICETYPE ='CO' and
            --trunc(trans.SYSTEMTIMESTAMP) > trunc(sysdate)-4 and
             trunc(PROCESSEDDATE)=trunc(sysdate)-3 and
          trunc(items.DUEDATE) = trunc(sysdate)
        and btycode != 'LIBUSE'
     order by
          history.item
;
-- Generate list to Receive 3 Days Prior/Coming Due. Use TXLOG_V2

select distinct
            --NOTICEHISTORYID,
--             NOTICEID,
--           --   history.CREATIONDATE,
--             -- RECEIPTID,
--             history.CREATION'S,
--             PROCESSEDDATE,
--              trunc(items.duedate) DueDate,
--              items.status,
--             -- history.EMAIL,
  trans.TRANSACTIONTYPE,
  trunc(trans.TXTRANSDATE),
  trans.ITEMSTATUS,
  --trans.ITEMLOCATION,
         patron.FIRSTNAME,
             Patron.EMAIL,
             patron.PATRONGUID,
             bib.AUTHOR,
             bib.TITLE,
             bib.ISBN,
             trunc(items.duedate) DueDate,
             trunc(trans.TXDUEORNOTNEEDEDAFTERDATE)  dueNotNeeded,
             branch2.BRANCHNAME                   homebranch,
             branch3.BRANCHNAME                   PickupLocation,
             trunc(trans.TXTRANSDATE)               transdate,
             branch.BRANCHNAME                    CheckoutLocation,
             loc.LOCNAME,

             --'billtotal' as BillTotal,
             Items.item ,
             'Courtesy' as NoticeType,
              syscodes.CODEDESCRIPTION
               from item_v2 items
               inner join TXLOG_V2 trans on items.item = trans.item
               inner join PATRON_V2 patron on patron.patronid = trans.PATRONID
               inner join BBIBMAP_V2 bib on items.bid = bib.BID
            --inner join NOTICES_V2 notices on items.item = notices.ITEM
            --inner join NOTICEHISTORY_V2 history on (history.ITEM = items.item)
            --inner join CARLREPORTS.SYSTEMNOTICECODES_V2 codes on codes.CODE = notices.NOTICETYPE

            inner join BRANCH_V2 branch on trans.ITEMBRANCH = branch.BRANCHNUMBER
            inner join BRANCH_V2 branch3 on trans.TXPICKUPBRANCH = branch3.BRANCHNUMBER
            inner join LOCATION_V2 loc on trans.ITEMLOCATION = loc.LOCNUMBER
            inner join branch_v2 branch2 on patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER
            inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
            inner join BTY_V2 btype on patron.bty = btype.BTYNUMBER
            inner join SYSTEMCODEVALUES_V2 syscodes on trans.TRANSACTIONTYPE = syscodes.CODEVALUE
      where
          Items.status like 'C%' AND
          btype.BTYCODE = 'STFBRW' AND
          --trans.itemstatus like 'C%' and
         -- trunc(trans.TXTRANSDATE)>= (trunc(SYSDATE)  - 30 ) AND
          --history.NOTICETYPE ='CO' and
          (trans.TRANSACTIONTYPE = 'C' or trans.TRANSACTIONTYPE='CH' or
           trans.TRANSACTIONTYPE = 'CT'
            or trans.TRANSACTIONTYPE='RN') AND
          -- trunc(PROCESSEDDATE)=trunc(sysdate)-3 and
          trunc(items.DUEDATE) <= trunc(sysdate) + 4 AND
         btycode != 'LIBUSE'
     order by trunc(trans.TXTRANSDATE) , trunc(items.DUEDATE) desc
;

-- Use TRANSITEM_V2 instead of TXLOG_V2
select
            --NOTICEHISTORYID,
--             NOTICEID,
--           --   history.CREATIONDATE,
--             -- RECEIPTID,
--             history.CREATIONDATE,
--             PROCESSEDDATE,
--              trunc(items.duedate) DueDate,
--              items.status,
--             -- history.EMAIL,
 syscodes.CODEDESCRIPTION,
  trans.RENEW,
 trans.LASTACTIONDATE,
 --trans.RETURNDATE,
-- trunc(trans.TRANSDATE),
-- trunc(trans.DUEORNOTNEEDEDAFTERDATE),
-- trunc(trans.LASTACTIONDATE),
         patron.FIRSTNAME,
             Patron.EMAIL,
             patron.PATRONGUID,
             bib.AUTHOR,
             bib.TITLE,
             bib.ISBN,
             trunc(items.duedate) DueDate,
             branch2.BRANCHNAME                   homebranch,
             branch3.BRANCHNAME                   PickupLocation,
             trunc(trans.TRANSDATE)               transdate,
             branch.BRANCHNAME                    CheckoutLocation,
             loc.LOCNAME,
             trunc(trans.DUEORNOTNEEDEDAFTERDATE) pickupby,
             --'billtotal' as BillTotal,
             Items.item ,
             'Courtesy' as NoticeType
               from TRANSITEM_V2 trans
               inner join item_v2 items on items.item = trans.item
               inner join PATRON_V2 patron on patron.patronid = trans.PATRONID
               inner join BBIBMAP_V2 bib on items.bid = bib.BID
            --inner join NOTICES_V2 notices on items.item = notices.ITEM
            --inner join NOTICEHISTORY_V2 history on (history.ITEM = items.item)
            --inner join CARLREPORTS.SYSTEMNOTICECODES_V2 codes on codes.CODE = notices.NOTICETYPE

            inner join BRANCH_V2 branch on trans.BRANCH = branch.BRANCHNUMBER
            inner join BRANCH_V2 branch3 on trans.PICKUPBRANCH = branch3.BRANCHNUMBER
            inner join LOCATION_V2 loc on trans.LOCATION = loc.LOCNUMBER
            inner join branch_v2 branch2 on patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER
            inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
            inner join BTY_V2 btype on patron.bty = btype.BTYNUMBER
             inner join SYSTEMCODEVALUES_V2 syscodes on trans.TRANSCODE = syscodes.CODEVALUE
      where
          Items.status like 'C%' and
          --trans.itemstatus like 'C%' and
       --
          --history.NOTICETYPE ='CO' and
         (trans.TRANSCODE = 'C' or trans.TRANSCODE='CH'
              or trans.TRANSCODE = 'CT' or trans.TRANSCODE = 'RN') AND
            -- trunc(PROCESSEDDATE)=trunc(sysdate)-3 and
         trunc(items.DUEDATE)<=trunc(sysdate) + 5  and
         btycode != 'LIBUSE'
     order by trunc(items.DUEDATE) desc
;

-- 04/17/2023 Patron Point extract format, Items Notice History, Patrons.
-- Generate list of 35 Day Overdue recipients that have received the 21 Days Overdue Bill Notice

select
             distinct NOTICEHISTORYID,
                      history.NOTICETYPE,
             --NOTICEID,
             history.CREATIONDATE,
--             -- RECEIPTID,
--             history.CREATIONDATE,
            PROCESSEDDATE,
            trunc(items.duedate) DueDate,
--              items.status,
--             -- history.EMAIL,
--              codes.DESCRIPTION,
             patron.FIRSTNAME,
             --Patron.EMAIL,
             --patron.PATRONGUID,
             bib.AUTHOR,
             bib.TITLE,
             bib.ISBN,
             trunc(items.duedate) DueDate,
             branch2.BRANCHNAME                   homebranch,
             branch3.BRANCHNAME                   PickupLocation,
             trunc(trans.TRANSDATE)               checkoutdate,
             branch.BRANCHNAME                    CheckoutLocation,
             loc.LOCNAME,
             trunc(trans.DUEORNOTNEEDEDAFTERDATE) pickupby,
             --'billtotal' as BillTotal,
             Items.item ,
             'OVERDUE5' as NoticeType,
              syscodes.CODEDESCRIPTION
               from item_v2 items
               inner join BBIBMAP_V2 bib on items.bid = bib.BID
               inner join TRANSITEM_V2 trans on items.item = trans.item
               --inner join NOTICES_V2 notices on items.item = notices.ITEM


            inner join NOTICEHISTORY_V2 history on (history.ITEM = items.item)
            inner join CARLREPORTS.SYSTEMNOTICECODES_V2 codes on codes.CODE = history.NOTICETYPE
            inner join PATRON_V2 patron on patron.patronid = history.PATRONID
            inner join BRANCH_V2 branch on trans.BRANCH = branch.BRANCHNUMBER
            inner join BRANCH_V2 branch3 on trans.PICKUPBRANCH = branch3.BRANCHNUMBER
            inner join LOCATION_V2 loc on trans.LOCATION = loc.LOCNUMBER

               inner join branch_v2 branch2 on patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER
               inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
               inner join BTY_V2 btype on patron.bty = btype.BTYNUMBER
              inner join SYSTEMCODEVALUES_V2 syscodes on trans.TRANSCODE = syscodes.CODEVALUE
      where
          Items.status like 'L%' AND
          history.NOTICETYPE ='L1'
          and
 trunc(PROCESSEDDATE)<=trunc(sysdate)-14 and
  trunc(items.DUEDATE) <= trunc(sysdate)-35
        and btycode != 'LIBUSE'
     order by trunc(history.CREATIONDATE) desc, trunc(items.DUEDATE) desc
;

-- 04/17/2023 Patron Point extract format, Items Notice History, Patrons.
-- Generate list of 35 Day Overdue recipients that have received the 21 Days Overdue Bill Notice

select
             distinct NOTICEHISTORYID,
                      history.NOTICETYPE,
             --NOTICEID,
             history.CREATIONDATE,
--             -- RECEIPTID,
--             history.CREATIONDATE,
            PROCESSEDDATE,
            trunc(items.duedate) DueDate,
--              items.status,
--             -- history.EMAIL,
--              codes.DESCRIPTION,
             patron.FIRSTNAME,
             --Patron.EMAIL,
             --patron.PATRONGUID,
             bib.AUTHOR,
             bib.TITLE,
             bib.ISBN,
             trunc(items.duedate) DueDate,
             branch2.BRANCHNAME                   homebranch,
             branch3.BRANCHNAME                   PickupLocation,
             trunc(trans.TRANSDATE)               checkoutdate,
             branch.BRANCHNAME                    CheckoutLocation,
             loc.LOCNAME,
             trunc(trans.DUEORNOTNEEDEDAFTERDATE) pickupby,
             --'billtotal' as BillTotal,
             Items.item ,
             'OVERDUE5' as NoticeType,
              syscodes.CODEDESCRIPTION
               from item_v2 items
               inner join BBIBMAP_V2 bib on items.bid = bib.BID
               inner join TRANSITEM_V2 trans on items.item = trans.item
               --inner join NOTICES_V2 notices on items.item = notices.ITEM


            inner join NOTICEHISTORY_V2 history on (history.ITEM = items.item)
            inner join CARLREPORTS.SYSTEMNOTICECODES_V2 codes on codes.CODE = history.NOTICETYPE
            inner join PATRON_V2 patron on patron.patronid = history.PATRONID
            inner join BRANCH_V2 branch on trans.BRANCH = branch.BRANCHNUMBER
            inner join BRANCH_V2 branch3 on trans.PICKUPBRANCH = branch3.BRANCHNUMBER
            inner join LOCATION_V2 loc on trans.LOCATION = loc.LOCNUMBER

               inner join branch_v2 branch2 on patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER
               inner join bst_v2 bstatus on bstatus.bst = patron.STATUS
               inner join BTY_V2 btype on patron.bty = btype.BTYNUMBER
              inner join SYSTEMCODEVALUES_V2 syscodes on trans.TRANSCODE = syscodes.CODEVALUE
      where
          Items.status like 'L%' AND
          history.NOTICETYPE ='L2'
          and
   trunc(PROCESSEDDATE) <=trunc(sysdate)-25 and
  trunc(items.DUEDATE) <= trunc(sysdate)-60
        and btycode != 'LIBUSE'
     order by trunc(history.CREATIONDATE) desc, trunc(items.DUEDATE) desc
;

select distinct udf.patronid, name from patron_v2 patron , UDFPATRON_V2 udf, UDFLABEL_V2 label
where udf.patronid=patron.PATRONID and udf.fieldid=4 and udf.valuename='HQ'
  and ( name not like '%3M%' ) ;


select trans.PATRONID, trans.item, trunc(item.DUEDATE), type.BTYCODE, patron.name, bib.TITLE
from TRANSITEM_V2 trans
inner join item_v2 item  on item.ITEM = trans.ITEM
inner join patron_v2 patron on trans.PATRONID = patron.PATRONID
inner join BTY_V2 type on patron.BTY = type.BTYNUMBER
inner join BBIBMAP_V2 bib on item.BID = bib.BID
where
    item.STATUS = 'C' AND
    trunc(item.DUEDATE) = trunc(CURRENT_DATE)+ 1  AND
    BTYCODE = 'STFBRW'

;
-- Find the ILL Items on the Hold Shelf
select bib.bid, item.item, transitem.patronid, medcode, btyp.BTYCODE, CALLNUMBER, item.status,trunc(statusdate), loccode,suppress ,bib.title from BBIBMAP_V2 bib
inner join item_v2 item on item.bid = bib.bid
inner join location_v2 loc on item.LOCATION = loc.LOCNUMBER
inner join TRANSITEM_V2 transitem on transitem.item = item.item
inner join patron_v2 patron on transitem.patronid = patron.PATRONID
inner join bty_v2 btyp on patron.bty = btyp.BTYNUMBER
inner join media_v2 media on media.mednumber = item.MEDIA

where medcode like 'ILL%' and
item.status like 'H%' and
( btyp.btycode like 'STF%' OR btyp.btycode='LIBUSE') and
trunc(statusdate) >= '07-JUL-23'
--and item.STATUS LIKE 'H%'
;

/*Automated Renewals for STFBRW Patrons (optionally opted in for email receipts) */
select distinct transitem.patronid , item, site username, --branchcode DSC,
                renew,MEDCODE, trunc(DUEORNOTNEEDEDAFTERDATE) due,trunc(transdate)
from transitem_v2 transitem
inner join patron_v2 patron on patron.PATRONID =transitem.PATRONID
inner join bty_v2 btyp on transitem.BORROWERTYPE = btyp.BTYNUMBER
inner join MEDIA_V2 media on transitem.media = media.MEDNUMBER
inner join BRANCH_V2 branch on transitem.BRANCH = branch.BRANCHNUMBER
where
transcode in ('C', 'O')
--and btyp.BTYCODE='STFBRW'
and renew >='1'
and trunc(transdate) ='24-AUG-23'
--and patron.EMAILRECEIPTS = 'Y'
and btyp.BTYCODE = 'STFBRW'
group by transitem.patronid , item, site, renew,medcode, trunc(DUEORNOTNEEDEDAFTERDATE) ,trunc(transdate)
order by trunc(transdate)
;

/*Automated Renewals for STFBRW Patrons (optionally opted in for email receipts) */
select distinct patron.FirstName, /*'wil.blake@fcpl.org' as Email,*/
                patron.EMAIL,
      '240-415-8336' as Mobile   ,'email' as Method, patron.PATRONID , patron.Language,bib.Author,bib.Title,
      -- transitem.item,
       bib.ISBN, trunc(transitem.DUEORNOTNEEDEDAFTERDATE) as DueDate, branch2.BRANCHCODE as HomeLibrary,'' as PickupLocation,
     '' as PickupLocationLabel, trunc(transitem.TRANSDATE) as CheckoutDate,branch.BRANCHCODE as CheckoutLocation ,loc.LOCCODE as ItemLocation,trunc(transdate)+10 pickupby,
      '' as ChargeReason,Item.PRICE as ReplacementCost,'0.00' as ProcessingFee,'0.00' As OverdueCharge,
       '0.00' as Total,'0.00' as TotalDue,transitem.item as TransactionID,'autorenew' as NoticeType
from transitem_v2 transitem
inner join patron_v2 patron on patron.PATRONID =transitem.PATRONID
inner join bty_v2 btyp on transitem.BORROWERTYPE = btyp.BTYNUMBER
inner join item_v2 item on transitem.item = item.ITEM
inner join LOCATION_V2 loc on item.LOCATION = loc.LOCNUMBER
inner join BBIBMAP_V2 bib on item.bid = bib.BID
inner join MEDIA_V2 media on transitem.media = media.MEDNUMBER
inner join BRANCH_V2 branch on transitem.BRANCH = branch.BRANCHNUMBER
inner join BRANCH_V2 branch2 on Patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER

where
transcode in ('C', 'O')
--and btyp.BTYCODE='STFBRW'
and renew >='1'
and trunc(transdate) >='11-Sep-23'
--and patron.EMAILRECEIPTS = 'Y'
and btyp.BTYCODE = 'STFBRW'
--group by transitem.patronid , item, site, renew,medcode, trunc(DUEORNOTNEEDEDAFTERDATE) ,trunc(transdate)
order by trunc(transdate)
;

-- Staff Borrower email not county email
select
    patron.PATRONID,
       patron.NAME,
       patron.EMAIL
from  PATRON_V2 patron
inner join bty_v2 btyp on patron.BTY = btyp.BTYNUMBER

inner join BRANCH_V2 branch2 on Patron.PREFERRED_BRANCH = branch2.BRANCHNUMBER

where
btyp.BTYCODE = 'STFBRW' AND
upper(patron.email) not like ('%FREDERICKCOUNTYMD.GOV')
--group by

;
