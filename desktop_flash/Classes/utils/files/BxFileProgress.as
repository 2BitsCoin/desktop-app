package utils.files
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.*;
	import controls.BxWindow;
	import utils.*;

	/**
	* Dispatched when the file uploading is finished.
	* Object with <code>user</code> (file recipient user ID) and <code>name</code> (file name) properties 
	* is passed as <code>data</code> value for event.
	*/
	[Event(name="onFileUploaded", type="utils.BxXmlEvent")]
	
	/**
	* File Uploading Progress Dialog class.
	*/
	dynamic public class BxFileProgress extends BxWindow
	{
		/**
		* @private
		*/
		public static const SEND_FILE:String = "onSendFile";
		public static const FILE_UPLOADED:String = "onFileUploaded";
		private const iWidth:Number = 340;
		private const iHeight:Number = 170;
		private var bActive:Boolean = false;
		protected var fFile:FileReference;
		
		/**
		* @private
		*/
		function BxFileProgress()
		{
			super();
			width = iWidth;
			height = iHeight;
			this.btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
			this.btnCancel.removeEventListener(MouseEvent.CLICK, close);
		}
		/**
		* Active status. Defines whether the upload is in progress.
		*/
		public function get active():Boolean {return bActive;}
		/**
		* @private
		*/
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			BxStyle.changeTextFormat(this.txtMessage, root.mcStyle.WindowText);
		}
		/**
		* @private
		*/
		override protected function onLanguage(event:Event):void
		{
			super.onLanguage(event);
			caption = root.oLanguage.getString("dlgFileUploadProgress", "Uploading Progress");
		} 
		/**
		* @private
		*/
		override protected function onConnected(event:Event):void
		{
			super.onConnected(event);
			root.mcSendFile.addEventListener(SEND_FILE, init);
		}
		
		protected function init(event:Event):void
		{
			fFile = event.data.file;
			this.txtMessage.text = root.oLanguage.getString("dlgFileUpload");
			
			progress = 0;
			visible = bActive = true;
			fFile.addEventListener(ProgressEvent.PROGRESS, onProgress);
			fFile.addEventListener(Event.COMPLETE, onComplete);
			fFile.addEventListener(IOErrorEvent.IO_ERROR, onError);
            fFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			fFile.upload(new URLRequest(getUploadUrl()));
		}
		
		protected function getUploadUrl():String
		{
			return root.oXml.getXmlUrl("uploadFile").url;
		}

        private function onError(event:Event):void
		{
			bActive = false;
            root.mcAlert.init(event.text);
			close();
        }

		private function onProgress(event:ProgressEvent):void
		{
			progress = event.bytesLoaded / event.bytesTotal;
		}
		
		private function set progress(iPosition:Number):void
		{
			trace("progress", iPosition);
			this.mcIndicator.width = this.mcIndicatorBack.width * iPosition;
		}
		
		protected function onComplete(event:Event):void
		{
			bActive = false;
			close();
			dispatchComplete();
		}
		
		protected function dispatchComplete():void
		{
			dispatchEvent(new Event(FILE_UPLOADED));
		}
		
		private function onCancel(event:Event):void
		{
			root.mcConfirm.init(root.oLanguage.getString("msgUploadCancel"), this, "onConfirmResult");
		}
		/**
		* @private
		*/
		public function onConfirmResult(bResult:Boolean):void
		{
			if(bResult)
			{
				bActive = false;
				fFile.cancel();
				close();
			}
		}
	}
}