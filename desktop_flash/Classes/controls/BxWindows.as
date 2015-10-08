package controls
{
	import flash.display.*;
	import flash.events.*;

	/**
	* Dispatched when some of windows that require input text ability is opened.
	* @see BxWindows#INPUT_ENABLE
	*/
	[Event(name="onInputEnable", type="flash.events.Event")]
	/**
	* Dispatched when a window that require input text ability is closed 
	* and other opened windows don't require this ability.
	* @see BxWindows#INPUT_DISABLE
	*/
	[Event(name="onInputDisable", type="flash.events.Event")]

	/**
	 * Provides a functionality to manage all windows in the Chat/Messenger.
	 * You should add your custom windows to this object by calling <code>addWindow</code> method.
	 * That will automatically add some additional functionality to your custom window: 
	 * depth changing when a window becomes active, enabling/disabling all input 
	 * catching by Chat/Messenger dialog input TextField.
	 * @see BxWindow
	 */
	dynamic public class BxWindows extends Sprite
	{
		/**
		 * @private
		 */
		public static const 
			INPUT_ENABLE:String = "onInputEnable",
			INPUT_DISABLE:String = "onInputDisable";
		private var
			iInputWindows:Number = 0;
			
		/**
		 * Adds your custom window to all windows holder (this object)
		 * @param mcWindow Your custom window object
		 */
		public function addWindow(mcWindow:Object):void
		{
			mcWindow.addEventListener(BxWindow.WINDOW_MOVE, onWindowMove);
			mcWindow.addEventListener(BxWindow.WINDOW_ACTIVE, onWindowActive);
			mcWindow.addEventListener(BxWindow.WINDOW_PASSIVE, onWindowPassive);
			addChild(mcWindow);
			mcWindow.x = (parent.width - mcWindow.width) / 2;
			mcWindow.y = (parent.height - mcWindow.height) / 2;
			trace("ADD", mcWindow);
		}
		
		private function onWindowMove(event:Event):void
		{
			var mcWindow:Object = event.target;
			setChildIndex(mcWindow, numChildren - 1);
		}
		
		private function onWindowActive(event:Event):void
		{
			var mcWindow:Object = event.target;
			if(mcWindow.inputRequired)
			{
				iInputWindows++;
				if(iInputWindows == 1) dispatchEvent(new Event(INPUT_ENABLE));
			}
			trace("WINDOW ACTIVE", mcWindow.name, iInputWindows);
			onWindowMove(event);
		}
		
		private function onWindowPassive(event:Event):void
		{
			var mcWindow:Object = event.target;
			if(mcWindow.inputRequired)
			{
				iInputWindows = Math.max(0, iInputWindows-1);
				if(iInputWindows == 0) dispatchEvent(new Event(INPUT_DISABLE));
			}
			trace("WINDOW PASSIVE", mcWindow.name, iInputWindows);
		}
	}
}