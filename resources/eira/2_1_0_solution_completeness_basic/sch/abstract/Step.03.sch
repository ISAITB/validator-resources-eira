<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.03">
	<rule context="$Model">
        <assert test="$EIRA-025-01" flag="warning" id="EIRA-025-01">[EIRA-025] All ABBs in the high-level overview must be defined. No 'Public Policy' SBB is defined.</assert>
        <assert test="$EIRA-025-02" flag="warning" id="EIRA-025-02">[EIRA-025] All ABBs in the high-level overview must be defined. No 'Public Service Provider' SBB is defined.</assert>
        <assert test="$EIRA-025-03" flag="warning" id="EIRA-025-03">[EIRA-025] All ABBs in the high-level overview must be defined. No 'Public Service Consumer' SBB is defined.</assert>
        <assert test="$EIRA-025-04" flag="warning" id="EIRA-025-04">[EIRA-025] All ABBs in the high-level overview must be defined. No 'Public Service' SBB is defined.</assert>
        <assert test="$EIRA-025-05" flag="warning" id="EIRA-025-05">[EIRA-025] All ABBs in the high-level overview must be defined. No 'Business Capability' SBB is defined.</assert>
        <assert test="$EIRA-025-06" flag="warning" id="EIRA-025-06">[EIRA-025] All ABBs in the high-level overview must be defined. No 'Exchange of Business Information' SBB is defined.</assert>
        <assert test="$EIRA-025-07" flag="warning" id="EIRA-025-07">[EIRA-025] All ABBs in the high-level overview must be defined. No 'Business Information' SBB is defined.</assert>
        <assert test="$EIRA-025-08" flag="warning" id="EIRA-025-08">[EIRA-025] All ABBs in the high-level overview must be defined. No 'Representation' SBB is defined.</assert>

	    <assert test="$EIRA-026-01" flag="warning" id="EIRA-026-01">[EIRA-026] All ABBs in the high-level overview must be defined. No 'Data' SBB (or a specialization) is defined.</assert>
	    <assert test="$EIRA-026-02" flag="warning" id="EIRA-026-02">[EIRA-026] All ABBs in the high-level overview must be defined. No 'Hosting and Networking Infrastructure' SBB (or a specialization) is defined.</assert>
	    <assert test="$EIRA-026-03" flag="warning" id="EIRA-026-03">[EIRA-026] All ABBs in the high-level overview must be defined. No 'Application Service' SBB (or a specialization) is defined.</assert>
	    <assert test="$EIRA-026-04" flag="warning" id="EIRA-026-04">[EIRA-026] All ABBs in the high-level overview must be defined. No 'Digital Service Infrastructure' SBB (or a specialization) is defined.</assert>

	    <assert test="$EIRA-027-01" flag="warning" id="EIRA-027-01">[EIRA-027] All ABBs in the high-level overview must be defined. At least one SBB for ABBs ['Machine to Machine Interface', 'Human Interface'] must be defined.</assert>
	</rule>
</pattern>
