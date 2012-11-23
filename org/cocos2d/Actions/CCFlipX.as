package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	import flash.geom.Matrix;

	public class CCFlipX extends CCActionInstant {
		private var flipX:Boolean;

		public function CCFlipX(fx:Boolean = true) {
			flipX = fx;
		}

		public static function actionWithFlipX(fx:Boolean) : CCFlipX {
			return new CCFlipX(fx);
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);

			//aTarget.setFlipX:flipX;
			var node:CCSprite = aTarget as CCSprite;
			if (node ) {
				node.flipX = flipX;
			}
		}

		//override public function reverse() : CCActionInstant {
		//	return CCFlipX.actionWithFlipX(!flipX);
		//}
	}
}
