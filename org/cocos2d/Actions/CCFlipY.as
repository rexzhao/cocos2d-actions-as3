package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	//import flash.geom.Matrix;

	public class CCFlipY extends CCActionInstant {
		private var flipY:Boolean;

		public function CCFlipY(fy:Boolean = true) {
			flipY = fy;
		}

		public static function actionWithFlipY(fx:Boolean) : CCFlipY {
			return new CCFlipY(fx);
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);

			//aTarget.setFlipY:flipY;
			var node:CCSprite = aTarget as CCSprite;
			if (node ) {
				node.flipY = flipY;
			}
		}

/*
		override public function reverse() : CCFiniteTimeAction {
			return CCFlipY.actionWithFlipY(!flipY);
		}
*/
	}
}
