select 
  tbl1.*,
  tbl4.TECHPACK_NAME || '|_|' || tbl4.TECHPACK_VERSION || '|_|' || tbl4.TECHNOLOGY || '|_|' || tbl4.VENDOR || '|_|' || tbl3.TYPE as "TECHPACK_INFO",
  tbl5.LOADER_NAME as "LOADER_NAME"
from (
  select
    *
  from
    (
      select
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/AlarmContext') as "GERN_ALARM_CONTEXT",
        TIME_STAMP as "GERN_ALARM_CREATED_DATE",
        TEMPLATE_NAME as "GERN_ALARM_NAME", 
        -- General
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/AlarmStandardMapping/X733/EventType/@ParameterValue') as "GERN_ALARM_TYPE",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/AlarmDescription') as "GERN_ALARM_DESCRIPTION",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/@AlarmStandard') as "GERN_ALARM_STANDARD",
        VERSION_ID as "GERN_VERSION_ID",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/KeyPerformanceIndicator') as "GERN_ALARM_KPI",
        -- Options
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/AlarmSettings/ReportPredicates/@Active') as "OPT_RPT_PREDICATE",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/AlarmStandardMapping/X733/ManagedObjectClass/@ParameterValue') as "OPT_NTWK_OBJ_CLS",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/AlarmStandardMapping/X733/ManagedObjectName/@ParameterValue') as "OPT_NTWK_OBJ_INST_MAPPING",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/LoaderParameters/ContextName') as "OPT_TABLE_NAME",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/LoaderParameters/Ruleset') as "OPT_RULESET_ID",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/MappedReportName') as "OPT_REPORT_NAME",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/MappedReportID') as "OPT_REPORT_ID",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/General/MappedReportFolderName') as "OPT_REPORT_FOLDER_ID",       
        -- X.773
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/AlarmStandardMapping/X733/ProbableCause/@ParameterValue') as "X773_PROBABLE_CAUSE",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/AlarmStandardMapping/X733/AdditionalText/@ParameterValue') as "X773_ADDI_TEXT",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/AlarmStandardMapping/X733/MonitoredAttribute/@ParameterValue') as "X773_MONITORED_ATTR",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmTemplate/AlarmSettings/UseTrendNotification/@Active') as "X773_USE_TREND_IND"
      from 
        alarm_templates
      ) tbl1
  where OPT_REPORT_NAME != '(null)'
  and OPT_REPORT_ID != '(null)'
  and OPT_REPORT_FOLDER_ID != '(null)'
  and OPT_RULESET_ID != '(null)'
  ) tbl1
inner join 
  pm_document tbl2
on 
  tbl2.DOCUMENT_ID = tbl1.OPT_REPORT_FOLDER_ID
inner join 
  lc_ruleset tbl3
on 
  tbl3.RULESET_ID = tbl1.OPT_RULESET_ID
inner join
  lc_datasource tbl4
on
  tbl4.DATASOURCE_ID = tbl3.DATASOURCE_ID
inner join (
  select datasource_id, loader_name 
  from LC_LOADER_CONFIG_PROPERTIES 
  group by datasource_id, loader_name
) tbl5
on 
  tbl5.datasource_id = tbl3.DATASOURCE_ID
order by 
  tbl1.GERN_ALARM_NAME;