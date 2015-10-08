package controls
{
	import flash.display.*;
	import flash.events.*;
	import utils.*;

	/**
	* Super class for some PopupList objects. Defines common methods and properties.
	*/
	dynamic public class BxPopupList extends Sprite
	{
		/**
		* @private
		*/
		protected var
			bActive:Boolean = false, bEnabled:Boolean = false,
			iHintShift:Number = 10,
			sHint:String = "";
		/**
		* @private
		*/
		function BxPopupList()
		{
			if(this.mcArrow != undefined) this.mcArrow.mouseEnabled = false;
			this.btnOpen.addEventListener(MouseEvent.CLICK, onOpen);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		/**
		* @private
		*/
		protected function onLanguage(event:Event):void
		{
			root.mcHint.attach(this.btnOpen, root.oLanguage.getString(sHint), iHintShift);
		}
		/**
		* @private
		*/
		protected function onAddToStage(event:Event):void
		{
			active = bActive;
			root.addEventListener(BxLanguage.LANGUAGE_LOADED, onLanguage);
		}
		/**
		* Defines whether PopupList object is enabled
		*/
		public function set enabled(bMode:Boolean):void
		{
			bEnabled = bMode;
			if(!bEnabled) active = false;
		}
		/**
		* @private
		*/
		public function get enabled():Boolean
		{
			return bEnabled;
		}
		/**
		* @private
		*/
		protected function set active(bMode:Boolean):void
		{
			this.mcBack.visible = bActive = bEnabled && bMode;
			if(bActive) stage.addEventListener(MouseEvent.MOUSE_UP, onClick);
			else stage.removeEventListener(MouseEvent.MOUSE_UP, onClick);
		}
		/**
		* @private
		*/
		protected function get active():Boolean
		{
			bActive;
		}
		
		private function onOpen(event:Event):void
		{
			active = true;
		}
		protected function onClick(event:Event):void
		{
			active = false;
		}
		/**
		* PopupList object width
		*/
		override public function get width():Number
		{
			return this.mcBack.width;
		}
		/**
		* @private
		*/
		override public function set width(iWidth:Number):void
		{
			this.mcBack.width = iWidth;
		}
	}
}