package org.cocos2d.Actions
{
	public class CCEaseSineOut extends CCActionEase {
		public function CCEaseSineOut(action:CCActionInterval) {
			super(action);
		}
		
		override public function update(t:Number) : void {
			other.update(Math.sin(t * M_PI_2));
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseSineIn(other.reverse());
		}
	}
}
