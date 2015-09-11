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
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/General/AlarmContext') as "GERN_ALARM_CONTEXT",
        TIME_STAMP as "GERN_ALARM_CREATED_DATE",
        DEFINITION_NAME as "GERN_ALARM_NAME", 
        -- General
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmStandardMapping/X733/EventType/@ParameterValue') as "GERN_ALARM_TYPE",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/General/AlarmDescription') as "GERN_ALARM_DESCRIPTION",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/@AlarmStandard') as "GERN_ALARM_STANDARD",
        VERSION_ID as "GERN_VERSION_ID",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/@TemplateName') as "GERN_TEMPLATE_NAME",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/@TemplateVersion') as "GERN_TEMPLATE_VERSION",
        -- Alarm Predicate
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/General/KeyPerformanceIndicator') as "PRED_KPI",
        
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[1]/Severity/@Level') || ' '
        || extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[1]/BinaryOperator/@Symbol') || ' '
        || extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[1]/RightOperand')as "PRED_1",
        
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[2]/Severity/@Level') || ' '
        || extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[2]/BinaryOperator/@Symbol') || ' '
        || extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[2]/RightOperand')as "PRED_2",
        
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[3]/Severity/@Level') || ' '
        || extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[3]/BinaryOperator/@Symbol') || ' '
        || extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[3]/RightOperand')as "PRED_3",
        
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[4]/Severity/@Level') || ' '
        || extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[4]/BinaryOperator/@Symbol') || ' '
        || extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[4]/RightOperand')as "PRED_4",
        
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[5]/Severity/@Level') || ' '
        || extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[5]/BinaryOperator/@Symbol') || ' '
        || extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmPredicate[5]/RightOperand')as "PRED_5",

        -- Options
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmSettings/ReportPredicates/@Active') as "OPT_RPT_PREDICATE",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmStandardMapping/X733/ManagedObjectClass/@ParameterValue') as "OPT_NTWK_OBJ_CLS",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmStandardMapping/X733/ManagedObjectName/@ParameterValue') as "OPT_NTWK_OBJ_INST_MAPPING",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/LoaderParameters/ContextName') as "OPT_TABLE_NAME",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/LoaderParameters/Ruleset') as "OPT_RULESET_ID",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/General/MappedReportName') as "OPT_REPORT_NAME",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/General/MappedReportID') as "OPT_REPORT_ID",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/General/MappedReportFolderName') as "OPT_REPORT_FOLDER_ID",
        
        -- X.773
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmStandardMapping/X733/ProbableCause/@ParameterValue') as "X773_PROBABLE_CAUSE",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmStandardMapping/X733/AdditionalText/@ParameterValue') as "X773_ADDI_TEXT",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmStandardMapping/X733/MonitoredAttribute/@ParameterValue') as "X773_MONITORED_ATTR",
        extractValue(xmltype(XML_DOCUMENT), '/AlarmDefinition/AlarmSettings/UseTrendNotification/@Active') as "X773_USE_TREND_IND"        
      from 
        alarm_definitions
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