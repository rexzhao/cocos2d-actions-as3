package org.cocos2d.Actions
{
	public class CCEaseSineInOut extends CCActionEase {
		public function CCEaseSineInOut(action:CCActionInterval) {
			super(action);
		}
		
		override public function update(t:Number) : void {
			other.update(-0.5*(Math.cos(M_PI*t) - 1));
		}
	}
}
