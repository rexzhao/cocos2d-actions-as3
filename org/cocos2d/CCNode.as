package org.cocos2d
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	use namespace CCTimer;

	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;

	import flash.system.LoaderContext; 
	import flash.system.ApplicationDomain;

	public class CCNode extends Sprite {
		private var isRunning_:Boolean;

		protected function WriteLog(...params) : void {
			trace("[" + new Date() + "]", params);
			
		}

		protected static function Assert(v:Boolean, str:String) : void {
			if (!v) {
				throw Error(str);
			}
		}

		public function set position(pos:CCPoint) : void {
			this.x = pos.x;
			this.y = pos.y;
		}

		public function get position() : CCPoint  {
			return new CCPoint(this.x, this.y);
		}

		public function get isRunning() : Boolean {
			return isRunning_;
		}

		public function CCNode() {
			isRunning_ = true;

			//addEventListener(Event.ADDED, onAdded); 
			//addEventListener(Event.REMOVED, onRemoved); 
		}

		override public function addChild(child:DisplayObject):DisplayObject {
			return addChildAt(child, this.numChildren);
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			super.addChildAt(child, index);
			if(isRunning_ && child is CCNode) {
				(child as CCNode).onEnter();
			}
			return child;
		}

		override public function removeChild(child:DisplayObject):DisplayObject {
			if(isRunning_ && child is CCNode) {
				(child as CCNode).onExit();
				//(child as CCNode).cleanup();
			}
			super.removeChild(child);
			return child;
		}

		override public function removeChildAt(index:int):DisplayObject {
			var child:DisplayObject = getChildAt(index);
			return removeChild(child);
		}

		public function runAction(action:CCAction) : void {
			Assert(action != null, "Argument must be non-nil");
			CCActionManager.sharedManager().addAction(action, this, !isRunning_);
		}

		public function stopAllActions() : void {
			CCActionManager.sharedManager().removeAllActionsFromTarget(this);
		}

		public function stopAction(action:CCAction) : void {
			CCActionManager.sharedManager().removeAction(action);
		}

		public function stopActionByTag(aTag:int) : void {
			Assert( aTag != 1, "Invalid tag");
			CCActionManager.sharedManager().removeActionByTag(aTag, this);
		}

		public function getActionByTag(aTag:int) : CCAction {
			Assert(aTag != 1, "Invalid tag");
			return CCActionManager.sharedManager().getActionByTag(aTag, this);
		}

		public function schedule(selector:Function, interval:Number = 0.0,
				repeat:uint = CCTimer.kCCRepeatForever,
				delay:Number = 0.0) : void {
			Assert(selector != null, "Argument must be non-nil");
			Assert(interval >=0, "Arguemnt must be positive");

			CCScheduler.sharedScheduler().scheduleSelector(selector, this, interval, !isRunning_, repeat, delay);
		}

		public function scheduleOnce(selector:Function, delay:Number) :  void {
			schedule(selector, 0.0, 0, delay);
		}

		public function unschedule(selector:Function) : void {
			// explicit nil handling
			if (selector == null)
				return;

			CCScheduler.sharedScheduler().unscheduleSelector(selector, this);
		}

		public function numberOfRunningActions() : uint {
			return CCActionManager.sharedManager().numberOfRunningActionsInTarget(this);
		}

		private function unscheduleAllSelectors() : void {
			CCScheduler.sharedScheduler().unscheduleAllSelectorsForTarget(this);
		}
		private function resumeSchedulerAndActions() : void {
			CCScheduler.sharedScheduler().resumeTarget(this);
			CCActionManager.sharedManager().resumeTarget(this);
		}

		private function pauseSchedulerAndActions() : void {
			CCScheduler.sharedScheduler().pauseTarget(this);
			CCActionManager.sharedManager().pauseTarget(this);
		}

		public function cleanup() : void {
			stopAllActions();
			unscheduleAllSelectors();
			for(var i:int = 0; i < this.numChildren; i++) {
				var c:CCNode = getChildAt(i) as CCNode;
				if (c) {
					c.cleanup();
				}
			}
		}

		public function onEnter() : void {
			//[children_ makeObjectsPerformSelector:@selector(onEnter)];	
			for(var i:int = 0; i < this.numChildren; i++) {
				var c:CCNode = getChildAt(i) as CCNode;
				if (c) {
					c.onEnter();
				}
			}
			resumeSchedulerAndActions();
			isRunning_ = true;
		}

		public function onExit() : void {
			pauseSchedulerAndActions();
			isRunning_ = false;	
			for(var i:int = 0; i < this.numChildren; i++) {
				var c:CCNode = getChildAt(i) as CCNode;
				if (c) {
					c.onExit();
				}        
			}  
		}
	}
}
