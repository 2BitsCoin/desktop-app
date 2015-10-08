package modules.desktop
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.ContextMenu;
	import flash.external.ExternalInterface;
	import flash.text.*;
	import flash.net.*;
	import flash.utils.Timer;
	import modules.presence.*;
	import utils.BxXml;
	
	/**
	* The Main application object (<code>root</code>). It serves as both applications Main classes super object. 
	* Defines main objects and dispatches main events.
	*/
	dynamic public class BxNotification extends MovieClip
	{
		private var
			sMessageId:String = "", sMode:String,
			tCloseTimer:Timer,
			mcUser:Object,
			oXml:BxXml,
			oInitParams:Object;
		public var EVENT_CONFIG:String = "onConfig";
		public var oConfig:Object;
		public var oLanguage:BxLanguageDesktop;
		/**
		* @private
		*/
		function BxNotification()
		{
			this.btnOk.addEventListener(MouseEvent.CLICK, onOk);
			this.btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			this.mcStyle.visible = false;

			stage.align = "LT";
			stage.scaleMode = "noScale";
			resize();
			
			oInitParams = parent.loaderInfo.parameters;
	
			sMessageId = oInitParams["caseId"];
//			oInitParams = {"owner": 1, "password": "", "case": "mail", "caseId": "1", "id": "2", "nick": "test1", "sex": "male", "age": "19", "image": "http://rayz.s/dolphin/flash/modules/global/data/man.gif", "profile": "", "music": "true", "video": "false", "text": "hi"};
			
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			root.contextMenu = cm;
			
			oLanguage = new BxLanguageDesktop();
			oConfig = ExternalInterface.call("getConfig");

			this.txtCaption.text = oLanguage.getString("windowNotification", "Notification");
			this.txtMessage.text = oLanguage.getString(oInitParams["case"] + "Message");
			this.txtMessage.autoSize = TextFieldAutoSize.CENTER;
			mcUser = this.addChildAt(new BxUserDesktop(oInitParams), this.getChildIndex(this.txtCaption));
			mcUser.x = (width - mcUser.width) / 2;
			mcUser.y = this.txtMessage.y + this.txtMessage.height;
			this.txtText.text = oInitParams["text"];
			this.txtText.autoSize = TextFieldAutoSize.CENTER;
			this.txtText.y = mcUser.y + mcUser.height + 10;
			
			this.dispatchEvent(new Event("onLanguage"));
			
			mode = oInitParams["case"];
		}
		
		public function get initParams():Object
		{
			return oInitParams;
		}
		
		private function set mode(strMode:String):void
		{
			sMode = strMode;
			switch(sMode)
			{
				case "friend":
					tCloseTimer = new Timer(10000);
					tCloseTimer.addEventListener("timer", onClose);
					tCloseTimer.start();
					stage.addEventListener(MouseEvent.MOUSE_UP, initClose);
					this.btnOk.visible = this.btnCancel.visible = false;
					return;
					break;
				case "mail":
					oLanguage.setButtonCaption(this.btnOk, oLanguage.getString("btnRead", "Read"));
					oLanguage.setButtonCaption(this.btnCancel, oLanguage.getString("btnCancel", "Cancel"));
					break;
				case "im":
					oLanguage.setButtonCaption(this.btnOk, oLanguage.getString("btnAccept", "Accept"));
					oLanguage.setButtonCaption(this.btnCancel, oLanguage.getString("btnDecline", "Decline"));
					break;
			}
		}
		
		private function onOk(event:Event):void
		{
			if(sMode == "im")
				mcUser.btnIm.dispatchEvent(new Event(MouseEvent.MOUSE_DOWN));
			else
				navigateToURL(new URLRequest(oConfig.userMailMessage.split("#ID#").join(sMessageId)), "_blank");
			initClose(event);
		}
		
		private function onCancel(event:Event):void
		{
			if(sMode == "im")
				ExternalInterface.call("declineIm");
			else
				initClose(event);
		}
		
		private function initClose(event:Event):void
		{
			if(tCloseTimer != null) tCloseTimer.stop();
			tCloseTimer = new Timer(100);
			tCloseTimer.addEventListener("timer", onClose);
			tCloseTimer.start();
		}
		
		private function onClose(event:Event):void
		{
			ExternalInterface.call("closeMe");
		}
		
		private function resize():void
		{
			var iWidth = stage.stageWidth;
			var iHeight = stage.stageHeight;
			this.mcBack.height = iHeight;
			this.mcBack.width = iWidth;
		}		
		
		/**
		* Gets current application width
		*/
		override public function get width():Number {return this.mcBack.width;}
		/**
		* Gets current application height
		*/
		override public function get height():Number {return this.mcBack.height;}
	}
}