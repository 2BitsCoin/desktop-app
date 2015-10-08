package controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import controls.MovieClipContainer;
//	import modules.chat.connect.BxConnect;
	import utils.*;
	
	/**
	* Dispatched when the window is being closed by calling <code>close</code> method.
	*/
	[Event(name="onWindowClose", type="flash.events.Event")]
	/**
	* Dispatched when the window becomes active (visible).
	*/
	[Event(name="onWindowActive", type="flash.events.Event")]
	/**
	* Dispatched when the window becomes passive (invisible).
	*/
	[Event(name="onWindowPassive", type="flash.events.Event")]
	/**
	* Dispatched when the window receives focus by clicking on it's background.
	* Used by <code>mcWindows</code> object to bring the window to front.
	* @see BxWindows
	*/
	[Event(name="onWindowMove", type="flash.events.Event")]

	/**
	 * Serves as a super class for all windows used in Chat/Messenger
	 * @see BxWindows
	 * @see BxWindowBack
	 */
	dynamic public class BxWindow extends MovieClipContainer
	{
		/**
		 * @private
		 */
		public static const 
			WINDOW_MOVE:String = "onWindowMove",
			WINDOW_CLOSE:String = "onWindowClose",
			WINDOW_ACTIVE:String = "onWindowActive",
			WINDOW_PASSIVE:String = "onWindowPassive",
			START_DRAG:String = "onStartDrag",
			STOP_DRAG:String = "onStopDrag";
		private var
			rRect:Rectangle;
		/**
		 * @private
		 */
		protected var
			bInputRequired:Boolean = false;
		
		/**
		* @private
		*/
		function BxWindow()
		{
			visible = false;
			cacheAsBitmap = true;
			this.btnClose.addEventListener(MouseEvent.MOUSE_DOWN, close);
			if(this.btnCancel != null) this.btnCancel.addEventListener(MouseEvent.CLICK, close);
			this.mcBack.addEventListener(MouseEvent.MOUSE_DOWN, onMove);
			this.mcBack.addEventListener(START_DRAG, onStartDrag);
			this.mcBack.addEventListener(STOP_DRAG, onStopDrag);
		}
		/**
		 * @private
		 */
		protected function onLanguage(event:Event):void
		{
			if(this.btnCancel != null) root.oLanguage.setButtonCaption(this.btnCancel, root.oLanguage.getString("btnCancel", "Cancel"));
		}
		/**
		 * @private
		 */
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			BxStyle.changeTextFormat(this.txtCaption, root.mcStyle.WindowCaption);
			refreshRect();
			parent.addEventListener(Event.RESIZE, refreshRect);
			parent.addEventListener(BxMain.EVENT_CONNECTED, onConnected);
			parent.addEventListener(BxLanguage.LANGUAGE_LOADED, onLanguage);
		}
		/**
		 * @private
		 */
		protected function refreshRect(event:Event = null):void
		{
			rRect = new Rectangle(0, 0, root.width - this.width, root.height - this.height);
		}
		/**
		 * @private
		 */
		protected function onConnected(event:Event):void
		{
			parent.mcWindows.addWindow(this);
		}
		/**
		 * Defines whether the window is used for entering some text
		 * @return true - text might be entered / false - text won't be entered
		 */		
		public function get inputRequired():Boolean
		{
			return bInputRequired;
		}
		/**
		 * Closes the window and provokes dispatching <code>onWindowClose</code> event.
		 */
		public function close(event:Event = null):void
		{
			this.visible = false;
			dispatchEvent(new Event(WINDOW_CLOSE));
		}
		/**
		 * @private
		 */
		protected function onStartDrag(event:Event):void
		{
			this.startDrag(false, rRect);
		}
		/**
		 * @private
		 */
		protected function onStopDrag(event:Event):void
		{
			this.stopDrag();
		}
		
		override public function set width(iWidth:Number):void
		{
			trace("!!!!!!!width", this.name, iWidth, this.mcBack.width);
			var iShiftX:Number = Math.floor(iWidth - this.mcBack.width);
			this.btnClose.x += iShiftX;
			this.txtCaption.width += iShiftX;
			super.width = iWidth;
		}
		/**
		 * @private
		 */		
		override public function set visible(b:Boolean):void
		{
			super.visible = b;
			dispatchEvent(new Event(b ? WINDOW_ACTIVE : WINDOW_PASSIVE));
		}
		/**
		 * @private
		 */	
		private function onMove(event:Event):void
		{
			dispatchEvent(new Event(WINDOW_MOVE));
		}
	}
}