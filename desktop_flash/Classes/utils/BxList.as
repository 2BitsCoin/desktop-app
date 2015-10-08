package utils
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;

	/*
	* Boonex system class. It's completely closed.
	*/
	dynamic public class BxList extends EventDispatcher
	{
		/**
		* @private
		*/
		public static const EVENT_REFRESH:String = "onRefreshList";
		private var 
			aElements:Array, //elements array
			mcPane:Object, //pane object
			oFilter:Object, //filter function
			bUseFilter:Boolean = false,//use filter
			bUseHolder:Boolean = false, //use holder for elements
			bUseNumbers:Boolean = false, //use numbers
			bCenter:Boolean = false, //align by center
			iCurrentElement:Number = 0, //current element counter
			iColumns:Number = 1, //columns number
			iPadding:Number = 0, //elements padding
			iMaxWidth:Number, //elements holder max width
			iLeftMargin:Number = 0, iTopMargin:Number = 0; //margins
		
		/**
		* @private
		*/
		function BxList()
		{
			aElements = new Array();
		}
		
		/**
		* @private
		*	set holder
		*	@param mcpPane
		*	@param strElementId
		*	@param width
		*	@param height
		*	@param iAlpha
		*	@param bShowScroll
		*/
		public function setHolder(mcpPane:Object, iWidth:Number, iHeight:Number, iAlpha:Number = 1):void
		{
			pane = mcpPane;
			mcPane.setSize(iWidth, iHeight);
			mcPane.iBGAlpha = iAlpha;
			mcPane.setBackGroundAlpha(iAlpha);
		}
		/*
		* @private
		*/
		public function set pane(oPane:Object):void
		{
			bUseHolder = true;
			mcPane = oPane;
		}
		
		/*
		* @private
		*/
		public function set center(bolCenter:Boolean):void
		{
			bCenter = bolCenter;
			refresh();
		}
	
		/*
		* @private
		*/
		public function set columns(intColumns:Number):void
		{
			iColumns = intColumns;
			refresh();
		}
	
		/*
		* @private
		*/
		public function set padding(intPadding:Number):void
		{
			iPadding = intPadding;
			refresh();
		}
		
		/*
		* @private
		*/
		public function set maxWidth(intMaxWidth:Number):void
		{
			iMaxWidth = intMaxWidth;
			refresh();
		}
		
		/*
		* @private
		*/
		public function set left(iLeft:Number):void
		{
			iLeftMargin = iLeft;
			refresh();
		}
	
		/*
		* @private
		*/
		public function set top(iTop:Number):void
		{
			iTopMargin = iTop;
			refresh();
		}
		
		/*
		* @private
		*/
		public function set numbers(bolUseNumbers:Boolean):void
		{
			bUseNumbers = bolUseNumbers;
			refresh();
		}
	
		/*
		* @private
		*/
		public function get elements():Array
		{
//			return oFilter == null ? aElements : aElements.filter(oFilter);
			return aElements;
		}
	
		/*
		* @private
		*/
		public function get length():Number
		{
//			return oFilter == null ? aElements.length : aElements.filter(oFilter).length;
			return aElements.length;
		}
	
		/*
		* @private
		*/
		public function set element(oElement:Object):void
		{
			add(oElement);
		}
		
		/*
		* @private
		*/
		public function add(oElement:Object, bBegin:Boolean = false):Object
		{
			if(bUseHolder)
			{
				mcPane.mcHolder.addChild(oElement);
				iCurrentElement++;
			}
			if(bBegin) aElements.splice(0, 0, oElement);
			else aElements.push(oElement);
			refresh();
			return oElement;
		}
		
		/*
		* @private
		*/
		public function remove(index:Number, bRefresh:Boolean = true):Object
		{
			var o:Object = null;
			if(index <= -1) return o;
			if(bUseHolder && aElements[index] != null && mcPane.mcHolder.contains(aElements[index]))
				o = mcPane.mcHolder.removeChild(aElements[index]);
			aElements.splice(index, 1);
			if(bRefresh) refresh();
			return o;
		}
		/*
		* @private
		*/
		public function removeObject(o:Object):Object
		{
			var index:Number = aElements.indexOf(o);
			if(index > -1) return remove(index);
			else return null;
		}

		/*
		* @private
		*/
		public function removeByKey(sKey:String, oValue:Object):Object
		{
			var index:Number = getByKey(sKey, oValue, true).index;
			return remove(index);
		}
		
		/*
		* @private
		*/
		public function clear():void
		{
			for(var i:Number=aElements.length-1; i>=0; i--)
				remove(i, false);
			refresh();
		}
		/*
		* @private
		*/
		public function setPosition(iFromIndex:Number, iToIndex:Number):void
		{
			if(aElements[iFromIndex] == null || aElements[iToIndex] == null) return;
			var aRemoved:Array = aElements.splice(iFromIndex, 1);
			aElements.splice(iToIndex, 0, aRemoved[0]);
			refresh();
		}
		
		/*
		* @private
		*/
		public function getByKey(sKey:String, oValue:Object, bGetIndex:Boolean = false):Object
		{
			for(var i:Number=0; i<aElements.length; i++)
				if(aElements[i][sKey] == oValue)
					return bGetIndex ? {object: aElements[i], index: i} : aElements[i];
			return bGetIndex ? {object: null, index: -1} : null;
		}
		
		/**
		*	sort elements
		*	@param aFields
		*	@param aSortingOptions
		*/
/*		function sort(aFields:Array, aSortingOptions:Array)
		{
			var aTemp = new Array();
			for(var i=0; i<aElements.length; i++)
			{
				var oTemp = new Object();
				oTemp.index = i;
				for(var j=0; j<aFields.length; j++)
				{
					var sField = aFields[j];
					oTemp[sField] = aElements[i][sField];
				}
				aTemp.push(oTemp);
			}
			aTemp.sortOn(aFields, aSortingOptions);
			
			var aNew = new Array();
			for(var i=0; i<aTemp.length; i++)
				aNew.push(aElements[aTemp[i].index]);
			aElements = aNew;
			
			refresh();
		}*/
		
		/**
		*	sort elements with given function
		*	@param fFunction
		*/
/*		function sortWith(fFunction:Function)
		{
			aElements = aElements.sort(fFunction);
			refresh();
		}*/
		
/*		function enableFilter(bMode:Boolean)
		{
			bUseFilter = bMode;
			refresh();
		}*/
		
		public function set filter(objFilter:Object)
		{
			oFilter = objFilter;
			refresh();
		}
		
		private function filterFunction(oElement:Object, index:Number, array:Array):Boolean
		{
			if(oFilter == null) return true;
			return oFilter.filter(oElement);
		}
		
/*		function filter(oElement:Object):Boolean
		{
			if(!bUseFilter) return true;
			else return this.oFilter.call(this, oElement);
		}*/
		
		/**
		*	tell all elements to call sMethod with aParams parameters
		*	@param sMethod
		*	@param aParams
		*/
/*		public function tell(sMethod:String, aParams:Array, aExcept:Array = [])
		{
			for(var i=0; i<aElements.length; i++)
			{
				var bTellHim = true;
				for(var j=0; j<aExcept.length; j++)
					if(aExcept[j] == aElements[i]){bTellHim = false; break;}
				if(bTellHim)aElements[i][sMethod].apply(aElements[i], aParams);
			}
		}*/
		/*
		* @private
		*/
		public function get elementsHeight():Number
		{
			var oLast:Object = aElements[aElements.length - 1];
			return oLast.y + oLast.height;
		}
		
		/*
		* @private
		*/
		public function refresh():void
		{
			if(!bUseHolder)	return;

			var aWorkingArray:Array = oFilter == null ? aElements : aElements.filter(filterFunction);
			if(aWorkingArray.length > 0)
			{
				var iElementWidth:Number = aWorkingArray[0].width;
				var iElementHeight:Number = aWorkingArray[0].height;

				var iColumnsWidth:Number, iTempColumns:Number = iColumns, iWidth:Number = mcPane.width;
				if(isNaN(iWidth))iWidth = mcPane.width;
				if(iWidth > iMaxWidth)iWidth = iMaxWidth;
////////////???????????
				while((iColumnsWidth = iTempColumns * iElementWidth + (iTempColumns - 1) * iPadding) && iColumnsWidth > iWidth && iTempColumns > 1)iTempColumns--;

				var initX:Number = iLeftMargin;
				if(bCenter)initX += (iWidth - iColumnsWidth) / 2;
				var xPos:Number = initX, yPos:Number = iTopMargin + iPadding;
				var aYPos:Array = new Array();
				for(var i:Number=0; i<iTempColumns; i++) aYPos.push(yPos);

				var iCurrentColumns:Number = 0;
		
				for(i=0; i<aWorkingArray.length; i++)
				{
					aWorkingArray[i].y = aYPos[iCurrentColumns];
					aWorkingArray[i].x = xPos;
					iElementWidth = aWorkingArray[i].width;
					iElementHeight = aWorkingArray[i].height;
					
					xPos += iElementWidth + iPadding;
					aYPos[iCurrentColumns] += iElementHeight + iPadding;
					iCurrentColumns++;
					if(/*xPos + iElementWidth > iWidth || */iCurrentColumns >= iTempColumns)
					{
						xPos = initX;
						iCurrentColumns = 0;
					}
					if(bUseNumbers) aWorkingArray[i].number = i + 1;
				}
			}
			mcPane.refresh();
			dispatchEvent(new Event(EVENT_REFRESH));
		}
	}
}