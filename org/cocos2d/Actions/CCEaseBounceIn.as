package org.cocos2d.Actions
{
	public class CCEaseBounceIn extends CCEaseBounce {
		public function CCEaseBounceIn(action:CCActionInterval) {
			super(action);
		}

		override public function update(t:Number) : void {
			var newT:Number = 1 - bounceTime(1-t);	
			other.update(newT);
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseBounceOut(other.reverse());
		}
	}
}
