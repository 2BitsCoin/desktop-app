package message
{
	import utils.BxStyle;
	import dialogs.BxDialog;
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	/**
	 * Used to show major system messages such as loading something or even connecting.
	 * <code>visible = false</code> should be used to stop displaying the system message.
	 */
	dynamic public class BxSystemMessage extends BxDialog
	{
		/**
		* @private
		* class constructor
		*/
		function BxSystemMessage()
		{
			this.mcBackGround.alpha = 0;
			this.mcDisabled.alpha = 1;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			BxStyle.changeTextFormat(this.txtMessage, root.mcStyle.SystemMessageText);
		}

		/**
		* Initializes System Message with given message
		* @param sMessage Message to display
		* @param bWaiting Enable loading indicator
		* @example The following example will initialize System Message object with "Loading ..." text
		* <listing>root.mcMessage.init("Loading ...", true);</listing>
		*/
		public function init(sMessage:String, bWaiting:Boolean = true):void
		{
			trace(sMessage);
			this.txtMessage.text = sMessage;			
			this.txtMessage.autoSize = TextFieldAutoSize.CENTER;
			
			this.mcLoading.visible = bWaiting;
			
			this.txtMessage.y = bWaiting
				? this.mcLoading.y + this.mcLoading.height + 5
				: this.mcBackGround.y + this.mcBackGround.height / 2 - this.txtMessage.height / 2;
									
			this.visible = true;
		}
	}
}