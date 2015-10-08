package utils
{
	import utils.BxXml;
	import flash.events.Event;
	import flash.display.*;
	import flash.text.*;
	
	/**
	 * Provides skins list retrieving functionality
	 */
	public class BxSkin extends Sprite
	{
		/**
		* @private
		*/
		public static const SKINS_LIST_LOADED:String = "skinsLoaded";
		/**
		* @private
		*/
		protected var 
			sCurrent:String = "", sUrl:String, sListEvent:String = SKINS_LIST_LOADED,
			aFiles:Array,
			oXml:Object;
		
		/**
		* @private
		*/
		function BxSkin(objXml:BxXml, sAction:String)
		{
			oXml = objXml;
			oXml.returnXml(oXml.getXmlUrl(sAction), this, "onGetFiles", 2);
		}
		
		/**
		* Gets all skins array. Every entry is represented by object with <code>value</code> (file name)
		* and <code>caption</code> properties.
		*/
		public function get files():Array {return aFiles;}
		/**
		* Gets current skin file name.
		*/
		public function get current():String {return sCurrent;}
		/**
		* Gets skin's preview image URL.
		* @param sName skin's name.
		*/
		public function getPreviewUrl(sName:String):String
		{
			return sUrl + sName + ".jpg";
		}
		
		/**
		* @private
		* getting languages handler
		* @param aData - skins data
		*/
		public function onGetFiles(event:Event):void
		{
			aFiles = new Array();
			var aFilesData:Object = event.data[0][0];
			var aCurrent:Object = event.data[0][1];
			sUrl = aCurrent["url"].substring(0, aCurrent["url"].lastIndexOf("/")+1);
			for(var i:Number=0; i<aFilesData.length; i++)
			{
				var sName:String = aFilesData[i]["name"];
				var sCaption:String = (aFilesData[i]["_value"] is String) ? BxXml.replaceXmlCharacters(aFilesData[i]["_value"]) : sName;
				aFiles.push({value: sName, caption: sCaption});
			}
			loadFile(aCurrent["name"]);
			root.dispatchEvent(new Event(sListEvent));
		}
		
		/**
		* Changes current skin (doesn't change it actually).
		* @param sName New skin name
		* @see modules.chat.settings.BxSkins#apply
		*/
		public function loadFile(sName:String):Boolean
		{
			if(sCurrent == sName) return false;
			sCurrent = sName;
			return true;
		}
	}
}