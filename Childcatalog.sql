--CarlX Queries for the Childrens Collections Changes



-- Perl Script for Items UpdateItem.pl expects 
-- item, bid, old call number, new call number

-- Beginning to Read, with diagnostics
select item.item, bib.bid,  callnumber "bib call",  item.cn "item call", Concat ('ER ', substr(item.cn,3,(instr(callnumber,'-')-4))) newcall, item.editdate, item.userid, author , title,media.medcode, location.loccode , item.status, branch.branchcode from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where bib.callnumber like '%BEGINNING TO READ';

-- Perl Script UpdateItem.pl expects item, bid, old call number, new call number
select item.item, bib.bid,  item.cn "item call", Concat ('ER ', substr(item.cn,3,(instr(item.cn,'-')-4))) newcall, title, media.medcode media, location.loccode, item.status, branch.branchcode from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where bib.callnumber like '%BEGINNING TO READ';

-- Change new Item cns back to old. Excpects the Title call number to be the old one
-- Use the Title Call Number as base for string manipulation to create the New/Old Item Call Number

select item.item, bib.bid,  Concat(Concat ('E ', substr(item.cn,4)), ' - BEGINNING TO READ' ) newcall , callnumber "bib call" , item.cn "item call",title, media.medcode media, location.loccode, item.status, branch.branchcode from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where bib.callnumber like '%BEGINNING TO READ';

--Global Marc Update (GMU) Only needs BIDs. Can then use Macro
select bib.bid,  Concat ('ER ', substr(callnumber,3,(instr(callnumber,'-')-4))) newcall , callnumber "bib call" ,title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join formatterm_v2 form on bib.format=form.formattermid where bib.callnumber like '%BEGINNING TO READ';
-- Testing the Marc Edit Macro
select bib.bid, callnumber "bib call" ,title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join formatterm_v2 form on bib.format=form.formattermid where bib.callnumber like 'ER %';

select bib.bid, callnumber "bib call" ,bib.title,bib.author, bib.recordtype, bib.bibtype, bib.hiddentype, bib.isbn,bib.language,bib.eresource, form.formattext from bbibmap_v2 bib  inner join formatterm_v2 form on bib.format=form.formattermid where bib.callnumber like 'ER%';
select bib.bid, callnumber "bib call" ,bib.title,bib.author, bib.recordtype, bib.bibtype, bib.hiddentype, bib.isbn,bib.language,bib.eresource, form.formattext from bbibmap_v2 bib  inner join formatterm_v2 form on bib.format=form.formattermid where bib.callnumber like '%BEGINNING TO READ';

-- Fix the double dash
select bib.bid, callnumber "bib call" ,bib.title,bib.author, bib.recordtype, bib.bibtype, bib.hiddentype, bib.isbn,bib.language,bib.eresource, form.formattext from bbibmap_v2 bib  inner join formatterm_v2 form on bib.format=form.formattermid where bib.callnumber like '% - -  BEGINNING TO READ';

-- Update the Old Item cn to new. Will not make sense for reverting New back to Old.
select item.item, bib.bid,  callnumber "bib call",  item.cn "item call", Concat ('ER ', substr(item.cn,3,(instr(item.cn,'-')-4 ))) newcall, item.editdate, item.userid, author , title,media.medcode, location.loccode , item.status, branch.branchcode from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where bib.callnumber like '%BEGINNING TO READ' order by item.item;
-- Old to new.
-- Search item.cn or title.callnumber first. Old to New
--Item search for Bid call number bib.callnumber
select item.item, bib.bid,  callnumber "bib call",  item.cn "item cn", case when instr(item.cn ,'BEGINNING TO READ')>0 then Concat ('ER ', substr(item.cn,3,(instr(item.cn,'-')-4 ))) else '<same>' end "new item.cn", item.editdate, item.userid, author , title,media.medcode, location.loccode , item.status, branch.branchcode from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where bib.callnumber like '%BEGINNING TO READ' order by item.item;

-- Item search for Item Call Number item.cn
select item.item, bib.bid,  item.cn "olditemcn", case when instr(item.cn ,'BEGINNING TO READ')>0 then Concat ('ER ', substr(item.cn,3,(instr(item.cn,'-')-4 ))) else '<same>' end "newitem.cn", callnumber "bib call",item.editdate, item.userid, author , title,media.medcode, location.loccode , item.status, branch.branchcode from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like '%BEGINNING TO READ' order by item.item;
select item.item, bib.bid,  item.cn "olditemcn", case when instr(item.cn ,'BEGINNING TO READ')>0 then Concat ('ER ', substr(item.cn,3,(instr(item.cn,'-')-4 ))) else '<same>' end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like '%BEGINNING TO READ' order by item.item;

-- Keep Call Numbers in display if no change. For use with Perl utilities.
--Main query for Items with call number BEGINNING TO READ
select item.item, bib.bid,  item.cn "olditemcn", case when instr(item.cn ,'BEGINNING TO READ')>0 then 'ER '||  substr(item.cn,3,(instr(item.cn,'-')-4 )) else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like '%BEGINNING TO READ%' order by bib.bid;

-- Try to find the BEGINNING TO READ having trailing characters. Repair the old item.cn to work with the Perl filters
select item.item, bib.bid,  substr(item.cn,1,(instr(item.cn,'BEGINNING TO READ')+16)) "olditemcn", case when instr(item.cn ,'BEGINNING TO READ')>0 then Concat ('ER ', substr(item.cn,3,(instr(item.cn,'-')-4 ))) else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where REGEXP_LIKE(item.cn, 'E.+BEGINNING TO READ\s+') order by bib.bid;
select item.item, bib.bid,  substr(item.cn,1,(instr(item.cn,'BEGINNING TO READ')+16)) "olditemcn", case when instr(item.cn ,'BEGINNING TO READ')>0 then 'ER '||  substr(item.cn,3,instr(substr(item.cn,3,instr(item.cn,'BEGINNING')),' ')) else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like '%BEGINNING TO READ%' order by bib.bid;

-- Missing Items for bid 447
select item.item, bib.bid,  item.cn "olditemcn", length(item.cn),case when instr(item.cn ,'BEGINNING TO READ')>0 then Concat ('ER ', substr(item.cn,3,(instr(item.cn,'-')-4 ))) else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.item='21982008419149'  order by bib.bid;

-- Identify the Item Call Numbers with no dash in iten.cn
select item.item, bib.bid,  item.cn "olditemcn", case when instr(item.cn ,'BEGINNING TO READ')>0 then Concat ('ER ', substr(item.cn,3,(instr(item.cn,'-')-4 ))) else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where (item.cn like '%BEGINNING TO READ') and (item.cn not like '%-%')  order by item.item;

--Reverse column order of new call number/old call number for Undo script use
select item.item, bib.bid,  case when instr(item.cn ,'BEGINNING TO READ')>0 then Concat ('ER ', substr(item.cn,3,(instr(item.cn,'-')-4 ))) else item.cn end "newitem.cn" ,item.cn "olditemcn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like '%BEGINNING TO READ' order by item.item;


-- Query in order to Change Title call number via ITSI Global Iem Update. Want BID output first column in csv file for the ITSI Global MARC Update (GMU).
-- Main query for Title Call Number containging "BEGINNING TO READ" Search for bid/title Call Number bib.callnumber
select bib.bid, callnumber "bib call" ,case when instr(callnumber,'BEGINNING TO READ')>0 then 'ER ' || substr(callnumber,3,(instr(callnumber,'-')-4)) else callnumber end  "new bid call number", title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join formatterm_v2 form on bib.format=form.formattermid where bib.callnumber like '%BEGINNING TO READ%' order by bib.bid;

--From New Call Number convention back to Old. Looking for item.cn or bib.callnumber like ER %
-- Change from New back to Old

-- Item Search for Bib Call Number bib.callnumber like ER %
select item.item, bib.bid,  item.cn "item call",case when instr (item.cn,'ER ')>0 then Concat(Concat ('E ', substr(item.cn,4)), ' - BEGINNING TO READ' )  else '<same>' end "new item.cn" , callnumber "bib call" , title, media.medcode media, location.loccode, item.status, branch.branchcode from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where bib.callnumber like 'ER %' order by item.item;

-- Item Search for Item.cn like ER %
select item.item, bib.bid, item.cn "item call", case when instr (item.cn,'ER ')>0 then Concat(Concat ('E ', substr(item.cn,4)), ' - BEGINNING TO READ' )  else '<same>' end "new item.cn" ,title, media.medcode media, location.loccode, item.status, branch.branchcode from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like 'ER %' order by item.item;
select item.item, bib.bid, item.cn "item.cn", case when instr (item.cn,'ER ')>0 then 'E ' || substr(item.cn,4) || ' - BEGINNING TO READ'   else item.cn end "new item.cn"  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid where item.cn like 'ER %' order by item.item;
--Main query for Item Call Numbers in new format "ER <author>"
select item.item, bib.bid, item.cn "item.cn" ,case when instr (item.cn,'ER ')>0 then 'E ' || substr(item.cn,4) || ' - BEGINNING TO READ'   else item.cn end "new item.cn"  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid where item.cn like 'ER %' order by bib.bid;

--BIB. Want BID first for the ITSI Global MARC Update (GMU). Don't need items.
select bib.bid, item.item,  callnumber "bib call", case when instr (callnumber,'ER ')>0 then Concat(Concat ('E ', substr(callnumber,4)), ' - BEGINNING TO READ' ) else '<same>' end newcall  , item.cn "item call",title, media.medcode media, location.loccode, item.status, branch.branchcode from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where bib.callnumber like 'ER %' order by bib.bid;
-- Main query for Title Call Numbers in the new format "ER <author>"
select bib.bid,  callnumber "bib call", case when instr (callnumber,'ER ')>0 then 'E '||  substr(callnumber,4) || ' - BEGINNING TO READ'  else callnumber end newcall, title from bbibmap_v2 bib where bib.callnumber like 'ER %' order by bib.bid;


-- BIB Call Number ER, Item call number something else
select item.item, bib.bid, bib.callnumber "bib.call" , item.cn "item.cn" ,case when instr (item.cn,'ER ')>0 then 'E ' || substr(item.cn,4) || ' - BEGINNING TO READ'   else item.cn end "new item.cn"  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid where bib.callnumber like 'ER %' and item.cn not like 'ER %' order by bib.bid, item.item;
select item.item, bib.bid, bib.callnumber "bib.call" , item.cn "item.cn" ,case when instr (item.cn,'ER ')>0 then 'E ' || substr(item.cn,4) || ' - BEGINNING TO READ'   else item.cn end "new item.cn"  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid where bib.callnumber like '%BEGINNING TO%' OR item.cn like '%BEGINNING TO%' order by bib.bid, item.item;


-- Very Easy
select item.item, bib.bid,  item.cn "olditemcn",
       case when instr(item.cn ,'VERY EASY')>0 then 'BOARD '||  substr(item.cn,3,(instr(item.cn,'-')-4 ))
        else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where item.cn like '%VERY EASY' order by bib.bid;

-- Juvenile Mystery J MYS FIC

--Item
select item.item, bib.bid,  item.cn "olditemcn", case when instr(item.cn ,'J MYS FIC')>0 then 'J FIC '||  substr(item.cn,11) else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like '%J MYS FIC%' order by bib.bid;
select item.item, bib.bid,  item.cn "olditemcn", case when (instr(item.cn ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J FIC '||  substr(item.cn,7) end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where regexp_like (item.cn ,'^J MYS [^F][^I][^C]') order by bib.bid;
select item.item, bib.bid,  item.cn "olditemcn", case when instr(item.cn ,'J MYS')>0 then 'J FIC '||  substr(item.cn,instr(item.cn,'MYS ')+4) else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like '%J%MYS%' order by bib.bid;
select item.item, bib.bid,  item.cn "olditemcn", 
case 
when (instr(item.cn ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J FIC '||  substr(item.cn,7) 
when instr(item.cn ,'J CD BOOK MYS')>0 then 'J CD BOOK FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J GRAPHIC MYS')>0 then 'J GRAPHIC FIC' ||  substr(item.cn,14)
when instr(item.cn ,'J PL BOOK MYS')>0 then 'J PL FIC' ||  substr(item.cn,14)
when instr(item.cn ,'J PL MYS')>0 then 'J PL FIC' ||  substr(item.cn,9)
when instr(item.cn ,'J MYS FIC')>0 then 'J FIC' ||  substr(item.cn,10) 

else item.cn end 
"newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where regexp_like (item.cn ,'^J.+MYS.*') order by item.cn;

--Bib

select bib.bid,  
case 
when (instr(callnumber ,'J MYS')>0 and instr(callnumber, 'MYS FIC')=0) then 'J FIC '||  substr(callnumber,7) 
when instr(callnumber ,'J CD BOOK MYS')>0 then 'J CD BOOK FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J GRAPHIC MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J PL BOOK MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J PL MYS')>0 then 'J FIC' ||  substr(callnumber,9) 
when instr(callnumber ,'J MYS FIC')>0 then 'J FIC' ||  substr(callnumber,10) 

else callnumber end 
newcallnumber, callnumber,title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join formatterm_v2 form on bib.format=form.formattermid where regexp_like (callnumber ,'^J.+MYS.*') order by bid;
select callnumber,title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join formatterm_v2 form on bib.format=form.formattermid where regexp_like (callnumber ,'^J.+MYS.*') order by callnumber;

--08/26/2022 Review changes to make the call numbers J FIC
select bib.bid, item.editdate, item.item, item.cn "item call", callnumber,title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join item_v2 item on item.bid= bib.bid inner join formatterm_v2 form on bib.format=form.formattermid where ( regexp_like (callnumber ,'^J FIC.+$') or regexp_like (item.cn ,'^J FIC.+$') )and trunc (item.editdate,'DD' )='26-AUG-2022' order by callnumber;
select bib.bid, item.editdate, item.item, item.cn "item call", callnumber,title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join item_v2 item on item.bid= bib.bid inner join formatterm_v2 form on bib.format=form.formattermid where regexp_like (callnumber ,'^J FIC.+$') and item.cn is null and trunc (item.editdate,'DD' )='26-AUG-2022' order by callnumber;
select bib.bid, item.editdate, item.item, item.cn "item call", callnumber,title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join item_v2 item on item.bid= bib.bid inner join formatterm_v2 form on bib.format=form.formattermid where regexp_like (item.cn ,'^J FIC.+$') and callnumber is null and trunc (item.editdate,'DD' )='26-AUG-2022' order by callnumber;

-- !! BIB and Item Call Number in the same query.
--
--

select  bib.bid, item.item, callnumber "title call", item.cn "item call",
case 
when (instr(callnumber ,'J MYS')>0 and instr(callnumber, 'MYS FIC')=0) then 'J MYS' 
when instr(callnumber ,'J CD BOOK MYS')>0 then 'J CD BOOK MYS' 
when instr(callnumber ,'J GRAPHIC MYS')>0 then 'J GRAPHIC MYS' 
when instr(callnumber ,'J PL BOOK MYS')>0 then 'J PL BOOK MYS' 
when instr(callnumber ,'J PL MYS')>0 then 'J PL MYS' 
when instr(callnumber ,'J MYS FIC')>0 then 'J MYS FIC'
else 'No Patttern'
end 
Pattern_MARC092,
case 
when (instr(item.cn ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J MYS' 
when instr(item.cn ,'J CD BOOK MYS')>0 then 'J CD BOOK MYS'
when instr(item.cn ,'J GRAPHIC MYS')>0 then 'J GRAPHIC MYS' 
when instr(item.cn ,'J PL BOOK MYS')>0 then 'J PL BOOK MYS' 
when instr(item.cn ,'J PL MYS')>0 then 'J PL MYS' 
when instr(item.cn ,'J MYS FIC')>0 then 'J MYS FIC' 
else 'No Pattern'
end 
Pattern_ITEM,
case 
when (instr(callnumber ,'J MYS')>0 and instr(callnumber, 'MYS FIC')=0) then 'J FIC '||  substr(callnumber,7) 
when instr(callnumber ,'J CD BOOK MYS')>0 then 'J CD BOOK FIC' ||  substr(callnumber,14)
when instr(callnumber ,'J GRAPHIC MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J PL BOOK MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J PL MYS')>0 then 'J FIC' ||  substr(callnumber,9) 
when instr(callnumber ,'J MYS FIC')>0 then 'J FIC' ||  substr(callnumber,10) 
end 
NewMARC092,
case 
when (instr(item.cn ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J FIC '||  substr(item.cn,7) 
when instr(item.cn ,'J CD BOOK MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J GRAPHIC MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J PL BOOK MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J PL MYS')>0 then 'J FIC' ||  substr(item.cn,9) 
when instr(item.cn ,'J MYS FIC')>0 then 'J FIC' ||  substr(item.cn,10) 

end 
newItemCallNum,
title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join item_v2 item on item.bid= bib.bid inner join formatterm_v2 form on bib.format=form.formattermid where regexp_like (callnumber ,'^J.+MYS.*') order by callnumber;

-- Title only
select bib.bid, callnumber "title call",
case 
when (instr(callnumber ,'J MYS')>0 and instr(callnumber, 'MYS FIC')=0) then 'J MYS' 
when instr(callnumber ,'J CD BOOK MYS')>0 then 'J CD BOOK MYS' 
when instr(callnumber ,'J GRAPHIC MYS')>0 then 'J GRAPHIC MYS' 
when instr(callnumber ,'J PL BOOK MYS')>0 then 'J PL BOOK MYS' 
when instr(callnumber ,'J PL MYS')>0 then 'J PL MYS' 
when instr(callnumber ,'J MYS FIC')>0 then 'J MYS FIC'
else 'No Patttern'
end 
Pattern_MARC092,
case 
when (instr(callnumber ,'J MYS')>0 and instr(callnumber, 'MYS FIC')=0) then 'J FIC '||  substr(callnumber,7) 
when instr(callnumber ,'J CD BOOK MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J GRAPHIC MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J PL BOOK MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J PL MYS')>0 then 'J FIC' ||  substr(callnumber,9) 
when instr(callnumber ,'J MYS FIC')>0 then 'J FIC' ||  substr(callnumber,10) 
end 
NewMARC092,
title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join formatterm_v2 form on bib.format=form.formattermid where regexp_like (callnumber ,'^J.+MYS[^T].*') order by callnumber;


-- Titles not all items redux
select bib.bid, callnumber "title call",
case 
when (instr(callnumber ,'J MYS')>0 and instr(callnumber, 'MYS FIC')=0) then 'J MYS' 
when instr(callnumber ,'J CD BOOK MYS')>0 then 'J CD BOOK MYS' 
when instr(callnumber ,'J GRAPHIC MYS')>0 then 'J GRAPHIC MYS' 
when instr(callnumber ,'J PL BOOK MYS')>0 then 'J PL BOOK MYS' 
when instr(callnumber ,'J PL MYS')>0 then 'J PL MYS' 
when instr(callnumber ,'J MYS FIC')>0 then 'J MYS FIC'
else 'No Patttern'
end 
Pattern_MARC092,
case 
when (instr(item.cn ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J MYS' 
when instr(item.cn ,'J CD BOOK MYS')>0 then 'J CD BOOK MYS'
when instr(item.cn ,'J GRAPHIC MYS')>0 then 'J GRAPHIC MYS' 
when instr(item.cn ,'J PL BOOK MYS')>0 then 'J PL BOOK MYS' 
when instr(item.cn ,'J PL MYS')>0 then 'J PL MYS' 
when instr(item.cn ,'J MYS FIC')>0 then 'J MYS FIC' 
else 'No Pattern'
end 
Pattern_ITEM,
case 
when (instr(callnumber ,'J MYS')>0 and instr(callnumber, 'MYS FIC')=0) then 'J FIC '||  substr(callnumber,7) 
when instr(callnumber ,'J CD BOOK MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J GRAPHIC MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J PL BOOK MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J PL MYS')>0 then 'J FIC' ||  substr(callnumber,9) 
when instr(callnumber ,'J MYS FIC')>0 then 'J FIC' ||  substr(callnumber,10) 
end 
NewMARC092,
case 
when (instr(item.cn ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J FIC '||  substr(item.cn,7) 
when instr(item.cn ,'J CD BOOK MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J GRAPHIC MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J PL BOOK MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J PL MYS')>0 then 'J FIC' ||  substr(item.cn,9) 
when instr(item.cn ,'J MYS FIC')>0 then 'J FIC' ||  substr(item.cn,10) 

end 
newItemCallNum,
title,author, isbn,language,eresource, form.formattext from bbibmap_v2 bib inner join item_v2 item on item.bid= bib.bid inner join formatterm_v2 form on bib.format=form.formattermid 
where regexp_like (callnumber ,'^J.+MYS[^T].*') order by callnumber;

--Combined Search Item Call Number and Title Call Number
select  bib.bid, item.item, callnumber "title call", item.cn "item call",
case 
when (instr(callnumber ,'J MYS')>0 and instr(callnumber, 'MYS FIC')=0) then 'J MYS' 
when instr(callnumber ,'J CD BOOK MYS')>0 then 'J CD BOOK MYS' 
when instr(callnumber ,'J GRAPHIC MYS')>0 then 'J GRAPHIC MYS' 
when instr(callnumber ,'J PL BOOK MYS')>0 then 'J PL BOOK MYS' 
when instr(callnumber ,'J PL MYS')>0 then 'J PL MYS' 
when instr(callnumber ,'J MYS FIC')>0 then 'J MYS FIC'
else 'No Patttern'
end 
Pattern_MARC092,
case 
when (instr(item.cn ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J MYS' 
when instr(item.cn ,'J CD BOOK MYS')>0 then 'J CD BOOK MYS'
when instr(item.cn ,'J GRAPHIC MYS')>0 then 'J GRAPHIC MYS' 
when instr(item.cn ,'J PL BOOK MYS')>0 then 'J PL BOOK MYS' 
when instr(item.cn ,'J PL MYS')>0 then 'J PL MYS' 
when instr(item.cn ,'J MYS FIC')>0 then 'J MYS FIC' 
else 'No Pattern'
end 
Pattern_ITEM,
case 
when (instr(callnumber ,'J MYS')>0 and instr(callnumber, 'MYS FIC')=0) then 'J FIC '||  substr(callnumber,7) 
when instr(callnumber ,'J CD BOOK MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J GRAPHIC MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J PL BOOK MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
when instr(callnumber ,'J PL MYS')>0 then 'J FIC' ||  substr(callnumber,9) 
when instr(callnumber ,'J MYS FIC')>0 then 'J FIC' ||  substr(callnumber,10) 
end 
NewMARC092,
case 
when (instr(item.cn ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J FIC '||  substr(item.cn,7) 
when instr(item.cn ,'J CD BOOK MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J GRAPHIC MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J PL BOOK MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J PL MYS')>0 then 'J FIC' ||  substr(item.cn,9) 
when instr(item.cn ,'J MYS FIC')>0 then 'J FIC' ||  substr(item.cn,10) 

end 
newItemCallNum,
title,author, isbn,language,eresource, form.formattext 
from bbibmap_v2 bib inner join item_v2 item on item.bid= bib.bid inner join formatterm_v2 form on bib.format=form.formattermid
where ( regexp_like (item.cn ,'^J.+MYS[^T].*') or regexp_like (callnumber ,'^J.+MYS[^T].*') )order by callnumber, item.cn;

--Misc ItemID length less than 14
select bid,item, length(item), cn,media.medcode, type, suppress from item_v2 item inner join media_v2 media on item.media=media.mednumber where cn is not null and length(item) <14 ;

--Misc J FIC for Walkersville inquiry
select item.item, item.bid, item.cn,circhistory, holdshistory, title, author , branch.branchcode, location.loccode  
from bbibmap_v2 bib 
inner join bbibcontents_v2 marc on bib.bid = marc.bid 
inner join item_v2 item on bib.bid=item.bid 
--inner join itemnotetext_v2 text on item.item = text.refid
inner join media_v2 media on item.media = media.mednumber 
inner join branch_v2 branch on item.owningbranch=branch.branchnumber 
inner join location_v2 location on item.location=location.locnumber 
where regexp_like(item.cn, 'J FIC.+') and branch.branchcode='WAL' and 
marc.tagnumber='590' and
item.status='C' order by circhistory desc;

--Sept 22 , 2022 JMYS Snafu for J CD BOOK, J GRAPHIC MYS, J PL MYS, J PL BOOK MYS
--CD BOOK SNAFU
select snafu.bid, snafu.item_call itemcall, 
--bib.callnumber bibcall,
--marc.tagdata "old call", 
case 
when (instr(snafu.item_call ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J FIC '||  substr(item.cn,7) 
when instr(snafu.item_call ,'J CD BOOK MYS')>0 then 'J CD BOOK FIC' ||  substr(item.cn,14) 
when instr(snafu.item_call ,'J GRAPHIC MYS')>0 then 'J GRAPHIC FIC' ||  substr(item.cn,14) 
when instr(snafu.item_call ,'J PL BOOK MYS')>0 then 'J PL FIC' ||  substr(item.cn,14) 
when instr(snafu.item_call ,'J PL MYS')>0 then 'J PL FIC' ||  substr(item.cn,9) 
when instr(snafu.item_call,'J MYS FIC')>0 then 'J FIC' ||  substr(item.cn,10) 
end 
newItemCallNum,
bib.author,
branch.branchcode,
loc.loccode,
format.formattext,
bib.isbn,
snafu.title 
from JMYSITEMBID snafu
inner join bbibmap_v2 bib on snafu.bid = bib.bid
inner join formatterm_v2 format on bib.format = format.formattermid
inner join item_v2 item on snafu.item = item.item
inner join branch_v2 branch on branch.branchnumber=item.owningbranch
inner join location_v2 loc on item.location = loc.locnumber
order by bid
;
-- Some checking 09/23/22, 09/26/22, 09/27/22
select snafu.bid, snafu.item,snafu.item_call "original itemcall", 
item.cn "current item call",
--bib.callnumber bibcall,
--marc.tagdata "old call", 
case 
when (instr(snafu.item_call ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J FIC '||  substr(item.cn,7) 
when instr(snafu.item_call ,'J CD BOOK MYS')>0 then 'J CD BOOK FIC' ||  substr(item.cn,14) 
when instr(snafu.item_call ,'J GRAPHIC MYS')>0 then 'J GRAPHIC FIC' ||  substr(item.cn,14) 
when instr(snafu.item_call ,'J PL BOOK MYS')>0 then 'J PL FIC' ||  substr(item.cn,14) 
when instr(snafu.item_call ,'J PL MYS')>0 then 'J PL FIC' ||  substr(item.cn,9) 
when instr(snafu.item_call,'J MYS FIC')>0 then 'J FIC' ||  substr(item.cn,10) 
end 
newItemCallNum,
bib.author,
branch.branchcode,
loc.loccode,
format.formattext,
bib.isbn,
snafu.title 
from JMYSITEMBID snafu
inner join bbibmap_v2 bib on snafu.bid = bib.bid
inner join formatterm_v2 format on bib.format = format.formattermid
inner join item_v2 item on snafu.item = item.item
inner join branch_v2 branch on branch.branchnumber=item.owningbranch
inner join location_v2 loc on item.location = loc.locnumber
order by snafu.bid
;

-- Delete Extra Space chars
select snafu.bid, snafu.item,snafu.TITLE_CALL , snafu.item_call,
case when instr(snafu.item_call,'  ')>0 then replace(snafu.item_call,'  ',' ')
 else 'NoSpaces'
 end replacement,
 snafu.item_call "original itemcall",
item.cn "current item call",
--bib.callnumber bibcall,
--marc.tagdata "old call",
case
when (instr(snafu.item_call ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J FIC '||  substr(item.cn,7)
when instr(snafu.item_call ,'J CD BOOK MYS')>0 then 'J CD BOOK FIC' ||  substr(item.cn,14)
when instr(snafu.item_call ,'J GRAPHIC MYS')>0 then 'J GRAPHIC FIC' ||  substr(item.cn,14)
when instr(snafu.item_call ,'J PL BOOK MYS')>0 then 'J PL FIC' ||  substr(item.cn,14)
when instr(snafu.item_call ,'J PL MYS')>0 then 'J PL FIC' ||  substr(item.cn,9)
when instr(snafu.item_call,'J MYS FIC')>0 then 'J FIC' ||  substr(item.cn,10)
end
newItemCallNum,
bib.author,
branch.branchcode,
loc.loccode,
format.formattext,
bib.isbn,
snafu.title
from JMYSITEMBID snafu
inner join bbibmap_v2 bib on snafu.bid = bib.bid
inner join formatterm_v2 format on bib.format = format.formattermid
inner join item_v2 item on snafu.item = item.item
inner join branch_v2 branch on branch.branchnumber=item.owningbranch
inner join location_v2 loc on item.location = loc.locnumber
where instr(snafu.item_call,'  ')>0
order by snafu.bid
;

select snafu.bid, item.item, item.cn itemcall, 'J CD BOOK FIC' || substr(item.cn,6) newcall, bib.callnumber bibcall, snafu.title 
from bids_jfic_jcdbookfic snafu
inner join bbibmap_v2 bib on snafu.bid = bib.bid
inner join item_v2 item on snafu.bid = item.bid 
;
-- GRAPHIC
select snafu.bid, item.item, item.cn itemcall,
case when instr(item.cn ,'J GRAPHIC FIC')=0 then 'J GRAPHIC FIC' || substr(item.cn,6)
else 'Updated'
end
newcall, bib.callnumber bibcall, snafu.title 

from bids_jfic_jgraphicfic snafu
inner join bbibmap_v2 bib on snafu.bid = bib.bid
inner join item_v2 item on snafu.bid = item.bid 
;
--PL MYS looking for 590 tag that holds the old Call Number prior to recent change
select snafu.bid, item.item, item.cn itemcall, 'J PL FIC' || substr(item.cn,6) newcall, bib.callnumber bibcall, snafu.title 
from bids_jfic_jplfic snafu
inner join bbibmap_v2 bib on snafu.bid = bib.bid
inner join item_v2 item on snafu.bid = item.bid 
inner join bbibcontents_v2 tags on snafu.bid = tags. bid 
where tags.tagnumber = 590;

--TDT issue 10/14/2022
select item.ITEM, item.BID, bib.CALLNUMBER, item.status, trunc(item.statusdate) "status date", branch.branchcode branch, location.LOCCODE, bib.title from ITEM_V2 item inner join BBIBMAP_V2 bib on item.bid = bib.bid inner join LOCATION_V2 location on item.location = location.LOCNUMBER inner join BRANCH_V2 branch on item.OWNINGBRANCH= branch.BRANCHNUMBER where branchcode='TDT' order by statusdate desc, item asc ;
select item.ITEM, item.BID, item.statusdate, branch.branchcode from ITEM_V2 item inner join BRANCH_V2 branch on item.OWNINGBRANCH= branch.BRANCHNUMBER where branchcode='TDT' and item in (select "ITEM NUMBER" from "TDT items on shelf") order by statusdate desc, item asc ;
-- 10/24/2022 Hold Shelf Pull Date
select status , trunc(trans.DUEORNOTNEEDEDAFTERDATE) from item_v2 item inner join transitem_v2 trans on item.item = trans.item where item.item='21982319491639' ;
select ''''||item.item,  trunc(trans.DUEORNOTNEEDEDAFTERDATE) pulldate, patron.NAME "patron name", item.cn call,bib.title, branch.BRANCHCODE branchcode, item.status status
    from item_v2 item
    inner join BRANCH_V2 branch on item.branch =branch.branchnumber
    inner join BBIBMAP_V2 bib on item.bid=bib.bid
    inner join transitem_v2 trans on item.item = trans.item
    inner join PATRON_V2 patron on trans.PATRONID = patron.patronid
   where branchcode='CBA' and item.status like 'H%' and trunc(trans.DUEORNOTNEEDEDAFTERDATE) <'27-OCT-2022' order by pulldate desc, patron.name asc  ;

select item.item, branch.BRANCHCODE branch, trunc(trans.DUEORNOTNEEDEDAFTERDATE) pulldate, item.cn call, item.status status, patron.NAME patron,  bib.title  from item_v2 item

    inner join BRANCH_V2 branch on item.branch =branch.branchnumber
    inner join BBIBMAP_V2 bib on item.bid=bib.bid
    inner join transitem_v2 trans on item.item = trans.item
    inner join PATRON_V2 patron on trans.PATRONID = patron.patronid
   where  item.item = '21982319491639' order by pulldate desc, patron.name asc  ;

--  Nov 2022 Extra Space Removal from Call Number
select item.item, item.bid , item.cn "old cn", replace(item.cn,'  ',' ') "string_sub", regexp_replace(trim(item.cn),'\s\s+',' ') "new cn"
from item_v2 item where regexp_like(item.cn,'\s\s+') ;

select bib.bid, bib.CALLNUMBER "old call", replace(bib.CALLNUMBER,'  ',' ') "string_sub", regexp_replace(bib.CALLNUMBER,'\s\s+',' ') "new call"
from BBIBMAP_V2 bib where regexp_like(bib.callnumber,'\s{3}') ;

-- Nov 10 2022 VERY EASY to BOARD
select bib.bid , bib.callnumber, bib.author, bib.isbn, bib.ERESOURCE, bib.title from BBIBMAP_V2 bib inner join "VeryEasyBIDGMUOut" gmu on bib.bid = gmu.bid ;

select item.item, gmu.bid , item.cn, regexp_replace(item.cn,'E (\w+) .+','BOARD \1' ) "new cn", bib.author, bib.isbn, bib.title
from BBIBMAP_V2 bib inner join item_v2 item on bib.bid=item.bid inner join "VeryEasyBIDGMUOut" gmu on bib.bid = gmu.bid ;

select item.item, item.bid, bib.CALLNUMBER "bib call",item.cn "item call", regexp_replace(item.cn,'E +(\w+)[- ]*.+','BOARD \1' ) "new cn", bib.author, bib.isbn, bib.title
from BBIBMAP_V2 bib inner join item_v2 item on bib.bid=item.bid where item.cn like '%VERY EASY' order by bib.bid, item.item asc;

--Titles exported from GMU with 092b Call Number
select item.item, item.bid, bib.CALLNUMBER "bib call",item.cn "item call", regexp_replace(item.cn,'E +(\w+)[- ]*.+','BOARD \1' ) "new cn", bib.author, bib.isbn, bib.title
from BBIBMAP_V2 bib inner join item_v2 item on bib.bid=item.bid  inner join "GMU_PROD_VERYEASY_092b" gmu on gmu.bid = bib.bid  order by bib.bid, item.item asc;

-- Titles exported from GMU with 092 Call Number
select item.item, item.bid, bib.CALLNUMBER "bib call",item.cn "item call", regexp_replace(item.cn,'E +(\w+)[- ]*.+','BOARD \1' ) "new cn", bib.author, bib.isbn, bib.title
from BBIBMAP_V2 bib inner join item_v2 item on bib.bid=item.bid  inner join "GMU_PROD_VERYEASY_092" gmu on gmu.bid = bib.bid  order by bib.bid, item.item asc;

-- See if any call numbers don't fit the pattern BOARD%
select item.item, item.bid, bib.CALLNUMBER "bib call",item.cn "item call", regexp_replace(item.cn,'E +(\w+)[- ]*.+','BOARD \1' ) "new cn", bib.author, bib.isbn, bib.title
from BBIBMAP_V2 bib inner join item_v2 item on bib.bid=item.bid  inner join "GMU_PROD_VERYEASY_092" gmu on gmu.bid = bib.bid  where ( bib.CALLNUMBER not like 'BOARD%'  or item.cn not like 'BOARD%') order by bib.bid, item.item asc;

--Add Branches to the Excel Workbook
select gmu.item, gmu.bid, gmu."item call" "item call", gmu."new cn" "new cn", branch.BRANCHCODE, bib.author, bib.title
from BBIBMAP_V2 bib
inner join PROD_092 gmu on gmu.bid = bib.bid
inner join item_v2 item on item.item=gmu.item
inner join branch_v2 branch on item.branch=branch.BRANCHNUMBER
order by bib.bid, gmu.item asc;

-- CH to J DVD

-- Search for Items or titles with Call Number matching the pattern
select item.item, bib.bid,
       bib.CALLNUMBER "oldbib call",
       case
           when instr(bib.CALLNUMBER ,'DVD CH ')=1 then 'J DVD '||  substr(bib.CALLNUMBER,8)
           else bib.CALLNUMBER end "newbib call",
       item.cn "olditemcn",
       case
           when instr(item.cn ,'DVD CH ')=1 then 'J DVD '||  substr(item.cn,8)
           else item.cn end "newitem.cn",
title, author , branch.branchcode, location.loccode
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where regexp_like(item.cn,'^DVD\s+CH\s+')  or regexp_like(bib.CALLNUMBER, '^DVD\s+\CH\s+') order by bib.bid;

-- From the list of Bids exported by the GMU
select item.item, bib.bid,  item.cn "olditemcn",
       case
           when instr(item.cn ,'DVD CH ')=1 then 'J DVD '||  substr(item.cn,8)
           else item.cn end "newitem.cn", bib."Title", branch.branchcode, location.loccode
from GMU_BIDS_2 bib inner join item_v2 item on bib.bid=item.bid
    inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where regexp_like(item.cn,'^DVD\s+CH\s+') order by bib.bid;

-- Just the bids of the Items that match. Want to compare with GMU list
select  unique bib.bid, bib.callnumber "oldbibcn",
       case
           when instr(bib.CALLNUMBER ,'DVD CH ')=1 then 'J DVD '||  substr(item.cn,8)
           else bib.CALLNUMBER end "new bib.cn",
title, author
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
where regexp_like(item.cn,'^DVD\s+CH\s+') order by bib.bid;

create table adhocbids
AS
select  unique bib.bid, bib.callnumber "oldbibcn",
       case
           when instr(bib.CALLNUMBER ,'DVD CH ')=1 then 'J DVD '||  substr(item.cn,8)
           else bib.CALLNUMBER end "new bib.cn",
title, author
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
where regexp_like(item.cn,'^DVD\s+CH\s+') order by bib.bid;
-- Adhoc BIDS not matched by GMU Bids though Item has CN "DVD CH" Title Call Number does not have "DVD CH"
select adhoc.bid , adhoc."oldbibcn" "old bib call",  item.cn "old item call", adhoc.title, adhoc.author from ADHOCBIDS adhoc
 inner join ITEM_V2 item on item.bid = adhoc.bid
 LEFT OUTER JOIN GMU_BIDS_2 gmu on gmu.bid=adhoc.bid
where gmu.bid is null;

-- After Megan fixed Title Call Numbers so that they have "DVD CH" like the Item CN.
select adhoc.bid , bib.CALLNUMBER "old bib call",   item.cn "old item call", adhoc.title, adhoc.author from ADHOCBIDS adhoc
    inner join BBIBMAP_V2 bib on adhoc.bid = bib.bid
    inner join ITEM_V2 item on item.bid = adhoc.bid
 LEFT OUTER JOIN GMU_BIDS_2 gmu on gmu.bid=adhoc.bid
where gmu.bid is null;

-- Read back the JVF title and item call numbers from the imported table CHILDRENS_COLLECTION_DVDCH_JVF.
select catalog.ITEM , catalog.BID,bib.CALLNUMBER bibcall ,item_v2.CN itemcall, bib.TITLE, branch.BRANCHCODE, location.LOCCODE,tag.WORDDATA SavedCallNum, item_v2.EDITDATE
from CHILDRENS_COLLECTION_DVDCH_JVF catalog
inner join BBIBMAP_V2 bib on catalog.bid = bib.bid
inner join BBIBCONTENTS_V2 marc on catalog.bid = marc.BID
inner join BTAGS_V2 tag on tag.tagid = marc.TAGID
inner join item_v2  on catalog.item = item_v2.item
inner join BRANCH_V2 branch on item_v2.OWNINGBRANCH = branch.BRANCHNUMBER
inner join LOCATION_V2 location on item_v2.LOCATION = location.LOCNUMBER
where marc.TAGNUMBER = 590
;
-- Location JVF, fix for J DVD instead of J VID
--Bids and Items
select item.item, bib.bid,
       bib.CALLNUMBER "oldbib call",
       case
           when instr(bib.CALLNUMBER ,'DVD CH FF')=1 then 'J DVD '||  substr(bib.CALLNUMBER,8)
           else bib.CALLNUMBER end "newbib call",
       item.cn "olditemcn",
       case
           when instr(item.cn ,'DVD CH FF')=1 then 'J DVD '||  substr(item.cn,8)
           else item.cn end "newitem.cn",
title, branch.branchcode, location.loccode, trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where ((regexp_like(item.cn,'^DVD\s+CH\s+FF')  or regexp_like(bib.CALLNUMBER, '^DVD\s+\CH\s+FF'))
           AND ( location.LOCCODE = 'JVF') )
        order by bib.bid;

-- Separate the Title from Item due to failure in the ITSI Macro
-- BIB first
select bib.bid,
       bib.CALLNUMBER "oldbib call",
       case
           when instr(bib.CALLNUMBER ,'DVD CH FF')=1 then 'J DVD '||  substr(bib.CALLNUMBER,8)
           else bib.CALLNUMBER end "newbib call",
bib.title --, trunc(biblog.ACTIONTIMESTAMP) bibedit
from bbibmap_v2 bib
-- inner join BIBLOG_V2 biblog on biblog.BID = bib.BID
where regexp_like(bib.CALLNUMBER, '^DVD\s+\CH\s+FF')
        order by bib.bid;

-- Read back the JVF title and item call numbers from the imported table CHILDRENS_COLLECTION_DVDCH_JVF.
select catalog.ITEM , catalog.BID,bib.CALLNUMBER bibcall ,item_v2.CN itemcall, bib.TITLE, branch.BRANCHCODE, location.LOCCODE,tag.WORDDATA SavedCallNum, item_v2.EDITDATE
from "Location_JVF" catalog
inner join BBIBMAP_V2 bib on catalog.bid = bib.bid
inner join BBIBCONTENTS_V2 marc on catalog.bid = marc.BID
inner join BTAGS_V2 tag on tag.tagid = marc.TAGID
inner join item_v2  on catalog.item = item_v2.item
inner join BRANCH_V2 branch on item_v2.OWNINGBRANCH = branch.BRANCHNUMBER
inner join LOCATION_V2 location on item_v2.LOCATION = location.LOCNUMBER
where marc.TAGNUMBER = 590
;
-- 03/04/2023 Fix for JVNF. Use the values exported to an Excel file Location_JVNF and then re-imported

select distinct bib.bid, bib.CALLNUMBER "bib call", item.cn "item call",tags.TAGDATA,
bib.title, bib.author , branch.branchcode, location.loccode
from "Location_JVNF" test_jvnf
    inner join BBIBMAP_V2 bib on test_jvnf.bid = bib.bid
    inner join item_v2 item on test_jvnf.bid=item.bid
    inner join BBIBCONTENTS_V2 marc on bib.bid = marc.BID
    inner join BTAGS_V2 tags on tags.TAGID = marc.TAGID
    inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
    where marc.TAGNUMBER = 245 and regexp_like(bib.CALLNUMBER,'J VID [0-9]+.[0-9]+\z')

    order by bib.bid;


-- 1/11/2023 Search for Items or titles with Call Number matching the DVD CH pattern

-- 02/27/2023 Location JVTV
-- 03/07/2023 Use BIDS exported from ITSI GMU

select item.item, itsi.bid,
       bib.CALLNUMBER "oldbib call",
       case
           when instr(bib.CALLNUMBER ,'DVD CH ')=1 then 'J DVD TV '||  substr(bib.CALLNUMBER,8)
           else bib.CALLNUMBER end "newbib call",
       item.cn "olditemcn",
       case
           when instr(item.cn ,'DVD CH ')=1 then 'J DVD TV '||  substr(item.cn,8)
           else item.cn end "newitem.cn",
         bib.title, bib.author , branch.branchcode, location.loccode
    from "JVTV_Bibs_Only" itsi inner join BBIBMAP_V2 bib on itsi.bid = bib.bid
    inner join item_v2 item on bib.bid=item.bid
--     inner join BBIBCONTENTS_V2 marc on bib.bid = marc.BID
--     inner join BTAGS_V2 tags on tags.TAGID = marc.TAGID
    inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
    where ((regexp_like(item.cn,'^DVD\s+CH\s+')  or regexp_like(bib.CALLNUMBER, '^DVD\s+\CH\s+'))
--         AND
--         ( marc.TAGNUMBER = 092 )

        AND (
               (location.LOCCODE = 'JVTV')

              OR
               (location.LOCCODE = 'LCOL')
           )
    )
        order by bib.bid;


-- 03/01/2023 Verify updates to JVTV
-- Include the 590 tag having the saved old Title Call Number
select item.item, bib.bid, bib.CALLNUMBER "bib call", item.cn "item call",
bib.title, bib.author , branch.branchcode, location.loccode, tags.WORDDATA "Saved BIB Call"
from BBIBMAP_V2 bib
    inner join "JVTV_Bibs_Only" results on results.BID = bib.BID
    inner join item_v2 item on bib.bid=item.bid
    inner join BBIBCONTENTS_V2 marc on bib.bid = marc.BID
    inner join BTAGS_V2 tags on tags.TAGID = marc.TAGID
    inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
    where (
              marc.TAGNUMBER = 590
-- Doesn't match New Pattern J DVD TV
--                   AND
--               NOT (regexp_like(item.cn,'^J DVD TV\s+') OR regexp_like(bib.CALLNUMBER, '^J DVD TV\s+'))
--               )
--             AND
--                (
--                            location.LOCCODE = 'JVTV'
--                        OR
--                            location.LOCCODE = 'LCOL'
--                    )
              )
    order by bib.bid;


-- 03/07/2023 JVTV Bibs Only
select  distinct bib.bid,
-- item.item,
       bib.CALLNUMBER "oldbib call",
       case
           when instr(bib.CALLNUMBER ,'DVD CH ')=1 then 'J DVD TV '||  substr(bib.CALLNUMBER,8)
           else bib.CALLNUMBER end "newbib call",
--       item.cn "olditemcn",
--        case
--            when instr(item.cn ,'DVD CH ')=1 then 'J DVD '||  substr(item.cn,8)
--            else item.cn end "newitem.cn",
title, author
--  ,branch.branchcode, location.loccode
from bbibmap_v2 bib

inner join item_v2 item on bib.bid=item.bid
    --inner join media_v2 media on item.media = media.mednumber
    --inner join branch_v2 branch on item.owningbranch=branch.branchnumber
inner join location_v2 location on item.location=location.locnumber
where  (regexp_like(bib.CALLNUMBER, '^DVD\s+\CH\s+')
      AND ( location.LOCCODE = 'JVTV')
    )
        order by bib.bid ;


-- 03/07/2023 JVTV Bibs Only Review Update using GMU exported bids in JVTV_Bibs_Only
select distinct bib.BID,
       gmu."oldbib call",
       bib.CALLNUMBER,
       bib.TITLE, bib.AUTHOR
      from "JVTV_Bibs_Only" gmu
      inner join BBIBMAP_V2 bib on gmu.BID = bib.BID
      inner join item_v2 item on bib.bid=item.bid
     inner join location_v2 location on item.location=location.locnumber
   where
       location.LOCCODE = 'JVTV'
    order by bib.bid ;

-- 04/04/2023 Location JVNF
--04/04/2023 Location JVNF Bids and Items
select item.item, bib.bid,
       bib.CALLNUMBER "oldbib call",
       case
           when instr(bib.CALLNUMBER ,'DVD CH')=1 then 'J DVD '||  substr(bib.CALLNUMBER,8)
           else bib.CALLNUMBER end "newbib call",
       item.cn "olditemcn",
       case
           when instr(item.cn ,'DVD CH')=1 then 'J DVD '||  substr(item.cn,8)
           else item.cn end "newitem.cn",
bib.title, branch.branchcode, location.loccode,  trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where ((regexp_like(item.cn,'^DVD CH')  or regexp_like(bib.CALLNUMBER, '^DVD CH'))
           AND (
               location.LOCCODE = 'JVNF'
               OR
               location.LOCCODE = 'LCOL'
               )

    )

        order by bib.bid;



    -- 04/04/2023 JVNF Bib only
select distinct bib.bid,
       bib.CALLNUMBER "oldbib call",
       case
           when instr(bib.CALLNUMBER ,'DVD CH')=1 then 'J DVD '||  substr(bib.CALLNUMBER,8)
           else bib.CALLNUMBER end "newbib call",
title
--branch.branchcode, location.loccode, trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    --inner join media_v2 media on item.media = media.mednumber
    -- inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where ( (regexp_like(bib.CALLNUMBER, '^DVD CH') or regexp_like(ITEM.CN, '^DVD CH'))
           AND (
               location.LOCCODE = 'JVNF'
               OR
               location.LOCCODE = 'LCOL'
               )

    )

        order by bib.bid;

    --inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where ( (regexp_like(bib.CALLNUMBER, '^DVD CH') or regexp_like(ITEM.CN, '^DVD CH'))
           AND (
               location.LOCCODE = 'JVNF'
               OR
               location.LOCCODE = 'LCOL'
               )

    )

        order by bib.bid;


-- 03/31/2023 JVNF Bibs on Test with a 590

select distinct bib.bid,
       bib.CALLNUMBER "oldbib call",
       case
           when instr(bib.CALLNUMBER ,'DVD CH')=1 then 'J DVD '||  substr(bib.CALLNUMBER,8)
           else bib.CALLNUMBER end "newbib call",
title,
marc.TAGNUMBER,
tags.WORDDATA
--branch.branchcode, location.loccode, trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid
    --inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where ( (regexp_like(bib.CALLNUMBER, '^DVD CH') or regexp_like(ITEM.CN, '^DVD CH'))
           AND (
               location.LOCCODE = 'JVNF'
               OR
               location.LOCCODE = 'LCOL'
               )
    AND marc.tagnumber='590'

    )

        order by bib.bid;

-- April 4 Read Back  04/01/2023 JVNF Bibs only on Test with a 590

select
 --      item.ITEM,
      catalog.bid,
       bib.CALLNUMBER  "newbib call",
 --     item.cn "new item call",
      bib.title,
      marc.TAGNUMBER,
     tags.WORDDATA "TagData"
-- branch.branchcode, location.loccode, trunc(item.EDITDATE)
from
    bbibmap_v2 bib
     --inner join item_v2 item on bib.bid=item.bid
     --Test
    -- inner join "03_30_2023_JVNF_Bib_only" catalog on catalog.bid=bib.bid
     --Production
     inner join "Bids_JVNF_PROD_APRIL4" catalog on catalog.bid=bib.bid
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid
    --inner join media_v2 media on item.media = media.mednumber
     -- inner join branch_v2 branch on item.owningbranch=branch.branchnumber
     -- inner join location_v2 location on item.location=location.locnumber
where
  --  ( (regexp_like(bib.CALLNUMBER, '^DVD CH') or regexp_like(ITEM.CN, '^DVD CH'))
--             (
--                location.LOCCODE = 'JVNF'
--                OR
--                location.LOCCODE = 'LCOL'
--                )
    --AND ( item.cn like 'J VID%' OR bib.CALLNUMBER like 'J VID%')
    -- AND
    marc.tagnumber='590'

        order by to_number(catalog.bid);

-- Still cleaning JVNF
select
       item.ITEM,
      catalog.bid,
       bib.CALLNUMBER  "newbib call",
      item.cn "new item call",
      bib.title,
      marc.TAGNUMBER,
     tags.WORDDATA "TagData"
--branch.branchcode, location.loccode, trunc(item.EDITDATE)
from
    bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
     inner join JVID590 catalog on catalog.bid=bib.bid
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid
    --inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where
  --  ( (regexp_like(bib.CALLNUMBER, '^DVD CH') or regexp_like(ITEM.CN, '^DVD CH'))
            (
               location.LOCCODE = 'JVNF'
               OR
               location.LOCCODE = 'LCOL'
               )
    AND marc.tagnumber='590'

        order by to_number(catalog.bid);

-- April 4 Read Back Bids and Items but keep old Call Numbers for testing

select
       item.ITEM,
      catalog.bid,
       bib.CALLNUMBER  "newbib call",
      'DVD CH ' || SUBSTR(bib.CALLNUMBER,7) "oldbib call",
      item.cn "newitem call",
      'DVD CH ' || SUBSTR(item.cn,7) "olditem call",
      bib.title,
      marc.TAGNUMBER,
     tags.WORDDATA "TagData"
--branch.branchcode, location.loccode, trunc(item.EDITDATE)
from
    bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
     --Test
     --inner join "03_30_2023_JVNF_Bib_only" catalog on catalog.bid=bib.bid
     --Production
     inner join "Bids_JVNF_PROD_APRIL4" catalog on catalog.bid=bib.bid
     inner join bbibcontents_v2 marc on bib.bid = marc.bid
     inner join btags_v2 tags on tags.tagid = marc.tagid
    --inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where
  --  ( (regexp_like(bib.CALLNUMBER, '^DVD CH') or regexp_like(ITEM.CN, '^DVD CH'))
            (
               location.LOCCODE = 'JVNF'
               OR
               location.LOCCODE = 'LCOL'
               )
    --AND ( item.cn like 'J VID%' OR bib.CALLNUMBER like 'J VID%')
    AND marc.tagnumber='590'

        order by to_number(catalog.bid);

    -- 04/06/2023 J GRAPHIC FORMAT BIB Call Numbers seem correct.
select bib.bid,
       item.ITEM,
       bib.CALLNUMBER "oldbib call",
--        case
--            when regexp_like(bib.CALLNUMBER, '^J.+GRAPHIC FORMAT$')
--                then regexp_replace(bib.CALLNUMBER,'^J\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','J GRAPHIC \1')
--            else bib.CALLNUMBER end "newbib call",
       item.cn "olditem call",
        case
             when regexp_like(bib.CALLNUMBER, '^J.+GRAPHIC .+$')
               then bib.CALLNUMBER
           else item.cn end "newitem call",
--            when regexp_like(item.cn, '^J.+GRAPHIC FORMAT$')
--                then regexp_replace(item.cn,'^J\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','J GRAPHIC \1')
--            else item.cn end "newitem call",
       LOCATION.LOCCODE,
       title
--branch.branchcode, location.loccode, trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    --inner join media_v2 media on item.media = media.mednumber
    -- inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where (
       (regexp_like(bib.CALLNUMBER, '^J.+GRAPHIC FORMAT$') or
         regexp_like(ITEM.CN, '^J.+GRAPHIC FORMAT$'))
--            AND (
--                location.LOCCODE = 'JVNF'
--                OR
--                location.LOCCODE = 'LCOL'
--                )

    )

        order by bib.bid;

    -- 08/03/2023 Y GRAPHIC FORMAT BIB Call Numbers seem correct.
    -- Location codes YGF, YGNF, YGB,YPF, YGNEW, YDSPLY
select item.item,
       bib.bid,
       item.cn "olditem call",
        case
            when regexp_like(bib.CALLNUMBER, '^Y.+GRAPHIC .+$')
               then bib.CALLNUMBER
            when regexp_like(item.cn, '^Y.+GRAPHIC FORMAT$')
                then regexp_replace(item.cn,'^Y\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','Y GRAPHIC \1')
            else 'No Match. Default: '||item.cn end "newitem call",
       BRANCHCODE,
       LOCATION.LOCCODE,
       title
--branch.branchcode, location.loccode, trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    --inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.BRANCH=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where (
--       (
--          regexp_like(bib.CALLNUMBER, '^\s*Y.+GRAPHIC FORMAT$') or
         regexp_like(ITEM.CN, '^\s*Y.+GRAPHIC FORMAT$')
 --       )

            AND (
                --location.LOCCODE = 'YGNF'
               -- Location codes 'YGF', 'YGNF', 'YGB','YPF', 'YGNEW', 'YDSPLY'
                location.LOCCODE = :location
                --location.LOCCODE !='YGF'
                OR
                location.LOCCODE = 'LCOL'
                )

    )
        group by bib.bid,item.item,bib.CALLNUMBER, item.ITEM, bib.bid, item.ITEM, bib.CALLNUMBER, case
            when regexp_like(bib.CALLNUMBER, '^Y.+GRAPHIC FORMAT$')
                then regexp_replace(bib.CALLNUMBER,'^Y\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','Y GRAPHIC \1')
            else bib.CALLNUMBER end, item.cn, case
             when regexp_like(bib.CALLNUMBER, '^Y.+GRAPHIC .+$')
               then bib.CALLNUMBER
           else item.cn end, BRANCHCODE, LOCATION.LOCCODE, title
        order by bib.bid;

 -- Location codes YGF, YGNF, YGB,YPF, YGNEW, YDSPLY
select item.item,
       bib.bid,
       item.cn "olditem call",
        case
            when regexp_like(bib.CALLNUMBER, '^Y.+GRAPHIC .+$')
               then bib.CALLNUMBER
            when regexp_like(item.cn, '^Y.+GRAPHIC FORMAT$')
                then regexp_replace(item.cn,'^Y\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','Y GRAPHIC \1')
            else 'No Match. Default: '||item.cn end "newitem call",
       --BRANCHCODE,
       LOCATION.LOCCODE,
       title
--branch.branchcode, location.loccode, trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    --inner join media_v2 media on item.media = media.mednumber
     -- inner join branch_v2 branch on item.BRANCH=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where (
       (regexp_like(bib.CALLNUMBER, '^\s*Y.+GRAPHIC FORMAT$') or
         regexp_like(ITEM.CN, '^\s*Y.+GRAPHIC FORMAT$'))
            AND (
                --location.LOCCODE = 'YGNF'
               -- Location codes 'YGF', 'YGNF', 'YGB','YPF', 'YGNEW', 'YDSPLY'
                --location.LOCCODE = :location
                location.LOCCODE !='YGF'
                OR
                location.LOCCODE = 'LCOL'
                )

    )
        group by bib.bid,item.item,bib.CALLNUMBER, item.ITEM, bib.bid, item.ITEM, bib.CALLNUMBER, case
            when regexp_like(bib.CALLNUMBER, '^Y.+GRAPHIC FORMAT$')
                then regexp_replace(bib.CALLNUMBER,'^Y\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','Y GRAPHIC \1')
            else bib.CALLNUMBER end, item.cn, case
             when regexp_like(bib.CALLNUMBER, '^Y.+GRAPHIC .+$')
               then bib.CALLNUMBER
           else item.cn end, LOCATION.LOCCODE, title
        order by bib.bid;

-- Confirm update by reading back the anticipated new Call Numbers
-- Location codes YGF, YGNF, YGB,YPF, YGNEW, YDSPLY
select item.item,
       bib.bid,
       bib.CALLNUMBER "bib call",
       item.cn "item call",
--         case
--             when regexp_like(bib.CALLNUMBER, '^Y GRAPHIC.+$')
--                then bib.CALLNUMBER
--             when regexp_like(item.cn, '^Y.+GRAPHIC FORMAT$')
--                 then regexp_replace(item.cn,'^Y\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','Y GRAPHIC \1')
--             else 'No Match. Default: '||item.cn end "newitem call",
       --BRANCHCODE,
       LOCATION.LOCCODE,
       title
--branch.branchcode, location.loccode, trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    --inner join media_v2 media on item.media = media.mednumber
     -- inner join branch_v2 branch on item.BRANCH=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where (
       (
         --regexp_like(bib.CALLNUMBER, '^Y GRAPHIC') or
         regexp_like(ITEM.CN, '^Y GRAPHIC'))
            AND (
                --location.LOCCODE = 'YGNF'
               -- Location codes 'YGF', 'YGNF', 'YGB','YPF', 'YGNEW', 'YDSPLY'
                --location.LOCCODE = :location
                location.LOCCODE = 'YGNF'
                OR
                location.LOCCODE = 'YGB'
                OR
                location.LOCCODE ='YPF'
                OR
                location.LOCCODE ='YGNEW'
                OR
                location.LOCCODE ='YDSPLY'
                OR
                location.LOCCODE = 'LCOL'
                )

    )
        group by  bib.bid, item.ITEM, bib.CALLNUMBER, case
            when regexp_like(bib.CALLNUMBER, '^Y.+GRAPHIC FORMAT$')
                then regexp_replace(bib.CALLNUMBER,'^Y\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','Y GRAPHIC \1')
            else bib.CALLNUMBER end, item.cn, case
             when regexp_like(bib.CALLNUMBER, '^Y.+GRAPHIC .+$')
               then bib.CALLNUMBER
           else item.cn end, LOCATION.LOCCODE, change.title
        order by bib.bid;

-- 08/07/2023 For the label updates
select item.item,
       bib.bid,
       bib.CALLNUMBER "bib call",
       item.cn "item call",
--         case
--             when regexp_like(bib.CALLNUMBER, '^Y GRAPHIC.+$')
--                then bib.CALLNUMBER
--             when regexp_like(item.cn, '^Y.+GRAPHIC FORMAT$')
--                 then regexp_replace(item.cn,'^Y\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','Y GRAPHIC \1')
--             else 'No Match. Default: '||item.cn end "newitem call",
       branch.BRANCHCODE,
       LOCATION.LOCCODE,
       change.title
--branch.branchcode, location.loccode, trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    inner join YGNF_YGB_YPF_YGNEW_YDSPLY change on item.ITEM = change.ITEM
    --inner join media_v2 media on item.media = media.mednumber
     inner join branch_v2 branch on item.BRANCH=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where (
       (
         --regexp_like(bib.CALLNUMBER, '^Y GRAPHIC') or
         regexp_like(ITEM.CN, '^Y GRAPHIC'))
      --      AND (
                --location.LOCCODE = 'YGNF'
               -- Location codes 'YGF', 'YGNF', 'YGB','YPF', 'YGNEW', 'YDSPLY'
                --location.LOCCODE = :location
--                 location.LOCCODE = 'YGNF'
--                 OR
--                 location.LOCCODE = 'YGB'
--                 OR
--                 location.LOCCODE ='YPF'
--                 OR
--                 location.LOCCODE ='YGNEW'
--                 OR
--                 location.LOCCODE ='YDSPLY'
--                 OR
--                 location.LOCCODE = 'LCOL'
         --      )

    )
        group by bib.bid,item.item,bib.CALLNUMBER, item.ITEM, bib.bid, item.ITEM, bib.CALLNUMBER, case
            when regexp_like(bib.CALLNUMBER, '^Y.+GRAPHIC FORMAT$')
                then regexp_replace(bib.CALLNUMBER,'^Y\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','Y GRAPHIC \1')
            else bib.CALLNUMBER end, item.cn, case
             when regexp_like(bib.CALLNUMBER, '^Y.+GRAPHIC .+$')
               then bib.CALLNUMBER
           else item.cn end, branch.branchcode ,LOCATION.LOCCODE, change.title
        order by bib.bid;

   -- 05/15/2023 J GRAPHIC FORMAT BIB Call Numbers seem correct.
   -- Locations JGNF Non-Fiction and JGB Biography
select
       item.item,
       bib.bid,
       item.cn "olditem call",
        case
             when regexp_like(item.cn, '^J.+GRAPHIC FORMAT$')
                then regexp_replace(item.cn,'^J\s+([^\s\-]+)\s*-*\s*GRAPHIC FORMAT','J GRAPHIC \1')
            else item.cn end "newitem call",
       branch.branchcode,
       LOCATION.LOCCODE,
       title
--  trunc(item.EDITDATE)
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    --inner join media_v2 media on item.media = media.mednumber
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where (
              regexp_like(ITEM.CN, '^J.+GRAPHIC FORMAT$')
              AND (
                          location.LOCCODE = 'JGB'
                      OR
                          location.LOCCODE = 'JGNF'
                  )
          )

        group by branch.BRANCHCODE,location.LOCCODE, item.ITEM,
                 item.cn,
                 bib.bid, title
        order by item.cn    ;

-- 05/26/23
-- Location JGF
select
       item.item,
       bib.bid,
       item.cn "olditem call",
        case
             when regexp_like(item.cn, '^J.+GRAPHIC FORMAT$')
                then regexp_replace(item.cn,'^J\s+([^\s]+)\s*-\s*GRAPHIC FORMAT','J GRAPHIC \1')
            else item.cn end "newitem call",
       branch.branchcode,
       LOCATION.LOCCODE,
       title
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid
    inner join branch_v2 branch on item.owningbranch=branch.branchnumber
    inner join location_v2 location on item.location=location.locnumber
where (
              regexp_like(ITEM.CN, '^J.+GRAPHIC FORMAT$')
              AND
                          location.LOCCODE = 'JGF'


          )

        group by branch.BRANCHCODE,location.LOCCODE, item.ITEM,
                 item.cn,
                 bib.bid, title
        order by item.cn   , branch.BRANCHCODE ;

-- JGF title updates
select
       bib.bid,
       log.ACTIONCODE,
       trunc(log.ACTIONTIMESTAMP),
      bib.CALLNUMBER,
       bib.title,
      --branch.BRANCHCODE
        log.BRANCHNUMBER
from bbibmap_v2 bib
    inner join BIBLOG_V2 log on bib.bid = log.bid
   -- inner join branch_v2 branch on log.BRANCHNUMBER=branch.branchnumber
where (
            log.ACTIONCODE = 1 AND
              regexp_like(bib.CALLNUMBER, '^J.+GRAPHIC')

          )

--         group by branch.BRANCHCODE,location.LOCCODE, item.ITEM,
--                  item.cn,
--                  bib.bid, title
        order by bib.callnumber, trunc(log.ACTIONTIMESTAMP) desc   ;

--08/08/2023 Adult Graphic
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
