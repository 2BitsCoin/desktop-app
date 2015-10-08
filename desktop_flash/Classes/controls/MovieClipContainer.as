package controls
{
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * A simple object that has a <code>mcBack MovieClip</code> being resized by changing 
	 * <code>width</code> and <code>height</code> properties. 
	 * No other childs of this object are being resized.
	 * Also this object should contain <code>txtCaption TextField text</code> value 
	 * of which is changed by changing <code>caption</code> property.
	 */
	dynamic public class MovieClipContainer extends MovieClip
	{
		/**
		* @private
		*/
		function MovieClipContainer()
		{
			if(this.txtCaption != null) this.txtCaption.mouseEnabled = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		/**
		 * @private
		 */
		protected function onAddToStage(event:Event):void{}
		
		override public function get width():Number
		{
			return this.mcBack.width;
		}

		/**
		 * @private
		 */
		override public function set width(iWidth:Number):void
		{
			this.mcBack.width = iWidth;
		}

		override public function get height():Number
		{
			return this.mcBack.height;
		}

		/**
		 * @private
		 */
		override public function set height(iHeight:Number):void
		{
			this.mcBack.height = iHeight;
		}
		/**
		 * Object caption
		 */
		public function set caption(sCaption:String):void
		{
			this.txtCaption.text = sCaption;
		}
	}
}