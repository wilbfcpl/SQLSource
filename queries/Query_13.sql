SELECT
bm.bid,
i.item,
bm.author,
bm.title,
bm.publishingdate,
i.cnlabel,
i.cn as CALLNUMBER,
i.status,
CASE
    WHEN i.status IN ('C', 'CT') AND ti.transcode IN ('O' , 'L') THEN s.codedescription
    ELSE si.description
END as STATUS,
i.price,
br.branchname,
l.locname as LOCATION,
m.medname as MEDIA,
i.circhistory as CIRCULATIONS,
i.cumulativehistory as CUMULATIVECIRCULATIONS,
i.statusdate,
bm.isbn,
i.creationdate,
i.editdate
FROM item_v2 i
-- JOIN institution_v2 inst ON (i.instbit = inst.instbit)
JOIN BBIBMAP_V2 bm ON (i.BID = bm.BID AND i.INSTBIT = bm.INSTBIT AND bm.FOLDER = 0)
JOIN systemitemcodes_v2 si ON (si.code = i.status AND si.instbit = i.instbit AND si.type = i.type)
JOIN location_v2 l ON (i.instbit = l.instbit AND i.location = l.locnumber)
JOIN media_v2 m ON (i.instbit = m.instbit AND i.media = m.mednumber)
LEFT OUTER JOIN transitem_v2 ti ON (ti.occur = 0 AND i.item = ti.item AND i.instbit = ti.instbit)
LEFT OUTER JOIN systemcodevalues_v2 s ON (s.codetype = 4 AND s.codevalue = ti.transcode) -- for transit items
JOIN branch_v2 br ON (
                        (i.status in ('H', 'HT') AND i.instbit = br.instbit AND ti.branch = br.branchnumber)
                        OR
                        (i.status NOT IN ('H' , 'HT') AND i.instbit = br.instbit and i.branch = br.branchnumber)
    )
WHERE
br.branchnumber = 1
and (
i.statusdate < TO_DATE('2025/07/23 00:00:00','YYYY/MM/DD HH24:MI:SS') -- For newly updated items (withdrawn, lost or missing items)
AND i.statusdate >= TO_DATE('1970/01/01 00:00:00','YYYY/MM/DD HH24:MI:SS') -- For newly updated items (withdrawn, lost or missing items)
)
/*
OR  i.creationdate < TO_DATE('2025/07/01 00:00:00','YYYY/MM/DD HH24:MI:SS')-- For newly added items
*/

-- Birthdate explorations
SELECT patronid, name, birthdate,
       cast (to_char(birthdate,'YYYYMMDD') as integer) as bd_int
,       to_number(to_char(to_date( '19000101','YYYYMMDD'),'YYYYMMDD')) as bd_min
FROM patron_v2
WHERE birthdate IS NOT NULL
  AND (birthdate < TO_DATE('1900-01-01', 'YYYY-MM-DD')
       OR birthdate > TO_DATE('2100-12-31', 'YYYY-MM-DD'));


-- More date explorations
select i.item, to_char(i.statusdate,'YYYYMMDD') from item_v2 i
where i.statusdate < TO_DATE('2025/07/23','YYYY/MM/DD') and
        i.statusdate >= TO_DATE('1970/01/01','YYYY/MM/DD') ;

select i.item, to_char(i.statusdate,'YYYYMMDD') as status from item_v2 i
where
         i.statusdate > CURRENT_DATE OR
        i.statusdate < TO_DATE('19700101','YYYYMMDD')
order by i.statusdate desc;

-- For CB
select
it.item,

branch_v2.branchcode "current branch",
location_v2.loccode "current loc",
--it.location,
--it.owningbranch,
br2.branchcode owningbranch,
--it.owninglocation,
loc2.loccode owninglocation,
media_v2.medname,
it.cn
from item_v2 it
join location_v2 on it.location=location_v2.locnumber
join location_v2 loc2 on it.owninglocation=loc2.locnumber
join branch_v2 on it.branch=branch_v2.branchnumber
join branch_v2 br2 on it.owningbranch=br2.branchnumber
join media_v2 on it.media=media_v2.mednumber
where it.status not in ('SM','L','LT','T','TT', 'SW')
--and br2.branchname != branch_v2.branchname
order by it.owningbranch, it.owninglocation ;

-- Latest Update from FCPS, e.g. trunc(regdate)='30-NOV-22'
select student.patronid, student.firstname, student.lastname, student.middlename,udf.VALUENAME grade,
       street1, student.city1, student.state1, student.zip1, student.status,trunc(sysdate) edittime,btycode, branchcode,
       trunc(regdate),trunc(editdate), trunc(actdate)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    where branchcode ='SSL' and udf.FIELDID='3' and
         -- (trunc(regdate) = '26-APR-23' OR
          trunc(regdate) >= '01-JUL-25' --)
    order by student.lastname ;

select count(student.patronid)
    from patron_v2 student
    inner join bty_v2 type on student.bty = type.BTYNUMBER inner join branch_v2 branch on student.REGBRANCH = branch.BRANCHNUMBER
    inner join UDFPATRON_V2 udf on student.patronid=udf.patronid
    where branchcode ='SSL' and udf.FIELDID='3' and
         -- (trunc(regdate) = '26-APR-23' OR
          trunc(regdate) >= '01-JUL-25' --)
    order by student.lastname ;

select distinct patron.patronid, bounce."DNC Comment",upper(patron.email),upper(bounce.email) as bounceemail,
       case emailnotices when 0 then 'No Email Notices'
                         when 1 then 'Email Notices'
                         when 2 then 'bounced email'
                         when 3 then 'opt out'
                         else 'Unknown' end as emailnotices,
       patron.status,note.text notetext, bty.btycode, name from patron_v2 patron
inner join bty_v2 bty on (patron.bty = bty.btynumber)
inner join patronnotetext_v2 note on patron.patronid=note.refid
inner join ppbcomm bounce
    on ( upper(patron.email) = upper(bounce.email) or
       patron.patronid=bounce."Patron ID (Barcode)"
        )
where patron.emailnotices=1 ;
  --and note.notetype=900 ;

-- Patron Reg. Won't find students using txlog. Use patron table below.
  select  log.patronid patron, bty.BTYCODE patrontype,
           patron.zip1 zipcode,
            --patron.name patronname,
           trunc(log.SYSTEMTIMESTAMP) regdate,
             -- branch.branchcode defaultbranch,
              branch2.branchcode regbranch
            from txlog_v2 log
                        inner join patron_v2 patron on log.PATRONID=patron.PATRONID
                        inner join bty_v2 bty on patron.BTY=bty.BTYNUMBER
               --         inner join branch_v2 branch on patron.defaultbranch =branch.BRANCHNUMBER
                        inner join branch_v2 branch2 on patron.regbranch =branch2.BRANCHNUMBER
     where
         trunc(log.systemtimestamp)  between (trunc(sysdate,'MM')  )  and sysdate
       and TRANSACTIONTYPE='PR' ;

-- Patron Reg alternative finds students using patron table
  select patron.patronid patron,
          bty.BTYCODE patrontype,
            patron.zip1 zipcode,
           -- patron.name patronname,
            trunc(patron.regdate) regdate,
           -- trunc(sysdate,'MM') month,
           -- trunc(sysdate) today,
            branch.branchcode defaultbranch
          -- branch2.branchcode regbranch
            --    patron.userid userid
            from patron_v2 patron
                inner join bty_v2 bty on patron.BTY=bty.BTYNUMBER
                inner join branch_v2 branch on patron.defaultbranch =branch.BRANCHNUMBER
               -- inner join branch_v2 branch2 on patron.regbranch =branch2.BRANCHNUMBER
               --     inner join UDFPATRON_V2 udf on patron.patronid=udf.patronid
               --     inner join UDFLABEL_V2 label on label.FIELDID = udf.FIELDID

    where
     branch.branchcode NOT LIKE '%SSL%'
       --and branch2.branchcode!=branch.branchcode
      -- and bty.btycode='STUDNT'
      -- and upper(label.label)='GRADE'
      -- and
    -- and bty.btycode='STUDNT'
      -- and upper(label.label)='GRADE'
       and
   trunc(regdate)  between (trunc(sysdate,'MM')  )  and trunc(sysdate)
--  trunc(regdate)  between (trunc(sysdate,'MM')  )   and '15-SEP-25'

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
         and trunc(regdate) between '31-AUG-25' and '01-OCT-25'

    order by student.lastname ;

-- Patron Reg alternative does not select students
select count(patron.patronid) patroncount,
          bty.BTYCODE patrontype,
            trunc(patron.regdate) regdate,
            branch.branchcode defaultbranch
            from patron_v2 patron
                inner join bty_v2 bty on patron.BTY=bty.BTYNUMBER
                inner join branch_v2 branch on patron.defaultbranch =branch.BRANCHNUMBER
    where
     bty.btycode NOT IN ('GRAD','ILL','INST','LIBUSE','STFBRW','STUDNT','TEMP') and
     trunc(regdate)  between (trunc(sysdate,'MM')  )  and trunc(sysdate)
    -- trunc(regdate)  between ('01-SEP-25'  )  and trunc(sysdate)

group by   bty.BTYCODE, trunc(patron.regdate), branch.branchcode
order by regdate desc, branch.branchcode asc
        ;

select count(patron.patronid) patroncount,sum(count(patron.patronid)) over (order by trunc(patron.regdate)) runningtotal,
            trunc(patron.regdate) regdate
            from patron_v2 patron
                inner join bty_v2 bty on patron.BTY=bty.BTYNUMBER
                inner join branch_v2 branch on patron.defaultbranch =branch.BRANCHNUMBER
    where
    bty.btycode NOT IN ( 'GRAD','ILL','INST','LIBUSE','STFBRW','STUDNT','TEMP'  )  and
   trunc(regdate)  between (trunc(sysdate,'MM')  )  and trunc(sysdate)

group by  trunc(patron.regdate)
order by regdate desc
;
-- Last Month New Cards excluding students
select count(patron.patronid) patroncount,sum(count(patron.patronid)) over (order by trunc(patron.regdate)) runningtotal,
            trunc(patron.regdate) regdate
            from patron_v2 patron
                inner join bty_v2 bty on patron.BTY=bty.BTYNUMBER
                inner join branch_v2 branch on patron.defaultbranch =branch.BRANCHNUMBER
    where
    bty.btycode NOT IN ( 'GRAD','ILL','INST','LIBUSE','STFBRW','STUDNT','TEMP'  )  and
   trunc(regdate)  between ADD_MONTHS(trunc(sysdate,'MM') ,-1 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,-1 ))

group by  trunc(patron.regdate)
order by regdate desc
;
-- Last Month New Cards excluding students
select count(patron.patronid) patroncount,sum(count(patron.patronid)) over (order by trunc(patron.regdate)) runningtotal,
            trunc(patron.regdate) regdate
            from patron_v2 patron
                inner join bty_v2 bty on patron.BTY=bty.BTYNUMBER
                inner join branch_v2 branch on patron.defaultbranch =branch.BRANCHNUMBER
    where
    bty.btycode NOT IN ( 'GRAD','ILL','INST','LIBUSE','STFBRW','STUDNT')  and
   trunc(regdate)  between ADD_MONTHS(trunc(sysdate,'MM') ,-1 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,-1 ))

group by  trunc(patron.regdate)
order by regdate desc
;
-- Up to :MonthsBack Months
select count(patron.patronid) patroncount,sum(count(patron.patronid)) over (order by trunc(patron.regdate)) runningtotal,
            trunc(patron.regdate) regdate
            from patron_v2 patron
                inner join bty_v2 bty on patron.BTY=bty.BTYNUMBER
                inner join branch_v2 branch on patron.defaultbranch =branch.BRANCHNUMBER
    where
    bty.btycode NOT IN ( 'GRAD','ILL','INST','LIBUSE','STFBRW','STUDNT','TEMP'  )  and
   trunc(regdate)  between ADD_MONTHS(trunc(sysdate,'MM') ,:MonthsBack ) and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM'), -1 ))
group by  trunc(patron.regdate)
order by regdate desc
;
-- multibyte name search for webreg.
select p.patronid, p.patronguid,p.status, substrb(p.name,1), trunc(p.birthdate), p.patronid, b.btycode,
  trunc(p.regdate) AS Register,   trunc(p.actdate) AS Active,
  trunc(p.sactdate) AS SelfServe,   trunc(p.editdate) AS Edit
from patron_v2 p, bty_v2 b
where
       length(p.name)<lengthb(p.name) AND
p.bty=b.btynumber and upper(b.btycode) ='WEBREG'

;
SELECT VALUE AS DATABASE_CHARACTER_SET
FROM NLS_DATABASE_PARAMETERS
WHERE PARAMETER = 'NLS_CHARACTERSET';

SELECT VALUE AS LENGTH_SEMANTICS
FROM NLS_DATABASE_PARAMETERS
WHERE PARAMETER = 'NLS_LENGTH_SEMANTICS';

-- In Oracle, the VARCHAR2 data type is used to store variable-length character strings. When dealing with multibyte characters in VARCHAR2, there are a few key points to understand:
--
-- Key Concepts:
--
--
-- Multibyte Characters:
--
-- Oracle supports multibyte character sets (e.g., UTF-8, AL32UTF8) that allow storage of characters requiring more than one byte (e.g., Chinese, Japanese, Korean, emojis).
-- A single character may occupy 1 to 4 bytes depending on the character set.

--
-- VARCHAR2 Size Declaration:
--
-- When defining a VARCHAR2 column, you can specify its size in bytes or characters:
--
-- VARCHAR2(n BYTE): Limits the column to n bytes.
-- VARCHAR2(n CHAR): Limits the column to n characters, regardless of how many bytes each character requires.
--
-- The default behavior depends on the NLS_LENGTH_SEMANTICS parameter:
--
-- BYTE: Default if not explicitly set.
-- CHAR: Must be explicitly enabled for character semantics.

-- Storage Implications:
--
-- If you use BYTE semantics, multibyte characters may reduce the number of characters that can be stored in the column.
-- If you use CHAR semantics, the column will store the specified number of characters, regardless of their byte size.
--
-- Patron Registation Past Month
select trunc(patron.regdate) regdate, branch.branchcode,
        sum(count(patron.patronid)) over ( partition by patron.defaultbranch) indivbranchdailytotal,
        sum(count(patron.patronid)) over ( order by trunc(patron.regdate) range between 1 preceding and current row) allbrdailytotal,
        btycode,
         sum(count(patron.patronid)) over ( partition by btycode  order by trunc(patron.regdate)
            range between 1 preceding and current row) allbtydailytotal,
        branch.branchcode,
        btycode,
        sum(count(patron.patronid)) over ( partition by branchcode, btycode  order by trunc(patron.regdate)
            range between 1 preceding and current row) brbtydailytotal,
        sum(count(patron.patronid)) over ( order by trunc(patron.regdate)) runningtotal
        from patron_v2 patron
                inner join bty_v2 bty on patron.BTY=bty.BTYNUMBER
                inner join branch_v2 branch on patron.defaultbranch =branch.BRANCHNUMBER
    where
    bty.btycode NOT IN ( 'GRAD','ILL','INST','LIBUSE','STFBRW','STUDNT')  and
   trunc(regdate) between ADD_MONTHS(trunc(sysdate,'MM') ,-1 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,-1 ))

group by trunc(patron.regdate) , patron.defaultbranch,branch.branchcode,btycode
order by regdate desc, branch.branchcode asc;

select trunc(patron.regdate) regdate, branch.branchcode,
        sum(count(patron.patronid)) over ( partition by patron.defaultbranch) indivbranchdailytotal,
        sum(count(patron.patronid)) over ( order by trunc(patron.regdate) range between 1 preceding and current row) allbrdailytotal,
        btycode,
         sum(count(patron.patronid)) over ( partition by btycode  order by trunc(patron.regdate)
            range between 1 preceding and current row) allbtydailytotal,
        sum(count(patron.patronid)) over ( partition by branchcode, btycode  order by trunc(patron.regdate)
            range between 1 preceding and current row) brbtydailytotal,
        sum(count(patron.patronid)) over ( order by trunc(patron.regdate)) runningtotal
        from patron_v2 patron
                inner join bty_v2 bty on patron.BTY=bty.BTYNUMBER
                inner join branch_v2 branch on patron.defaultbranch =branch.BRANCHNUMBER
    where
    bty.btycode NOT IN ( 'GRAD','ILL','INST','LIBUSE','STFBRW','STUDNT')  and
   trunc(regdate) between ADD_MONTHS(trunc(sysdate,'MM') ,-1 )  and LAST_DAY(ADD_MONTHS(trunc(sysdate,'MM') ,-1 ))

group by trunc(patron.regdate) , patron.defaultbranch,branch.branchcode,btycode
order by regdate desc, branch.branchcode asc
;
SELECT od.bid, i.bid, od.vendorcode, od.status, od.invoicenumber,od.purchaseorder, i.statusdate, i.item, od.fund, od.statusdate
FROM orderdetail_v2 od
LEFT JOIN item_v2 i on i.bid = od.bid
WHERE od.vendorcode LIKE 'BDRP'
AND i.item LIKE 'C%'
 AND od.statusdate > to_date ('2025-10-21', 'YYYY-MM-DD');