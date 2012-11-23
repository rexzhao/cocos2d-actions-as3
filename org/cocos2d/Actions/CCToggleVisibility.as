package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCToggleVisibility extends CCActionInstant {
		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			target_.visible = !target_.visible;
		}
/*
		override public function reverse() : CCActionInterval {
			return new CCToggleVisibility();
		}
*/
	}
}
