package utils.tabs
{
	import flash.events.Event;
	
	/**
	* Dispatched when the Tab "calling" mode is enabled.
	*/
	[Event(name="tabCallingStart", type="flash.events.Event")]
	/**
	* Dispatched when the Tab "calling" mode is disabled.
	*/
	[Event(name="tabCallingStop", type="flash.events.Event")]	

	/**
	* Base Tab for room and private chat tabs.
	* @see modules.chat.chat.BxDialog
	*/
	dynamic public class BxTabCalling extends BxTab
	{
		public static const
			TAB_CALLING_START:String = "tabCallingStart",
			TAB_CALLING_STOP:String = "tabCallingStop";
		/**
		* @private
		*/
		private var	bCalling:Boolean = false;
		/**
		* @private
		*/
		function BxTabCalling(objOwner:Object = null)
		{
			super(objOwner);
		}
		
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			this.mcIconCaller.visible = false;
			calling = bCalling;
		}

		/**
		* The Tab "calling" status.
		*/
		public function set calling(b:Boolean):void
		{
			if(bActive || bCalling == b) return;
			bCalling = b;
			this.mcIcon.visible = !bCalling;
			this.mcIconCaller.visible = bCalling;
			dispatchEvent(new Event(bCalling ? TAB_CALLING_START : TAB_CALLING_STOP));
		}
		/**
		* @private
		*/
		override public function get calling():Boolean
		{
			return bCalling;
		}
		/**
		* @private
		*/
		override public function set active(bolActive:Boolean):void
		{
			if(bolActive) calling = false;
			super.active = bolActive;
		}
	}
}