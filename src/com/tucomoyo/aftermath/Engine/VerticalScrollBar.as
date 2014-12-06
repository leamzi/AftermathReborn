package com.tucomoyo.aftermath.Engine 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class VerticalScrollBar extends Sprite{
		
		public var line:Quad;
		public var bar:Quad;
		public var bar_orientation:int;
		public var total_size:int;
		public var bar_size:Number;
		public var window_size:int;
		public var scrolling:Number;
		public var bar_press:Boolean=false;
		public var press_point:Number;
		
		public function VerticalScrollBar():void {
			// constructor code
			super();
			bar = new Quad(0, 0, 0xffffff);
			total_size = 0;
		}
		public function create_scrollBar(_orientation:int, _window_size:int, _size:int):void {
			bar_orientation=_orientation;
			total_size=_size;
			window_size=_window_size;
			scrolling=(Number)(_size)/(Number)(_window_size);
			bar_size=_window_size/scrolling;
			
			
			if(_orientation==0){
				
				
			}
			else{
				line = new Quad(30, _window_size, 0xffffff);
				line.alpha = 0.3;
				
				bar = new Quad(30, bar_size, 0xffffff);
				
				
			}
			removeChildren();
			addChild(line);
			addChild(bar);
			
		}//end create_scrollbar
		
		public function removeScroll():void {
		
			removeChild(line);
			removeChild(bar);
		}
		
		public function scrollBar_onMouseDown(py:Number):void {
			press_point=py;
			bar_press=true;
		}//end scrollBar_onMouseDown
		
		public function scrollBar_onMouseMove(by:Number):int{
			bar.y+=(by-press_point);
			press_point = by;
			//bar.y=by-(bar.height/2);
			if(bar.y<0)bar.y=0;
			if(bar.y>(window_size-bar.height))bar.y=window_size-bar.height;
			return -1*(bar.y*scrolling);
		}//end scrollBar_onMouseMove
		
		public function scrollBar_onMouseUp():void {
			bar_press=false;
		}//end scrollBar_onMouseUp
		
	}
}