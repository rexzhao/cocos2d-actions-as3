package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCFadeIn extends CCActionInterval {
		public function CCFadeIn(d:Number) {
			super(d);
		}

		public static function actionWithDuration(d:Number) : CCFadeIn {
			return new CCFadeIn(d);
		}

		override public function update(t:Number) : void {
			target.alpha = t;
		}

		override public function reverse() : CCActionInterval {
			return CCFadeOut.actionWithDuration(duration_);
		}
	}
}
