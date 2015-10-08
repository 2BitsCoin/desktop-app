package controls
{
	import controls.BxScrollBar;
	
	/**
	 * Horizontal ScrollBar control.
	 */
	dynamic public class BxhScrollBar extends BxScrollBar
	{
		/**
		 * @private
		 */
		function BxhScrollBar()
		{
			bVertical = false;
			sDimension = "width";
			sPosition = "x";
			sMouse = "mouseX";
		}
	}
}