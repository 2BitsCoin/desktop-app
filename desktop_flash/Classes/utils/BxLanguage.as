package utils
{
	import flash.events.Event;
	import flash.display.*;
	import flash.text.*;
	
	/**
	 * Provides languages list retrieving and language files loading and applying functionality
	 */
	public class BxLanguage extends BxSkin
	{
		/**
		* @private
		*/
		public static const 
			LANGUAGES_LIST_LOADED:String = "langsLoaded",
			LANGUAGE_LOADED:String = "languageLoaded";
		private var 
			bRepeatLoading:Boolean = false,
			aStrings:Array;
		
		/**
		* @private
		* class constructor
		*/
		function BxLanguage(objXml:BxXml, sAction:String)
		{
			super(objXml, sAction);
			sListEvent = LANGUAGES_LIST_LOADED;
			aStrings = new Array();
		}
		
		/**
		* Changes current language, loads it and changes all language keys.
		* @param sName New language name
		*/
		override public function loadFile(sName:String):Boolean
		{
			if(!super.loadFile(sName)) return false;
			oXml.returnXml(sUrl + sName + ".xml", this, "languageHandler", 1);
			root.mcMessage.init(getString("msgLoading", "LOADING"));
			return true;
		}
		
		/**
		* @private
		* loading language file handler
		* @param aData - parsed XML document
		*/
		public function languageHandler(event:Event):void
		{
			aStrings = new Array();
			var aData:Object = event.data[0];
			for(var i:Number=0; i<aData.length; i++)
				aStrings[aData[i]["key"]] = BxXml.replaceXmlCharacters(aData[i]["_value"]);
			
			if(bRepeatLoading) root.mcMessage.visible = false;
			else bRepeatLoading = true;
			parent.dispatchEvent(new Event(LANGUAGE_LOADED));
		}
		
		public function get strings():Array
		{
			return aStrings;
		}

		/**
		* Gets language string by key (the language file is represented in [widget_name]/langs/english.xml file by default)
		* @param sKey Language string key
		* @param sDefault Default text that should be used if language entry is not found
		*/
		public function getString(sKey:String, sDefault:String = ""):String
		{
			if(sDefault == "") sDefault = sKey;
			return (aStrings[sKey] is String) ? aStrings[sKey] : sDefault;
		}
		/**
		* Applies language string to a given button
		* @param btn Button which caption should be changed
		* @param sCaption Button caption
		* @param bKey Shows whether <code>sCaption</code> should be considered 
		* as language key (true) or as a direct caption for a button
		* @see getString
		*/
		public function setButtonCaption(btn:SimpleButton, sCaption:String, bKey:Boolean = true):void
		{
			if(bKey) sCaption = getString(sCaption);
			setButtonStateText(btn.upState, sCaption);
			setButtonStateText(btn.overState, sCaption);
			setButtonStateText(btn.downState, sCaption);
		}
		
		private function setButtonStateText(mcState:DisplayObject, sText:String):void
		{
			if(!(mcState is DisplayObjectContainer)) return;
			for(var i:Number=0; i<mcState.numChildren; i++)
			{
				var mcChild:Object = mcState.getChildAt(i);
				if(mcChild is TextField) mcChild.text = sText;
			}
		}
	}
}