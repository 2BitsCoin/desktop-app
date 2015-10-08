package modules.presence
{
	import flash.events.*;
	import flash.external.ExternalInterface;
	import controls.MovieClipContainer;
	import utils.*;
	
	dynamic public class BxUsers extends MovieClipContainer
	{
		public static const ONLINE_ACTIVE:String = "onOnlineActive";
		public static const FRIEND_ONLINE:String = "onFriendOnline";
		private var
			iTabsPadding:Number = 2,
			iPadding:Number = 3,
			iElementWidth:Number = 0,
			aUsers:BxList;
		
		function BxUsers()
		{
			aUsers = new BxList();
			aUsers.left = iPadding;
			aUsers.padding = iPadding;
			aUsers.filter = this;
			aUsers.setHolder(this.mcPane, this.mcBack.width, this.mcBack.height - this.mcPane.y, 0);
			this.mcOnline.addEventListener(Event.SELECT, onOnline);
			this.mcFriends.addEventListener(Event.SELECT, onFriends);
			this.mcOnline.x = iTabsPadding;
		}
		
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			root.addEventListener(BxLanguage.LANGUAGE_LOADED, onLanguage);
			root.addEventListener(root.EVENT_CONFIG, onConfig);
		}
		
		private function onLanguage(event:Event):void
		{
			this.mcOnline.caption = root.oLanguage.getString("tabOnline", "Online");
			this.mcFriends.caption = root.oLanguage.getString("tabFriends", "Friends");
		}
		
		private function onConfig(event:Event):void
		{
			var oConfig:Object = event.data;
			if(oConfig.useFriends is Boolean && !oConfig.useFriends)
			{
				this.mcTabsBack.visible = this.mcOnline.visible = this.mcFriends.visible = false;
				this.mcPane.y = 0;
				this.mcPane.setSize(this.mcBack.width, this.mcBack.height);
			}
			root.mcFilter.addEventListener(BxFilter.FILTER_CLICK, refreshUsers)
			onlineActive = this.mcOnline.active = true;
		}
		
		override public function set width(iWidth:Number):void
		{
			super.width = this.mcBorder.width = this.mcTabsBack.width = iWidth;
			this.mcPane.setSize(this.mcBack.width);
			this.mcOnline.width = this.mcFriends.width = (iWidth - 3*iTabsPadding) / 2;
			this.mcFriends.x = this.mcOnline.x + this.mcOnline.width + iTabsPadding;
			
			iElementWidth = this.mcPane.getScrollSpaceBounds().width - this.mcPane.getScrollBarWidth() - 2;
			for(var i:Number=0; i<aUsers.length; i++)
				aUsers.elements[i].width = iElementWidth;
		}
		
		override public function set height(iHeight:Number):void
		{
			super.height = this.mcBorder.height = iHeight;
			this.mcPane.setSize(-1, this.mcBack.height - this.mcPane.y);
		}
		
		public function updateUser(aInitData:Array):void
		{
			if(aInitData["nick"] is String)
				addUser(aInitData);
			else if(aInitData["online"] is String)
			{
				var oUser:Object = getUser(aInitData["id"]);
				if(oUser == null) return;
				
				var bOnline:Boolean = aInitData["online"] == BxXml.TRUE_VAL;
				if(oUser.online == bOnline) return;
				
				oUser.online = bOnline;
				if(!bOnline && !oUser.friend) removeUser(oUser.id);
				else if(bOnline && oUser.friend) dispatchEvent(new BxXmlEvent(FRIEND_ONLINE, oUser.id));
			}
			refreshUsers();
		}
		
		public function getUserById(sUserId:String):Object
		{
			return aUsers.getByKey("id", sUserId);
		}
	
		private function addUser(aInitData:Object):Object
		{
			var oUser:Object = aUsers.getByKey("id", aInitData.id);
			if(oUser == null)
			{
				oUser = root.generateUser(aInitData);
				oUser.addEventListener(BxUser.SEX_DEFINED, onSexDefined);
				aUsers.add(oUser);
				if(iElementWidth > 0) oUser.width = iElementWidth;
				else width = width;
			}
			return oUser;
		}
		
		private function onSexDefined(event:Event):void
		{
			dispatchEvent(new BxXmlEvent(BxUser.SEX_DEFINED, event.data));
		}
		
		private function removeUser(sUserId:String):void
		{
			aUsers.removeByKey("id", sUserId);
		}
		
		private function getUser(sUserId:String):Object
		{
			return aUsers.getByKey("id", sUserId);
		}
		
		private function onOnline(event:Event):void
		{
			onlineActive = true;			
		}

		private function onFriends(event:Event):void
		{
			onlineActive = false;
		}
		
		private function set onlineActive(bMode:Boolean):void
		{
			var mcPassive:Object = bMode ? this.mcFriends : this.mcOnline;
			mcPassive.active = false;
			refreshUsers();
			dispatchEvent(new BxXmlEvent(ONLINE_ACTIVE, bMode));
		}

		public function refreshUsers(event:Event = null):void
		{
			for(var i=0; i<aUsers.length; i++)
				aUsers.elements[i].x = -1000;
			aUsers.refresh();
		}
		
		public function filter(oUser:Object):Boolean
		{
			if(this.mcOnline.active && !oUser.online) return false;
			if(this.mcFriends.active && !oUser.friend) return false;
			if(root.mcFilter.isFilter)
			{
				if(root.mcFilter.sex != "" && root.mcFilter.sex != oUser.sex) return false;
				var oAges:Object = root.mcFilter.ages;
				if(oAges.from > oUser.age || oAges.to < oUser.age) return false;
				if(root.mcFilter.online && !oUser.online) return false;
			}
			return true;
		}
	}
}