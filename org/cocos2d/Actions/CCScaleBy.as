package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCScaleBy extends CCScaleTo {
		public function CCScaleBy(d:Number, sX:Number, sY:Number = NaN) {
			super(d, sX, sY);
		}

		public static function actionWithDuration(d:Number, sX:Number, sY:Number = NaN) : CCScaleBy {
			return new CCScaleBy(d, sX, sY);
		}

		override public function startWithTarget(aTarget:*) :  void {
			super.startWithTarget(aTarget);
			deltaX_ = startScaleX_ * endScaleX_ - startScaleX_;
			deltaY_ = startScaleY_ * endScaleY_ - startScaleY_;
		}

		override public function reverse() : CCActionInterval {
			return actionWithDuration(duration_, 1/endScaleX_, 1/endScaleY_);
		}
	}
}
