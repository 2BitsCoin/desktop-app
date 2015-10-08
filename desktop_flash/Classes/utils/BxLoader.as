package utils
{
	import flash.display.*;
	import flash.events.Event;
	
	dynamic public class BxLoader extends MovieClip
	{
		public static const PLAY_MIDDLE:String = "onPlayMiddle";
		private var 
			iCurrent:Number = 0;
	
		/*
		*	object constructor
		*/
		function BxLoader()
		{
			for(var i=0; i<numChildren; i++)
			{
				var mc = getChildAt(i);
				if(mc is MovieClip)	mc.addEventListener(PLAY_MIDDLE, startNext);
			}
			stop();
			startNext();
		}
		
		public function locate()
		{
			x = (stage.stageWidth - width) / 2;
			y = (stage.stageHeight - height) / 2;			
		}
		
		/*
		*	start next object blinking
		*/
		private function startNext(event:Event = null)
		{
			iCurrent = this["mcDot" + iCurrent] is MovieClip ? iCurrent : 0;
			this["mcDot" + iCurrent].play();
			iCurrent++;
		}
		
		override public function stop():void
		{
			for(var i=0; i<numChildren; i++)
			{
				var mc = getChildAt(i);
				if(mc is MovieClip) mc.gotoAndStop(1);
			}
		}
	}
}