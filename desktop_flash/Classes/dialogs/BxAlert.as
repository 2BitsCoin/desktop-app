package dialogs
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Rectangle;
	import controls.BxWindow;
	import utils.BxStyle;

	/**
	 * Alert is used to show some messages to user.
	 */
	dynamic public class BxAlert extends BxWindow
	{
		private const iWidth:Number = 340;
		private const iHeight:Number = 170;
		private var
			iTextY:Number, iTextHeight:Number;
		
		/**
		* @private
		*/
		function BxAlert()
		{
			width = iWidth;
			height = iHeight;
			iTextY = this.txtMessage.y;
			iTextHeight = this.txtMessage.height;
			this.btnOk.addEventListener(MouseEvent.CLICK, apply);
		}
		/**
		* @private
		*/
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			BxStyle.changeTextFormat(this.txtMessage, root.mcStyle.WindowText);
		}
		/**
		* Initializes the Alert Window with passed message
		* @param sMessage Message to display
		* @param objHandler not used (for proper inheritance only)
		* @param strMethod not used (for proper inheritance only)
		*/
		public function init(sMessage:String, objHandler:Object = null, strMethod:String = ""):void
		{
			this.txtMessage.text = sMessage;
			if(!visible)
			{
				x = (root.width - width) / 2;
				y = (root.height - height) / 2;
			}
			this.txtMessage.autoSize = TextFieldAutoSize.CENTER;
			this.txtMessage.y = iTextY + (iTextHeight - this.txtMessage.height) / 2;
			visible = true;
		}
		/**
		* @private
		*/
		override protected function onLanguage(event:Event):void
		{
			super.onLanguage(event);
			caption = root.oLanguage.getString("dlgAlert", "Alert");
			root.oLanguage.setButtonCaption(this.btnOk, root.oLanguage.getString("btnOk", "OK"));
		}
		/**
		* @private
		*/
		protected function apply(event:Event):void
		{
			super.close(event);
		}
	}
}