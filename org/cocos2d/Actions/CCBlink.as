package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCBlink extends CCActionInterval {
		private var times_:uint;

		public function CCBlink(d:Number, times:uint) {
			super(d);
			times_ = times;
		}

		/** creates the action */
		public static function actionWithDuration(d:Number, times:uint) : CCBlink {
			return new CCBlink(d, times);
		}

		override public function update(t:Number) : void {
			if (!isDone()) {
				var slice:Number = 1.0 / times_;
				var m:Number = t % slice; //fmodf(t, slice);
				target_.visible = ((m > slice / 2) ? true : false);
			}
		}
	}

}
