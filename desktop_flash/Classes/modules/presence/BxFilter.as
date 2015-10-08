package modules.presence
{
	import flash.events.*;
	import flash.text.*;
	import utils.*;
	import controls.BxPopupList;

	dynamic public class BxFilter extends BxPopupList
	{
		public static const FILTER_CLICK:String = "onFilterClick";
		private var 
			bOnlineEnable:Boolean = false,
			aSexes:Array;
		
		function BxFilter()
		{
			super();
			bEnabled = true;
			this.txtFilter.mouseEnabled = false;
			this.txtAgeFrom.restrict = this.txtAgeTo.restrict = "0-9";
			this.txtAgeFrom.maxChars = this.txtAgeTo.maxChars = 2;
			
			this.chbSex.addEventListener(Event.SELECT, onSexSelect);
			this.mcFilter.addEventListener(Event.SELECT, onFilterSelect);			
			sexSelected = false;
		}
		
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			root.mcUsers.addEventListener(BxUser.SEX_DEFINED, onSexDefined);
			root.mcUsers.addEventListener(BxUsers.ONLINE_ACTIVE, onOnlineActive);
			BxStyle.changeTextFormat(this.txtFilter, root.mcStyle.FilterText);
			BxStyle.changeTextFormat(this.txtSex, root.mcStyle.FilterText);
			BxStyle.changeTextFormat(this.txtAgeFromCaption, root.mcStyle.FilterText);
			BxStyle.changeTextFormat(this.txtAgeToCaption, root.mcStyle.FilterText);
			BxStyle.changeTextFormat(this.txtOnline, root.mcStyle.FilterText);
			BxStyle.changeTextFormat(this.txtAgeFrom, root.mcStyle.FilterText, root.mcStyle.FilterTextBorder.textColor, root.mcStyle.FilterTextBack.textColor);
			BxStyle.changeTextFormat(this.txtAgeTo, root.mcStyle.FilterText, root.mcStyle.FilterTextBorder.textColor, root.mcStyle.FilterTextBack.textColor);
		}

		override protected function onLanguage(event:Event):void
		{
			var iFilterWidth = this.txtFilter.width;
			this.txtFilter.text = root.oLanguage.getString("txtFilter", "Filter");
			this.txtFilter.autoSize = TextFieldAutoSize.LEFT;
			var iShift = this.txtFilter.width - iFilterWidth;
			this.btnOpen.x -= iShift;
			this.btnOpen.width += iShift;
			this.mcFilter.x -= iShift;
			this.txtFilter.x -= iShift;
			this.txtSex.text = root.oLanguage.getString("txtFilterSex", "Filter by sex");
			this.txtAgeFromCaption.text = root.oLanguage.getString("txtAgeFrom", "Age from:");
			this.txtAgeToCaption.text = root.oLanguage.getString("txtAgeTo", "to:");
			this.txtOnline.text = root.oLanguage.getString("txtOnlineOnly", "Online only");
			this.txtAgeFromCaption.autoSize = this.txtAgeToCaption.autoSize = TextFieldAutoSize.LEFT;
			this.txtAgeFrom.x = this.txtAgeFromCaption.x + this.txtAgeFromCaption.width + 2;
			this.txtAgeToCaption.x = this.txtAgeFrom.x + this.txtAgeFrom.width + 2;
			this.txtAgeTo.x = this.txtAgeToCaption.x + this.txtAgeToCaption.width + 2;
			
			this.mcSex.init([]);
			aSexes = new Array();
		}
		
		private function onSexDefined(event:Event):void
		{
			var oSex:Object = event.data;
			if(aSexes.indexOf(oSex.value) > -1) return;
			aSexes.push(oSex.value);
			this.mcSex.add(oSex);
		}
		
		private function onOnlineActive(event:Event):void
		{
			bOnlineEnable = !event.data;
			active = bActive;
		}
		
		private function onSexSelect(event:Event):void
		{
			sexSelected = event.data;
		}
		
		private function onFilterSelect(event:Event):void
		{
			active = false;
			dispatchEvent(new Event(FILTER_CLICK));
		}
		
		public function get isFilter():Boolean
		{
			return this.mcFilter.selected;
		}
		
		private function set sexSelected(bMode:Boolean):void
		{
			this.mcSex.enabled = bMode;
			if(!bMode) this.mcSex.value = this.mcSex.caption = "";
		}
		
		public function get sex():String
		{
			return this.chbSex.selected ? this.mcSex.value : "";
		}
		
		public function get ages():Object
		{
			return {
				from: this.txtAgeFrom.text != "" && !isNaN(this.txtAgeFrom.text) ? Number(this.txtAgeFrom.text) : Number.NEGATIVE_INFINITY,
				to: this.txtAgeTo.text != "" && !isNaN(this.txtAgeTo.text) ? Number(this.txtAgeTo.text) : Number.POSITIVE_INFINITY
			};
		}
		
		public function get online():Boolean
		{
			return this.chbOnline.selected;
		}
		
		override protected function set active(bMode:Boolean):void
		{
			super.active = bMode;
			this.mcSex.visible = this.chbSex.visible = this.txtSex.visible = 
			this.txtAgeFromCaption.visible = this.txtAgeFrom.visible = this.txtAgeToCaption.visible = 
			this.txtAgeTo.visible = this.chbOnline.visible = this.txtOnline.visible = bMode;
			this.chbOnline.visible = this.txtOnline.visible = bOnlineEnable && bMode;
		}
		
		override protected function onClick(event:Event):void
		{
			if(!this.mcBack.hitTestPoint(root.mouseX, root.mouseY, true)) active = false;
		}
	}
}