package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCFadeOut extends CCActionInterval {
		public function CCFadeOut(d:Number) {
			super(d);
		}

		public static function actionWithDuration(d:Number) : CCFadeOut {
			return new CCFadeOut(d);
		}

		override public function update(t:Number) : void {
			target.alpha = (1-t);
		}

		override public function reverse() : CCActionInterval {
			return CCFadeIn.actionWithDuration(duration_);
		}
	}
}
