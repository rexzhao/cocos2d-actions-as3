package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCPlace extends CCActionInstant {
		private var position:CCPoint;

		public function CCPlace(pos:CCPoint) {
			position = new CCPoint(pos.x, pos.y);
		}

		public static function actionWithPosition(pos:CCPoint) : CCPlace {
			return new CCPlace(pos);
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			target_.x = position.x;
			target_.y = position.y;
		}
	}
}
