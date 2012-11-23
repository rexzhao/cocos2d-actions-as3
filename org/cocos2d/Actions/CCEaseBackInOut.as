package org.cocos2d.Actions 
{
	public class CCEaseBackInOut extends CCActionEase  {
		public function CCEaseBackInOut(action:CCActionInterval) {
			super(action);
		}

		override public function update(t:Number) : void {
			var overshoot:Number = 1.70158 * 1.525;

			t = t * 2;
			if (t < 1) {
				other.update((t * t * ((overshoot + 1) * t - overshoot)) / 2);
			} else {
				t = t - 2;
				other.update((t * t * ((overshoot + 1) * t + overshoot)) / 2 + 1);
			}
		}
	}
}
