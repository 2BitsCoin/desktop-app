package message
{
	import flash.utils.Timer;
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * Used to show tooltips for different controls (buttons as a rule)
	 */
	dynamic public class BxHintComplex extends BxHint
	{
		/**
		* @private
		*/
		function BxHintComplex()
		{
			super()
			this.mcLeftUp.mouseEnabled = this.mcRightUp.mouseEnabled = false;
		}
	
		override protected function show(event:Event):Number
		{
			var index = super.show(event);
			if(y >= 0 || index == -1) return;

			visible = false;
			if(aArrows[index] >= 0) this.mcLeftUp.visible = true;
			else
			{
				this.mcRightUp.visible = true;
				this.mcRightUp.x = this.mcRight.x;
			}
			
			var rRect = oControl.getBounds(root);
			y = rRect.bottomRight.y + this.mcLeftUp.height - Math.min(iMargin, rRect.height / 2);
			visible = true;
			return index;
		}
		
		override public function set visible(bMode:Boolean):void
		{
			super.visible = bMode;
			if(!bMode) this.mcLeftUp.visible = this.mcRightUp.visible = false;
		}
	}
}