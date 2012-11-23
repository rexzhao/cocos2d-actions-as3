package org.cocos2d.Actions 
{
	public class CCEaseBackOut extends CCActionEase  {
		public function CCEaseBackOut(action:CCActionInterval) {
			super(action);
		}

		override public function update(t:Number) : void {
			var overshoot:Number = 1.70158;
			t = t - 1;
			other.update(t * t * ((overshoot + 1) * t + overshoot) + 1);
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseBackIn(other.reverse());
		}
	}
}
