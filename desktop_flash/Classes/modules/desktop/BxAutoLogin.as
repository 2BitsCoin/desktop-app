package modules.desktop
{
	import flash.display.MovieClip;
	import flash.events.*;
	import utils.*;
	import flash.external.ExternalInterface;
	
	/**
	* The Main application object for Chat application (<code>root</code>).
	*/
	dynamic public class BxAutoLogin extends MovieClip
	{
		/**
		* @private
		*/
		function BxAutoLogin()
		{
			this.mcProgress.stop();
			this.btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
			this.mcProgress.addEventListener(Event.COMPLETE, onComplete);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			this.visible = false;
			ExternalInterface.addCallback("close", onCancel);
		}
		
		private function onAddToStage(event:Event):void
		{
			root.addEventListener(BxLanguage.LANGUAGE_LOADED, onLanguage);
		}
		
		private function onLanguage(event:Event):void
		{
			this.txtCaption.text = root.oLanguage.getString("txtAutoLogging", "Auto Logging");
			root.oLanguage.setButtonCaption(this.btnCancel, root.oLanguage.getString("btnCancel", "Cancel"), false);
		}
		
		public function init():void
		{
			this.mcProgress.gotoAndPlay(1);
			this.visible = true;
		}
		
		private function onCancel(event:Event = null):void
		{
			this.mcProgress.gotoAndStop(1);
			this.visible = false;
		}
		
		private function onComplete(event:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			this.visible = false;
		}
	}
}