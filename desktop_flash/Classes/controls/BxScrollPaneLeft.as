package controls
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import controls.BxScrollPane;

	/**
	 * ScrollPane control with vertical ScrollBar located on the left side
	 * @see BxScrollPane
	 */
	dynamic public class BxScrollPaneLeft extends BxScrollPane
	{
		/**
		* @private
		*/
		override public function init(scrollSpaceMargin:Number, vertical:Boolean = true, horizontal:Boolean = false, bolRightScroll:Boolean = true):void
		{
			super.init(scrollSpaceMargin, vertical, horizontal, false);
		}
	}
}