package dialogs
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;

	dynamic public class BxConfirm extends BxAlert
	{
		private var
			sMethod:String,
			oHandler:Object;
			
		/**
		* @private
		*/
		override protected function onLanguage(event:Event):void
		{
			super.onLanguage(event);
			caption = root.oLanguage.getString("dlgConfirm", "Confirmation");
		}
		/**
		* Initializes the Confirmation window with passed message
		* @param sMessage Message to display
		* @param objHandler Object that should receive a confirmation responce
		* @param strMethod Method name in <code>objHandler</code> that should handle a responce.
		* A boolean value is passed to <code>strMethod</code>.
		*/
		override public function init(sMessage:String, objHandler:Object = null, strMethod:String = ""):void
		{
			super.init(sMessage);
			oHandler = objHandler;
			sMethod = strMethod;
		}

		/**
		* @private
		*/
		override protected function apply(event:Event):void
		{
			super.apply(event);
			oHandler[sMethod](true);
		}

		/**
		* Closes the Confirmation window and passes <code>false</code> to the handler
		*/
		override public function close(event:Event = null):void
		{
			super.close(event);
			oHandler[sMethod](false);
		}
	}
}