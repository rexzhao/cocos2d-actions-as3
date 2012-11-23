package org.cocos2d.Actions
{
	public class CCEaseIn extends CCEaseRateAction {
		public function CCEaseIn(action:CCActionInterval, rate:Number) {
			super(action, rate);
		}

		override public function update(t:Number) : void {
			other.update(Math.pow(t, rate));
		}
	}
}
