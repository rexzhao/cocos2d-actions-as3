package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCSpeed extends CCFiniteTimeAction {
		private var innerAction_:CCActionInterval;
		private var speed_:Number;

		/** alter the speed of the inner function in runtime */
		//@property (nonatomic,readwrite) float speed;
		public function get speed() : Number {
			return speed_;
		}

		public function set speed(s:Number) : void {
			speed_ = s;
		}

		/** Inner action of CCSpeed */
		//@property (nonatomic, readwrite, retain) CCActionInterval *innerAction;
		public function get innerAction() : CCActionInterval {
			return innerAction_;
		}

		public function set innerAction(action:CCActionInterval) : void {
			innerAction_ = action;
		}

		public function CCSpeed(action:CCActionInterval, speed_rate:Number) {
			innerAction_ = action;
			speed_ = speed_rate;
		}

		/** creates the action */
		public static function actionWithAction(action:CCActionInterval, speed_rate:Number) : CCSpeed {
			return new CCSpeed(action, speed_rate);	
		}


		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			innerAction_.startWithTarget(target_);
		}

		override public function stop() : void {
			innerAction_.stop();
			super.stop();
		}

		override public function step(dt:Number) : void {
			innerAction_.step(dt * speed_);
		}

		override public function isDone() : Boolean {
			return innerAction_.isDone();
		}

		//override public function reverse() : CCActionInterval {
			//return CCSpeed.actionWithAction(innerAction_.reverse() as CCActionInterval, speed_);
		//}
	}
}
