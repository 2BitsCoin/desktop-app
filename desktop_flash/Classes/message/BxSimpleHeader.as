package message
{
	import controls.MovieClipContainer;
	import utils.*
	import flash.net.*;
	import flash.events.*;
	import flash.display.*;
	import flash.text.TextField;
	
	/**
	* Used as a super class for <code>BxHeader</code> and in other widgets (Shoutbox and etc.)
	* @see BxHeader
	*/
	dynamic public class BxSimpleHeader extends MovieClipContainer
	{
		private var
			sSiteName:String = "", sBoonexUrl:String = "http://www.boonex.com/";
			
		/**
		* @private
		* class constructor
		*/
		function BxSimpleHeader()
		{
			this.btnBoonex.addEventListener(MouseEvent.MOUSE_DOWN, onBoonexPress);
			parent.addEventListener(BxLanguage.LANGUAGE_LOADED, onLanguage);
			parent.addEventListener(parent.EVENT_CONFIG, onConfig);
		}
		/**
		* @private
		*/
		protected function onLanguage(event:Event):void
		{
			refreshCaption();
			BxStyle.changeTextFormat(this.txtCaption, root.mcStyle.RootHeaderText);			
			root.mcHint.attach(this.btnBoonex, "Go to BoonEx homepage");
		}
		/**
		* @private
		*/
		protected function onConfig(event:Event):void
		{
			if(parent.oConfig.siteName is String)
			{
				sSiteName = BxXml.replaceXmlCharacters(parent.oConfig.siteName);
				refreshCaption();
			}
			this.btnBoonex.visible = root.free;
		}
		/**
		* @private
		*/
		protected function refreshCaption():void
		{
			caption = parent.oLanguage.getString("txtHeader").split("#site#").join(sSiteName);			
		}
		
		private function onBoonexPress(event:Event):void
		{
			navigateToURL(new URLRequest(sBoonexUrl), "_blank");
		}
		
		override public function set width(iWidth:Number):void
		{
			super.width = iWidth;
			this.txtCaption.width = iWidth;
		}
	}
}