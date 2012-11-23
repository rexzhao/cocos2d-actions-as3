package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCMoveBy extends CCMoveTo {
		public function CCMoveBy(t:Number, p:CCPoint) {
			super(t);
			delta_ = p;
		}

		public static function actionWithDuration(t:Number, position:CCPoint) : CCMoveBy {
			return new CCMoveBy(t, position);
		}

		override public function startWithTarget(aTarget:*) : void {
			var dTmp:CCPoint = new CCPoint(delta_.x, delta_.y);
			super.startWithTarget(aTarget);
			delta_ = dTmp;
		}

		override public function reverse() : CCActionInterval {
			return new CCMoveBy(duration_, new CCPoint(-delta_.x, -delta_.y));
		}
		
	}
}
