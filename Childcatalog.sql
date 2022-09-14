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
select item.item, bib.bid,  item.cn "olditemcn", case when instr(item.cn ,'VERY EASY')>0 then 'BOARD '||  substr(item.cn,3,(instr(item.cn,'-')-4 )) else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like '%VERY EASY' order by bib.bid;

-- Juvenile Mystery J MYS FIC
--Item
select item.item, bib.bid,  item.cn "olditemcn", case when instr(item.cn ,'J MYS FIC')>0 then 'J FIC '||  substr(item.cn,11) else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like '%J MYS FIC%' order by bib.bid;
select item.item, bib.bid,  item.cn "olditemcn", case when (instr(item.cn ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J FIC '||  substr(item.cn,7) end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where regexp_like (item.cn ,'^J MYS [^F][^I][^C]') order by bib.bid;
select item.item, bib.bid,  item.cn "olditemcn", case when instr(item.cn ,'J MYS')>0 then 'J FIC '||  substr(item.cn,instr(item.cn,'MYS ')+4) else item.cn end "newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where item.cn like '%J%MYS%' order by bib.bid;
select item.item, bib.bid,  item.cn "olditemcn", 
case 
when (instr(item.cn ,'J MYS')>0 and instr(item.cn, 'MYS FIC')=0) then 'J FIC '||  substr(item.cn,7) 
when instr(item.cn ,'J CD BOOK MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J GRAPHIC MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J PL BOOK MYS')>0 then 'J FIC' ||  substr(item.cn,14) 
when instr(item.cn ,'J PL MYS')>0 then 'J FIC' ||  substr(item.cn,9) 
when instr(item.cn ,'J MYS FIC')>0 then 'J FIC' ||  substr(item.cn,10) 

else item.cn end 
"newitem.cn", title, author , branch.branchcode, location.loccode  from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid inner join media_v2 media on item.media = media.mednumber inner join branch_v2 branch on item.owningbranch=branch.branchnumber inner join location_v2 location on item.location=location.locnumber where regexp_like (item.cn ,'^J.+MYS.*') order by item.cn;

--Bib

select bib.bid,  
case 
when (instr(callnumber ,'J MYS')>0 and instr(callnumber, 'MYS FIC')=0) then 'J FIC '||  substr(callnumber,7) 
when instr(callnumber ,'J CD BOOK MYS')>0 then 'J FIC' ||  substr(callnumber,14) 
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
