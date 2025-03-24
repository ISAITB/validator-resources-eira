<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.02">
	<rule context="$SBBsForLegalViewABBs">
		<assert test="$EIRA-011" flag="warning" id="EIRA-011">[EIRA-011] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Legal view.</assert>
	</rule>
	<rule context="$SBBsForOrganisationalViewABBs">
		<assert test="$EIRA-012" flag="warning" id="EIRA-012">[EIRA-012] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Organisational view.</assert>
	</rule>
	<rule context="$SBBsForSemanticViewABBs">
		<assert test="$EIRA-013" flag="warning" id="EIRA-013">[EIRA-013] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Semantic view.</assert>
	</rule>
	<rule context="$SBBsForTechAppViewABBs">
		<assert test="$EIRA-014" flag="warning" id="EIRA-014">[EIRA-014] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Technical view - application.</assert>
	</rule>
	<rule context="$SBBsForTechInfraViewABBs">
		<assert test="$EIRA-015" flag="warning" id="EIRA-015">[EIRA-015] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Technical view - infrastructure.</assert>
	</rule>
	<rule context="$SBBsForIOPPrincipleViewABBs">
		<assert test="$EIRA-016" flag="warning" id="EIRA-016">[EIRA-016] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's EIF Underlying Principles view.</assert>
	</rule>
	<rule context="$SBBsForTechViewABBs">
		<assert test="$EIRA-017" flag="warning" id="EIRA-017">[EIRA-017] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in one of the model's Technical views.</assert>
	</rule>

 	<rule context="$ABBsForLegalView">
	    <assert test="$EIRA-029" flag="warning" id="EIRA-029">[EIRA-029] ABB '<value-of select="$ABBName"/>' is not present in the model's Legal view.</assert>
 	</rule>
 	<rule context="$ABBsForOrganisationalView">
	    <assert test="$EIRA-030" flag="warning" id="EIRA-030">[EIRA-030] ABB '<value-of select="$ABBName"/>' is not present in the model's Organisational view.</assert>
 	</rule>
 	<rule context="$ABBsForSemanticView">
	    <assert test="$EIRA-031" flag="warning" id="EIRA-031">[EIRA-031] ABB '<value-of select="$ABBName"/>' is not present in the model's Semantic view.</assert>
 	</rule>
 	<rule context="$ABBsForTechAppView">
	    <assert test="$EIRA-032" flag="warning" id="EIRA-032">[EIRA-032] ABB '<value-of select="$ABBName"/>' is not present in the model's Technical view - application.</assert>
 	</rule>
 	<rule context="$ABBsForTechInfraView">
	    <assert test="$EIRA-033" flag="warning" id="EIRA-033">[EIRA-033] ABB '<value-of select="$ABBName"/>' is not present in the model's Technical view - infrastructure.</assert>
 	</rule>
 	<rule context="$ABBsForIOPPrincipleView">
	    <assert test="$EIRA-034" flag="warning" id="EIRA-034">[EIRA-034] ABB '<value-of select="$ABBName"/>' is not present in the model's EIF Underlying Principles view.</assert>
 	</rule>
 	<rule context="$ABBsForTechView">
	    <assert test="$EIRA-035" flag="warning" id="EIRA-035">[EIRA-035] ABB '<value-of select="$ABBName"/>' is not present in one of the model's Technical views.</assert>
 	</rule>
</pattern>
