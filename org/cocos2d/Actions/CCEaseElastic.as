package org.cocos2d.Actions
{
	public class CCEaseElastic extends CCActionEase {
		protected var period_:Number;
		public function CCEaseElastic(action:CCActionInterval, period:Number = 0.3) {
			super(action);
			period_ = period;
		}
	}
}
