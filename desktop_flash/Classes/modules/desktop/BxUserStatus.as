package modules.desktop
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import utils.*;
	import controls.BxPopupList;

	dynamic public class BxUserStatus extends BxPopupList
	{
		private var
			iPadding:Number = 4,
			sStatus:String = "",
			aStatuses:Array = new Array();
		/**
		* @private
		*/
		function BxUserStatus()
		{
			bEnabled = true;
			iHintShift = -10;
			sHint = "hintOnlineStatus";
		}
		
		public function init(aData:Array):void
		{
			var iMaxWidth:Number = 0;
			for(var i:Number=0; i<aData.length; i++)
			{
				var mcStatus = this.addChild(new BxUserStatusElement(aData[i]));
				var mcIcon = this.addChild(new Loader());
				mcIcon.visible = mcIcon.mouseEnabled = false;
				mcIcon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadIconError);
				mcIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconLoaded);
				mcIcon.load(new URLRequest(mcStatus.iconUrl));
				mcStatus.icon = mcIcon;
				mcStatus.addEventListener(MouseEvent.MOUSE_DOWN, onStatusClick);
				aStatuses.push(mcStatus);
				if(mcStatus.width > iMaxWidth)
					iMaxWidth = mcStatus.width;
			}
			
			iMaxWidth += 2*iPadding;
			if(iMaxWidth > this.mcBack.width)
			{
				this.mcBack.x -= iMaxWidth - this.mcBack.width;
				this.mcBack.width = iMaxWidth;
			}
			
			var iY:Number = 0;
			for(i=aStatuses.length-1; i>=0; i--)
			{
				iY -= iPadding + aStatuses[i].height;
				aStatuses[i].y = iY;
				aStatuses[i].x = this.mcBack.x + iPadding;
			}
			this.mcBack.height += Math.abs(aStatuses[0].y) + iPadding;
			this.mcBack.y = aStatuses[0].y - iPadding;
		}
		
		private function onLoadIconError(event:IOErrorEvent):void
		{
			trace("error loading icon");
		}
		
		private function onIconLoaded(event:Event):void
		{
			var mcIcon = event.target.loader;
			mcIcon.x = this.btnOpen.x + (this.mcArrow.x - this.btnOpen.x - mcIcon.width) / 2;
			mcIcon.y = (this.btnOpen.height - mcIcon.height) / 2;
		}
		
		private function onStatusClick(event:Event):void
		{
			status = event.target.parent.id;
		}
		
		public function set status(strStatus:String):void
		{
			if(strStatus != sStatus)
			{
				for(var i:Number=0; i<aStatuses.length; i++)
					aStatuses[i].icon.visible = aStatuses[i].id == strStatus;
				if(sStatus != "")
					root.oXml.returnXml(root.oXml.getXmlUrl("updateOnlineStatus", [strStatus]));
				sStatus = strStatus;
			}
		}
		/**
		* @private
		*/
		override protected function set active(bMode:Boolean):void
		{
			for(var i:Number=0; i<aStatuses.length; i++)	
				aStatuses[i].visible = bMode;
			super.active = bMode;
		}
	}
}