package utils.tabs
{
	import flash.events.*;
	import flash.display.*;
	import controls.MovieClipContainer;
	import utils.BxXmlEvent;
	
	/**
	* Tabs area class. Manages all tabs.
	*/
	dynamic public class BxTabs extends MovieClipContainer
	{
		public static const 
			TAB_ADDED:String = "onTabAdded",
			TABS_EMPTY:String = "onTabsEmpty";

		private const iPadding:Number = 2;
		private var 
			iCurrent:Number = 0,
			aTabs:Array = new Array();

		/**
		* Currently active Tab or null if there are no tabs at all.
		*/
		public function get current():Object
		{
			return aTabs[iCurrent];
		}
				
		/**
		* @private
		*/
		protected function getTabByOwner(mcOwner:Object):Object
		{
			for(var i:Number=0; i<aTabs.length; i++)
				if(aTabs[i].owner == mcOwner)
					return aTabs[i];
			return null;
		}
		/**
		* Adds custom tab to Tabs area and makes it active.
		* @param mcTab Custom tab object. Should contain all properties and methods as in <code>BxTab</code> class.
		* @return The Tab object itself.
		* @see modules.chat.tabs.BxTab
		* @example The following example adds custom tab to Tabs area.
		* <listing>var mcTab = new CustomTab();<br>root.mcTabs.addTab(mcTab);</listing>
		*/
		public function addTab(mcTab:Object):Object
		{
			if(!contains(mcTab))
			{
				mcTab.addEventListener(BxTab.TAB_ACTIVE, onTabActive);
				mcTab.addEventListener(BxTab.TAB_CLOSE, onTabClose);
				aTabs.push(mcTab);
				this.addChild(mcTab);
				refreshTabs();
				dispatchEvent(new BxXmlEvent(TAB_ADDED, mcTab));
			}
			mcTab.active = true;
			return mcTab;
		}
		
		protected function onTabActive(event:Event):Object
		{
			var mcTab:Object = event.target;
			var index:Number = aTabs.indexOf(mcTab);
			if(iCurrent != index)
			{
				aTabs[iCurrent].active = false;
				iCurrent = index;
			}
			this.mcExtraTabs.refreshActive();
			dispatchEvent(new BxXmlEvent(BxTab.TAB_ACTIVE, mcTab));
			return mcTab;
		}
		
		private function onTabClose(event:Event):void
		{
			var mcTab:Object = event.target;
			mcTab.removeEventListener(BxTab.TAB_ACTIVE, onTabActive);
			mcTab.removeEventListener(BxTab.TAB_CLOSE, onTabClose);
			var index:Number = aTabs.indexOf(mcTab);
			if(index > -1)
			{
				aTabs.splice(index, 1);
				if(iCurrent > index) iCurrent--;
				if(index == iCurrent)
				{
					if(aTabs.length > 0 && iCurrent == aTabs.length) iCurrent--;
					if(aTabs[iCurrent] != null) aTabs[iCurrent].active = true;
				}
			}
			dispatchEvent(new BxXmlEvent(BxTab.TAB_CLOSE, mcTab));
			if(mcTab.extra) this.mcExtraTabs.popTab(mcTab);
			else this.removeChild(mcTab);
			refreshTabs();
			if(aTabs.length == 0) dispatchEvent(new Event(TABS_EMPTY));
		}
		/**
		* Tabs area width.
		*/
		override public function set width(iWidth:Number):void
		{
			super.width = iWidth;
			refreshTabs();
		}
		
		private function refreshTabs(event:Event = null):void
		{
			var iTabsCount:Number = aTabs.length;
			var iTabsWidth:Number = width - (iTabsCount + 1)*iPadding;
			var iTabWidth:Number = Math.min(iTabsWidth/iTabsCount, BxTab.TAB_MAX_WIDTH);
			iTabsWidth -= this.mcExtraTabs.width + iPadding;
			while(iTabWidth < BxTab.TAB_MIN_WIDTH)
			{
				iTabsCount--;
				iTabsWidth += iPadding;
				this.mcExtraTabs.addTab(aTabs[iTabsCount]);
				iTabWidth = iTabsWidth / iTabsCount;
			}
			
			var iX:Number = iPadding;
			for(var i:Number=0; i<iTabsCount; i++)
			{
				if(aTabs[i].extra)
				{
					this.mcExtraTabs.popTab(aTabs[i]);
					this.addChild(aTabs[i]);
				}
				aTabs[i].y = 0;
				aTabs[i].x = iX;
				aTabs[i].width = iTabWidth;
				iX += aTabs[i].width + iPadding;
			}
			this.mcExtraTabs.x = iX;
			this.mcExtraTabs.visible = this.mcExtraTabs.length > 0;
			this.mcExtraTabs.refreshActive();
		}
	}
}