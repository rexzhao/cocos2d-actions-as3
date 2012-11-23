package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCRotateBy extends CCActionInterval {
		private var angle_:Number;
		private var startAngle_:Number;

		public function CCRotateBy(d:Number, angle:Number) {
			super(d);
			angle_ = angle;
		}

		public static function actionWithDuration(d:Number, angle:Number) : CCRotateBy {
			return new CCRotateBy(d, angle);
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			startAngle_ = target_.rotation;
		}

		override public function update(t:Number) : void {
			target_.rotation = startAngle_ + angle_ * t;
		}

		override public function reverse() : CCActionInterval {
			return actionWithDuration(duration_, -angle_);
		}
	}
}
