package controls
{
	import flash.display.Sprite;
	import flash.events.*;

	/**
	* Dispatched when user clicks top part of the window to drag it.
	* @eventType flash.events.Event
	*/
	[Event(name="onStartDrag", type="flash.events.Event")]
	/**
	* Dispatched when user releases top part of the window to stop dragging it.
	*/
	[Event(name="onStopDrag", type="flash.events.Event")]

	/**
	 * A window backgound class. Being resized by changing 
	 * <code>width</code> and <code>height</code> properties.
	 * Also this object dispatches events for starting/stopping dragging the window.
	 * @see BxWindow
	 */
	dynamic public class BxWindowBackSimple extends Sprite
	{
		/**
		* @private
		*/
		function BxWindowBackSimple()
		{
			scaleX = scaleY = 1;
			this.btnHeader.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
		}
		
		private function onStartDrag(event:Event):void
		{
			this.btnHeader.addEventListener(MouseEvent.CLICK, onStopDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			dispatchEvent(new Event(BxWindow.START_DRAG));
		}
		
		private function onStopDrag(event:Event):void
		{
			this.btnHeader.removeEventListener(MouseEvent.CLICK, onStopDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			dispatchEvent(new Event(BxWindow.STOP_DRAG));
		}
		
		override public function set width(iWidth:Number):void
		{
			var iShift:Number = iWidth - this.btnHeader.width;
			this.btnHeader.width += iShift;
			this.mcUpLine.width += iShift;
			this.mcDownLine.width += iShift;
			this.mcBack.width = iWidth;
		}
		
		override public function set height(iHeight:Number):void
		{
			var iShiftY:Number = iHeight - height;
			this.mcDownLine.y += iShiftY;
			this.mcBack.height = iHeight;
		}
	}
}