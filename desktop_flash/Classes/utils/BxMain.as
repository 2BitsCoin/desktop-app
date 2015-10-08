package utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.ContextMenu;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	/**
	* Dispatched when languages list is loaded.
	* @see utils.BxLanguage#files
	*/
	[Event(name="langsLoaded", type="flash.events.Event")]
	/**
	* Dispatched when language file is loaded/reloaded. You should listen to this event 
	* if you use some language strings that should be reset anytime a language is changed.
	* @see utils.BxLanguage#loadFile
	*/
	[Event(name="languageLoaded", type="flash.events.Event")]
	/**
	* Dispatched when configuration settings are loaded. 
	* <code>oConfig</code> object is passed as <code>data</code> value for event.
	* @see BxMain#oConfig
	*/
	[Event(name="onConfig", type="utils.BxXmlEvent")]
	/**
	* Dispatched when the application is being resized.
	* An object with <code>width</code> and <code>height</code> properties is passed 
	* as <code>data</code> value for event.
	*/
	[Event(name="resize", type="utils.BxXmlEvent")]
	

	/**
	* The Main application object (<code>root</code>). It serves as both applications Main classes super object. 
	* Defines main objects and dispatches main events.
	*/
	dynamic public class BxMain extends MovieClip
	{
		/**
		* @private
		*/
		public const EVENT_CONFIG:String = "onConfig";
		public static const EVENT_CONNECTED:String = "onConnect";
		private var 
			iPluginsCount:Number = 0,
			oInitParams:Object;
		protected var
			bPublish:Boolean = false,
			bAdmin:Boolean = false,
			bGetPlugins:Boolean = true,
			bGetSkins:Boolean = true,
			bAuthorize:Boolean = true,
			bAuthorized:Boolean = false,
			bAuthorizeObligatory:Boolean = true,
			iAuthDepth:Number = -1;
			
		/**
		* @private
		*/
		protected var
			MIN_WIDTH:Number = 0, MIN_HEIGHT:Number = 0, iAppHeight:Number = 0, iAppWidth:Number = 0, 
			sModule:String = "", sModuleName:String = "", sApp:String = "", sAppName:String = "user";
		/**
		* Configuration object, contains all configuration settings ([widget_name]/xml/config.xml).
		* Any setting is a property that can be accessed by this setting key name.
		* @example The following example will trace RMS server Url:
		* <listing>trace(root.oConfig.serverUrl);</listing>
		* rtmp://rms.boonex.com:10000/chat/
		*/
		public var oConfig:Object;
		/**
		* XML documents management object.
		* @see utils.BxXml
		*/
		public var oXml:Object;
		/**
		* Languages management object.
		* @see utils.BxLanguage
		*/
		public var oLanguage:BxLanguage;
		public var oSkin:BxSkin;
		/**
		* @private
		*/
		function BxMain()
		{
			this.mcAds.addEventListener(BxAdsSimple.LOADED, onAdsLoaded);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function get isAdmin():Boolean
		{
			return bAdmin;
		}
		
		protected function onAddToStage(event:Event):void
		{
			iAppHeight = MIN_HEIGHT;
			iAppWidth = MIN_WIDTH;
			this.mcStyle.visible = false;

			if(bPublish && !bAdmin) parent.addEventListener(Event.RESIZE, onResizeHandler);
			else
			{
				stage.align = "LT";
				stage.scaleMode = "noScale";
				stage.addEventListener(Event.RESIZE, onResizeHandler);
			}

			onResizeHandler();
			if(bPublish) init(parent.loaderInfo.parameters);
//			else init({"module": "rzvideo", "app": "player", "url": "http://rayz.s/d615/ray/XML.php", "id": "15", "user": "", "password": ""});
//			else init({"module": "video", "app": "player", "url": "http://d70/flash/XML.php", "id": "1", "user": "2", "password": "fb0e22c79ac75679e9881e6ba183b354"});
//			else init({"module": "video", "app": "recorder", "url": "http://rayz.s/dolphin/flash/XML.php", "user": "2", "password": "fb0e22c79ac75679e9881e6ba183b354", "extra": ""});
//			else init({"module": "mp3", "app": "player", "url": "http://rayz.s/dolphin/flash/XML.php", "id": "1", "user": "2", "password": "fb0e22c79ac75679e9881e6ba183b354"});
//			else init({"module": "mp3", "app": "recorder", "url": "http://rayz.s/dolphin/flash/XML.php", "user": "2", "password": "fb0e22c79ac75679e9881e6ba183b354"});
//			else init({"module": "video", "app": "player", "url": "http://rayz.s/dolphin/flash/XML.php", "id": "1"});
//			else init({"module": "photo", "app": "shooter", "url": "http://rayz.s/dolphin/flash/XML.php", "id": "1", "extra": "1_0"});
//			else init({"module": "presence", "app": "user", "url": "http://rayz.s/dolphin/flash/XML.php", "id": "2", "password": "fb0e22c79ac75679e9881e6ba183b354"});
//			else init({"module": "desktop", "app": "user", "url": "http://rayz.s/dolphin/flash/XML.php", "id": "2", "password": "fb0e22c79ac75679e9881e6ba183b354", "desktop": "true"});
//			else init({"module": "board", "app": "user", "url": "http://rayz.s/dolphin/flash/XML.php", "id": "3", "password": "fb0e22c79ac75679e9881e6ba183b354"});
//			else init({"module": "shoutbox", "app": "user", "url": "http://rayz.s/dolphin/flash/XML.php", "id": "2", "password": "fb0e22c79ac75679e9881e6ba183b354"});
//			else init({"module": "mp3", "app": "editor", "url": "http://rayz.s/d62/flash/XML.php", "id": "1", "password": "fb0e22c79ac75679e9881e6ba183b354"});
//			else init({"module": "im", "app": "user", "url": "http://rayz.s/dolphin/flash/XML.php", "sender": "2", "password": "fb0e22c79ac75679e9881e6ba183b354", "recipient": "1"});
			else init({"module": "chat", "app": "user", "url": "http://daysandnightsin.com/ray/XML.php", "id": "1", "password": "ce5ba92702cca653a91ca12e0a19ea47"});
//			else init({"module": "chat", "app": "admin", "url": "http://www.boonex.us/flash/XML.php", "nick": "admin", "password": "28f20a02bf8a021fab4fcec48afb584e"});
//			else init({"module": "chat", "app": "admin", "url": "http://rayz.s/d61/flash/XML.php", "nick": "admin", "password": "36cdf8b887a5cffc78dcd5c08991b993"});
//			else init({"module": "chat", "app": "admin", "url": "http://rayz.s/d615/ray/XML.php", "nick": "6", "password": "fb0e22c79ac75679e9881e6ba183b354"});

			if(bPublish) parent.dispatchEvent(new Event("applicationLoaded"));
			
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			root.contextMenu = cm;
		}
		/**
		* @private
		*/
		protected function init(oParams:Object):String
		{
			oInitParams = oParams;
			if(oInitParams["module"] is String) sModule = oInitParams["module"];
			else
			{
				var sModulesStr:String = "/modules/";
				var iModulesIndex:Number = parent.loaderInfo.url.lastIndexOf(sModulesStr);
				var iAppIndex:Number = parent.loaderInfo.url.lastIndexOf("/app/");
				sModule = parent.loaderInfo.url.substring(iModulesIndex + sModulesStr.length, iAppIndex);
			}
			sApp = (oInitParams["app"] is String) ? oInitParams["app"] : sAppName;
			var sXmlUrl:String = oParams["url"];
			oXml = new BxXml(sXmlUrl);
			oXml.addEventListener(BxXml.XML_ERROR, onConnectionError);
			oXml.addTemplate("getWidgetAds", sXmlUrl + "?action=getWidgetAds&widget=" + sModule);
			sXmlUrl += "?module=" + sModule + "&action=";
			oXml.addTemplate("getSkins", sXmlUrl + "getSkins");
			oXml.addTemplate("getLanguages", sXmlUrl + "getLanguages");
			oXml.addTemplate("setSkin", sXmlUrl + "setSkin", ["skin"]);
			oXml.addTemplate("setLanguage", sXmlUrl + "setLanguage", ["language"]);
			oXml.addTemplate("authorize", sXmlUrl + (bAdmin ? "adminAuthorize" : "userAuthorize") + "&id=" + oInitParams["id"] + "&password=" + oInitParams["password"]);
			oXml.addTemplate("config", sXmlUrl + "config");
			oXml.addTemplate("getPlugins", sXmlUrl + "getPlugins&app=" + sAppName);
			oXml.returnXml(oXml.getXmlUrl("getWidgetAds"), this.mcAds, "onGetAds", 1);
			this.mcMessage.init("LOADING");
			if(bGetSkins)
			{
				oSkin = addChild(new BxSkin(oXml, "getSkins"));
				addEventListener(BxSkin.SKINS_LIST_LOADED, afterSkins);
			}
			else afterSkins();
			return sXmlUrl;
		}
		/**
		* Gets initializationa parameters Object (FlashVars).
		*/
		public function get initParams():Object {return oInitParams;}
		
		public function get module():String {return sModule;}
		public function get app():String {return sApp;}
		
		private function afterSkins(event:Event = null):void
		{
			if(bGetPlugins)
				oXml.returnXml(oXml.getXmlUrl("getPlugins"), this, "onGetPlugins", 2);
			else getLanguages();
		}
		
		/**
		* @private
		*/
		public function onGetPlugins(event:Event):void
		{
			Security.allowDomain("rayz.s");
			var aData:Object = event.data[0][0];
			if(!aData is Array || aData.length == 0)
			{
				afterPlugins();
				return;
			}
			iPluginsCount = aData.length;

			for(var i:Number=0; i<iPluginsCount; i++)
			{
				var lPluginLoader:Loader = new Loader();
				lPluginLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPluginLoaded);
				lPluginLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onPluginLoaded);
				lPluginLoader.load(new URLRequest(aData[i]["_value"]));
				addChild(lPluginLoader);
			}
		}
		
		private function onPluginLoaded(event:Event):void
		{
			iPluginsCount--;
			afterPlugins();
		}
		
		private function afterPlugins():void
		{
			if(iPluginsCount > 0) return;
			getLanguages();
		}
		
		private function getLanguages(event:Event = null):void
		{
			oLanguage = addChild(new BxLanguage(oXml, "getLanguages"));
			addEventListener(BxLanguage.LANGUAGES_LIST_LOADED, onLanguagesList);
		}
		
		private function onLanguagesList(event:Event):void
		{
			if(bAuthorize)
				oXml.returnXml(oXml.getXmlUrl("authorize"), this, "onAuthorize", iAuthDepth, true);
			else getConfig();
			this.mcMessage.init(oLanguage.getString("msgLoading", "LOADING"));
		}
		
		public function onAuthorize(event:Event):void
		{
			var aData:Object = event.data[0][0];
			bAuthorized = aData["value"] == BxXml.TRUE_VAL;
			
			if(bAuthorized || !bAuthorizeObligatory) getConfig();
			else this.mcMessage.init(oLanguage.getString(aData["value"], "User Authorization Failed"), false);
		}

		public function get authorized():Boolean
		{
			return bAuthorized;
		}
		
		protected function getConfig():void
		{
			oXml.returnXml(oXml.getXmlUrl("config"), this, "configHandler", 2);
		}
		
		/**
		* @private
		* configuration loading handler
		* @param aData array
		*/
		public function configHandler(event:Event):void
		{
			oConfig = new Object();
			var aConfigData:Array = event.data[0][0];
			
			for(var i:Number=0; i<aConfigData.length; i++)
			{
				var sKey:String = aConfigData[i]["key"];
				var sValue:String = aConfigData[i]["_value"];
				if(sValue == BxXml.TRUE_VAL || sValue == BxXml.FALSE_VAL) oConfig[sKey] = sValue == BxXml.TRUE_VAL;
				else if(!isNaN(sValue) && sValue != "") oConfig[sKey] = Number(sValue);
				else oConfig[sKey] = BxXml.replaceXmlCharacters(sValue);
			}
			dispatchEvent(new BxXmlEvent(EVENT_CONFIG, oConfig));
		}
		
		protected function onAdsLoaded(event:Event):void
		{
			trace("!!!!!!!!!!!!!onAdsLoaded");
			onResizeHandler();
		}
		
		protected function onResizeHandler(event:Event = null):void
		{
			var iWidth:Number, iHeight:Number;
			if(!bPublish || event == null)
			{
				iWidth = width;
				iHeight = height;
			}
			else
			{
				iWidth = event.data.width;
				iHeight = event.data.height;
			}
			if(!bPublish || bAdmin)
			{
				iWidth = stage.stageWidth;
				iHeight = stage.stageHeight;
			}
			if(this.mcBorder != undefined)
			{
				this.mcBorder.width = iWidth - 1;
				this.mcBorder.height = iHeight - 1;
			}
			this.mcBack.height = iHeight;
			this.mcBack.width = iWidth;
			if(iWidth < MIN_WIDTH) iWidth = MIN_WIDTH;
			if(iHeight < MIN_HEIGHT) iHeight = MIN_HEIGHT;
			var iShiftX:Number = iWidth - iAppWidth;
			var iShiftY:Number = iHeight - iAppHeight;
			iAppHeight = iHeight;
			iAppWidth = iWidth;
			this.mcMessage.locate();
			if(this.mcAds != undefined)
			{
				this.mcAds.y = iHeight - this.mcAds.height;
				iHeight -= this.mcAds.height;
			}
			dispatchEvent(new BxXmlEvent(Event.RESIZE, {width: iWidth, height: iHeight}));
		}
		
		/**
		* @private
		* actions on connection error
		*/
		public function onConnectionError(event:Event = null):void
		{
			this.mcMessage.init(oLanguage.getString("msgConnectionError", "Connection Error"), false);
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