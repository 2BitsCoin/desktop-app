package message
{
	import utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.display.*;
	import flash.text.TextField;
	
	/**
	* Dispatched when the "Settings" button is pressed.
	*/
	[Event(name="onSettings", type="flash.events.Event")]
	/**
	* Dispatched when the "Help" button is pressed.
	*/
	[Event(name="onHelp", type="flash.events.Event")]

	/**
	* Used for Top Header object in Chat and Messenger.
	*/
	dynamic public class BxHeader extends BxSimpleHeader
	{
		/**
		* @private
		*/
		public static const 
			SETTINGS_PRESSED:String = "onSettings",
			HELP_PRESSED:String = "onHelp";
		private var
			iMargin:Number = 6, iPadding:Number = 2,
			aLeftButtons:Array = new Array(), aRightButtons:Array = new Array();
			
		/**
		* @private
		* class constructor
		*/
		function BxHeader()
		{
			if(this.btnSettings != undefined)
			{
				addButtonRight(this.btnSettings);
				this.btnSettings.addEventListener(MouseEvent.MOUSE_DOWN, onSettingsPress);
			}
			if(this.btnHelp != undefined)
			{
				addButtonRight(this.btnHelp);
				this.btnHelp.addEventListener(MouseEvent.MOUSE_DOWN, onHelpPress);
			}
		}
		/**
		* @private
		*/
		override protected function onLanguage(event:Event):void
		{
			super.onLanguage(event);
			if(this.btnHelp != undefined)
				root.mcHint.attach(this.btnHelp, root.oLanguage.getString("hintHelp", "Help"));
			if(this.btnSettings != undefined)
				root.mcHint.attach(this.btnSettings, root.oLanguage.getString("hintSettings", "Settings"));
		}
		/**
		* @private
		*/
		override protected function onConfig(event:Event):void
		{
			super.onConfig(event);
			if(root.free) addButtonLeft(this.btnBoonex);
		}
		/**
		* Adds custom button to the left edge of the Top Header. 
		* It's recommended to use buttons with size 16x16.
		* @param btn Cusom Button
		* @return The Button object itself
		*/
		public function addButtonLeft(btn:Object):Object
		{
			var btnPrevious:Object = aLeftButtons[aLeftButtons.length - 1];
			btn.x = btnPrevious == null ? iMargin : btnPrevious.x + btnPrevious.width + iPadding;
			addButton(btn);
			aLeftButtons.push(btn);
			return btn;
		}
		/**
		* Adds custom button to the right edge of the Top Header. 
		* It's recommended to use buttons with size 16x16.
		* @param btn Cusom Button
		* @return The Button object itself
		*/
		public function addButtonRight(btn:Object):Object
		{
			var btnPrevious:Object = aRightButtons[aRightButtons.length - 1];
			btn.x = btnPrevious == null ? this.mcBack.width - btn.width - iMargin : btnPrevious.x - btn.width - iPadding;
			addButton(btn);
			aRightButtons.push(btn);
			return btn;
		}

		private function addButton(btn:SimpleButton):void
		{
			btn.y = (this.mcBack.height - btn.height) / 2;
			if(!contains(btn)) addChild(btn);
		}
		
		private function onHelpPress(event:Event):void
		{
			dispatchEvent(new Event(HELP_PRESSED));
		}
		
		private function onSettingsPress(event:Event):void
		{
			dispatchEvent(new Event(SETTINGS_PRESSED));
		}
		/**
		* @private
		*/
		override public function set width(iWidth:Number):void
		{
			var iShift:Number = iWidth - this.mcBack.width;
			super.width = iWidth;
			for(var i:Number=0; i<aRightButtons.length; i++)
				aRightButtons[i].x += iShift;
		}
	}
}