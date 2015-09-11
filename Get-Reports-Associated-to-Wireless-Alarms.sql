-- Get Reports that are associated to TNPM Wireless Alarms
select 
  /*
  tbl1.CONTEXT_ID, tbl1.TEMPLATE_NAME, tbl1.TIME_STAMP, tbl1.VERSION_ID,
  tbl1.MAPPED_REPORT_NAME, tbl1.MAPPED_REPORT_ID, tbl2.NAME as "FOLDER_NAME", tbl1.MAPPED_REPORT_FOLDER_NAME, 
  tbl4.TECHPACK_NAME || '|_|' || tbl4.TECHPACK_VERSION || '|_|' || tbl4.TECHNOLOGY || '|_|' || tbl4.VENDOR as "TECHPACK", 
  tbl1.RULESET_ID
  */
  distinct(
  'report_impexp -e -c all -u sysadm -p Sysadm01 -m "' || tbl1.MAPPED_REPORT_NAME || '" -f' || ' '
  || '/var/tmp/' || replace(replace(replace(replace(replace(tbl1.MAPPED_REPORT_NAME, ' ', '-'), '''', '-'), '(', '-'), ')', '-'), '%', 'percent') || '.xml' || ' '
  || ' -l /Users/sysadm -r true;')
from (
  select
    *
  from
    (
      select
        CONTEXT_ID, TEMPLATE_NAME, TIME_STAMP, VERSION_ID,
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/MappedReportName') as "MAPPED_REPORT_NAME",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/MappedReportID') as "MAPPED_REPORT_ID",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/MappedReportFolderName') as "MAPPED_REPORT_FOLDER_NAME",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/LoaderParameters/Ruleset') as "RULESET_ID"
      from 
        alarm_templates
      ) tbl1
  where MAPPED_REPORT_NAME != '(null)'
  and MAPPED_REPORT_ID != '(null)'
  and MAPPED_REPORT_FOLDER_NAME != '(null)'
  and RULESET_ID != '(null)'
  ) tbl1
inner join 
  pm_document tbl2
on 
  tbl2.DOCUMENT_ID = tbl1.MAPPED_REPORT_FOLDER_NAME -- depending on projection
inner join 
  lc_ruleset tbl3
on 
  tbl3.RULESET_ID = tbl1.RULESET_ID
inner join
  lc_datasource tbl4
on
  tbl4.DATASOURCE_ID = tbl3.DATASOURCE_ID
where 
  tbl1.MAPPED_REPORT_NAME like '%HUA_%';