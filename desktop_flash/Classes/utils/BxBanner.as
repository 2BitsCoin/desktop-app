package utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import utils.BxXmlEvent;
	
	public class BxBanner extends Sprite
	{
		public static const LOADED:String = "onBannerLoaded";
		public static const CLICKED:String = "onBannerClicked";
		private var
			iViews = 0, iWidthShift = 10, iHeight:Number = 0,
			sId = "", sUrl:String = "",
			lImageLoader:Loader,
			oSize:Object;
		
		function BxBanner(aData:Object)
		{
			buttonMode = true;
			if(!isNaN(aData.height)) iHeight = aData.height;
			if(aData.id is String) sId = aData.id;
			if(aData.redirect is String) sUrl = aData.redirect;
			if(aData.image is String) image = aData.image;
			visible = false;
		}
		
		public function get id():String {return sId;}
		
		private function set image(sImage:String)
		{
			lImageLoader = new Loader();
			lImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			lImageLoader.load(new URLRequest(sImage));
		}
		
		private function onImageLoaded(event:Event)
		{
			oSize = {width: lImageLoader.width, height: lImageLoader.height};
			width = root.width;
			addChild(lImageLoader);
			lImageLoader.addEventListener(MouseEvent.CLICK, onClick);
			dispatchEvent(new BxXmlEvent(LOADED, this));
		}
		
		private function onClick(event:Event)
		{
			navigateToURL(new URLRequest(sUrl), "_blank");
			dispatchEvent(new BxXmlEvent(CLICKED, sId));
		}
		
		override public function set width(iWidth:Number):void
		{
			iWidth -= iWidthShift;
			lImageLoader.scaleX = lImageLoader.scaleY = Math.min(iWidth / oSize.width, iHeight / oSize.height);
			lImageLoader.x = (root.width - lImageLoader.width) / 2;
			lImageLoader.y = (iHeight - lImageLoader.height) / 2;
		}
		
		override public function set visible(b:Boolean):void
		{
			super.visible = b;
			if(b) iViews++;
		}
		
		public function get views():Number
		{
			var t = iViews;
			iViews = 0;
			return t;
		}
	}
}