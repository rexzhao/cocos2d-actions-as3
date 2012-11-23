package org.cocos2d.Actions
{
	public class CCEaseBounceOut extends CCEaseBounce {
		public function CCEaseBounceOut(action:CCActionInterval) {
			super(action);
		}

		override public function update(t:Number) : void {
			var newT:Number = bounceTime(t);
			other.update(newT);
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseBounceIn(other.reverse());
		}
	}
}
