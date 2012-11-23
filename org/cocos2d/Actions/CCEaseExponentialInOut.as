package org.cocos2d.Actions
{
	public class CCEaseExponentialInOut extends CCActionEase {
		public function CCEaseExponentialInOut(action:CCActionInterval) {
			super(action)
		}

		override public function update(t:Number) : void {
			t /= 0.5;
			if (t < 1)
				t = 0.5 * Math.pow(2, 10 * (t - 1));
			else
				t = 0.5 * (-Math.pow(2, -10 * (t -1) ) + 2);
											
			other.update(t);
		}
	}
}
