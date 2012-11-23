package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCJumpBy extends CCActionInterval {
		protected var startPosition_:CCPoint;
		protected var delta_:CCPoint;
		private var height_:Number;
		private var jumps_:uint;

		public function CCJumpBy(d:Number, pos:CCPoint, height:Number, jumps:uint) {
			super(d);
			delta_ = new CCPoint(pos.x, pos.y);
			height_ = height;
			jumps_ = jumps;
		}

		public static function actionWithDuration(d:Number, pos:CCPoint, height:Number, jumps:uint) : CCJumpBy {
			return new CCJumpBy(d, pos, height, jumps);
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			startPosition_ = new CCPoint(target_.x, target_.y);
		}

		override public function update(t:Number) : void {
			// Sin jump. Less realistic
			// ccTime y = height * fabsf( sinf(t * (CGFloat)M_PI * jumps ) );
			// y += delta.y * t;
			// ccTime x = delta.x * t;
			// [target setPosition: ccp( startPosition.x + x, startPosition.y + y )];	

			// parabolic jump (since v0.8.2)
			var frac:Number = fmodf(t * jumps_, 1.0);
			var y:Number = height_ * 4 * frac * (frac - 1);
			y += delta_.y * t;
			var x:Number = delta_.x * t;
			target_.x = startPosition_.x + x;
			target_.y = startPosition_.y + y;
		}

		override public function reverse() : CCActionInterval {
			return actionWithDuration(duration_, new CCPoint(-delta_.x, -delta_.y), height_, jumps_);
		}
	}
}
