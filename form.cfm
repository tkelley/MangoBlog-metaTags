<cfoutput>
	<fieldset id="setMetaTags" class="">
		<legend>Meta Tags</legend>
		<p style="clear:left;margin:0.5em 0;">
			<label for="metaTags_keywords">Meta Keywords</label>
			<span class="field"><input type="text" name="metaTags_keywords" id="metaTags_keywords" size="100" maxsize="300" class="text" value="<cfoutput>#local.metaKeywords#</cfoutput>"></span>
		</p>

		<p style="clear:left;margin:0.5em 0;">
			<label for="metaTags_description">Meta Description</label>
			<span class="field"><textarea id="metaTags_description" name="metaTags_description" rows="4" cols="75"><cfoutput>#local.metaDescription#</cfoutput></textarea></span>
		</p>
	</fieldset>
</cfoutput>