<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.03">
	<rule context="$Model">
        <assert test="$EIRA-018-01" flag="fatal" id="EIRA-018-01">[EIRA-018] All ABBs in the high-level overview must be defined. No 'Public Policy' SBB is defined.</assert>
        <assert test="$EIRA-018-02" flag="fatal" id="EIRA-018-02">[EIRA-018] All ABBs in the high-level overview must be defined. No 'Public Service Provider' SBB is defined.</assert>
        <assert test="$EIRA-018-03" flag="fatal" id="EIRA-018-03">[EIRA-018] All ABBs in the high-level overview must be defined. No 'Public Service Consumer' SBB is defined.</assert>
        <assert test="$EIRA-018-04" flag="fatal" id="EIRA-018-04">[EIRA-018] All ABBs in the high-level overview must be defined. No 'Public Service' SBB is defined.</assert>
        <assert test="$EIRA-018-05" flag="fatal" id="EIRA-018-05">[EIRA-018] All ABBs in the high-level overview must be defined. No 'Business Capability' SBB is defined.</assert>
        <assert test="$EIRA-018-06" flag="fatal" id="EIRA-018-06">[EIRA-018] All ABBs in the high-level overview must be defined. No 'Exchange of Business Information' SBB is defined.</assert>
        <assert test="$EIRA-018-07" flag="fatal" id="EIRA-018-07">[EIRA-018] All ABBs in the high-level overview must be defined. No 'Business Information' SBB is defined.</assert>
        <assert test="$EIRA-018-08" flag="fatal" id="EIRA-018-08">[EIRA-018] All ABBs in the high-level overview must be defined. No 'Representation' SBB is defined.</assert>

	    <assert test="$EIRA-019-01" flag="fatal" id="EIRA-019-01">[EIRA-019] All ABBs in the high-level overview must be defined. No 'Data Policy' SBB (or a specialisation) is defined.</assert>
	    <assert test="$EIRA-019-02" flag="fatal" id="EIRA-019-02">[EIRA-019] All ABBs in the high-level overview must be defined. No 'Hosting and Networking Infrastructure' SBB (or a specialisation) is defined.</assert>
	    <assert test="$EIRA-019-03" flag="fatal" id="EIRA-019-03">[EIRA-019] All ABBs in the high-level overview must be defined. No 'Interoperable European Solution Service' SBB (or a specialisation) is defined.</assert>
	    <assert test="$EIRA-019-04" flag="fatal" id="EIRA-019-04">[EIRA-019] All ABBs in the high-level overview must be defined. No 'Digital Service Infrastructure' SBB (or a specialisation) is defined.</assert>

	    <assert test="$EIRA-020-01" flag="fatal" id="EIRA-020-01">[EIRA-020] All ABBs in the high-level overview must be defined. At least one SBB for ABBs ['Machine to Machine Interface', 'Human Interface'] must be defined.</assert>
	</rule>
</pattern>
