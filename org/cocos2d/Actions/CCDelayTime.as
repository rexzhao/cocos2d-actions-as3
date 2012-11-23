package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCDelayTime extends CCActionInterval {
		public function CCDelayTime(d:Number) {
			super(d);
		}

		public static function actionWithDuration(d:Number) : CCDelayTime {
			return new CCDelayTime(d);
		}

		override public function update(t:Number) : void {
			return;
		}

		override public function reverse() : CCActionInterval {
			return actionWithDuration(duration_);
		}
	}

}
