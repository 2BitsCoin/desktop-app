package message
{
	import flash.utils.Timer;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import utils.BxStyle;
	
	/**
	 * Used to show tooltips for different controls (buttons as a rule)
	 */
	dynamic public class BxHint extends Sprite
	{
		private const iShowInterval:Number = 2000;
		private const iAppearInterval:Number = 500;
		private var
			aControls:Array = new Array(),
			aHints:Array = new Array(),
			tAppearTimer:Timer,
			tTimer:Timer;
		protected var
			iMargin:Number = 5,
			aArrows:Array = new Array(),
			aAligns:Array = new Array(),
			oControl:Object;
		
		/**
		* @private
		*/
		function BxHint()
		{
			visible = false;
			tTimer = new Timer(iShowInterval);
			tTimer.addEventListener("timer", hide);
			tAppearTimer = new Timer(iAppearInterval);
			tAppearTimer.addEventListener("timer", show);
			this.mouseEnabled = this.mcBack.mouseEnabled = this.mcLeft.mouseEnabled = 
			this.mcRight.mouseEnabled = this.txtCaption.mouseEnabled = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			BxStyle.changeTextFormat(this.txtCaption, root.mcStyle.HintText);			
		}

		/**
		 * Adds a tooltip for specified control. 
		 * <code>MouseEvent.ROLL_OVER</code> is listened to provoke a tooltip displaying.
		 * @param oControl Control element <code>(Button, MovieClip)</code>
		 * @param sHint Text that will be shown as a tooltip
		 * @example The following example adds a tooltip to <code>btn</btn> Button:
		 * <listing>var btn:SimpleButton = new SimpleButton();<br>root.addChild(btn);<br>root.mcHint.attach(btn, "Click me");</listing>
		 */
		public function attach(oControl:Object, sHint:String, iArrow:Number = 10, iAlign:Number = -1):void
		{
			oControl.addEventListener(MouseEvent.ROLL_OVER, showStart);
			var index:Number = aControls.indexOf(oControl);
			if(index > -1)
			{
				aControls[index] = oControl;
				aHints[index] = sHint;
				aArrows[index] = iArrow;
				aAligns[index] = iAlign;
			}
			else
			{
				aControls.push(oControl);
				aHints.push(sHint);
				aArrows.push(iArrow);
				aAligns.push(iAlign);
			}
		}
		
		/**
		 * Removes a tooltip from specified control. <code>attach</code> method should be used before this one.
		 * <code>MouseEvent.ROLL_OVER</code> is stopped to listen for specified control element.
		 * @param oControl Control element <code>(Button, MovieClip)</code>
		 * @example The following example adds a tooltip to <code>btn</btn> Button:
		 * <listing>root.mcHint.detach(btn);</listing>
		 * @see attach
		 */
		public function detach(oControl:Object):void
		{
			oControl.removeEventListener(MouseEvent.ROLL_OVER, showStart);
			var index:Number = aControls.indexOf(oControl);
			if(index > -1)
			{
				aControls.splice(index, 1);
				aHints.splice(index, 1);
				aArrows.splice(index, 1);
				aAligns.splice(index, 1);
			}
		}
		
		private function showStart(event:Event):void
		{
			tAppearTimer.start();
			oControl = event.target;
			oControl.addEventListener(MouseEvent.ROLL_OUT, hide);
		}
		
		protected function show(event:Event):Number
		{
			tAppearTimer.stop();
			visible = false;

			var index:Number = aControls.indexOf(oControl);
			if(index == -1) return -1;
			
			caption = aHints[index];
			var rRect = oControl.getBounds(root);
			x = rRect.topLeft.x + (aAligns[index] < 0 ? rRect.width / 2 : aAligns[index]);
			y = rRect.topLeft.y - height - this.mcLeft.height + Math.min(iMargin, rRect.height / 2);
			if(aArrows[index] >= 0)
			{
				this.mcLeft.visible = true;
				this.mcLeft.x = aArrows[index];
				x -= this.mcLeft.getBounds(this).topLeft.x;
			}
			else
			{
				this.mcRight.visible = true;
				this.mcRight.x = this.mcBack.width + aArrows[index];
				x -= this.mcRight.getBounds(this).bottomRight.x;
			}
			visible = true;
			tTimer.start();
			return index;
		}

		private function hide(event:Event = null):void
		{
			oControl.removeEventListener(MouseEvent.ROLL_OUT, hide);
			tAppearTimer.stop();
			tTimer.stop();
			this.visible = false;
		}
		
		private function set caption(sCaption:String):void
		{
			this.txtCaption.text = sCaption;
			this.txtCaption.autoSize = TextFieldAutoSize.LEFT;
			this.mcBack.width = this.txtCaption.width + this.txtCaption.x * 2;
		}
		
		override public function set visible(bMode:Boolean):void
		{
			super.visible = bMode;
			if(!bMode) this.mcLeft.visible = this.mcRight.visible = false;
		}
		
		override public function get height():Number
		{
			return this.mcBack.height;
		}
	}
}