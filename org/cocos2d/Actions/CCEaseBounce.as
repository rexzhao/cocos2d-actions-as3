package org.cocos2d.Actions
{
	public class CCEaseBounce extends CCActionEase {
		public function CCEaseBounce(action:CCActionInterval) {
			super(action);
		}

		public function bounceTime(t:Number) : Number {
			if (t < 1 / 2.75) {
				return 7.5625 * t * t;
			} else if (t < 2 / 2.75) {
				t -= 1.5 / 2.75;
				return 7.5625 * t * t + 0.75;
			} else if (t < 2.5 / 2.75) {
				t -= 2.25 / 2.75;
				return 7.5625 * t * t + 0.9375;
			}

			t -= 2.625 / 2.75;
			return 7.5625 * t * t + 0.984375;
		}
	}
}
