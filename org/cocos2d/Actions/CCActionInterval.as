package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCActionInterval extends CCFiniteTimeAction {
		private var elapsed_:Number;
		private var firstTick_:Boolean;

		/** how many seconds had elapsed since the actions started to run. */
		//@property (nonatomic,readonly) ccTime elapsed;
		public function get elapsed() : Number {
			return elapsed_;
		}

		public function CCActionInterval(d:Number = 0) {
			duration_ = d;

			// prevent division by 0
			// This comparison could be in step:, but it might decrease the performance
			// by 3% in heavy based action games.
			if( duration_ == 0 )
				duration_ = 0.01;
			elapsed_ = 0;
			firstTick_ = true;
		}

		public static function actionWithDuration(d:Number) : CCActionInterval {
			return new CCActionInterval(d);
		}

		/** returns YES if the action has finished */
		//-(BOOL) isDone;
		override public function isDone() : Boolean {
			return (elapsed_ >= duration_);
		}

		private function MIN(v1:Number, v2:Number) : Number {
			return ((v1>v2) ? v2 : v1);
		}

		//-(void) step: (ccTime) dt
		override public function step(dt:Number) : void {
			//WriteLog("CCActionInterval::step " + dt);
			if (firstTick_) {
				firstTick_ = false;
				elapsed_ = 0;
			} else {
				elapsed_ += dt;
			}

			update(MIN(1, elapsed_/duration_));
		}


		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			elapsed_ = 0.0;
			firstTick_ = true;
		}

		override public function reverse() : CCActionInterval {
			Assert(false, "CCIntervalAction: reverse not implemented.");
			return null;
		}
	}
}
