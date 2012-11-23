package org.cocos2d
{
	import flash.geom.Point;
	public class CCSize extends Point {
		public function CCSize(w:Number = 0, h:Number = 0) {
			super(w, h);
		}

		public function get width() : Number {
			return x;
		}

		public function get height() : Number {
			return y;
		}
	};
}
