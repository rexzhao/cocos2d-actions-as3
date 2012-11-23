package org.cocos2d.Actions
{
	public class CCEaseBounceInOut extends CCEaseBounce {
		public function CCEaseBounceInOut(action:CCActionInterval) {
			super(action);
		}

		override public function update(t:Number) : void {
			var newT:Number = 0;
			if (t < 0.5) {
				t = t * 2;
				newT = (1 - bounceTime(1-t)) * 0.5;
			} else {
				newT = bounceTime(t * 2 - 1) * 0.5 + 0.5;
			}
			other.update(newT);
		}
	}
}
