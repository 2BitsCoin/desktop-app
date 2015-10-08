package utils
{
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;

	public class BxStyle
	{
		/**
		*	change textformat of input textfield
		*	@param target - target format textfield
		*	@param sourceName - name of source format textfield
		*	@param iBorderColor - border color
		*	@param iBGColor - BG color
		*	@return tf - target textfield textformat
		*/
		public static function changeTextFormat(target:TextField, tfSource:Object, iBorderColor:Number = -1, iBGColor:Number = -1):TextFormat
		{
			if(tfSource == null) return null;
				
			var tf = (tfSource is TextField) ? tfSource.getTextFormat() : tfSource;
			if(target is TextField)
			{
				target.setTextFormat(tf);
				target.defaultTextFormat = tf;
				target.borderColor = isNaN(iBorderColor) || iBorderColor == -1 ? target.borderColor : iBorderColor;
				target.backgroundColor = isNaN(iBGColor) || iBGColor == -1 ? target.backgroundColor : iBGColor;
			}
			
			return tf;
		}

		public static function getHtmlText(sText:String, tfSource:Object, bIgnoreSize:Boolean = false):String
		{
			if(tfSource == null) return sText;
				
			var tf = (tfSource is TextField) ? tfSource.getTextFormat() : tfSource;
			if(tf.underline) sText = "<U>" + sText + "</U>";
			if(tf.italic) sText = "<I>" + sText + "</I>";
			if(tf.bold) sText = "<B>" + sText + "</B>";
			var sSize:String = bIgnoreSize ? "" : '" SIZE="' + tf.size;
			sText = '<FONT FACE="' + tf.font + sSize + '" COLOR="#' + tf.color.toString(16) + '">' + sText + '</FONT>';
			return sText;
		}

		/**
		*	format time string by given duration
		*	@param iDuration
		*	@param string
		*/
		public static function formatTime(iDuration:Number, bUseHours:Boolean = false):String
		{
			if(isNaN(iDuration)) return bUseHours ? "00:00:00" : "00:00";
			var iHours = Math.floor(iDuration / 3600);
			iDuration -= iHours * 3600;
			var iMinutes = Math.floor(iDuration / 60);
			var iSeconds = iDuration - iMinutes * 60;
			var sTime = "";
			if(bUseHours) sTime = (iHours < 10 ? "0" : "") + iHours.toString() + ":";
			sTime += (iMinutes < 10 ? "0" : "") + iMinutes.toString() + ":";
			sTime += (iSeconds < 10 ? "0" : "") + iSeconds.toString();
			return sTime;
		}
		
		/**
		*	get current time string by given template
		*	@return current time
		*/
		public static function getTimeString(sTimeTemplate:String = "", oDate:Date = null, bFullYear:Boolean = true):String
		{
			sTimeTemplate = sTimeTemplate == "" ? "#hours#:#minutes#" : sTimeTemplate;
			
			oDate = oDate == null ? new Date() : oDate;
			var iYear = oDate.getFullYear();
			if(!bFullYear)iYear = iYear % 100;
			var sYear = iYear < 10 ? "0" + iYear : iYear.toString();
			
			var iMonth = oDate.getMonth() + 1;
			var iDay = oDate.getDate();
			var iHours = oDate.getHours();
			var iMinutes = oDate.getMinutes();
			iMonth = (iMonth < 10) ? "0" + iMonth : iMonth;
			iDay = (iDay < 10) ? "0" + iDay : iDay;
			iHours = (iHours < 10) ? "0" + iHours : iHours;
			iMinutes = (iMinutes < 10) ? "0" + iMinutes : iMinutes;
			
			return sTimeTemplate.split("#year#").join(sYear).split("#month#").join(iMonth).split("#day#").join(iDay).split("#hours#").join(iHours).split("#minutes#").join(iMinutes);
		}
		
		/**
		*	replaces tags < and >
		*	@param sString - string to replace
		*	@return sString
		*/
		public static function replaceTags(sString:String):String
		{
			sString = sString.split("<").join("&lt;");
			sString = sString.split(">").join("&gt;");
			return sString;
		}
		
		/**
		*	replaces tags < and >
		*	@param sString - string to replace
		*	@return sString
		*/
		public static function setFloatingText(sText:String, txt:TextField, mc:Sprite, iScrollingDelay:Number = 10):Function
		{
			txt.text = sText;
			if(txt.textWidth + 4 > txt.width)
			{
				var iShift = 2, iCurrent = -iScrollingDelay;
				var onEnterFrame = function()
				{
					iCurrent += iShift;
					txt.scrollH = iCurrent;
					if(iCurrent >= txt.maxScrollH + iScrollingDelay || iCurrent <= -iScrollingDelay)
						iShift = -iShift;
				}
				mc.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				return onEnterFrame;
			}
			else
			{
				txt.scrollH = 0;
				return null;
			}
		}
	}
}