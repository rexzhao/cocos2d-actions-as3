package org.cocos2d.Actions
{

	public class CCActionEase extends CCActionInterval {
		protected var other:CCActionInterval;

		protected var M_PI_X_2:Number = M_PI * 2.0;

		public static function actionWithAction(action:CCActionInterval) : CCActionEase {
			return CCActionEase(action);
		}

		public function CCActionEase(action:CCActionInterval) {
			Assert( action != null, "Ease: arguments must be non-nil");
			super(action.duration);
			other = action;
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			other.startWithTarget(target_);
		}

		override public function stop() : void {
			other.stop();
			super.stop();
		}

		override public function update(t:Number) : void {
			other.update(t);
		}

		override public function reverse() : CCActionInterval {
			return new CCActionEase(other.reverse());
		}
	}
}
