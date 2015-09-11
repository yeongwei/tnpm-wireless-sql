-- Correlate DATASOURCE_ID, RULESET_ID and TECHNOLOGY PACK Information
select 
  * 
from (
  select
    tbl1.RULESET_ID, tbl2.DATASOURCE_ID,
    tbl2.techpack_name || '|_|' || tbl2.techpack_version || '|_|' ||
    tbl2.technology || '|_|' || tbl2.vendor || '|_|' || tbl1.TYPE as "TECHPACK_KEY"  
  from
    lc_ruleset tbl1
  left outer join
    lc_datasource tbl2
  on 
    tbl2.DATASOURCE_ID = tbl1.DATASOURCE_ID
  ) tbl;