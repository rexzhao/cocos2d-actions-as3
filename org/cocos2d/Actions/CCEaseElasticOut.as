package org.cocos2d.Actions
{
	public class CCEaseElasticOut extends CCEaseElastic {
		public function CCEaseElasticOut (action:CCActionInterval, period:Number = 0.3) {
			super(action, period);
		}

		override public function update(t:Number) : void {
			var newT:Number = 0;
			if (t == 0 || t == 1) {
				newT = t;
			} else {
				var s:Number = period_ / 4;
				newT = Math.pow(2, -10 * t) * Math.sin( (t-s) *M_PI_X_2 / period_) + 1;
			}
			other.update(newT);
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseElasticIn(other.reverse(), period_);
		}
	}
}
