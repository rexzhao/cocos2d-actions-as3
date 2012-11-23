package org.cocos2d.Actions
{
	public class CCEaseSineIn extends CCActionEase {
		public function CCEaseSineIn(action:CCActionInterval) {
			super(action);
		}
		
		override public function update(t:Number) : void {
			other.update(-1*Math.cos(t * Math.PI)+1);
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseSineOut(other.reverse());
		}
	}
}
