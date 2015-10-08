package dialogs
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.MouseEvent;
	
	/**
	 * Dialog class is used as a super class for System Message
	 * @see message.BxSystemMessage
	 */
	dynamic public class BxDialog extends Sprite
	{
		/**
		* @private
		*/
		function BxDialog()
		{
			this.mcDisabled.alpha = 0;
			visible = false;
			locate();
		}
		
		/**
		* @private
		* set dialog message
		* @param sMessage
		* @param iWidth - message width
		* @param iHeight - message height
		*/
		protected function setMessage(sMessage:String, iWidth:Number, iHeight:Number):void
		{
			iWidth = isNaN(iWidth) ? this.mcBackGround.width : iWidth;
			iHeight = isNaN(iHeight) ? this.mcBackGround.height : iHeight;
	
			this.txtMessage.text = "";
			this.txtMessage.autoSize = TextFieldAutoSize.CENTER;
			this.txtMessage.text = sMessage;
			this.txtMessage.width = iWidth;
			this.txtMessage.x = this.mcBackGround.x + (this.mcBackGround.width - iWidth) / 2;
			this.txtMessage.y = this.mcBackGround.y + (iHeight - this.txtMessage.height) / 2;		
		}
		
		/**
		* Locates the Dialog object centering to passed values
		* @param iWidth Dialog area width
		* @param iHeight Dialog area height
		*/
		public function locate(iWidth:Number = 0, iHeight:Number = 0):void
		{
			x = y = 0;
			if(iWidth == 0) iWidth = parent.width;
			if(iHeight == 0) iHeight = parent.height;

			this.mcDisabled.width = iWidth;
			this.mcDisabled.height = iHeight;
	
			var iShiftX:Number = (this.mcDisabled.width - this.mcBackGround.width) / 2 - this.mcBackGround.x;
			var iShiftY:Number = (this.mcDisabled.height - this.mcBackGround.height) / 2 - this.mcBackGround.y;
	
			locateElements(iShiftX, iShiftY);
		}
	
		/**
		* Locates the Dialog centering to given target
		* @param oTarget Some object that should be the main one for the Dialog
		*/
		public function locateByTarget(oTarget:Object):void
		{
			var oPoint:Object = {x: 0, y: 0};
			oTarget.localToGlobal(oPoint);
	
			var iShiftX:Number = oPoint.x + (oTarget.width - this.mcBackGround.width) / 2 - this.mcBackGround.x;
			var iShiftY:Number = oPoint.y + (oTarget.height - this.mcBackGround.height) / 2 - this.mcBackGround.y;
	
			locateElements(iShiftX, iShiftY);
		}
		
		/**
		*	locate elements
		*	@param iShiftX
		*	@param iShiftY
		*/
		private function locateElements(iShiftX:Number, iShiftY:Number):void
		{
			for(var i:Number=0; i<this.numChildren; i++)
			{
				var mc:Object = this.getChildAt(i);
				mc.x += iShiftX;
				mc.y += iShiftY;
			}
			this.mcDisabled.x = this.mcDisabled.y = 0;
		}
	
		/**
		* Gets the Dialog active state
		* @return true for active state / false for passive
		*/
		public function getStatus():Boolean
		{
			return this.visible;
		}
	}
}