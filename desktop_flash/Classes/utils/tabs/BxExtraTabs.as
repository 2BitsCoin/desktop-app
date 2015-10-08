package utils.tabs
{
	import flash.events.*;
	import flash.display.*;
	import flash.utils.Timer;
	import utils.BxLanguage;
	
	/**
	* Extra Tabs class. Serves as a container for tabs that can't be located in general tabs container.
	* @see modules.chat.tabs.BxTab
	* @see modules.chat.tabs.BxTabs
	*/
	dynamic public class BxExtraTabs extends Sprite
	{
		private var 
			bFirstClick:Boolean = true, bActiveState:Boolean = false, bActive:Boolean = false,
			iCallingTabs:Number = 0,
			tTimer:Timer,
			aTabs:Array = new Array(),
			mcContainer:Sprite;
		/**
		* @private
		*/
		function BxExtraTabs()
		{
			mcContainer = new Sprite();
			addChild(mcContainer);
			mcContainer.y = this.height;

			tTimer = new Timer(500);
			tTimer.addEventListener("timer", onTimer);
			active = bActive;
		
			listVisible = visible = this.mcActive.mouseEnabled = false;
			
			this.mcBack.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			root.addEventListener(BxLanguage.LANGUAGE_LOADED, onLanguage);
		}
		
		private function onLanguage(event:Event):void
		{
			root.mcHint.attach(this.mcBack, root.oLanguage.getString("hintTabExtra", "View more Tabs"));
		}

		private function onTimer(event:Event):void
		{
			activeState = !bActiveState;
		}
		
		private function onMouseDown(event:Event):void
		{
			listVisible = !mcContainer.visible;
			active = !bActive;
			refreshActive();
			stage.addEventListener(MouseEvent.MOUSE_UP, onClick);
			bFirstClick = true;
		}
		private function isTabActive(mcTab:*, index:int, arr:Array):Boolean
		{
            return mcTab.active;
        }

		private function onClick(event:Event):void
		{
			if(bFirstClick) bFirstClick = false;
			else listVisible = false;
		}
		
		private function set listVisible(bVisible:Boolean):void
		{
			mcContainer.visible = bVisible;
			refreshCalling();
			if(!bVisible && stage != null) stage.removeEventListener(MouseEvent.MOUSE_UP, onClick);
		}
		/**
		* Adds the Tab to ExtraTabs object.
		* @param mcTab Tab object to add to the list.
		* @see modules.chat.tabs.BxTab
		*/
		public function addTab(mcTab:MovieClip):void
		{
			if(aTabs.indexOf(mcTab) > -1) return;
			mcTab.addEventListener(BxTabCalling.TAB_CALLING_START, onTabCallingStart);
			mcTab.addEventListener(BxTabCalling.TAB_CALLING_STOP, onTabCallingStop);
			mcTab.extra = true;
			if(mcTab.calling) callingTabs++;
			mcContainer.addChild(mcTab);
			aTabs.splice(0, 0, mcTab);
			refreshTabs();
		}
		/**
		* Removes the Tab to ExtraTabs object.
		* @param mcTab Tab object to remove from the list.
		* @return Tab object itself or <code>null</code> if it's not in the list
		* @see modules.chat.tabs.BxTab
		*/
		public function popTab(mcTab:MovieClip):Object
		{
			var index:Number = aTabs.indexOf(mcTab);
			if(index <= -1) return null;
			aTabs.splice(index, 1);
			mcTab.removeEventListener(BxTabCalling.TAB_CALLING_START, onTabCallingStart);
			mcTab.removeEventListener(BxTabCalling.TAB_CALLING_STOP, onTabCallingStop);
			mcTab.extra = false;
			if(mcTab.calling) callingTabs--;
			mcContainer.removeChild(mcTab);
			refreshTabs();
			return mcTab;
		}
		/**
		* ExtraTabs object active status.
		*/
		public function set active(bolActive:Boolean):void
		{
			bActive = bolActive;
			refreshCalling();
			activeState = bActive;
		}
		
		private function set activeState(b:Boolean):void
		{
			this.mcActive.visible = bActiveState = b;
			alpha = b ? 1 : 0.6;
		}
		
		private function set callingTabs(i:Number):void
		{
			iCallingTabs = Math.min(aTabs.length, Math.max(i, 0));
			refreshCalling();
		}
		
		private function get callingTabs():Number
		{
			return iCallingTabs;
		}
		
		private function onTabCallingStart(event:Event):void
		{
			callingTabs++;
		}
		
		private function onTabCallingStop(event:Event):void
		{
			callingTabs--;
		}

		private function refreshCalling():void
		{
			if(!mcContainer.visible && iCallingTabs > 0) tTimer.start();
			else tTimer.stop();
		}
		/**
		* @private
		*/
		public function refreshActive():void
		{
			active = mcContainer.visible || aTabs.some(isTabActive);
		}
		/**
		* @private
		*/
		override public function get width():Number
		{
			return this.mcBack.width;
		}

		private function refreshTabs():void
		{
			mcContainer.x = this.mcBack.width - mcContainer.width;
			var iY:Number = 0;
			for(var i:Number=0; i<aTabs.length; i++)
			{
				aTabs[i].y = iY;
				iY += aTabs[i].height;
			}
			refreshActive();
		}
		/**
		* Extra Tabs number.
		*/
		public function get length():Number
		{
			return aTabs.length;
		}
	}
}