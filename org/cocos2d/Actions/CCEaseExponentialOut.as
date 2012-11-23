package org.cocos2d.Actions
{
	public class CCEaseExponentialOut extends CCActionEase {
		public function CCEaseExponentialOut(action:CCActionInterval) {
			super(action)
		}

		override public function update(t:Number) : void {
			other.update((t==1)?1:(-Math.pow(2, -10 * t/1) + 1));
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseExponentialIn(other.reverse());
		}
	}
}
