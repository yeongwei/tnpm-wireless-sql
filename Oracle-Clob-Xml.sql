-- Create test table
create table if not exists test_table (id varchar(20), xml_doc clob);
delete from test_table; 
commit;

-- Insert test data
insert into test_table values ('yeongwei', '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<basket>
	<owner>
		<name>Yeong Wei</name>
		<contact>6018 660 1566</contact>
		<location>Petaling Jaya</location>
	</owner>
	<laptop>
		<brand>HP</brand>
		<model>ProBook 6470b</model>
	</laptop>
	<vehicle>
		<brand>Proton</brand>
		<model>Persona</model>
    <engine>
      <capacity>1.6</capacity>
    </engine>
	</vehicle>
</basket>');
commit;

-- Update xml name tag
update test_table
set xml_doc = to_clob(
updatexml(xmltype(xml_doc), '/basket/owner/name/text()', 'Yeong Wei, Lai'))
where id = 'yeongwei';
commit;

-- Update xml location tag
update test_table
set xml_doc = to_clob(
updatexml(xmltype(xml_doc), '/basket/owner/location/text()', 'Petaling Jaya, Damasara Uptown'))
where id = 'yeongwei';
commit;

-- Update xml engine/capacity tag
update test_table
set xml_doc = to_clob(
updatexml(
  xmltype(xml_doc), 
  '/basket/vehicle/engine/capacity/text()', '1600 cc',
  '/basket/vehicle/model/text()', 'Persona Facelift'))
where id = 'yeongwei';
commit;

select 
  extractValue(xmltype(xml_doc), '/basket/owner/name') as "Owner Name",
  extractValue(xmltype(xml_doc), '/basket/owner/location') as "Owner Location",
  extractValue(xmltype(xml_doc), '/basket/vehicle/engine/capacity') as "Engine Capacity"
from test_table where id = 'yeongwei';