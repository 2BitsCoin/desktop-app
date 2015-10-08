package modules.presence
{
	import flash.events.*;
	import flash.utils.Timer;
	import utils.*;
	
	/**
	* The Main application object for Chat application (<code>root</code>).
	*/
	dynamic public class BxMainPresence extends BxMain
	{
		private var
			iPaddingY:Number = 6,
			iFilterShift:Number = 0,
			iUpdateInterval:Number = 20,
			tUpdateTimer:Timer;
		protected var
			iUpdateDepth:Number = -1;
		
		/**
		* @private
		*/
		function BxMainPresence()
		{
			super();
			bAuthorizeObligatory = true;
			sModuleName = "presence";
			sCode = "presence_7.0.0000";
			iFilterShift = this.width - this.mcFilter.x;

			this.addEventListener(Event.RESIZE, onResize);
			this.addEventListener(this.EVENT_CONFIG, onConfig);
			this.btnSettings.addEventListener(MouseEvent.CLICK, onSettings);
			this.addEventListener(BxLanguage.LANGUAGE_LOADED, onLanguage);
		}
		
		override protected function init(oParams:Object):String
		{
			var sXmlUrl:String = super.init(oParams);
			oXml.addTemplate("getUsers", sXmlUrl + "getUsers&id=" + oParams["id"]);
			oXml.addTemplate("updateUsers", sXmlUrl + "updateUsers&id=" + oParams["id"]);
			return sXmlUrl;
		}
		
		private function onLanguage(event:Event):void
		{
			this.mcHint.attach(this.btnSettings, this.oLanguage.getString("hintSettings", "Settings"));
		}
		
		protected function onResize(event:Event):void
		{
			var oNewSize:Object = event.data;
			this.mcUsers.width = oNewSize.width - 2*this.mcUsers.x;
			this.btnSettings.y = this.mcFilter.y = oNewSize.height - this.btnSettings.height - iPaddingY;
			this.mcUsers.height = this.mcFilter.y - this.mcUsers.y - iPaddingY;
			if(iFilterShift > 0)
				this.mcFilter.x = oNewSize.width - iFilterShift;
		}
		
		private function onConfig(event:Event):void
		{
			if(isNaN(this.oConfig.updateInterval) && this.oConfig.updateInterval > iUpdateInterval)
				iUpdateInterval = this.oConfig.updateInterval;
			if(this.oConfig.userIm is String) this.oConfig.userIm.split("#owner#").join(this.initParams["id"]).split("#password#").join(this.initParams["password"]);
			
			tUpdateTimer = new Timer(this.oConfig.updateInterval * 1000);
			tUpdateTimer.addEventListener("timer", callUpdate);
			oXml.returnXml(oXml.getXmlUrl("getUsers"), this, "onGetUsers", iUpdateDepth);
		}
		
		private function onSettings(event:Event):void
		{
			this.mcSettings.visible = true;
		}
		
		private function callUpdate(event:Event):void
		{
			oXml.returnXml(getUpdateXmlObject(), this, "onUpdate", iUpdateDepth);
		}
		
		protected function getUpdateXmlObject():Object
		{
			return oXml.getXmlUrl("updateUsers");
		}
		
		public function onGetUsers(event:Event):void
		{
			onUpdate(event);
			this.mcUsers.refreshUsers();
			tUpdateTimer.start();
			this.mcMessage.visible = false;
		}
		
		public function onUpdate(event:Event):void
		{
			var aUsers:Array = event.data[0][0];
			for(var i:Number=0; i<aUsers.length; i++)
				this.mcUsers.updateUser(aUsers[i]);
			if(this.mcMessage.visible) this.mcMessage.visible = false;
		}
		
		override public function onConnectionError(event:Event = null):void
		{
			this.mcMessage.init(oLanguage.getString("msgConnecting", "Connecting ..."));
		}
		
		public function generateUser(aInitData:Object):Object
		{
			return new BxUser(aInitData);
		}
	}
}