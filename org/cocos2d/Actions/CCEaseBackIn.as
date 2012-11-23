package org.cocos2d.Actions 
{
	public class CCEaseBackIn extends CCActionEase  {
		public function CCEaseBackIn(action:CCActionInterval) {
			super(action);
		}

		override public function update(t:Number) : void {
			var overshoot:Number = 1.70158;
			other.update(t * t * ((overshoot + 1) * t - overshoot));
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseBackOut(other.reverse());
		}
	}
}
