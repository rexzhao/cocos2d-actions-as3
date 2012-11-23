package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCCallFuncN extends CCCallFunc {
		public function CCCallFuncN(t:*, selector:Function) {
			super(t, selector);
		}

		public static function actionWithTarget(t:*, selector:Function) : CCCallFuncN {
			return new CCCallFuncN(t, selector);	
		}

		override public function execute() : void {
			selector_.apply(targetCallback_, [target_]);
		}
	}
}
