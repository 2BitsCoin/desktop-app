package utils
{
	import flash.display.*;
	import flash.events.*;
	import utils.BxXml;
	
	dynamic public class BxAds extends Sprite
	{
		private var iAlpha:Number = 100;
		
		function BxAds()
		{
			super();
			this.mcBack.buttonMode = true;
			this.mcBack.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override protected function onResize(event:Event):void {}
		
		override public function onGetAds(event:Event):void
		{
			var aResult:Object = super.onGetAds(event);
				
			var bEnabled = aResult["enabled"] is String && aResult["enabled"] == BxXml.TRUE_VAL;
			this.mcBoonex.visible = !bEnabled;
			if(bEnabled && aResult["banner"] is String && aResult["banner"] != "")
			{
				image = aResult["banner"];
				sUrl = aResult["url"];
				sTarget = aResult["target"];
				if(!isNaN(aResult["alpha"])) iAlpha = Number(aResult["alpha"]);
			}
			else visible = true;			
		}
		
		private function set image(sImage:String):void
		{
			var lLoader = new Loader();
			lLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			lLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadImageError);
			lLoader.load(new URLRequest(sImage));
		}
		
		protected function onLoadImageError(event:IOErrorEvent):void
		{
			trace("error screen");
		}
		
		private function onImageLoaded(event:Event)
		{
			var lLoader = event.target.loader;
			this.mcBack.width = lLoader.width;
			this.mcBack.height = lLoader.height;
			lLoader.mouseEnabled = false;
			lLoader.alpha = iAlpha / 100;
			addChild(lLoader);
			visible = true;
		}
	}
}