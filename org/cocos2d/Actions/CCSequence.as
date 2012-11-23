package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCSequence extends CCActionInterval {
		private var actions_:Vector.<CCFiniteTimeAction>;
		private var split_:Number;
		private var last_:int;

		/** helper contructor to create an array of sequenceable actions */
		//+(id) actions: (CCFiniteTimeAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;
		/** helper contructor to create an array of sequenceable actions given an array */
		//+(id) actionsWithArray: (NSArray*) actions;

		public static function actionTwo(one:CCFiniteTimeAction, two:CCFiniteTimeAction) : CCSequence {	
			return new CCSequence(one, two);
		}


		//: (CCFiniteTimeAction*) action1, ...
		public static function actions(...action) : CCFiniteTimeAction {
			return CCSequence.actionsWithArray(action);
		}

		//+(id) actionsWithArray: (NSArray*) actions
		public static function actionsWithArray(actions:Array) : CCFiniteTimeAction {
			var prev:CCFiniteTimeAction = actions[0] as CCFiniteTimeAction;
			for (var i:uint = 1; i < actions.length; i++) {
				prev = new CCSequence(prev, actions[i]);
			}
			return prev;
		}

		public function CCSequence(one:CCFiniteTimeAction, two:CCFiniteTimeAction) {
			actions_ = new Vector.<CCFiniteTimeAction>(2, true);
			Assert(one!=null && two!=null, "Sequence: arguments must be non-nil");
			Assert(one!=actions_[0] && one!=actions_[1], "Sequence: re-init using the same parameters is not supported");
			Assert(two!=actions_[1] && two!=actions_[0], "Sequence: re-init using the same parameters is not supported");

			var d:Number = one.duration + two.duration;
			super(d);
			// XXX: Supports re-init without leaking. Fails if one==one_ || two==two_
			actions_[0] = one;
			actions_[1] = two;
		}

		
		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);	
			split_ = actions_[0].duration / duration_;
			last_ = -1;
		}

		override public function stop() : void {
			actions_[0].stop();
			actions_[1].stop();
			super.stop();
		}

		override public function update(t:Number) : void {
			var found:int = 0;
			var new_t:Number = 0.0;

			if (t >= split_) {
				found = 1;
				if (split_ == 1) {
					new_t = 1;
				} else {
					new_t = (t-split_) / (1-split_);
				}
			} else {
				found = 0;
				if ( split_ != 0) {
					new_t = t / split_;
				} else {
					new_t = 1;
				}
			}

			if (last_ == -1 && found==1)	{
				actions_[0].startWithTarget(target_);
				actions_[0].update(1.0);
				actions_[0].stop();
			}

			if (last_ != found) {
				if (last_ != -1) {
					actions_[last_].update(1.0);
					actions_[last_].stop();
				}
				actions_[found].startWithTarget(target_);
			}
			actions_[found].update(new_t);
			last_ = found;
		}

		override public function reverse() : CCActionInterval {
			return actionTwo(actions_[1].reverse(), actions_[0].reverse());
		}

	}
}
