package org.cocos2d.Actions
{
	public class CCEaseRateAction extends CCActionEase {
		protected var rate:Number;
		public function CCEaseRateAction(action:CCActionInterval, rate:Number) {
			super(action);
			this.rate = rate;
		}

		public static function actionWithAction(action:CCActionInterval, rate:Number) : CCEaseRateAction {
			return new CCEaseRateAction(action, rate);
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseRateAction(other.reverse(), 1/rate);
		}
	}
}
