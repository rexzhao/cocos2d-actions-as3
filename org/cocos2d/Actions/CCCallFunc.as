package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCCallFunc extends CCActionInstant {
		protected var targetCallback_:*;
		protected var selector_:Function;

		public function CCCallFunc(t:*, selector:Function) {
			targetCallback_ = t;
			selector_ = selector;
		}

		public static function actionWithTarget(t:*, selector:Function) : CCCallFunc {
			return new CCCallFunc(t, selector);	
		}

		override public function startWithTarget(aTarget:*) : void {
			super.startWithTarget(aTarget);
			this.execute();
		}

		public function execute() : void {
			selector_.apply(targetCallback_);
		}
	}
}
