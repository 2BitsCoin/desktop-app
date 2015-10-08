package modules.presence
{
	import flash.events.*;
	import controls.MovieClipContainer;
	import utils.BxStyle;

	dynamic public class BxTab extends MovieClipContainer
	{
		function BxTab()
		{
			this.mcBack.mouseEnabled = false;
			this.btnBack.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:Event):void
		{
			active = true;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function set active(bActive:Boolean):void
		{
			this.btnBack.visible = !bActive;
			BxStyle.changeTextFormat(this.txtCaption, root.mcStyle[bActive ? "TabActiveCaption" : "TabPassiveCaption"]);
		}
		
		public function get active():Boolean
		{
			return !this.btnBack.visible;
		}

		override public function set width(iWidth:Number):void
		{
			super.width = this.txtCaption.width = this.btnBack.width = iWidth;
		}
	}
}