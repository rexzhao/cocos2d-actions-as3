package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCScaleTo extends CCActionInterval {
		protected var  scaleX_:Number;
		protected var  scaleY_:Number;
		protected var  startScaleX_:Number;
		protected var  startScaleY_:Number;
		protected var  endScaleX_:Number;
		protected var  endScaleY_:Number;
		protected var  deltaX_:Number;
		protected var  deltaY_:Number;

		public function CCScaleTo(d:Number, sX:Number, sY:Number = NaN) {
			super(d);
			endScaleX_ = sX;
			if (isNaN(sY)) {
				endScaleY_ = sX;
			} else {
				endScaleY_ = sY;
			}
		}

		public static function actionWithDuration(d:Number, sX:Number, sY:Number = NaN) : CCScaleTo {
			return new CCScaleTo(d, sX, sY);
		}

		override public function startWithTarget(aTarget:*) :  void {
			super.startWithTarget(aTarget);
			startScaleX_ = target_.scaleX;
			startScaleY_ = target_.scaleY;
			deltaX_ = endScaleX_ - startScaleX_;
			deltaY_ = endScaleY_ - startScaleY_;
		}

		override public function update(t:Number) : void {
			target_.scaleX = startScaleX_ + deltaX_ * t;
			target_.scaleY = startScaleY_ + deltaY_ * t;
		}
	}
}
