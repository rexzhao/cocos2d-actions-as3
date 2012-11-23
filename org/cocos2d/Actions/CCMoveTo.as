package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCMoveTo extends CCActionInterval {
		private var endPosition_:CCPoint;
		private var startPosition_:CCPoint;
		protected var delta_:CCPoint;

		public function CCMoveTo(t:Number, p:CCPoint = null) {
			super(t);
			if(p == null) {
				p = new CCPoint(0,0);
			}
			endPosition_ = new CCPoint(p.x, p.y);
		}

		public function ccpSub(v1:CCPoint, v2:CCPoint) : CCPoint {
			return new CCPoint(v1.x - v2.x, v1.y - v2.y);
		}

		public static function  actionWithDuration(duration:Number, position:CCPoint) : CCMoveTo {
			return new CCMoveTo(duration, position);
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			startPosition_ = new CCPoint(target.x, target.y); //[(CCNode*)target_ position];
			delta_ = ccpSub(endPosition_, startPosition_);
		}

		override public function update(dt:Number) : void {
			target.x = startPosition_.x + delta_.x * dt;
			target.y = startPosition_.y + delta_.y * dt;
		}
	}
}
