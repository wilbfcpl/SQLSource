--Display
select item.item, bib.bid,callnumber,item.owningbranch, loc.locname, 
item.alternatestatus,item.status, item.statusdate, item.editdate, title, author 
from bbibmap_v2 bib inner join item_v2 item on bib.bid=item.bid 
inner join location_v2 loc on item.location = loc.locnumber 
where loc.loccode like '%DSPLY' and item.owningbranch=4 order by bib.bid;