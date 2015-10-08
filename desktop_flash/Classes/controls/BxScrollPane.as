package controls
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.events.Event;

	/**
	* Dispatched when the ScrollPane object is being refreshed.
	*/
	[Event(name="onRefresh", type="flash.events.Event")]
	
	/**
	 * ScrollPane control is used to display objects with large sizes. 
	 * Comes with vertical and horizontal ScrollBars.
	 * @see BxScrollBar
	 */
	dynamic public class BxScrollPane extends MovieClip
	{
		/**
		* @private
		*/
		public static const EVENT_REFRESH:String = "onRefresh";
		private var 
			bVertical:Boolean, bHorizontal:Boolean, 
			bHideScrollBars:Boolean = false, bAlwaysShowScrollBar:Boolean = true,
			iScrollBarMargin:Number = 1, iScrollSpaceMargin:Number = 1,
			scrollWindow:Rectangle;
		/**
		* @private
		*/
		protected var bRightScroll:Boolean;
		/**
		 * ScrollPane width
		 */
		public var iWidth:Number;
		/**
		 * ScrollPane height
		 */
		public var iHeight:Number;
		/**
		 * ScrollPane background transparency
		 */
		public var iBGAlpha:Number = 1;
		/**
		 * ScrollPane inner holder MovieClip
		 */
		public var mcHolder:MovieClip;
		
		/**
		* @private
		*/
		function BxScrollPane()
		{
			iWidth = isNaN(iWidth) ? this.width : iWidth;
			iHeight = isNaN(iHeight) ? this.height : iHeight;
			
			mcHolder = this.scrollSpace.holder;
			this.scrollSpace.holder.src.alpha = 0;
			
			init(iScrollSpaceMargin);
			setBackGroundAlpha(iBGAlpha);
			refresh();	
		}
		
		/**
		* @private
		* Initializes the ScrollPane
		* @param scrollSpaceMargin ScrollPane margin (in pixels)
		* @param vertical use vertical scrollBar (true) or not (false)
		* @param horizontal use horizontal scrollBar (true) or not (false)
		*/
		public function init(scrollSpaceMargin:Number, vertical:Boolean = true, horizontal:Boolean = false, bolRightScroll:Boolean = true):void
		{
			iScrollSpaceMargin = !(scrollSpaceMargin is Number) ? iScrollSpaceMargin : scrollSpaceMargin;
			bVertical = vertical;
			bHorizontal = horizontal;
			bRightScroll = bolRightScroll;

			this.scrollBar.oScrollingObject = this.hScrollBar.oScrollingObject = this.scrollSpace.holder;
			this.scrollBar.oScrollingTarget = this.hScrollBar.oScrollingTarget = this;
			setSize(iWidth, iHeight);
		}
	
		/**
		* Sets size of ScrollPane
		* @param intWidth Scrollpane width (-1 will leave width unchanged)
		* @param intHeight Scrollpane height (-1 will leave height unchanged)
		*/
		public function setSize(intWidth:Number = -1, intHeight:Number = -1):void
		{
			iWidth = isNaN(intWidth) || intWidth == -1 ? iWidth : Math.floor(intWidth);
			iHeight = isNaN(intHeight) || intHeight == -1 ? iHeight : Math.floor(intHeight);
	
			var iScrollSpaceWidth:Number = iWidth - 2*iScrollSpaceMargin;
			var iScrollSpaceHeight:Number = iHeight - 2*iScrollSpaceMargin;
			this.scrollSpace.holder.src.width = iScrollSpaceWidth;
			this.scrollSpace.holder.src.height = iScrollSpaceHeight;
	
			var bScrollBarVisible:Boolean = bVertical && (this.scrollSpace.holder.height > iScrollSpaceHeight || bAlwaysShowScrollBar);
			iScrollSpaceWidth -= bScrollBarVisible ? getScrollBarWidth() : 0;
			var bHScrollBarVisible:Boolean = bHorizontal && (this.scrollSpace.holder.width > iScrollSpaceWidth || bAlwaysShowScrollBar);
			if(bHScrollBarVisible)
			{
				iScrollSpaceHeight -= getHScrollBarHeight();
				if(!bScrollBarVisible && bVertical)
				{
					bScrollBarVisible = (this.scrollSpace.holder.height > iScrollSpaceHeight);
					if(bScrollBarVisible)
						iScrollSpaceWidth -= getScrollBarWidth();
				}
			}
			this.scrollSpace.x = iScrollSpaceMargin + (bRightScroll ? 0 : getScrollBarWidth());
			this.scrollSpace.y = iScrollSpaceMargin;
			this.scrollBar.y = iScrollBarMargin;
			this.scrollBar.x = bRightScroll && bScrollBarVisible ? iWidth - getScrollBarWidth() : iScrollSpaceMargin;
			this.hScrollBar.x = iScrollBarMargin;
			this.hScrollBar.y = bHScrollBarVisible ? iHeight - getHScrollBarHeight() : 0;
			
			this.backGround.width = iWidth;
			this.backGround.height = iHeight;
			
			this.scrollBar.setSize(bHScrollBarVisible ? iHeight - iScrollBarMargin - getHScrollBarHeight() : iHeight - 2*iScrollBarMargin);
			this.hScrollBar.setSize(bScrollBarVisible ? iWidth - iScrollBarMargin - getScrollBarWidth() : iWidth - 2*iScrollBarMargin);
			
			if(bVertical)
			{
				this.scrollBar.initScrollBar(iScrollSpaceHeight);
				this.scrollBar.updateScrollingObjectPosition();
			}
			if(bHorizontal)
			{
				this.hScrollBar.initScrollBar(iScrollSpaceWidth);
				this.hScrollBar.updateScrollingObjectPosition();
			}
			this.scrollBar.visible = bScrollBarVisible && !bHideScrollBars;
			this.hScrollBar.visible = bHScrollBarVisible && !bHideScrollBars;
	
			if( (bScrollBarVisible && iScrollSpaceHeight >= this.scrollSpace.holder.height) || (bVertical && !bScrollBarVisible) )
				scrollTo(0);
			if( (bHScrollBarVisible && iScrollSpaceWidth >= this.scrollSpace.holder.width) || (bHorizontal && !bHScrollBarVisible) )
				scrollTo(undefined, 0);
	
			scrollWindow = null;
			this.scrollSpace.scrollRect = null;
			scrollWindow = new Rectangle(this.scrollSpace.x, this.scrollSpace.y, iScrollSpaceWidth, iScrollSpaceHeight);
			this.scrollSpace.scrollRect = scrollWindow;
		}
		
		/**
		* Scrolling area real height
		*/
		public function get scrollHeight():Number
		{
			return this.scrollSpace.holder.height;
		}
		/**
		* Shows (true) / hides (false) ScrollBars
		*/
		public function set showScrollBar(b:Boolean):void
		{
			bHideScrollBars = !b;
			refresh();
		}
		
		/**
		* Refreshes contents and scrollbars locations and sizes
		*/
		public function refresh():void
		{
			setSize();
			dispatchEvent(new Event(EVENT_REFRESH));
		}
		
		/**
		* Sets background transparency (0-1)
		*/
		public function setBackGroundAlpha(alpha:Number):void
		{
			this.backGround.alpha = (alpha < 1 && alpha >= 0) ? alpha : 1;
		}
		
		/**
		* Gets scrollSpace bounds
		* @return bounds object with <code>width</code> and <code>height</code> properties
		*/
		public function getScrollSpaceBounds():Object
		{
			return {width: this.scrollSpace.holder.src.width, height: this.scrollSpace.holder.src.height};
		}
		
		/**
		* Gets vertical scrollBar width
		*/
		public function getScrollBarWidth():Number
		{
			return this.scrollBar.width + iScrollBarMargin;
		}
		
		/**
		* Gets horizontal scrollBar height
		*/
		public function getHScrollBarHeight():Number
		{
			return this.hScrollBar.height + iScrollBarMargin;
		}
		
		/**
		* Scrolls to passed positions
		* @param yPosition Vertical position to scroll to. 
		* Scrolls to the bottom if <code>yPosition = undefined</code>
		* @param xPosition Horizontal position to scroll to. 
		* Scrolls to the most right position if <code>xPosition = undefined</code>
		*/
		public function scrollTo(yPosition:Number = undefined, xPosition:Number = undefined):void
		{
			if(bVertical)
			{
				yPosition = isNaN(yPosition) ? getBottomPosition() : -1 * yPosition;
				var iBottom:Number = getBottomPosition();
				this.scrollSpace.holder.y = (yPosition < iBottom) ? iBottom : yPosition;
				this.scrollSpace.holder.y = (yPosition > 0) ? 0 : this.scrollSpace.holder.y;
				this.scrollBar.updateScrollerPosition();
			}
			if(bHorizontal)
			{
				xPosition = isNaN(xPosition) ? getRightPosition() : -1 * xPosition;
				var iRight:Number = getRightPosition();
				this.scrollSpace.holder.x = (xPosition < iRight) ? iRight : xPosition;
				this.scrollSpace.holder.x = (xPosition > 0) ? 0 : this.scrollSpace.holder.x;
				this.hScrollBar.updateScrollerPosition();
			}
		}
		
		/**
		* Gets bottom position
		*/
		public function getBottomPosition():Number
		{
			var oBounds:Object = getScrollSpaceBounds();
			var iBottom:Number = (this.scrollSpace.holder.height > oBounds.height) ? oBounds.height - this.scrollSpace.holder.height : 0;
			return iBottom;
		}
		
		/**
		* Gets rigth position
		*/
		public function getRightPosition():Number
		{
			var oBounds:Object = getScrollSpaceBounds();
			var iRight:Number = (this.scrollSpace.holder.width > oBounds.width) ? oBounds.width - this.scrollSpace.holder.width : 0;
			return iRight;
		}
	}
}