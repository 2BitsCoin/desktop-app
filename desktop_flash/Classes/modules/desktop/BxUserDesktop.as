package modules.desktop
{
	import modules.presence.BxUser;
	import flash.external.ExternalInterface;

	/**
	* User object.
	*/
	dynamic public class BxUserDesktop extends BxUser
	{
		/**
		* @private
		*/
		function BxUserDesktop(aData:Object)
		{
			super(aData);
		}
		
		override protected function get ownerId():String
		{
			return root.initParams["owner"];
		}
		
		override protected function openUrl(sUrl:String):void
		{
			if(getTarget(sUrl) == "_self")
				 ExternalInterface.call("openUserWidget", sUrl);
			else ExternalInterface.call("openUrl", sUrl);
		}
	}
}