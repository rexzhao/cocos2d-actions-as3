package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCShow extends CCActionInstant {
		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			target_.visible = true;
		}

		//override public function reverse() : CCFiniteTimeAction {
		//	return new CCHide();
		//}
	}
}
