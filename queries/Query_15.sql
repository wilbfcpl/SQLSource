-- multibyte name search for webreg.
select p.patronid, p.patronguid,p.status, substrb(p.name,1), trunc(p.birthdate), p.patronid, b.btycode,
  trunc(p.regdate) AS Register,   trunc(p.actdate) AS Active,
  trunc(p.sactdate) AS SelfServe,   trunc(p.editdate) AS Edit
from patron_v2 p, bty_v2 b
where
       length(p.name)<lengthb(p.name) AND
p.bty=b.btynumber and upper(b.btycode) ='WEBREG'