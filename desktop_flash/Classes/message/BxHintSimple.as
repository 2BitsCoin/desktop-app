package message
{
	import flash.utils.Timer;
	import flash.display.*;
	import flash .events.*;
	import flash.text.*;
	import utils.BxStyle;
	
	/**
	 * Used to show tooltips for different controls (buttons as a rule)
	 */
	dynamic public class BxHintSimple extends Sprite
	{
		private const iShowInterval:Number = 2000;
		private var
			aControls:Array, aHints:Array,
			tTimer:Timer;
		
		/**
		* @private
		*/
		function BxHintSimple()
		{
			aHints = new Array();
			aControls = new Array();
			visible = false;
			tTimer = new Timer(iShowInterval);
			tTimer.addEventListener("timer", hide);
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
		public function attach(oControl:Object, sHint:String):void
		{
			oControl.addEventListener(MouseEvent.ROLL_OVER, show);
			var index:Number = aControls.indexOf(oControl);
			if(index > -1)
			{
				aControls[index] = oControl;
				aHints[index] = sHint;
			}
			else
			{
				aControls.push(oControl);
				aHints.push(sHint);
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
			oControl.removeEventListener(MouseEvent.ROLL_OVER, show);
			var index:Number = aControls.indexOf(oControl);
			if(index > -1)
			{
				aControls.splice(index, 1);
				aHints.splice(index, 1);
			}
		}
		
		private function show(event:Event):void
		{
			var oControl:Object = event.target;
			var index:Number = aControls.indexOf(oControl);
			if(index == -1) return;
			
			oControl.addEventListener(MouseEvent.MOUSE_OUT, hide);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			caption = aHints[index];
			onMove();
			visible = true;
			tTimer.start();
		}

		private function hide(event:Event):void
		{
			var oControl:Object = event.target;
			oControl.removeEventListener(MouseEvent.MOUSE_OUT, hide);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			visible = false;
			tTimer.stop();
		}

		private function onMove(event:Event = null):void
		{
			var iY:Number = parent.mouseY - height - 2;
			y = iY > 0 ? iY : parent.mouseY + 2;
			var iX:Number = Math.min(parent.mouseX, parent.width - width - 2);
			x = iY <= 0 && iX < parent.mouseX ? parent.mouseX - width : iX;
		}
		
		private function set caption(sCaption:String):void
		{
			this.txtCaption.text = sCaption;
			this.txtCaption.autoSize = TextFieldAutoSize.LEFT;
			this.mcCenter.width = this.txtCaption.width;
			this.mcRight.x = this.mcCenter.x + this.txtCaption.width;
		}
	}
}