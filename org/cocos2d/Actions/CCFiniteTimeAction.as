package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCFiniteTimeAction extends CCAction {
		protected var duration_:Number;

		public function CCFiniteTimeAction() {
			duration_ = 0;
		}

		public function get duration() : Number {
			return duration_;
		}

		public function set duration(d:Number) : void {
			duration_ = d;
		}

		public function reverse() : CCActionInterval {
			WriteLog("cocos2d: FiniteTimeAction#reverse: Implement me");
			return null;
		}

	}
}
