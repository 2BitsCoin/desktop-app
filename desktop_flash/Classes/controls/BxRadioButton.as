package controls
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	* Dispatched when the RadioButton control <code>selected</code> status is set to <code>true</code>.
	*/
	[Event(name="select", type="flash.events.Event")]
	
	/**
	 * Responsible for RadioButton control work
	 */
	dynamic public class BxRadioButton extends MovieClip
	{
		/**
		* @private
		*/
		protected var
			bSelected:Boolean, bEnabled:Boolean = true;

		/**
		* @private
		*/
		function BxRadioButton()
		{
			selected = false;
			this.mcMark.mouseEnabled = false;
			this.mcBack.buttonMode = true;
			this.mcBack.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
		}
		
		/**
		* @private
		*/
		protected function onClick(event:Event):void
		{
			if(!bSelected) selected = true;
		}
		
		/**
		* defines/sets selected state for RadioButton control
		* @example The following code sets the control's <code>selected</code> state to <code>true</code>:
		* <listing version="3.0">mcRadioButton.selected = true;</listing>
		* @default false
		*/
		public function get selected():Boolean
		{
			return bSelected;
		}
		
		/**
		* @private
		*/
		public function set selected(bMode:Boolean):void
		{
			this.mcMark.visible = bSelected = bMode;
			onSelect(bMode);
		}

		/**
		* @private
		*/
		protected function onSelect(bMode:Boolean):void
		{
			if(bMode) dispatchEvent(new Event(Event.SELECT));
		}
		
		/**
		* defines whether RadioButton is enabled
		* @default true
		*/
		override public function set mouseEnabled(bMode:Boolean):void
		{
			this.mcBack.mouseEnabled = bMode;
		}
	}
}