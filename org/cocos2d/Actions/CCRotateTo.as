package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCRotateTo extends CCActionInterval {
		private var dstAngle_:Number;
		private var startAngle_:Number;
		private var diffAngle_:Number;

		public function CCRotateTo(d:Number, angle:Number) {
			super(d);
			dstAngle_ = angle;
		}

		public static function actionWithDuration(d:Number, angle:Number) : CCRotateTo {
			return new CCRotateTo(d, angle);	
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);

			startAngle_ = target_.rotation;
			if (startAngle_ > 0)
				startAngle_ = fmodf(startAngle_, 360.0);
			else
				startAngle_ = fmodf(startAngle_, -360.0);

			diffAngle_ = dstAngle_ - startAngle_;
			if (diffAngle_ > 180)
				diffAngle_ -= 360;
			if (diffAngle_ < -180)
				diffAngle_ += 360;
		}

		override public function update(t:Number) : void {
			target_.rotation = startAngle_ + diffAngle_ * t;
		}
	}
}
