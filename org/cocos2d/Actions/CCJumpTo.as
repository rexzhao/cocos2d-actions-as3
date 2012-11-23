package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCJumpTo extends CCJumpBy {
		protected var dstPosition_:CCPoint;
		public function CCJumpTo(d:Number, pos:CCPoint, height:Number, jumps:uint) {
			super(d, pos, height, jumps);
			dstPosition_ = new CCPoint(pos.x, pos.y);
		}

		public static function actionWithDuration(d:Number, pos:CCPoint, height:Number, jumps:uint) : CCJumpTo {
			return new CCJumpTo(d, pos, height, jumps);
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			delta_ = new CCPoint(dstPosition_.x - startPosition_.x, dstPosition_.y - startPosition_.y);
		}
	}
}
