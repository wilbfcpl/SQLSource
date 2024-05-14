SELECT
  DISTINCT
  s.client_version
FROM
  v$session_connect_info s
WHERE
  s.sid = SYS_CONTEXT('USERENV', 'SID');
  
select * from bbibmap_v2 bib where upper(title) like '%TABLET%KIT%';