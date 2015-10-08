package modules.desktop
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import modules.chat.blocks.BxProfileButton;
	import utils.BxXml;
	
	/**
	* User Status PopupList entry.
	* @see modules.chat.tools.BxUserStatus
	*/
	dynamic public class BxUserStatusElement extends BxProfileButton
	{
		private var
			sId:String = "",
			sImage:String = "",
			lImageLoader:Loader = new Loader(),
			oIcon:Object;
			
		function BxUserStatusElement(aData:Object)
		{
			super();
			visible = lImageLoader.mouseEnabled = false;
			this.btn.buttonMode = true;
			sId = aData["id"];
			image = aData["image"];
			caption = BxXml.replaceXmlCharacters(aData["_value"]);
		}
		
		/**
		* @private
		*/
		override protected function onAddToStage(event:Event):void
		{
			tfSource = root.mcStyle.UserStatusText;
		}
		
		public function get id():String
		{
			return sId;
		}
		
		public function get iconUrl():String
		{
			return sImage;
		}
		
		private function set image(strImage:String):void
		{
			sImage = strImage;
			lImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadPhotoError);
			lImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoLoaded);
			lImageLoader.load(new URLRequest(sImage));
		}
		
		private function onLoadPhotoError(event:IOErrorEvent):void
		{
			trace("error loading photo");
		}
		
		private function onPhotoLoaded(event:Event):void
		{
			this.btn.addChild(lImageLoader);
		}

		public function set icon(objIcon:Object):void
		{
			oIcon = objIcon;
		}
		
		public function get icon():Object
		{
			return oIcon;
		}
		
		override public function get width():Number
		{
			return this.txtCaption.x + this.txtCaption.width;
		}
	}
}