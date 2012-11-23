package org.cocos2d.Actions
{
	public class CCEaseOut extends CCEaseRateAction {
		public function CCEaseOut(action:CCActionInterval, rate:Number) {
			super(action, rate);
		}

		override public function update(t:Number) : void {
			other.update(Math.pow(t, 1/rate));
		}
	}
}
