package utils
{
	import flash.xml.*;
	import flash.display.Stage;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	import flash.events.*;

	/**
	 * Provides some methods to load, read, parse XML documents and return the retrieved data to handlers.
	 */
	public class BxXml extends EventDispatcher
	{
		/**
		* @private
		*/
		public static const 
			XML_ERROR:String = "onXmlError",
			SUCCESS_VAL:String = "success",
			TRUE_VAL:String = "true",
			FALSE_VAL:String = "false";

		private var aTemplates:Array = new Array();
		
		/**
		* @private
		* class constructor
		*/
		function BxXml(sUrl:String)
		{
			System.useCodePage = false;
			var sCrossDomainUrl:String = sUrl.split("XML.php")[0];
			if(sCrossDomainUrl != "")
			{
				sCrossDomainUrl += "crossdomain.xml";
				Security.loadPolicyFile(sCrossDomainUrl);
			}
		}
		
		/**
		* Adds XML URL template to this object to allow it's quick calling. 
		* After template is added you can use <code>returnXml</code> and <code>getXmlUrl</code> 
		* methods to call and handle these documents.
		* @param sIndex Template's index
		* @param sUrl URL to XML document
		* @param aParams Extra parameters to add to XML URL
		* @example The following example shows how to add some XML URL to load data from it.
		* <listing>oXml.addTemplate("uploadFile", "http://your_site/ray/XML.php?module=chat&action=uploadFile", ["sender", "recipient"]);</listing>
		* @see returnXml
		* @see getXmlUrl
		*/
		public function addTemplate(sIndex:String, sUrl:String, aParams:Array = null):void
		{
			aTemplates[sIndex] = {url: sUrl, params: aParams};
		}
		
		/**
		* Gets full URL by template index
		* @param sCase URL index
		* @param aParams Extra parameters array
		* @param sMethod Sending method (POST, GET)
		* @param bAntiCash Use extra anticash variable (true/false)
		* @return URL object
		* @example The following example adds a template and then calls it.
		* <listing>oXml.addTemplate("uploadFile", "http://your_site/ray/XML.php?module=chat&action=uploadFile", ["sender", "recipient"]);<br>trace(oXml.getXmlUrl("uploadFile", ["1", "2"], "GET", true).url);</listing>
		* The above statement will print <br><code>http://your_site/ray/XML.php?module=chat&action=uploadFile&sender=1&recipient=2&_t=12345</code>
		*/
		public function getXmlUrl(sCase:String, aParams:Array = null, sMethod:String = "POST", bAntiCash:Boolean = true):URLRequest
		{
			if(aTemplates[sCase] == undefined) return null;
			var sUrl:String = aTemplates[sCase].url;
			sUrl += (sUrl.indexOf("?") == -1) ? "?" : "&";
			var lvVars:URLVariables = new URLVariables();
			if(aParams is Array)
				for(var i:Number=0; i<aParams.length && i<aTemplates[sCase].params.length; i++)
					if(sMethod == "POST") lvVars[aTemplates[sCase].params[i]] = aParams[i];
					else sUrl += aTemplates[sCase].params[i] + "=" + aParams[i] + "&";
			if(bAntiCash) sUrl += "_t=" + getTimer();
			var urlRequest:URLRequest = new URLRequest(sUrl);
			urlRequest.method = sMethod;
			urlRequest.data = lvVars;
			if(bAntiCash) trace(getXmlUrl(sCase, aParams, "GET", false).url);
			return urlRequest;
		}	
	
		/**
		* Loads pre-formed URLRequest object or an URL string and returns the result object to specified handler
		* @param oPostUrl URLRequest (or URL as a string) object to load
		* @param oEventHandler An object that will handle the result data
		* @param sEventType Event type dispatch when the data is loaded and parsed 
		* (don't call <code>addEventListener</code> or <code>removeEventListener</code> methods
		* to assign the event handler. <code>BxXml</code> object will do it automatically.
		* @param iDepth Maximum depth of XML childs structure to parse (-1 parses the whole structure). 
		* That means all elements above <code>iDepth</code> are considered as parent nodes and their attributes are ignored.
		* And beginning from nodes with <code>iDepth</code> depth all nodes are considered as childs without any extra childs.
		* Their attributes are set as the respective objects properties and all code that comes as child nodes is set 
		* as <code>_value</code> property with <code>String</code> type.
		* @param bGetAll Tells to get all contents into variables (attributes and childs <code>String _value</code>) 
		* beginning with <code>iDepth</code> depth nodes.
		* @example The following example will create <code>mc</code> object handling XML request. 
		* All result data will be passed to <code>onHandle</code> method as <code>data</code> property 
		* of <code>BxXmlEvent</code> object.
		* <listing>var mc:Handler = new Handler(); oXml.returnXml(oXml.getXmlUrl("uploadFile", ["1", "2"], "GET", true), mc, "onHandle");</listing>
		* @see returnXml
		* @see BxXmlEvent
		*/
		public function returnXml(oPostUrl:Object, oEventHandler:Object = null, sEventType:String = "", iDepth:Number = -1, bGetAll:Boolean = false):void
		{
			if(oPostUrl == null) return;
			
			if(!(oPostUrl is URLRequest))
				oPostUrl = new URLRequest(oPostUrl.toString());

			var urlLoader:URLLoader = new URLLoader(), oSelf:Object = this;
			var onComplete:Function = function(event:Event):void
			{
				var xXml:XMLDocument = new XMLDocument();
				xXml.ignoreWhite = true;
				try {xXml.parseXML(urlLoader.data); trace(urlLoader.data);}
				catch (e:Error) {trace(e); dispatchEvent(new Event(XML_ERROR));}
				if(oEventHandler != null)
				{
					var aData:Array = oSelf.parseXml(xXml.firstChild, iDepth, bGetAll);
					oSelf.addEventListener(sEventType, oEventHandler[sEventType]);
					dispatchEvent(new BxXmlEvent(sEventType, aData));
					oSelf.removeEventListener(sEventType, oEventHandler[sEventType]);
				}
			}
			var onIOError:Function = function(event:IOErrorEvent):void 
			{
            	trace("ioErrorHandler: " + event.text);
	        }			
			var securityErrorHandler:Function = function(event:SecurityErrorEvent):void 
			{
				trace("securityErrorHandler: " + event);
			}

			var httpStatusHandler:Function = function(event:HTTPStatusEvent):void 
			{
				//trace("httpStatusHandler: " + event);
			}

            urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.load(oPostUrl);
		}
	
		/**
		* parses an XML node
		* @param xElement - XML node to parse
		* @param iDepth - max depth of XML structure
		* @return aXmlNodes - array containing all subnodes and values of the given node
		*/
		private function parseXml(xElement:XMLNode, iDepth:Number, bGetAll:Boolean):Array
		{
			//trace(xElement.toString());
			iDepth = (bGetAll && iDepth == -1) ? 0 : iDepth;
			var aXmlNodes:Array = new Array();
			while(xElement != null)
			{
				var aXmlNode:Array = new Array();
				
				if(xElement.firstChild != null)
				{
					if(bGetAll || iDepth != 0) aXmlNode = parseXml(xElement.firstChild, iDepth - 1, bGetAll);
					if(iDepth == 0) aXmlNode["_value"] = xElement.childNodes.toString();
				}
				for(var i:String in xElement.attributes)
					aXmlNode[i] = xElement.attributes[i];
	
				aXmlNode["_name"] = xElement.nodeName;
				aXmlNodes.push(aXmlNode);
				xElement = xElement.nextSibling;
			}
			return aXmlNodes;
		}
		
		/**
		* @private
		* get child by property value
		* @param aParent
		* @param sValue
		* @param sProperty
		* @return aChild
		*/
		static public function getChildByProperty(aParent:Object, sValue:String, sProperty:String = "_name"):Array
		{
			for(var i:String in aParent)
				if((aParent[i] is Array) && aParent[i][sProperty] == sValue)
					return aParent[i];
			return [];
		}
		
		/**
		* @private
		* Replaces XML special symbols with normal ones
		* @param sString - string to replace
		* @return sString - result string
		*/
		static public function replaceXmlCharacters(sString:String = ""):String
		{
			sString = sString.split("&amp;").join("&");
			sString = sString.split("&apos;").join("'");
			sString = sString.split("&quot;").join("\"");
			sString = sString.split("&lt;").join("<");
			sString = sString.split("&gt;").join(">");
			return sString;
		}
	}
}