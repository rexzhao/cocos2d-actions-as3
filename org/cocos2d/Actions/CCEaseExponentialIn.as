package org.cocos2d.Actions
{
	public class CCEaseExponentialIn extends CCActionEase {
		public function CCEaseExponentialIn(action:CCActionInterval) {
			super(action)
		}

		override public function update(t:Number) : void {
			other.update((t==0) ? 0 : Math.pow(2, 10 * (t/1 - 1)) - 1 * 0.001);
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseExponentialOut(other.reverse());
		}
	}
}
