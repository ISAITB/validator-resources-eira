<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.02">

	<rule context="$SBB">
		<assert test="$EIRA-011" flag="fatal" id="EIRA-011">[EIRA-011] SBB '<value-of select="$ElementName"/>' (<value-of select="$SBBDeclaredABB"/>) is not present in the model's Legal view.</assert>
		<assert test="$EIRA-012" flag="fatal" id="EIRA-012">[EIRA-012] SBB '<value-of select="$ElementName"/>' (<value-of select="$SBBDeclaredABB"/>) is not present in the model's Organisational view.</assert>
		<assert test="$EIRA-013" flag="fatal" id="EIRA-013">[EIRA-013] SBB '<value-of select="$ElementName"/>' (<value-of select="$SBBDeclaredABB"/>) is not present in the model's Semantic view.</assert>
		<assert test="$EIRA-014" flag="fatal" id="EIRA-014">[EIRA-014] SBB '<value-of select="$ElementName"/>' (<value-of select="$SBBDeclaredABB"/>) is not present in the model's Technical view - application.</assert>
		<assert test="$EIRA-015" flag="fatal" id="EIRA-015">[EIRA-015] SBB '<value-of select="$ElementName"/>' (<value-of select="$SBBDeclaredABB"/>) is not present in the model's Technical view - infrastructure.</assert>
		<assert test="$EIRA-017" flag="fatal" id="EIRA-017">[EIRA-017] SBB '<value-of select="$ElementName"/>' (<value-of select="$SBBDeclaredABB"/>) is not present in one of the model's Technical views.</assert>
	</rule>

 	<rule context="$ABB">
	    <assert test="$EIRA-029" flag="fatal" id="EIRA-029">[EIRA-029] ABB '<value-of select="$ElementName"/>' is not present in the model's Legal view.</assert>
	    <assert test="$EIRA-030" flag="fatal" id="EIRA-030">[EIRA-030] ABB '<value-of select="$ElementName"/>' is not present in the model's Organisational view.</assert>
	    <assert test="$EIRA-031" flag="fatal" id="EIRA-031">[EIRA-031] ABB '<value-of select="$ElementName"/>' is not present in the model's Semantic view.</assert>
	    <assert test="$EIRA-032" flag="fatal" id="EIRA-032">[EIRA-032] ABB '<value-of select="$ElementName"/>' is not present in the model's Technical view - application.</assert>
	    <assert test="$EIRA-033" flag="fatal" id="EIRA-033">[EIRA-033] ABB '<value-of select="$ElementName"/>' is not present in the model's Technical view - infrastructure.</assert>
	    <assert test="$EIRA-035" flag="fatal" id="EIRA-035">[EIRA-035] ABB '<value-of select="$ElementName"/>' is not present in one of the model's Technical views.</assert>
 	</rule>
</pattern>
