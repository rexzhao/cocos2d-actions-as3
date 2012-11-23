package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCCallFuncND extends CCCallFuncN {
		private var data_:*;

		public function CCCallFuncND(t:*, selector:Function, data:*) {
			super(t, selector);
			data_ = data;
		}

		public static function actionWithTarget(t:*, selector:Function, data:*) : CCCallFuncND {
			return new CCCallFuncND(t, selector, data);
		}

		override public function execute() : void {
			selector_.apply(targetCallback_, [target_, data_]);
		}
	}
}
