package utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import utils.*;
	
	dynamic public class BxAdsSimple extends Sprite
	{
		public static const LOADED:String = "onLoaded";
		private var
			iShiftX:Number = 0,
			sUrl:String = "http://www.boonex.com/",
			sTarget:String = "_blank";
		
		function BxAdsSimple()
		{
			visible = false;
			iShiftX = this.mcBack.width - this.mcBoonex.x;
			this.mcBoonex.buttonMode = true;
			this.mcBoonex.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			root.addEventListener(Event.RESIZE, onResize);
		}
		
		public function onGetAds(event:Event):void
		{
			var aResult:Object = event.data[0][0];
				
			var bEnabled = aResult["enabled"] is String && aResult["enabled"] == BxXml.TRUE_VAL;
			visible = !bEnabled;
			dispatchEvent(new BxXmlEvent(LOADED, aResult));
		}
		
		private function onResize(event:Event):void
		{
			var iWidth = event.data.width - 2*x - 1;
			this.mcBoonex.x = iWidth - iShiftX;
			this.mcBack.width = iWidth;
		}
		
		private function onClick(event:Event)
		{
			navigateToURL(new URLRequest(sUrl), sTarget);
		}
		
		override public function get height():Number
		{
			return visible ? super.height + x : 0;
		}
	}
}