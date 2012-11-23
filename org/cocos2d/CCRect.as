package org.cocos2d
{
	import flash.geom.Rectangle;
	public class CCRect extends Rectangle {
		public function CCRect(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) {
			super(x, y, width, height);
		}

		public function get origin() : CCPoint {
			return new CCPoint(x, y);
		}

		public function set origin(pt:CCPoint) : void {
			x = pt.x;
			y = pt.y;
		}

		//public function get size() : CCSize {
		//	return new CCSize(width, height);
		//}

		//override public function set size(s:CCSize) : void {
		//	width = s.width;
		//	height = s.height;
		//}
	};
}
