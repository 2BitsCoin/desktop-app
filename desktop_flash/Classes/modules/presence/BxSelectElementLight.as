package modules.presence
{
	import flash.events.Event;
	import controls.BxSelectElement;
	import utils.BxStyle;
	
	/**
	 * Select Element for DropDown Select control.
	 * @see BxSelect
	 */
	dynamic public class BxSelectElementLight extends BxSelectElement
	{
		/**
		* @private
		*/
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			BxStyle.changeTextFormat(this.txtCaption, root.mcStyle.SelectElementCaptionLight);
		}
	}
}