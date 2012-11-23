package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCAnimate extends CCActionInterval {
		public var animation_:CCAnimation;
		public var origFrame_:*;
		public var restoreOriginalFrame_:Boolean;

		private var _name:String;
		private static var _idx:uint = 0;

		public static function actionWithDuration(d:Number, animation:CCAnimation, restoreOriginalFrame:Boolean) : CCAnimate {
			return new CCAnimate(animation, restoreOriginalFrame, d);
		}


		public static function actionWithAnimation(animation:CCAnimation, restoreOriginalFrame:Boolean = true) : CCAnimate {
			return new CCAnimate(animation, restoreOriginalFrame);
		}

		public function CCAnimate(anim:CCAnimation, restoreOriginalFrame:Boolean = true, d:Number = NaN) {
			_name = "Animate:" + _idx++;

			if (isNaN(d)) {
				d = anim.frames.length * anim.delay;
			}
			super(d);

			restoreOriginalFrame_ = restoreOriginalFrame;
			animation_ = anim;
			origFrame_ = null;
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			var sprite:CCSprite = target_ as CCSprite;
			if (sprite == null) {
				throw Error("CCAnimate::startWithTarget error target");
			}
			origFrame_ = null;

			if( restoreOriginalFrame_ ) {
				origFrame_ = sprite.displayFrame;
			}
		}

		override public function stop() : void {
			if(restoreOriginalFrame_) {
				var sprite:CCSprite = target_;
				if (sprite) {
					sprite.setDisplayFrame(origFrame_);
				}
			}
			super.stop();
		}

		private var last_t:Number  = 0;
		private var total_t:Number = 0;

		override public function update(t:Number) : void {
			total_t += t;
			if (total_t - last_t > 1 ) {
				//WriteLog(_name + " update " + target_.toString() + " " + target_.stag);
				last_t = total_t;
			}


			var frames:Array = animation_.frames;
			var numberOfFrames:uint = frames.length;

			var idx:uint = t * numberOfFrames;

			if(idx >= numberOfFrames)
				idx = numberOfFrames - 1;

			//WriteLog("CCAnimate::update " + idx);

			var sprite:CCSprite = target_;
			if (!sprite.isFrameDisplayed(frames[idx])) {
				sprite.setDisplayFrame(frames[idx]);
			}
		}
	}
}
