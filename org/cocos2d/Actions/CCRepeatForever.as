package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCRepeatForever extends CCFiniteTimeAction {
		private var innerAction_:CCActionInterval;

		/** Inner action */
		//@property (nonatomic, readwrite, retain) CCActionInterval *innerAction;
		public function get innerAction() : CCActionInterval {
			return innerAction_;
		}

		public function set innerAction(action:CCActionInterval) : void {
			innerAction_ = action;
		}

		public function CCRepeatForever(action:CCActionInterval) {
			innerAction_ = action;
		}

		public static function actionWithAction(action:CCActionInterval) : CCRepeatForever {
			return new CCRepeatForever(action);
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			innerAction_.startWithTarget(target_);
		}

		override public function step(dt:Number) : void {
			innerAction_.step(dt);
			if(innerAction_.isDone()) {
				var diff:Number = dt + innerAction_.duration - innerAction_.elapsed;
				innerAction_.startWithTarget(target_);

				// to prevent jerk. issue #390
				innerAction_.step(diff);
			}
		}

		override public function isDone() : Boolean {
			return false;
		}

		//public function reverse() : CCFiniteTimeAction {
		//	return CCRepeatForever.actionWithAction(innerAction_.reverse() as CCActionInterval);
		//}
	}
}
