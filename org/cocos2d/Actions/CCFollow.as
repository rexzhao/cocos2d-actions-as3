package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCFollow extends CCAction {
		/* node to follow */
		private var followedNode_:CCNode;

		/* whether camera should be limited to certain area */
		private var boundarySet_:Boolean;

		/* if screensize is bigger than the boundary - update not needed */
		private var boundaryFullyCovered:Boolean;

		/* fast access to the screen dimensions */
		private var halfScreenSize:CCPoint;
		private var fullScreenSize:CCPoint;

		/* world boundaries */
		private var leftBoundary:Number;
		private var rightBoundary:Number;
		private var topBoundary:Number;
		private var bottomBoundary:Number;


		/** alter behavior - turn on/off boundary */
		//@property (nonatomic,readwrite) BOOL boundarySet;
		public function get boundarySet() : Boolean {
			return boundarySet_;
		}

		public function set boundarySet(b:Boolean) : void  {
			boundarySet_ = b;
		}

		/** creates the action with a set boundary */
		public static function actionWithTarget(followedNode:CCNode, worldBoundary:CCRect = null) : CCFollow {
			return new CCFollow(followedNode, worldBoundary);
		}

		/** initializes the action */
		public function CCFollow(followedNode:CCNode, worldBoundary:CCRect = null) {
			followedNode_ = followedNode;
			boundarySet = false;
			boundaryFullyCovered = false;

			//CCSize s = [[CCDirector sharedDirector] winSize];
			fullScreenSize = new CCPoint(1024, 768);
			halfScreenSize = new CCPoint(1024 * 0.5, 768 * 0.5);

			if (worldBoundary == null ) {
				return;
			}

			var rect:CCRect = worldBoundary;

			leftBoundary = -((rect.origin.x+rect.size.x) - fullScreenSize.x);
			rightBoundary = -rect.origin.x ;
			topBoundary = -rect.origin.y;
			bottomBoundary = -((rect.origin.y+rect.size.y) - fullScreenSize.y);

			if(rightBoundary < leftBoundary)
			{
				// screen width is larger than world's boundary width
				//set both in the middle of the world
				rightBoundary = leftBoundary = (leftBoundary + rightBoundary) / 2;
			}
			if(topBoundary < bottomBoundary)
			{
				// screen width is larger than world's boundary width
				//set both in the middle of the world
				topBoundary = bottomBoundary = (topBoundary + bottomBoundary) / 2;
			}

			if( (topBoundary == bottomBoundary) && (leftBoundary == rightBoundary) )
				boundaryFullyCovered = true;
		}

		private function ccpSub(v1:CCPoint, v2:CCPoint) : CCPoint {
			return new CCPoint(v1.x - v2.x, v1.y - v2.y);
		}

		private function clampf(value:Number, min_inclusive:Number, max_inclusive:Number) : Number {
			if (min_inclusive > max_inclusive) {
				var tmp:Number = min_inclusive;
				min_inclusive = max_inclusive;
				max_inclusive = tmp;
			}
			return value < min_inclusive ? min_inclusive : value < max_inclusive? value : max_inclusive;
		}

		override public function step(dt:Number) : void {
			if(boundarySet) {
				// whole map fits inside a single screen, no need to modify the position - unless map boundaries are increased
				if(boundaryFullyCovered)
					return;

				var tempPos:CCPoint = ccpSub(halfScreenSize, followedNode_.position);
				target_.x = clampf(tempPos.x, leftBoundary, rightBoundary);
				target_.y = clampf(tempPos.y, bottomBoundary, topBoundary);
			} else {
				var pt:CCPoint = ccpSub(halfScreenSize, followedNode_.position);
				target_.x = pt.x;
				target_.y = pt.y;
			}
		}


		override public function isDone() : Boolean {
			return !followedNode_.isRunning;
		}

		override public function stop() : void {
			target_ = null;
			super.stop();
		}
	}
}
