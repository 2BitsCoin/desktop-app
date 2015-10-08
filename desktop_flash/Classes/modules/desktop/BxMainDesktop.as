package modules.desktop
{
	import flash.events.*;
	import modules.presence.*;
	import flash.external.ExternalInterface;
	import utils.*;
	
	/**
	* The Main application object for Chat application (<code>root</code>).
	*/
	dynamic public class BxMainDesktop extends BxMainPresence
	{
		private var
			iStatusShift:Number = 0,
			aReceivedMails:Array = new Array(),
			aReceivedIms:Array = new Array();
			
		function BxMainDesktop()
		{
			super();
			MIN_WIDTH = 300;
			MIN_HEIGHT = 500;
			iUpdateDepth = 2;
//			iAuthDepth = 3;
			sModuleName = "desktop";
			sCode = sModuleName + "_7.0.0000";
			iStatusShift = this.width - this.mcStatus.x;
		}
		
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			bPublish = false;
			stage.align = "LT";
			stage.scaleMode = "noScale";
			stage.addEventListener(Event.RESIZE, onResizeHandler);
			this.addEventListener(BxLanguage.LANGUAGE_LOADED, onLanguage);
			this.mcUsers.addEventListener(BxUsers.FRIEND_ONLINE, onFriendOnline);
		}
		
		override protected function init(oParams:Object):String
		{
			var sXmlUrl:String = super.init(oParams);
			oXml.addTemplate("updateUsers", sXmlUrl + "updateUsers&id=" + oParams["id"], ["mails"]);
			oXml.addTemplate("updateOnlineStatus", sXmlUrl + "updateOnlineStatus&id=" + oParams["id"], ["status"]);
			return sXmlUrl;
		}
		
		private function onLanguage(event:Event):void
		{
			var oTemp = new Object();
			for(var i in oLanguage.strings)
				oTemp[i] = oLanguage.strings[i];
			if(ExternalInterface.available)
				ExternalInterface.call("setLanguage", oTemp);
		}
		
		override public function onAuthorize(event:Event):void
		{
			super.onAuthorize(event);
			if(authorized)
			{
				var aData:Object = event.data[0];
				this.mcStatus.init(BxXml.getChildByProperty(aData, "statuses"));
				this.mcStatus.status = BxXml.getChildByProperty(aData, "status")["current"];
			}
		}
		
		override protected function onResize(event:Event):void
		{
			super.onResize(event);
			this.mcStatus.y = this.mcFilter.y;
			if(iStatusShift > 0)
				this.mcStatus.x = event.data.width - iStatusShift;
		}
		
		override protected function getUpdateXmlObject():Object
		{
			return oXml.getXmlUrl("updateUsers", [aReceivedMails.join(",")]);
		}
		
		override public function onUpdate(event:Event):void
		{
			super.onUpdate(event);
			var aMails:Array = event.data[0][1];
			for(var i:Number=0; i<aMails.length; i++)
			{
				if(aReceivedMails.indexOf(aMails[i].id) > -1) continue;
				var sUser = getUserSummary(aMails[i]["sender"]);
				if(sUser == "" && aMails[i]["nick"] is String)
				{
					var oUser = aMails[i];
					sUser = "id=" + oUser["sender"] + "&nick=" + oUser["nick"] + "&sex=" + oUser["sex"] + "&age=" + oUser["age"] + "&image=" + oUser["image"] 
						+ "&profile=" + oUser["profile"] + "&music=" + oUser["music"] + "&video=" + oUser["video"];
				}
				if(sUser == "") continue;
				
				notify("mail", aMails[i].id, sUser, BxXml.replaceXmlCharacters(aMails[i]["_value"]));
				aReceivedMails.push(aMails[i]["id"]);
			}
			
			var aIms:Array = event.data[0][2];
			for(var i:Number=0; i<aIms.length; i++)
			{
				if(aReceivedIms.indexOf(aIms[i].id) > -1) continue;
				var sUser = getUserSummary(aIms[i]["sender"], true);
				if(sUser == "") continue;
				
				notify("im", aIms[i].id, sUser, BxXml.replaceXmlCharacters(aIms[i]["_value"]));
				aReceivedIms.push(aIms[i]["id"]);
			}
		}
		
		private function getUserSummary(sUserId:String, bOnlineOnly:Boolean = false):String
		{
			var oUser = this.mcUsers.getUserById(sUserId);
			if(bOnlineOnly && !oUser.online) return "";
			return oUser != null ? oUser.serialize() : "";
		}
		
		private function onFriendOnline(event:Event):void
		{
			var sUserId = event.data;
			var sUser = getUserSummary(sUserId);
			if(sUser != "") notify("friend", sUserId, sUser);
		}
		
		private function notify(sCase:String, sId:String, oUser:Object, sText:String = ""):void
		{
			ExternalInterface.call("notify", sCase, sId, oUser, sText);
		}
		
		override public function generateUser(aInitData:Object):Object
		{
			return new BxUserDesktop(aInitData);
		}
	}
}