<cfcomponent extends="BasePlugin">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true">
		<cfargument name="preferences" type="any" required="true">

		<cfscript>
			setManager(arguments.mainManager);
			setPreferencesManager(arguments.preferences);
			setPackage("com.tysonkelley.plugins.metaTags");

			variables.metaTags = structNew();

			// Map our meta tags
			variables.metaTags["metaTags_description"] = "";
			variables.metaTags["metaTags_keywords"] = "";

			return this;
		</cfscript>
	</cffunction>

	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true">
		<cfscript>
			var local = StructNew();

			// Run event handler
			switch(arguments.event.name){
				case "beforeHtmlHeadEnd": return displayMetaTags(arguments.event);
				case "beforeAdminPostFormDisplay": return removeMetaTagsFromCustomFields(arguments.event);
				case "beforeAdminPostFormEnd": return displayMetaTagFields(arguments.event);
				case "beforePostAdd": return addMetaTagsToCustomFields(arguments.event);
				case "beforePostUpdate": return addMetaTagsToCustomFields(arguments.event);
			}

			return arguments.event;
		</cfscript>
	</cffunction>

	<cffunction name="removeMetaTagsFromCustomFields" hint="Take our meta tags out of the custom fields (we'll use a custom display instead)" access="private" output="false" returntype="any">
		<cfargument name="event" type="any" required="true">
		<cfset var local = StructNew()>

		<cfloop collection="#variables.metaTags#" item="local.key">
			<cfif arguments.event.item.customFieldExists(local.key)>
				<cfset variables.metaTags[local.key] = arguments.event.item.getCustomField(local.key).value>
				<cfset arguments.event.item.removeCustomField(local.key)>
			</cfif>
		</cfloop>

		<cfreturn arguments.event>
	</cffunction>

	<cffunction name="displayMetaTagFields" hint="Use a custom display for the meta tags" access="private" output="false" returntype="any">
		<cfargument name="event" type="any" required="true">
		<cfset var local = StructNew()>

		<cfset local.metaKeywords = variables.metaTags.metaTags_keywords>
		<cfset local.metaDescription = variables.metaTags.metaTags_description>
		<cfsavecontent variable="contentForDisplay"><cfinclude template="form.cfm"></cfsavecontent>
		<cfset arguments.event.setOutputData(arguments.event.getOutputData() & contentForDisplay)>
		
		<cfreturn arguments.event>
	</cffunction>

	<cffunction name="displayMetaTags" hint="Output the actual meta tags" access="private" output="false" returntype="any">
		<cfargument name="event" type="any" required="true">
		<cfset var local = StructNew()>
		<cfset local.metaTags = StructNew()>
		<cfset local.currentPost = arguments.event.contextData.currentPost>

		<cfloop collection="#variables.metaTags#" item="local.key">
			<cfif local.currentPost.customFieldExists(local.key)>
				<cfset local.metaTags[local.key] = local.currentPost.getCustomField(local.key).value>
			</cfif>
		</cfloop>
		
		<cfsavecontent variable="contentForDisplay"><cfinclude template="display.cfm"></cfsavecontent>
		<cfset arguments.event.setOutputData(arguments.event.getOutputData() & contentForDisplay)>
		
		<cfreturn arguments.event>
	</cffunction>

	<cffunction name="addMetaTagsToCustomFields" hint="Add the meta tags back into custom fields" access="private" output="false" returntype="any">
		<cfargument name="event" type="any" required="true">
		<cfset var local = StructNew()>
		
		<cfloop collection="#variables.metaTags#" item="local.key">
			<cfif structKeyExists(arguments.event.data.rawData, local.key)>
				<cfset arguments.event.data.post.setCustomField(local.key, local.key, arguments.event.data.rawdata[local.key])>
			</cfif>
		</cfloop>

		<cfreturn arguments.event>
	</cffunction>

</cfcomponent>