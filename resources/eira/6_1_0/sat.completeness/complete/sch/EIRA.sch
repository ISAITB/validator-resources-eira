<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
	<title>EIRA v6.1.0 - SAT Completeness Profile - Complete level</title>
	<ns prefix="a" uri="http://www.opengroup.org/xsd/archimate/3.0/"/>
	<ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
	<phase id="Step.01">
		<active pattern="MEF-Step.01"/>
	</phase>
	<phase id="Step.02">
		<active pattern="MEF-Step.02"/>
	</phase>
	<include href="abstract/Step.01.sch"/>
	<include href="abstract/Step.02.sch"/>
	<include href="mef/MEF-Step.01.sch"/>
	<include href="mef/MEF-Step.02.sch"/>
</schema>