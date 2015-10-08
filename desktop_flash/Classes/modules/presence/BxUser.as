package modules.presence
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.external.ExternalInterface;
	import controls.MovieClipContainer;
	import utils.*;

	/**
	* User object.
	*/
	dynamic public class BxUser extends MovieClipContainer
	{
		public static const SEX_DEFINED:String = "onSexDefined";
		private var
			reUrl:RegExp = /(https?:\/\/+([^<][\w\d:#@%\/;$()~_?\+-=\\\.&])*)/,
			bOnline:Boolean = false, bFriend:Boolean = false,
			iAge:Number = 0,
			sMusicUrl, sVideoUrl, sImUrl, sMailUrl:String,
			sId:String = "", sNick:String = "", sSex:String = "", sImage:String = "", sProfile:String = "",
			lPhotoLoader:Loader;
		
		/**
		* @private
		*/
		function BxUser(aData:Object)
		{
			if(aData.id is String) sId = aData.id;
			if(aData.nick is String) sNick = aData.nick;
			if(!isNaN(aData.age)) iAge = Number(aData.age);
			if(aData.sex is String) sSex = aData.sex;
			if(aData.profile is String) sProfile = aData.profile;
			if(aData.image is String) photo = aData.image;
			if(aData.online is String) bOnline = aData.online == BxXml.TRUE_VAL;
			if(aData.friend is String) bFriend = aData.friend == BxXml.TRUE_VAL;
			this.btnMusic.visible = aData.music is String && aData.music == BxXml.TRUE_VAL;
			this.btnVideo.visible = aData.video is String && aData.video == BxXml.TRUE_VAL;
	
			this.mcBack.mouseEnabled = false;
			
			this.btnVideo.addEventListener(MouseEvent.MOUSE_DOWN, openVideo);
			this.btnMusic.addEventListener(MouseEvent.MOUSE_DOWN, openMusic);
			this.btnMail.addEventListener(MouseEvent.MOUSE_DOWN, openMail);
			this.btnIm.addEventListener(MouseEvent.MOUSE_DOWN, openIm);
		}
		
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			sMusicUrl = processUserUrl(root.oConfig.userMusic);
			sVideoUrl = processUserUrl(root.oConfig.userVideo);
			sImUrl = processUserUrl(root.oConfig.userIm);
			sMailUrl = processUserUrl(root.oConfig.userMail);

			BxStyle.changeTextFormat(this.txtDetails, root.mcStyle.UserDetails);
			this.txtCaption.htmlText = BxStyle.getHtmlText('<a href="event:">' + sNick + '</a>', root.mcStyle.UserNick);
			this.txtCaption.autoSize = TextFieldAutoSize.LEFT;
			this.txtCaption.mouseEnabled = true;
			this.txtCaption.addEventListener(TextEvent.LINK, openProfile);
			
			online = bOnline;
			onLanguage();
			root.addEventListener(BxLanguage.LANGUAGE_LOADED, onLanguage);
			
			if((root.oConfig.useMusic is Boolean && !root.oConfig.useMusic) || sMusicUrl == "") this.btnMusic.visible = false;
			if((root.oConfig.useVideo is Boolean && !root.oConfig.useVideo) || sVideoUrl == "") this.btnVideo.visible = false;
			if(root.oConfig.useMail is Boolean && !root.oConfig.useMail) this.btnMail.visible = false;
			if(root.oConfig.useIm is Boolean && !root.oConfig.useIm) this.btnIm.visible = false;
		}
		
		private function onLanguage(event:Event = null):void
		{
			if(root.mcHint != undefined)
			{
				root.mcHint.attach(this.btnMusic, root.oLanguage.getString("hintUserMusic", "Listen to #user#'s Music").split("#user#").join(sNick), -10);
				root.mcHint.attach(this.btnVideo, root.oLanguage.getString("hintUserVideo", "Watch #user#'s Video").split("#user#").join(sNick), -10);
				root.mcHint.attach(this.btnIm, root.oLanguage.getString("hintUserIM", "Chat with #user#").split("#user#").join(sNick), -10);
				root.mcHint.attach(this.btnMail, root.oLanguage.getString("hintUserMail", "Write a message to #user#").split("#user#").join(sNick), -10);
			}
			var sSexCaption:String = root.oLanguage.getString(sSex);
			this.txtDetails.text = root.oLanguage.getString("txtDetails", "#age# y/o, #sex#").split("#age#").join(iAge).split("#sex#").join(sSexCaption);
			refreshOnlineCaption();
			dispatchEvent(new BxXmlEvent(SEX_DEFINED, {value: sSex, caption: sSexCaption}));
		}

		public function serialize():String
		{
			return "id=" + sId + "&nick=" + sNick + "&sex=" + sSex + "&age=" + iAge + "&image=" + sImage + "&online=" + bOnline
				+ "&profile=" + sProfile + "&music=" + this.btnMusic.visible + "&video=" + this.btnVideo.visible;
		}
		
		private function refreshOnlineCaption():void
		{
			var sStatus:String = bOnline ? root.oLanguage.getString("txtOnline", "Online") : root.oLanguage.getString("txtOffline", "Offline");
			var sOnlineText:String = root.oLanguage.getString("txtStatus", "Status: #status#").split("#status#").join(sStatus);
			this.txtOnline.htmlText = BxStyle.getHtmlText(sOnlineText, root.mcStyle[bOnline ? "OnlineText" : "OfflineText"]);
		}
		
		protected function get ownerId():String
		{
			return root.initParams["id"];
		}
		
		private function processUserUrl(sUrl:String):String
		{
			return sUrl.split("#user#").join(sId).split("#nick#").join(sNick).split("#owner#").join(ownerId).split("#password#").join(root.initParams["password"]);
		}
		
		/**
		* User ID.
		*/
		public function get id():String {return sId;}
		/**
		* User sex.
		*/
		public function get sex():String {return sSex;}
		/**
		* User age.
		*/
		public function get age():Number {return iAge;}

		public function get friend():Boolean {return bFriend;}
		
		public function get online():Boolean {return bOnline;}
		
		public function set online(bMode:Boolean)
		{
			bOnline = bMode;
			this.btnIm.visible = bOnline && sImUrl != "";
			refreshOnlineCaption();
		}
		
		public function set photo(sPhoto:String):void
		{
			sImage = sPhoto;
			lPhotoLoader = new Loader();
			lPhotoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoLoaded);
			lPhotoLoader.load(new URLRequest(sPhoto));
		}
		
		private function onPhotoLoaded(event:Event):void
		{
			lPhotoLoader.scaleX = lPhotoLoader.scaleY = Math.min(this.mcPhotoBorder.width / lPhotoLoader.width, this.mcPhotoBorder.height / lPhotoLoader.height);
			lPhotoLoader.x = this.mcPhotoBorder.x + (this.mcPhotoBorder.width - lPhotoLoader.width) / 2;
			lPhotoLoader.y = this.mcPhotoBorder.y + (this.mcPhotoBorder.height - lPhotoLoader.height) / 2;
			lPhotoLoader.addEventListener(MouseEvent.MOUSE_DOWN, openProfile);
			addChild(lPhotoLoader);
			swapChildren(lPhotoLoader, this.mcPhotoBorder);
		}

		override public function set width(iWidth:Number):void
		{
			var iShiftX:Number = iWidth - this.mcBack.width;
			super.width = this.mcLine.width = iWidth;
			this.txtCaption.width += iShiftX;
			this.txtDetails.width += iShiftX;
			this.txtOnline.width += iShiftX;
			this.btnMusic.x += iShiftX;
			this.btnVideo.x += iShiftX;
			this.btnMail.x += iShiftX;
			this.btnIm.x += iShiftX;
		}

		private function openProfile(event:Event):void
		{
			openUrl(sProfile);
		}

		private function openMusic(event:Event):void
		{
			openUrl(sMusicUrl);
		}
		
		private function openVideo(event:Event):void
		{
			openUrl(sVideoUrl);
		}
		
		private function openIm(event:Event):void
		{
			openUrl(sImUrl);
		}
		
		private function openMail(event:Event):void
		{
			openUrl(sMailUrl);
		}
		
		protected function getTarget(sUrl:String):String
		{
			return reUrl.test(sUrl) ? "_blank" : "_self";
		}
		
		protected function openUrl(sUrl:String):void
		{
			navigateToURL(new URLRequest(sUrl), getTarget(sUrl));
		}
	}
}