package utils
{
	import flash.events.Event;
	
	/**
	 * An extra event with an additional property <code>data</code> that contain any custom data object
	 */
	public class BxXmlEvent extends Event
	{
		private var aData:Object;
		
		/**
		* class constructor
		* @param type Event type
		* @param data Custom data object
		*/
		function BxXmlEvent(sType:String, arrData:Object)
		{
			super(sType);
			aData = arrData;
		}
		
		/**
		* An object defined in the class constructor
		* @return Custom data object
		*/
		public function get data():Object
		{
			return aData;
		}
	}
}