-- List all tables in the current schema
connect carlreports/v#Qm8d3#fE@FREDPRODOCI
set pagesize 1000
set linesize 200
column table_name format a40

SELECT table_name 
FROM user_tables 
ORDER BY table_name;

exit;
