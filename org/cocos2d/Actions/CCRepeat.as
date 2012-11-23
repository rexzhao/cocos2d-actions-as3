package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCRepeat extends CCActionInterval {
		private var times_:uint;
		private var total_:uint;
		private var innerAction_:CCFiniteTimeAction;

		/** Inner action */
		//@property (nonatomic,readwrite,retain) CCFiniteTimeAction *innerAction;
		public function get innerAction() : CCFiniteTimeAction {
			return innerAction_;;
		}

		public function set innerAction(action:CCFiniteTimeAction) : void {
			innerAction_ = action;
		}

		/** creates a CCRepeat action. Times is an unsigned integer between 1 and MAX_UINT */
		public static function  actionWithAction(action:CCFiniteTimeAction, times:uint) : CCRepeat {
			return new CCRepeat(action, times);
		}

		public function CCRepeat(action:CCFiniteTimeAction, times:uint) {
			var d:Number = action.duration * times;
			super(d);
			times_ = times;
			this.innerAction = action;
			total_ = 0;
		}

		override public function startWithTarget(aTarget:*) : void {
			total_ = 0;
			super.startWithTarget(aTarget);
			innerAction_.startWithTarget(aTarget);
		}

		override public function stop() : void {
			innerAction_.stop();
			super.stop();
		}


		// issue #80. Instead of hooking step:, hook update: since it can be called by any 
		// container action like Repeat, Sequence, AccelDeccel, etc..
		override public function update(dt:Number) : void {
			var t:Number = dt * times_;
			if (t > total_+1) {
				innerAction_.update(1.0);
				total_++;
				innerAction_.stop();
				innerAction_.startWithTarget(target_);
				// repeat is over ?
				if (total_== times_) {
					// so, set it in the original position
					innerAction_.update(0);
				} else {
					// no ? start next repeat with the right update
					// to prevent jerk (issue #390)
					innerAction_.update(t - total_);
				}
			} else {
				//float r = fmodf(t, 1.0);
				var r:Number = t - Math.floor(t);

				// fix last repeat position
				// else it could be 0.
				if (dt == 1.0) {
					r = 1.0;
					total_++; // this is the added line
				}
				innerAction_.update(Math.min(r,1));
			}
		}

		override public function isDone() : Boolean {
			return (total_ == times_);
		}

		override public function reverse() : CCActionInterval {
			return actionWithAction(innerAction_.reverse(), times_);
		}
	}
}
