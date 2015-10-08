package modules.desktop
{
	import flash.display.*;
	import flash.text.TextField;
	import flash.external.ExternalInterface;
	
	public class BxLanguageDesktop
	{
		public function getString(sKey:String, sDefault:String = ""):String
		{
			var sReturn:String = ExternalInterface.call("getLanguageString", sKey, sDefault);
			return sReturn;
		}
		
		public function setButtonCaption(btn:SimpleButton, sCaption:String):void
		{
			setButtonStateText(btn.upState, sCaption);
			setButtonStateText(btn.overState, sCaption);
			setButtonStateText(btn.downState, sCaption);
		}
		
		private function setButtonStateText(mcState:DisplayObject, sText:String):void
		{
			if(!(mcState is DisplayObjectContainer)) return;
			for(var i:Number=0; i<mcState.numChildren; i++)
			{
				var mcChild:Object = mcState.getChildAt(i);
				if(mcChild is TextField) mcChild.text = sText;
			}
		}
	}
}