package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCReverseTime extends CCActionInterval {
		private var other_:CCFiniteTimeAction;

		public function CCReverseTime(action:CCFiniteTimeAction) {
			other_ = action;
		}

		public static function actionWithAction(action:CCFiniteTimeAction) : CCReverseTime {
			return new CCReverseTime(action);
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			other_.startWithTarget(target_);
		}

		override public function stop() : void {
			other_.stop();
			super.stop();
		}

		override public function update(t:Number) : void {
			other_.update(1-t);
		}
	}
}
