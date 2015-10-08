package controls
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.*;
	import controls.BxRadioButton;
	import utils.BxXmlEvent;
	import utils.BxStyle;
	import utils.BxList;
	import controls.*;	

	/**
	* Dispatched when the value of the Select control is changed 
	* after selecting different Select Element
	* @see BxSelectElement#value
	*/
	[Event(name="change", type="utils.BxXmlEvent")]

	/**
	 * DropDown Select control.
	 */
	dynamic public class BxSelect extends MovieClipContainer
	{
		private var
			iInitHeight:Number,
			iMaxWidth:Number = 0,
			sValue:String = "",
			aElements:BxList;
			
		/**
		* @private
		*/
		function BxSelect()
		{
			this.mcArrow.mouseEnabled = false;
			this.btnDown.addEventListener(MouseEvent.CLICK, open);
			aElements = new BxList();
			aElements.setHolder(this.mcPane, this.mcBack.width, this.mcBack.height, 0);
			iInitHeight = this.mcPane.scrollHeight;
		}
		/**
		* @private
		*/
		override protected function onAddToStage(event:Event):void
		{
			listShown = false;
			BxStyle.changeTextFormat(this.txtCaption, root.mcStyle.SelectCaption);
		}
		
		override public function set enabled(bMode:Boolean):void
		{
			super.enabled = this.btnDown.mouseEnabled = bMode;
		}
		/**
		 * Resets available options for the Select control
		 * @param aData array with initialization data
		 * @param bUseCaptions defines whether <code>aData</code> should contain objects 
		 * with <code>value, caption</code> properties or just <code>strings</code>
		 * @example The following example will initialize Select control with objects
		 * <listing>var aOptions:Array = new Array({value:"value1", caption:"caption1"}, {value:"value2", caption:"caption2"});<br>mcSelect.init(aOptions, true);</listing>
		 * The following example will initialize Select control with simple strings
		 * <listing>var aOptions:Array = new Array("value1", "value2");<br>mcSelect.init(aOptions, false);</listing>
		 */
		public function init(aData:Array, bUseCaptions:Boolean = false):void
		{
			aElements.clear();
			if(aData.length <= 0) return;
			if(iMaxWidth > 0)
			{
				iMaxWidth += this.mcPane.getScrollBarWidth() + 2;
				width = iMaxWidth;
			}
			for(var i:Number=0; i<aData.length; i++)
				add(aData[i]);
			caption = aElements.elements[0].caption;
			value = aElements.elements[0].value;
			updateHeight();
			dispatchEvent(new BxXmlEvent(Event.CHANGE, value));
		}
		
		public function add(aElement:Object, bBegin:Boolean = false):Object
		{
			var mcElement:Object = generateElement();
			mcElement.addEventListener(Event.CHANGE, onChangeWidth);
			mcElement.addEventListener(Event.SELECT, onChangeValue);
			if(aElement.hasOwnProperty("value") && aElement.hasOwnProperty("caption"))
				mcElement.init(aElement.value, aElement.caption);
			else mcElement.init(aElement);
			aElements.add(mcElement, bBegin);
			if(iMaxWidth > 0) mcElement.width = iMaxWidth;
			if(bBegin) updateHeight();
			return mcElement;
		}
		
		public function edit(strValue:String, sNewCaption:String):void
		{
			var oElement:Object = aElements.getByKey("value", strValue);
			if(oElement == null) return;
			oElement.caption = sNewCaption;
			if(sValue == strValue) caption = sNewCaption;
		}
		
		public function remove(strValue:String):void
		{
			var oElement:Object = aElements.getByKey("value", strValue);
			if(oElement == null) return;
			aElements.removeByKey("value", strValue);
			if(sValue == strValue)
			{
				if(aElements.length == 0) value = caption = "";
				else setValue(aElements.elements[0]);
			}
			updateHeight();
		}
		
		private function updateHeight():void
		{
			var iElementsHeight:Number = aElements.elementsHeight;
			var bShowScrollBar:Boolean = iInitHeight - iElementsHeight < 5;
			var iHeight:Number = bShowScrollBar ? iInitHeight : iElementsHeight + 3;
			this.mcBack.height = iHeight;
			if(aElements.length > 1) this.mcPane.setSize(-1, iHeight);
			this.mcPane.showScrollBar = bShowScrollBar;
		}
		
		/**
		* @private
		*/
		protected function generateElement():Object
		{
			return new BxSelectElement();
		}
		
		private function open(event:Event):void
		{
			listShown = true;
		}
		
		private function set listShown(bMode:Boolean):void
		{
			this.mcBack.visible = this.mcPane.visible = bMode;
			if(stage == null) return;
			if(bMode) stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			else stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
		}
		
		private function onStageClick(event:Event):void
		{
			var oPoint:Object = localToGlobal(new Point(mouseX, mouseY));
			if(!this.mcBack.hitTestPoint(oPoint.x, oPoint.y, false))
				listShown = false;
		}
		
		private function onChangeWidth(event:Event):void
		{
			var mcElement:Object = event.target;
			if(mcElement.width > iMaxWidth)
			{
				iMaxWidth = mcElement.width;
				width = iMaxWidth + this.mcPane.getScrollBarWidth();
			}
		}
		
		private function onChangeValue(event:Event):void
		{
			var aData:Object = event.data;
			setValue(aData);
		}
		
		public function changeValue(strValue:String):void
		{
			for(var i=0; i<aElements.length; i++)
				if(aElements.elements[i].value == strValue)
				{
					setValue(aElements.elements[i]);
					break;
				}
		}
		
		private function setValue(oElement:Object):void
		{
			if(oElement.value == sValue)
			{
				listShown = false;
				return;
			}
			caption = oElement.caption;
			value = oElement.value;
			dispatchEvent(new BxXmlEvent(Event.CHANGE, oElement.value));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set caption(sCaption:String):void
		{
			super.caption = sCaption;
			value = sCaption;
			var iShift:Number = this.txtCaption.textWidth + 4 - this.txtCaption.width;
			if(iShift > 0) width += iShift;
		}
		/**
		 * Current value of the Select control
		 */
		public function get value():String
		{
			return sValue;
		}
		/**
		* @private
		*/
		public function set value(strValue:String):void
		{
			sValue = strValue;
			listShown = false;
		}
		/**
		 * Control width
		 */
		override public function set width(iWidth:Number):void
		{
			var iShiftX:Number = iWidth - this.btnDown.width;
			this.mcBack.width = this.btnDown.width = iWidth;			
			this.mcArrow.x += iShiftX;
			this.txtCaption.width += iShiftX;
			this.mcPane.setSize(iWidth);
		}
		/**
		 * @private
		 */
		override public function get height():Number
		{
			return this.btnDown.height;
		}
	}
}