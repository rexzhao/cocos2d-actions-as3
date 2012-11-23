package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCHide extends CCActionInstant {
		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			target_.visible = false;
		}

		//override public function reverse() : CCFiniteTimeAction {
		//	return new CCShow();
		//}
	}
}
