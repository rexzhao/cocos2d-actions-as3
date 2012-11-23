package org.cocos2d.Actions
{
	public class CCEaseElasticInOut extends CCEaseElastic {
		public function CCEaseElasticInOut(action:CCActionInterval, period:Number = 0.3) {
			super(action, period);
		}

		override public function update(t:Number) : void {
			var newT:Number = 0;

			if( t == 0 || t == 1 ) {
				newT = t;
			} else {
				t = t * 2;
				if(! period_ )
					period_ = 0.3 * 1.5;
				var s:Number = period_ / 4;

				t = t -1;
				if( t < 0 )
					newT = -0.5 * Math.pow(2, 10 * t) * Math.sin((t - s) * M_PI_X_2 / period_);
				else
					newT = Math.pow(2, -10 * t) * Math.sin((t - s) * M_PI_X_2 / period_) * 0.5 + 1;
			}
			other.update(newT);
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseElasticInOut(other.reverse(), period_);
		}
	}
}
