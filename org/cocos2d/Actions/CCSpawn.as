package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCSpawn extends CCActionInterval {
		private var one_:CCFiniteTimeAction;
		private var two_:CCFiniteTimeAction;

		public static function actions(...action): CCFiniteTimeAction {
			return actionsWithArray(action);
		}

		/** helper contructor to create an array of spawned actions given an array */
		public static function actionsWithArray(actions:Array) : CCFiniteTimeAction {
			var prev:CCFiniteTimeAction = actions[0];
			for (var i:uint = 1; i < actions.length; i++) {
				prev = new CCSpawn(prev, actions[i]);
			}
			return prev;
		}

		//-(id) initOne: (CCFiniteTimeAction*) one two:(CCFiniteTimeAction*) two;
		public function CCSpawn(one:CCFiniteTimeAction, two:CCFiniteTimeAction) {
			Assert( one!=null && two!=null, "Spawn: arguments must be non-nil");
			Assert( one!=one_ && one!=two_, "Spawn: reinit using same parameters is not supported");
			Assert( two!=two_ && two!=one_, "Spawn: reinit using same parameters is not supported");

			var d1:Number = one.duration;
			var d2:Number = two.duration;	

			super(Math.max(d1,d2));

			one_ = one;
			two_ = two;

			if( d1 > d2 )
				two_ = new CCSequence(two, CCDelayTime.actionWithDuration(d1-d2));
			else if( d1 < d2)
				one_ = new CCSequence(one, CCDelayTime.actionWithDuration(d2-d1));
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			one_.startWithTarget(target_);
			two_.startWithTarget(target_);
		}

		override public function stop() : void {
			one_.stop();
			two_.stop();
			super.stop();
		}

		override public function update(t:Number) : void {
			one_.update(t);
			two_.update(t);
		}

		override public function reverse() : CCActionInterval {
			return new CCSpawn(one_.reverse(), two_.reverse());
		}
	}
}
