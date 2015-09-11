-- Relevant alarm tables
select * from alarm_document_context;
select * from alarm_templates;
select * from alarm_definitions;

-- Alarm Template relevant information
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
and RULESET_ID != '(null)';

/*
with tbl as (
    select
      CONTEXT_ID, TEMPLATE_NAME, TIME_STAMP, VERSION_ID,
      extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/MappedReportName') as "MAPPED_REPORT_NAME",
      extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/MappedReportID') as "MAPPED_REPORT_ID",
      extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/MappedReportFolderName') as "MAPPED_REPORT_FOLDER_NAME",
      extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/LoaderParameters/Ruleset') as "RULE_SET_ID"
    from 
      alarm_templates
) select * from tbl where MAPPED_REPORT_NAME != '(null)';
*/

-- Alarm Definition relevant information
select * from (
  select
    ALARM_ID, CONTEXT_ID, DEFINITION_NAME, IS_ACTIVE, TIME_STAMP, VERSION_ID,
    extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/General/MappedReportName') as "MAPPED_REPORT_NAME",
    extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/General/MappedReportID') as "MAPPED_REPORT_ID",
    extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/General/MappedReportFolderName') as "MAPPED_REPORT_FOLDER_NAME",
    extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/LoaderParameters/Ruleset') as "RULESET_ID"
  from 
    alarm_definitions) tbl
where MAPPED_REPORT_NAME != '(null)'
and MAPPED_REPORT_ID != '(null)'
and MAPPED_REPORT_FOLDER_NAME != '(null)'
and RULE_SET_ID != 'null';    
  
-- We know that each RULESET_ID is TP associated
-- Join to get full TP details with lc_dataload
select 
  tbl1.DATASOURCE_ID as "SOURCE_DS_ID", tbl2.RULESET_ID as "SOURCE_RULESET_ID",
  tbl1.TECHPACK_NAME || '|' || tbl1.TECHPACK_VERSION || '|' || tbl1.TECHNOLOGY || '|' || tbl1.VENDOR as "TECHPACK_KEY"
from 
  lc_datasource tbl1
inner join
  lc_ruleset tbl2
on 
  tbl1.DATASOURCE_ID = tbl2.DATASOURCE_ID;

-- Report and Report Folder information
select 
  tbl1.DOCUMENT_ID as "DOCUMENT_ID", tbl1.NAME as "DOCUMENT_NAME",
  tbl1.PARENT_DOC_ID as "FODLER_ID", tbl2.NAME as "FOLDER_NAME"
from 
  pm_document tbl1 -- Report
inner join
  pm_document tbl2 -- Report Foler
on 
  tbl2.DOCUMENT_ID = tbl1.PARENT_DOC_ID
where
  tbl1.DOCUMENT_TYPE_ID = 2 
  and tbl2.NAME = 'sysadm';

select 
  DOCUMENT_ID, NAME 
from 
  pm_document 
where 
  DOCUMENT_TYPE_ID = 1;
