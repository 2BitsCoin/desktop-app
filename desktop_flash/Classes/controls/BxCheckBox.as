package controls
{
	import flash.display.MovieClip;
	import flash.events.*;
	import controls.BxRadioButton;
	import utils.BxXmlEvent;
	
	/**
	* Dispatched when the CheckBox control <code>selected</code> status is changed.
	*/
	[Event(name="select", type="utils.BxXmlEvent")]
	
	/**
	 * Responsible for CheckBox control work
	 */
	dynamic public class BxCheckBox extends BxRadioButton
	{
		/**
		* @private
		*/
		function BxCheckBox()
		{
			this.mcDisabledMark.visible = false;
		}

		/**
		* @private
		*/
		override protected function onClick(event:Event):void
		{
			selected = !bSelected;
		}
		
		/**
		* @private
		*/
		override protected function onSelect(bMode:Boolean):void
		{
			dispatchEvent(new BxXmlEvent(Event.SELECT, bMode));
		}
	}
}