package controls
{
	import flash.geom.Rectangle;
	import flash.display.*;
	import flash.ui.Mouse;
	import flash.events.*;
	
	/**
	 * Vertical ScrollBar control.
	 */
	dynamic public class BxScrollBar extends Sprite
	{
		/**
		* @private
		*/
		protected var 
			bIsUp:Boolean = true, bUseArrows:Boolean = true, bScrollingEnabled:Boolean = true, bVertical:Boolean = true,
			sDimension:String = "height", sPosition:String = "y", sMouse:String = "mouseY",
			iDelayCounter:Number, iSize:Number = 100, iMinScrollerSize:Number = 10,
			iScrollerStep:Number = 2, iTopRange:Number, iBottomRange:Number, 
			iScrollPressedDelay:Number = 5, iScrollingObjectLimit:Number;
		/**
		 * ScrollBar scrolling target object (object defining scrolling area).
		 */
		public var oScrollingTarget:Object;
		/**
		 * ScrollBar scrolling object (object that is being scrolled).
		 */
		public var oScrollingObject:Object;
	
		/**
		* @private
		*/
		function BxScrollBar()
		{
			oScrollingTarget = (oScrollingTarget == null) ? this : oScrollingTarget;
			setScrollingTarget(oScrollingObject, oScrollingTarget);
			this.scroller.useHandCursor = this.upArrow.useHandCursor = this.downArrow.useHandCursor = this.track.useHandCursor = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}		
		private function onAddToStage(event:Event):void
		{
			setSize(iSize);
		}
		
		/**
		* Initialize scrollBar
		* @param limit scrolling object area limit
		*/
		public function initScrollBar(iLimit:Number):void
		{
			iScrollingObjectLimit = iLimit;
			bScrollingEnabled = (oScrollingObject[sDimension] > iScrollingObjectLimit);
			if(bScrollingEnabled)
			{
				this.scroller[sDimension] = Math.round((iBottomRange - iTopRange) * iScrollingObjectLimit / oScrollingObject[sDimension]);
				this.scroller[sDimension] = (this.scroller[sDimension] > iMinScrollerSize) ? this.scroller[sDimension] : iMinScrollerSize;
				updateScrollerPosition();
				
				this.scroller.visible = this.upArrow.visible = this.downArrow.visible = true;

				this.addEventListener("mouseWheel", onMouseWheel);
				this.scroller.addEventListener(MouseEvent.MOUSE_DOWN, onScrollerPress);
				initTrackScrolling();
				initArrowsScrolling();
			}
			else disableScrolling();
		}		
		
		private function onMouseWheel(event:MouseEvent):void
		{
			bIsUp = (event.delta > 0);
			mouseMoveScroller(bIsUp);
		}
		
		private function onScrollerPress(event:MouseEvent):void
		{
			var rRect:Rectangle = bVertical
				? new Rectangle(this.scroller.x, iTopRange, 0, iBottomRange - this.scroller[sDimension])
				: new Rectangle(iTopRange, this.scroller.y, iBottomRange - this.scroller[sDimension], 0);
			this.scroller.startDrag(false, rRect);
			this.addEventListener(Event.ENTER_FRAME, updateScrollingObjectPosition);
			stage.addEventListener(MouseEvent.MOUSE_UP, onScrollerRelease);
		}
		
		private function onScrollerRelease(event:MouseEvent):void
		{
			this.scroller.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME, updateScrollingObjectPosition);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onScrollerRelease);
		}
		
		private function initTrackScrolling():void
		{
			var oSelf:Object = this;
			var iDelayCounter:Number = 0;
	
			this.track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackPress);
			this.track.addEventListener(MouseEvent.CLICK, onTrackRelease);
			this.track.addEventListener(MouseEvent.MOUSE_OUT, onTrackRelease);
		}
		
		private function onTrackPress(event:MouseEvent = null):void
		{
			bIsUp = (this[sMouse] < this.scroller[sPosition]);
			moveScroller(bIsUp, true);
			this.addEventListener(Event.ENTER_FRAME, onTrackPressing);
		}
		
		private function onTrackPressing(event:Event):void
		{
			iDelayCounter++;
			if(iDelayCounter > iScrollPressedDelay)
				moveScroller(bIsUp, true);
		}

		private function onTrackRelease(event:MouseEvent = null):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onTrackPressing);
			iDelayCounter = 0;
		}

		private function initArrowsScrolling():void
		{
			this.upArrow.visible = this.upArrowOff.visible = this.downArrow.visible = this.downArrowOff._visible = bUseArrows;
			var oSelf:Object = this;
			if(bUseArrows)
			{
				this.upArrow.addEventListener(MouseEvent.MOUSE_DOWN, onUpArrow);
				this.downArrow.addEventListener(MouseEvent.MOUSE_DOWN, onDownArrow);
			}
		}
		
		private function onUpArrow(event:MouseEvent = null):void
		{
			arrowPress(this.upArrow, true);
		}
		
		private function onDownArrow(event:MouseEvent = null):void
		{
			arrowPress(this.downArrow, false);
		}
		
		private function arrowPress(arrow:SimpleButton, bolIsUp:Boolean):void
		{
			bIsUp = bolIsUp;
			moveScroller(bIsUp);
			iDelayCounter = 0;
			this.addEventListener(Event.ENTER_FRAME, onScrolling);
			arrow.addEventListener(MouseEvent.MOUSE_OUT, onArrowOut);
			arrow.addEventListener(MouseEvent.CLICK, onArrowOut);
		}
		
		private function onScrolling(event:Event):void
		{
			iDelayCounter++;
			if(iDelayCounter > iScrollPressedDelay)	moveScroller(bIsUp);
		}
		
		private function onArrowOut(event:MouseEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onScrolling);
			iDelayCounter = 0;
		}
	
		private function moveScroller(bolIsUp:Boolean, bIsPage:Boolean = false):void
		{
			if(bScrollingEnabled == false) return;
			
			var iShift:Number = (bIsPage) ? this.scroller[sDimension] : iScrollerStep;		
			iShift = bolIsUp ? iShift * (-1) : iShift;
			
			//do not cross cursor current y position
			if( (bolIsUp && this[sMouse] < this.scroller[sPosition]) || (!bolIsUp && this[sMouse] > this.scroller[sPosition] + this.scroller[sDimension]) )
				this.scroller[sPosition] += iShift;
			
			//do not cross scroll max(min) level
			if(bolIsUp) this.scroller[sPosition] = (this.scroller[sPosition] < iTopRange) ? iTopRange : this.scroller[sPosition];
			else this.scroller[sPosition] = (this.scroller[sPosition] + this.scroller[sDimension] >= iBottomRange) ? iBottomRange - this.scroller[sDimension] : this.scroller[sPosition];
			updateScrollingObjectPosition();
		}
		
		/**
		*	moves scroller from mouse wheel activity
		*	@param bIsUp - move scroller up/down - true/false
		*/
		private function mouseMoveScroller(bIsUp:Boolean):void
		{
			if(bScrollingEnabled == false || testScrollingTarget() == false) return;
			var iShift:Number = (bIsUp) ? -iScrollerStep : iScrollerStep;
			this.scroller[sPosition] += iShift;	
			this.scroller[sPosition] = (this.scroller[sPosition] < iTopRange) ? iTopRange : this.scroller[sPosition];
			this.scroller[sPosition] = (this.scroller[sPosition] + this.scroller[sDimension] >= iBottomRange) ? iBottomRange - this.scroller[sDimension] : this.scroller[sPosition];
			updateScrollingObjectPosition();
		}
		
		/**
		* Updates scrolling object position from scroller position
		*/
		public function updateScrollingObjectPosition(event:Event = null):void
		{
			this.scroller[sPosition] = (this.scroller[sPosition] < iTopRange) ? iTopRange : this.scroller[sPosition];
			this.scroller[sPosition] = (this.scroller[sPosition] + this.scroller[sDimension] > iBottomRange) ? iBottomRange - this.scroller[sDimension] : this.scroller[sPosition];
			oScrollingObject[sPosition] = Math.round(-1 * oScrollingObject[sDimension] * (this.scroller[sPosition] - iTopRange) / (iBottomRange - iTopRange));
		}
		
		/**
		* Updates scroller position from scrolling object position
		*/
		public function updateScrollerPosition():void
		{
			this.scroller[sPosition] = Math.round(-1 * (iBottomRange - iTopRange) * oScrollingObject[sPosition] / oScrollingObject[sDimension]) + iTopRange;
		}
		
		/**
		*	tests if this scrollbar is waiting for mouse wheel scrolling
		*	@return - true/false
		*/
		private function testScrollingTarget():Boolean
		{
			if(oScrollingTarget.mouseX < 0 || oScrollingTarget.mouseX > oScrollingTarget.width || 
			   oScrollingTarget.mouseY < 0 || oScrollingTarget.mouseY > oScrollingTarget.height)
				return false;
				
			return true;
		}
		
		/**
		*	sets scrolling target object for mouse wheel management
		*	@param scrollingObject - scrolling object
		*	@param scrollingTarget - scrolling target object
		*/
		private function setScrollingTarget(scrollingObject:Object, scrollingTarget:Object):void
		{
			oScrollingObject = scrollingObject;
			oScrollingTarget = scrollingTarget;
		}
		
		/**
		* Sets the ScrollBar size to passed value
		*/	
		public function setSize(intSize:Number):void
		{
			iSize = intSize;
			this.track[sDimension] = iSize;
			this.downArrow[sPosition] = this.downArrowOff[sPosition] = iSize - this.downArrow[sDimension];
			iTopRange = bUseArrows ? this.upArrow[sDimension] : 0;
			iBottomRange = bUseArrows ? this.downArrow[sPosition] : iSize;
		}
		
		/**
		*	disables scrolling
		*/	
		private function disableScrolling():void
		{
			this.removeEventListener("mouseWheel", onMouseWheel);
			this.track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackPress);
			this.track.removeEventListener(MouseEvent.CLICK, onTrackRelease);
			this.track.removeEventListener(MouseEvent.MOUSE_OUT, onTrackRelease);
			this.upArrow.removeEventListener(MouseEvent.MOUSE_DOWN, onUpArrow);
			this.downArrow.removeEventListener(MouseEvent.MOUSE_DOWN, onDownArrow);
			bScrollingEnabled = this.scroller.visible = this.upArrow.visible = this.downArrow.visible = false;
		}
	}
}