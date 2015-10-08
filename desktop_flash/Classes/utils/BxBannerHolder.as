package utils
{
	import flash.display.*;
	import flash.system.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class BxBannerHolder extends Sprite
	{
		private var
			iCurrent = -1, iHeight:Number = 0,
			sBoonexHome:String = "http://rms.boonex.com/ray/",
			aBanners:Array,
			tViewsTimer, tTimer:Timer,
			oXml:Object;
		
		override public function get height():Number {return iHeight;}
		
		public function init(objXml:Object, sModule:String, sApp:String)
		{
			oXml = objXml;
			aBanners = new Array();
			var sBoonexUrl = sBoonexHome + "XML.php?module=rms&action=";
			Security.loadPolicyFile(sBoonexHome + "crossdomain.xml");
			oXml.addTemplate("getBoonexBanners", sBoonexUrl + "getAds&widget=" + sModule + "&app=" + sApp);
			oXml.addTemplate("setBoonexImpressions", sBoonexUrl + "updateImpressions", ["ads_ids", "impressions"]);
			oXml.addTemplate("setBoonexClick", sBoonexUrl + "updateClicks", ["ads_id"]);
			
			oXml.returnXml(oXml.getXmlUrl("getBoonexBanners"), this, "onBanners");
			root.addEventListener(Event.RESIZE, onResize);			
		}
		
		public function onBanners(event:Event)
		{
			var aData = event.data[0][0];
			var iUpdateInterval = isNaN(aData.updateInterval) ? 10000 : aData.updateInterval * 1000;
			if(!isNaN(aData.height)) iHeight = aData.height;
			tTimer = new Timer(iUpdateInterval);
			tTimer.addEventListener("timer", onTimer);
			tViewsTimer = new Timer(60000);
			tViewsTimer.addEventListener("timer", onViewsTimer);
			
			for(var i=0; i<aData.length; i++)
			{
				aData[i].height = iHeight;
				var mcBanner = addChild(new BxBanner(aData[i]));
				mcBanner.addEventListener(BxBanner.LOADED, onBannerLoaded);
			}
		}
		
		private function onBannerLoaded(event:Event)
		{
			var mcBanner = event.data;
			mcBanner.addEventListener(BxBanner.CLICKED, onBannerClick);
			aBanners.push(mcBanner);
			if(!tTimer.running)
			{
				onTimer();
				tTimer.start();
				tViewsTimer.start();
				dispatchEvent(new Event(BxBanner.LOADED));
			}
		}
		
		private function onBannerClick(event:Event)
		{
			oXml.returnXml(oXml.getXmlUrl("setBoonexClick", [event.data]));
		}
		
		private function onTimer(event:Event = null)
		{
			if(aBanners[iCurrent] != null) aBanners[iCurrent].visible = false;
			iCurrent++;
			if(aBanners[iCurrent] == null) iCurrent = 0;
			aBanners[iCurrent].visible = true;
		}
		
		private function onViewsTimer(event:Event)
		{
			var aIds = new Array(), aViews = new Array(); 
			for(var i=0; i<aBanners.length; i++)
			{
				var iViews = aBanners[i].views;
				if(iViews)
				{
					aIds.push(aBanners[i].id);
					aViews.push(iViews);
				}
			}
			oXml.returnXml(oXml.getXmlUrl("setBoonexImpressions", [aIds.join(","), aViews.join(",")]));
		}
		
		private function onResize(event:Event)
		{
			var oSize = event.data;
			for(var i=0; i<aBanners.length; i++)
				aBanners[i].width = oSize.width;
		}
	}
}