package modules.presence
{
	import flash.events.Event;
	import controls.BxSelect;
	import utils.BxStyle;

	/**
	 * DropDown Select control.
	 */
	dynamic public class BxSelectLight extends BxSelect
	{
		/**
		* @private
		*/
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			BxStyle.changeTextFormat(this.txtCaption, root.mcStyle.SelectCaptionLight);
		}

		/**
		* @private
		*/
		override protected function generateElement():Object
		{
			return new BxSelectElementLight();
		}
	}
}