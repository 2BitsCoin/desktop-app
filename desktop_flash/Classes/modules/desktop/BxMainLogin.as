package modules.desktop
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.ContextMenu;
	import flash.external.ExternalInterface;
	import utils.*;
	
	/**
	* The Main application object for Chat application (<code>root</code>).
	*/
	dynamic public class BxMainLogin extends MovieClip
	{
		public const EVENT_CONFIG:String = "onConfig";
		private var 
			bPublish:Boolean = true,
			sUserId:String = "",
			sModule:String = "desktop";
		public var oXml:Object;
		public var oConfig:Object;
		public var oLanguage:BxLanguage;
		
		/**
		* @private
		*/
		function BxMainLogin()
		{
			this.txtLogin.addEventListener(Event.CHANGE, onInputChange);
			this.txtPassword.addEventListener(Event.CHANGE, onInputChange);
			this.txtPassword.displayAsPassword = true;
			this.btnLogin.addEventListener(MouseEvent.CLICK, onLogin);
			this.mcRemember.addEventListener(Event.SELECT, onRememberSelected);
			this.mcAutoLogin.addEventListener(Event.SELECT, onAutoLoginSelected);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			stage.align = "LT";
			stage.scaleMode = "noScale";
			this.mcBack.width = this.mcMessage.width = stage.width;
			this.mcBack.height = this.mcMessage.height = stage.height;
			this.mcStyle.visible = false;
			
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			root.contextMenu = cm;
			
			if(!ExternalInterface.available)
				this.mcMessage.init("Javascript should be enabled");
			ExternalInterface.addCallback("logout", onLogout);
			if(bPublish) init(parent.loaderInfo.parameters["url"]);
			else init("http://rayz.s/dolphin/flash/XML.php");
		}
		
		private function init(sUrl:String):void
		{
			if(!(sUrl is String) || sUrl == "")
			{
				this.mcMessage.init("Invalid Parameters");
				return;
			}
			var sXmlUrl:String = sUrl;
			oXml = new BxXml(sXmlUrl);
			oXml.addEventListener(BxXml.XML_ERROR, onConnectionError);
			sXmlUrl += "?module=" + sModule + "&action=";
			oXml.addTemplate("getLanguages", sXmlUrl + "getLanguages");
			oXml.addTemplate("setLanguage", sXmlUrl + "setLanguage", ["language"]);
			oXml.addTemplate("login", sXmlUrl + "login", ["nick", "password"]);
			oXml.addTemplate("logout", sXmlUrl + "logout", ["id"]);
			oXml.addTemplate("config", sXmlUrl + "config");
			
			oLanguage = addChild(new BxLanguage(oXml, "getLanguages"));
			this.addEventListener(BxLanguage.LANGUAGE_LOADED, onLanguage);
			this.addEventListener(BxLanguage.LANGUAGES_LIST_LOADED, onLanguagesList);
			this.mcMessage.init("LOADING");
					
			var bRemember:Boolean = getCookie("remember") == BxXml.TRUE_VAL;
			this.mcRemember.selected = bRemember;
			if(bRemember)
			{
				this.txtLogin.text = getCookie("login");
				this.txtPassword.text = getCookie("password");
				var bAutoLogin:Boolean = getCookie("autologin") == BxXml.TRUE_VAL;
				this.mcAutoLogin.selected = bAutoLogin;
				if(bAutoLogin)
				{
					this.mcAutoLoginPanel.init();
					this.mcAutoLoginPanel.addEventListener(Event.COMPLETE, onLogin);
				}
			}
			onInputChange();
		}
		
		private function onLanguage(event:Event):void
		{
			var oTemp = new Object();
			for(var i in oLanguage.strings)
				oTemp[i] = oLanguage.strings[i];
			ExternalInterface.call("setLanguage", oTemp);
				
			this.txtLoginCaption.text = oLanguage.getString("txtLogin", "Login:");
			this.txtPasswordCaption.text = oLanguage.getString("txtPassword", "Password:");
			this.txtRemember.text = oLanguage.getString("txtRemember", "Remember Me");
			this.txtAutoLogin.text = oLanguage.getString("txtAutoLogin", "Auto Login");
			oLanguage.setButtonCaption(this.btnLogin, oLanguage.getString("btnLogin", "Login"), false);
		}
		
		private function onLanguagesList(event:Event):void
		{
			oXml.returnXml(oXml.getXmlUrl("config"), this, "configHandler", 2);
			this.mcMessage.init(oLanguage.getString("msgLoading", "LOADING"));
		}
		
		public function configHandler(event:Event):void
		{
			oConfig = new Object();
			var aConfigData:Array = event.data[0][0];
			
			for(var i:Number=0; i<aConfigData.length; i++)
			{
				var sKey:String = aConfigData[i]["key"];
				var sValue:String = aConfigData[i]["_value"];
				if(sValue == BxXml.TRUE_VAL || sValue == BxXml.FALSE_VAL) oConfig[sKey] = sValue == BxXml.TRUE_VAL;
				else if(!isNaN(sValue) && sValue != "")	oConfig[sKey] = Number(sValue);
				else oConfig[sKey] = BxXml.replaceXmlCharacters(sValue);
			}

			ExternalInterface.call("setConfig", oConfig);
			this.mcMessage.visible = false;
		}
		
		private function onLogin(event:Event = null):void
		{
			this.oXml.returnXml(this.oXml.getXmlUrl("login", [this.txtLogin.text, this.txtPassword.text]), this, "onLoginResult");
			trace(this.oXml.getXmlUrl("login", [this.txtLogin.text, this.txtPassword.text], "GET").url);
			this.mcMessage.init(this.oLanguage.getString("msgAuthorizing", "Authorization ..."));
			this.txtError.text = "";
		}
		
		public function onLoginResult(event:Event):void
		{
			var aData:Object = event.data[0][0];
			if(aData["status"] != BxXml.SUCCESS_VAL)
				this.txtError.text = this.oLanguage.getString(aData["value"], "User Authentication Failed");
			else
			{
				sUserId = aData["value"];
				ExternalInterface.call("setLoggedUserData", sUserId, aData["password"]);
				if(this.mcRemember.selected)
				{
					setCookie("login", this.txtLogin.text);
					setCookie("password", this.txtPassword.text);
				}
				this.txtLogin.text = this.txtPassword.text = "";
			}
			this.mcMessage.visible = false;
		}
		
		private function onLogout():void
		{
			if(sUserId == "") return;
			this.oXml.returnXml(this.oXml.getXmlUrl("logout", [sUserId]));
			sUserId = "";
			this.mcRemember.selected = this.mcAutoLogin.selected = false;
			setCookie("remember", false);
			setCookie("autologin", false);
		}
		
		private function onInputChange(event:Event = null):void
		{
			this.btnLogin.mouseEnabled = this.txtLogin.text != "" && this.txtPassword.text != "";
		}
		
		private function onRememberSelected(event:Event):void
		{
			setCookie("remember", event.data);
		}
		
		private function onAutoLoginSelected(event:Event):void
		{
			setCookie("autologin", event.data);
		}
		
		private function setCookie(sKey:String, sValue:String):void
		{
			ExternalInterface.call("setCookie", sKey, sValue);
		}
		
		private function getCookie(sKey:String):String
		{
			return ExternalInterface.call("getCookie", sKey);
		}
		
		public function onConnectionError(event:Event = null):void
		{
			this.mcMessage.init(oLanguage.getString("msgConnectionError", "Connection Error"), false);
		}
		
		override public function get width():Number {return this.mcBack.width;}
		override public function get height():Number {return this.mcBack.height;}
	}
}