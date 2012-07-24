<cfloop collection="#local.metaTags#" item="local.key">
<cfoutput>
	<meta name="#listGetAt(local.key, 2, '_')#" content="#local.metaTags[local.key]#"></cfoutput>
</cfloop>