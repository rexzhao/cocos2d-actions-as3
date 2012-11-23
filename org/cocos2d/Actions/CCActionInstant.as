package org.cocos2d.Actions
{
	public class CCActionInstant extends CCFiniteTimeAction {
		public function CCActionInstant() {
			duration_ = 0;
		}


		override public function step(dt:Number) : void {
			update(1);
		}

		override public function update(t:Number) : void {
			// ignore
		}

		//public function override reverse() : CCFiniteTimeAction {
		//	return [[self copy] autorelease];
		//	return 
		//}
	}
}
