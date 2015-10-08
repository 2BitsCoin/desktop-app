package controls
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import controls.BxRadioButton;
	import utils.*;
	import controls.MovieClipContainer;	
	
	/**
	* Dispatched when the width of the Select Element changes, 
	* used by Select control to change it's width
	* @see BxSelect
	*/
	[Event(name="change", type="flash.events.Event")]
	/**
	* Dispatched when the Select Element is selected
	* <code>data</code> property is set to object 
	* with <code>value</code> and <code>caption</code> properties of the Select Element
	*/
	[Event(name="select", type="utils.BxXmlEvent")]

	/**
	 * Select Element for DropDown Select control.
	 * @see BxSelect
	 */
	dynamic public class BxSelectElement extends MovieClipContainer
	{
		private var
			sValue:String, sCaption:String;
			
		/**
		* @private
		*/
		function BxSelectElement()
		{
			this.txtCaption.mouseEnabled = false;
			this.mcBack.buttonMode = true;
			this.mcBack.addEventListener(MouseEvent.MOUSE_DOWN, select);
		}
		
		/**
		* Initializes Select Element
		* @param strValue value of the Select Element
		* @param strCaption caption of the Select Element 
		* (if <code>strCaption == ""</code> value will be used as caption)
		*/
		public function init(strValue:String, strCaption:String = ""):void
		{
			sValue = strValue;
			var iWidth:Number = this.txtCaption.width;
			caption = strCaption == "" ? sValue : strCaption;
			this.txtCaption.autoSize = TextFieldAutoSize.LEFT;
			if(iWidth < this.txtCaption.width)
			{
				this.mcBack.width = this.txtCaption.width;
				dispatchEvent(new Event(Event.CHANGE));
			}
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		/**
		* @private
		*/
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			BxStyle.changeTextFormat(this.txtCaption, root.mcStyle.SelectElementCaption);
		}

		private function select(event:Event):void
		{
			dispatchEvent(new BxXmlEvent(Event.SELECT, {value: sValue, caption: sCaption}));
		}

		override public function set width(iWidth:Number):void
		{
			this.mcBack.width = this.txtCaption.width = iWidth;
		}
		/**
		* Gets value of the Select Element
		*/
		public function get value():String
		{
			return sValue;
		}
		/**
		* @private
		*/
		public function get caption():String
		{
			return sCaption;
		}
		override public function set caption(strCaption:String):void
		{
			super.caption = sCaption = strCaption;
			this.txtCaption.autoSize = TextFieldAutoSize.LEFT;
		}
	}
}