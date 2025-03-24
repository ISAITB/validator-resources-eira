<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.02">
 	<rule context="$SBBsForLegalViewABBs">
	    <assert test="$EIRA-011" flag="fatal" id="EIRA-011">[EIRA-011] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Legal view.</assert>
 	</rule>
 	<rule context="$SBBsForOrganisationalViewABBs">
	    <assert test="$EIRA-012" flag="fatal" id="EIRA-012">[EIRA-012] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Organisational view.</assert>
 	</rule>
 	<rule context="$SBBsForSemanticViewABBs">
	    <assert test="$EIRA-013" flag="fatal" id="EIRA-013">[EIRA-013] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Semantic view.</assert>
 	</rule>
 	<rule context="$SBBsForTechAppViewABBs">
	    <assert test="$EIRA-014" flag="fatal" id="EIRA-014">[EIRA-014] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Technical view - application.</assert>
 	</rule>
 	<rule context="$SBBsForTechInfraViewABBs">
	    <assert test="$EIRA-015" flag="fatal" id="EIRA-015">[EIRA-015] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Technical view - infrastructure.</assert>
 	</rule>
 	<rule context="$SBBsForIOPPrincipleViewABBs">
	    <assert test="$EIRA-016" flag="fatal" id="EIRA-016">[EIRA-016] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's EIF Underlying Principles view.</assert>
 	</rule>
 	<rule context="$SBBsForTechViewABBs">
	    <assert test="$EIRA-017" flag="fatal" id="EIRA-017">[EIRA-017] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in one of the model's Technical views.</assert>
 	</rule>
</pattern>
