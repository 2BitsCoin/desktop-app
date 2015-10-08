package controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import message.BxHeader;
	import utils.*;

	/**
	* Settings manager class. Displays and manages all Settings Sections.
	* @see modules.chat.settings.BxSection
	*/
	dynamic public class BxSettings extends BxWindow
	{
		private const iWidth:Number = 240;
		private const iHeight:Number = 240;
		private var
			bLangChanged:Boolean = false,
			bSkinChanged:Boolean = false,
			sLanguage:String,
			sSkin:String,
			lImageLoader:Loader;
		/**
		* @private
		*/
		function BxSettings()
		{
			width = iWidth;
			height = iHeight;
			this.btnApply.addEventListener(MouseEvent.CLICK, onApply);
		}
		
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			root.addEventListener(BxLanguage.LANGUAGES_LIST_LOADED, onLanguagesList);
			root.addEventListener(BxSkin.SKINS_LIST_LOADED, onSkinsList);
			BxStyle.changeTextFormat(this.txtLanguage, root.mcStyle.WindowTextRight);
		}
		
		private function onLanguageChange(event:Event):void
		{
			this.btnApply.mouseEnabled = bLangChanged = true;
		}
		
		private function onLanguagesList(event:Event):void
		{
			trace("onLanguagesList");
			this.mcLanguages.init(root.oLanguage.files, true);
			sLanguage = root.oLanguage.current;
			this.mcLanguages.changeValue(sLanguage);
			this.mcLoading.visible = this.btnApply.mouseEnabled = false;
			this.mcLanguages.addEventListener(Event.CHANGE, onLanguageChange);
		}
		
		private function onSkinsList(event:Event):void
		{
			trace("onSkinsList");
			this.mcSkins.init(root.oSkin.files, true);
			sSkin = root.oSkin.current;
			this.mcSkins.changeValue(sSkin);
			image = root.oSkin.getPreviewUrl(sSkin);
			this.mcSkins.addEventListener(Event.CHANGE, onSkinChange);
		}
		
		private function onSkinChange(event:Event):void
		{
			image = root.oSkin.getPreviewUrl(this.mcSkins.value);
			this.btnApply.mouseEnabled = bSkinChanged = true;
		}
		
		private function set image(sImage:String):void
		{
			if(lImageLoader != null && contains(lImageLoader)) removeChild(lImageLoader);
			lImageLoader = new Loader();
			lImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			lImageLoader.load(new URLRequest(sImage));
			this.mcLoading.visible = true;
		}
		
		private function onImageLoaded(event:Event):void
		{
			lImageLoader.scaleX = lImageLoader.scaleY = Math.min(this.mcBorder.width / lImageLoader.width, this.mcBorder.height / lImageLoader.height);
			lImageLoader.x = this.mcBorder.x + (this.mcBorder.width - lImageLoader.width) / 2;
			lImageLoader.y = this.mcBorder.y + (this.mcBorder.height - lImageLoader.height) / 2;
			addChildAt(lImageLoader, getChildIndex(this.mcBorder));
			this.mcLoading.visible = false;
		}
		/**
		* @private
		*/
		override protected function onLanguage(event:Event):void
		{
			super.onLanguage(event);
			caption = root.oLanguage.getString("dlgSettings", "Settings");
			this.txtLanguage.text = root.oLanguage.getString("dlgLanguage", "Language: ");
			this.txtSkin.text = root.oLanguage.getString("dlgSkin", "Template: ");
			root.oLanguage.setButtonCaption(this.btnApply, root.oLanguage.getString("btnApply", "Apply"), false);
		}
		
		private function init(event:Event):void
		{
			visible = true;
		}
		
		private function onApply(event:Event):void
		{
			if(bLangChanged)
			{
				sLanguage = this.mcLanguages.value;
				root.oLanguage.loadFile(sLanguage);
				root.oXml.returnXml(root.oXml.getXmlUrl("setLanguage", [sLanguage]));
				bLangChanged = false;
			}
			if(bSkinChanged)
			{
				sSkin = this.mcSkins.value;
				root.oSkin.loadFile(sSkin);
				root.oXml.returnXml(root.oXml.getXmlUrl("setSkin", [sSkin]));
				navigateToURL(new URLRequest("javascript:reload()"), "_self");
				bSkinChanged = false;
			}
			this.btnApply.mouseEnabled = false;
			close();
		}
		
		override public function close(event:Event = null):void
		{
			this.mcLanguages.changeValue(sLanguage);
			this.mcSkins.changeValue(sSkin);
			this.btnApply.mouseEnabled = false;
			super.close(event);
		}
	}
}