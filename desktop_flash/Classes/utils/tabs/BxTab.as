package utils.tabs
{
	import controls.MovieClipContainer;
	import flash.events.*;
	import flash.display.*;
	import flash.text.TextField;
	import utils.*;

	/**
	* Dispatched when the Tab is activated.
	*/
	[Event(name="tabActive", type="flash.events.Event")]
	/**
	* Dispatched when the Tab is hidden.
	*/
	[Event(name="tabPassive", type="flash.events.Event")]
	/**
	* Dispatched when the Tab's "Close" button is pressed. Provokes Tabs manager to remove the Tab.
	*/
	[Event(name="tabClose", type="flash.events.Event")]
	
	/**
	* Base Tab class. Mainly used for switching on/off ChatPane objects.
	* @see modules.chat.chat.BxChatPane
	*/
	dynamic public class BxTab extends MovieClipContainer
	{
		/**
		* @private
		*/
		public static const 
			TAB_MIN_WIDTH:Number = 80,
			TAB_MAX_WIDTH:Number = 150,
			TAB_DEF_WIDTH:Number = 100,
			TAB_CLOSE:String = "tabClose",
			TAB_ACTIVE:String = "tabActive",
			TAB_PASSIVE:String = "tabPassive";

		private var 
			bExtra:Boolean = false,
			iBtnCloseShiftX:Number = 0;
		/**
		* @private
		*/
		protected var
			bClosable:Boolean, bActive:Boolean = false,
			mcOwner:Object;
		/**
		* @private
		*/
		function BxTab(objOwner:Object = null)
		{
			bClosable = this.btnClose != null;
			mcOwner = objOwner;
			if(bClosable)
			{
				iBtnCloseShiftX += width - this.btnClose.x;
				this.btnClose.addEventListener(MouseEvent.CLICK, onClose);
			}			
			this.mcActive.mouseEnabled = false;
			this.mcBack.addEventListener(MouseEvent.CLICK, onActive);
		}
		/**
		* @private
		*/
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			active = bActive;
			if(bClosable) root.mcHint.attach(this.btnClose, root.oLanguage.getString("hintClose", "Close"));
			root.mcHint.attach(this.mcBack, root.oLanguage.getString("hintTabActivate", "Activate"));
		}
		/**
		* Tab type. Base property for all tabs. Your custom tabs should define this property.
		*/
		public function get type():String {return "";}
		/**
		* Tab owner. Some main object (room, user or anything else) that you should assign to your custom Tabs.
		*/
		public function get owner():Object {return mcOwner;}
		/**
		* @private
		*/
		public function set owner(oOwner:Object):void {mcOwner = oOwner;}
		/**
		* Tab active event type. An event with this type is dispatched when the Tab becomes active.
		* Your custom tabs should define this property.
		*/
		public function get activeEvent():String {return "";}
		/**
		* @private
		*/
		protected function onClose(event:Event):void
		{
			close(event);
		}
		/**
		* Closes the Tab. Provokes dispatching <code>tabClose</code> event.
		*/
		public function close(event:Event = null):void
		{
			trace("CLOSE TAB", this.name);
			dispatchEvent(new Event(TAB_CLOSE));
		}
		private function onActive(event:Event):void
		{
			active = true;
		}
		/**
		* The Tab active status.
		* @example The following example sets the custom Tab object as active:
		* <listing>var mcTab = new CustomTab();<br>root.mcTabs.addTab(mcTab);<br>mcTab.active = true;</listing>
		*/
		public function set active(bolActive:Boolean):void
		{
			trace("tab active", this, bolActive, mcOwner.title);
			bActive = bolActive;
			this.mcActive.visible = bActive;
			this.mcBack.enabled = this.mcBack.mouseEnabled = !bActive;
			alpha = bActive ? 1 : 0.6;
			BxStyle.changeTextFormat(this.txtCaption, root.mcStyle[bActive ? "TabActiveCaption" : "TabPassiveCaption"]);
			dispatchEvent(new Event(bActive ? TAB_ACTIVE : TAB_PASSIVE));
		}
		/**
		* @private
		*/
		public function get active():Boolean
		{
			return bActive;
		}
		/**
		* The Tab width.
		*/
		override public function set width(iWidth:Number):void
		{
			super.width = this.mcActive.width = iWidth;
			var iX:Number = width - iBtnCloseShiftX;
			this.txtCaption.width = iX - this.txtCaption.x;
			if(bClosable) this.btnClose.x = iX;
		}
		/**
		* Defines whether the Tab is currently an extra Tab (displayed in Extra Tabs list).
		* @see modules.chat.tabs.BxExtraTabs
		*/
		public function set extra(bolExtra:Boolean):void
		{
			bExtra = bolExtra;
			if(bExtra)
			{
				width = TAB_DEF_WIDTH;
				x = 0;
			}
		}
		/**
		* @private
		*/
		public function get extra():Boolean
		{
			return bExtra;
		}
		
		/**
		* @private
		*/
		public function get calling():Boolean
		{
			return false;
		}
	}
}