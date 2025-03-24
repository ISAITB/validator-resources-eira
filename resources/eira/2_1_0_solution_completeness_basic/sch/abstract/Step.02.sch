<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.02">
 	<rule context="$SBBsForLegalViewABBs">
	    <assert test="$EIRA-018" flag="warning" id="EIRA-018">[EIRA-018] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Legal view.</assert>
 	</rule>
 	<rule context="$SBBsForOrganisationalViewABBs">
	    <assert test="$EIRA-019" flag="warning" id="EIRA-019">[EIRA-019] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Organisational view.</assert>
 	</rule>
 	<rule context="$SBBsForSemanticViewABBs">
	    <assert test="$EIRA-020" flag="warning" id="EIRA-020">[EIRA-020] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Semantic view.</assert>
 	</rule>
 	<rule context="$SBBsForTechAppViewABBs">
	    <assert test="$EIRA-021" flag="warning" id="EIRA-021">[EIRA-021] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Technical view - application.</assert>
 	</rule>
 	<rule context="$SBBsForTechInfraViewABBs">
	    <assert test="$EIRA-022" flag="warning" id="EIRA-022">[EIRA-022] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's Technical view - infrastructure.</assert>
 	</rule>
 	<rule context="$SBBsForIOPPrincipleViewABBs">
	    <assert test="$EIRA-023" flag="warning" id="EIRA-023">[EIRA-023] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in the model's EIF Underlying Principles view.</assert>
 	</rule>
 	<rule context="$SBBsForTechViewABBs">
	    <assert test="$EIRA-024" flag="warning" id="EIRA-024">[EIRA-024] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is not present in one of the model's Technical views.</assert>
 	</rule>
</pattern>
