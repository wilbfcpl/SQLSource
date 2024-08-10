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