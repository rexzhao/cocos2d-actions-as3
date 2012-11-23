package org.cocos2d.Actions
{
	import flash.utils.Dictionary;

	import org.cocos2d.Actions.*;
	import org.cocos2d.*;

	public class CCActionManager extends CCObject {
		private var targets:Dictionary;
		private var currentTarget:tHashElement;
		private var currentTargetSalvaged:Boolean;

		public function CCActionManager() { 
			//CCScheduler.sharedScheduler().scheduleUpdateForTarget:self priority:0 paused:NO];
			CCScheduler.sharedScheduler().scheduleSelector(update, this, 0.01);
			targets = new Dictionary();
		}

		private static var sharedManager_:CCActionManager;
		public static function sharedManager() : CCActionManager {
			if (sharedManager_ == null) {
				sharedManager_ = new CCActionManager();
			}
			return sharedManager_;
		}

		public static function purgeSharedManager() : void {
			sharedManager_ = null
		}

		public function addAction(action:CCAction,
				target:*, paused:Boolean = false) : void {
			Assert( action != null, "Argument action must be non-nil");
			Assert( target != null, "Argument target must be non-nil");	

			var element:tHashElement = targets[target];
			if( ! element ) {
				element = new tHashElement();
				element.actions = new Array();
				element.paused = false;
				element.target = target;
				targets[target] = element;
			}

			var index:int = element.actions.indexOf(action);
			Assert(index == -1, "runAction: Action already running");	

			element.actions.push(action);
			action.startWithTarget(target);
		}

		public function removeAllActions() : void {
			for each(var element:tHashElement in targets) {
				var target:* = element.target;
				removeAllActionsFromTarget(target);
			}
		}

		public function removeAllActionsFromTarget(target:*) : void {
			// explicit nil handling
			if( target == null)
				return;

			var element:tHashElement = targets[target];
			if( element ) {
				if (element.actions.indexOf(element.currentAction) != -1 && !element.currentActionSalvaged) {
					element.currentActionSalvaged = true;
				}
				element.actions = new Array();
				//ccArrayRemoveAllObjects(element->actions);
				if (currentTarget == element)
					currentTargetSalvaged = true;
				else
					deleteHashElement(element);
			}
		}

		/** Removes an action given an action reference.
		 */
		//-(void) removeAction: (CCAction*) action;
		public function removeAction(action:CCAction) : void {
			if (action == null)
				return;

			var target:* = action.originalTarget;
			var element:tHashElement = targets[target];
			if( element ) {
				var i:int = element.actions.indexOf(action);
				if( i != -1)
					removeActionAtIndex(i, element);
			}
		}

		/** Removes an action given its tag and the target */
		//-(void) removeActionByTag:(NSInteger)tag target:(id)target;
		public function removeActionByTag(aTag:int, target:*) : CCAction {
			Assert( aTag != 0, "Invalid tag");
			Assert( target != null, "Target should be ! nil");

			var element:tHashElement = targets[target];
			if( element ) {
				var limit:uint = element.actions.length;
				for(var i:uint = 0; i < limit; i++) {
					var a:CCAction = element.actions[i];
					if( a.tag == aTag && a.originalTarget == target) {
						removeActionAtIndex(i, element);
						return a;
					}
				}
			}
			return null;
		}

		/** Gets an action given its tag an a target
		  @return the Action the with the given tag
		 */
		//-(CCAction*) getActionByTag:(NSInteger) tag target:(id)target;
		public function getActionByTag(aTag:int, target:*) : CCAction {
			Assert( aTag != 1, "Invalid tag");

			var element:tHashElement = targets[target];
			if(element) {
				if(element.actions != null) {
					var limit:uint = element.actions.length;
					for(var i:uint = 0; i < limit; i++) {
						var a:CCAction = element.actions[i];
						if( a.tag == aTag )
							return a; 
					}
				}
				//CCLOG(@"cocos2d: getActionByTag: Action not found");
			}
			//else {
			//	CCLOG(@"cocos2d: getActionByTag: Target not found");
			//}
			return null;
		}

		/** Returns the numbers of actions that are running in a certain target
		 * Composable actions are counted as 1 action. Example:
		 *    If you are running 1 Sequence of 7 actions, it will return 1.
		 *    If you are running 7 Sequences of 2 actions, it will return 7.
		 */
		//-(NSUInteger) numberOfRunningActionsInTarget:(id)target;
		public function numberOfRunningActionsInTarget(target:*) : uint {
			var element:tHashElement = targets[targets];
			if(element && element.actions) {
				return element.actions.length;
			}
			//CCLOG(@"cocos2d: numberOfRunningActionsInTarget: Target not found");
			return 0;
		}

		/** Pauses the target: all running actions and newly added actions will be paused.
		 */
		//-(void) pauseTarget:(id)target;
		public function pauseTarget(target:*) : void {
			var element:tHashElement = targets[target];
			if (element)
				element.paused = true;
		}

		/** Resumes the target. All queued actions will be resumed.
		 */
		//-(void) resumeTarget:(id)target;
		public function resumeTarget(target:*) : void {
			var element:tHashElement = targets[target];
			if( element )
				element.paused = false;
		}


		//-(void) deleteHashElement:(tHashElement*)element
		private function deleteHashElement(element:Object) : void {
			element.actions = null;

			delete targets[element.target];
		}

		//-(void) actionAllocWithHashElement:(tHashElement*)element
		private function actionAllocWithHashElement(element:tHashElement): void {
			// 4 actions per Node by default
			if (element.actions == null) {
				element.actions = new Array();
			}
			/*
			   if( element->actions == nil )
			   element->actions = ccArrayNew(4);
			   else if( element->actions->num == element->actions->max )
			   ccArrayDoubleCapacity(element->actions);	
			 */
		}

		//-(void) removeActionAtIndex:(NSUInteger)index hashElement:(tHashElement*)element
		private function removeActionAtIndex(index:int,
				element:tHashElement) : void {	
			var action:* = element.actions[index];

			if (action == element.currentAction 
					&& !element.currentActionSalvaged) {
				element.currentActionSalvaged = true;
			}

			element.actions.splice(index, 1);
			if( element.actionIndex >= index )
				element.actionIndex--;

			if( element.actions.length == 0 ) {
				if( currentTarget == element )
					currentTargetSalvaged = true;
				else
					deleteHashElement(element);
			}
		}

		//-(void) update: (ccTime) dt
		public function update(dt:Number) : void {
			//WriteLog("CCActionManager::update " + dt);
			//for(tHashElement *elt = targets; elt != NULL; ) {	
			var _start:Date = new Date();

			var c1:int = 0;
			var c2:int = 0;

			for each (var elt:tHashElement in targets) {
				currentTarget = elt;
				currentTargetSalvaged = false;

				c1 ++;

				if(!currentTarget.paused) {
					// The 'actions' ccArray may change while inside this loop.
					for(currentTarget.actionIndex = 0;
							currentTarget.actionIndex < currentTarget.actions.length;
							currentTarget.actionIndex++) {
						c2++;
						currentTarget.currentAction = currentTarget.actions[currentTarget.actionIndex];
						currentTarget.currentActionSalvaged = false;

						currentTarget.currentAction.step(dt);

						if (currentTarget.currentActionSalvaged) {
							// The currentAction told the node to remove it. To prevent the action from
							// accidentally deallocating itself before finishing its step, we retained
							// it. Now that step is done, it's safe to release it.
							currentTarget.currentAction = null;
						} else if (currentTarget.currentAction.isDone()) {
							currentTarget.currentAction.stop();

							var a:CCAction = currentTarget.currentAction;
							// Make currentAction nil to prevent removeAction from salvaging it.
							currentTarget.currentAction = null;
							removeAction(a);
						}

						currentTarget.currentAction = null;
					}
				}

				// elt, at this moment, is still valid
				// so it is safe to ask this here (issue #490)
				// elt = elt->hh.next;

				// only delete currentTarget if no actions were scheduled during the cycle (issue #481)
				if (currentTargetSalvaged && currentTarget.actions.length == 0) {
					deleteHashElement(currentTarget);
				}
			}

			var _end:Date = new Date();
			var dt:Number = _end.getTime() - _start.getTime();

			WriteLog("CCActionManager::update take " + dt + " msec " + c1 + "," + c2);

			// issue #635
			currentTarget = null;
		}
	}
}

import org.cocos2d.Actions.CCAction;

class tHashElement {
	//struct ccArray	*actions;
	public var actions:Array;

	//NSUInteger		actionIndex;
	public var actionIndex:int;

	//BOOL			currentActionSalvaged;
	public var currentActionSalvaged:Boolean;

	//BOOL			paused;	
	public var paused:Boolean;

	//UT_hash_handle	hh;

	//CC_ARC_UNSAFE_RETAINED	id				target;
	public var target:*;

	//CC_ARC_UNSAFE_RETAINED	CCAction		*currentAction;
	public var currentAction:CCAction;

	public function tHashElement() {
		actionIndex = 0;
		currentActionSalvaged = false;
		paused = false;
		target = null;
		currentAction = null;
	}
}
