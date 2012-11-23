package org.cocos2d
{
	import flash.utils.Dictionary;

	import org.cocos2d.*;

	public class CCScheduler extends CCObject {
		private var timeScale_:Number;

		//
		// "updates with priority" stuff
		//
		//private var updatesNeg:Vector.<tListEntry>;	// list of priority < 0
		//private var updates0:vector.<tListEntry>;		// list priority == 0
		//private var updatesPos:vector.<tListEntry>;	// list priority > 0

		private var hashForUpdates:Dictionary;
		//struct tHashUpdateEntry		*hashForUpdates;	// hash used to fetch quickly the list entries for pause,delete,etc.

		// Used for "selectors with interval"
		//struct _hashSelectorEntry	*hashForSelectors;
		private var hashForSelectors:Dictionary;
		//struct _hashSelectorEntry	*currentTarget;
		private var currentTarget:tHashSelectorEntry;
		//BOOL						currentTargetSalvaged;
		private var currentTargetSalvaged:Boolean;

		// Optimization
		//TICK_IMP			impMethod;
		//SEL					updateSelector;

		//BOOL updateHashLocked; // If true unschedule will not remove anything from a hash. Elements will only be marked for deletion.
		//private var updateHashLocked:Boolean;

		public function CCScheduler() {
			timeScale_ = 1.0;

			hashForUpdates = new Dictionary();
			hashForSelectors = new Dictionary();

			// used to trigger CCTimer#update
			//updateSelector = @selector(update:);
			//impMethod = (TICK_IMP) [CCTimer instanceMethodForSelector:updateSelector];

			// updates with priority
			//updates0 = NULL;
			//updatesNeg = NULL;
			//updatesPos = NULL;
			//hashForUpdates = NULL;

			// selectors with interval
			//currentTarget = nil;
			//currentTargetSalvaged = NO;
			//hashForSelectors = nil;
			//updateHashLocked = NO;
		}

		//@property (nonatomic,readwrite) ccTime	timeScale;
		public function get timeScale() : Number {
			return timeScale_;
		}

		public function set timeScale(scale:Number) : void {
			timeScale_ = scale;
		}

		/** returns a shared instance of the Scheduler */
		//+(CCScheduler *)sharedScheduler;

		private static var _sharedScheduler:CCScheduler;

		public static function sharedScheduler() : CCScheduler {
			if (_sharedScheduler == null) {
				_sharedScheduler = new CCScheduler();
			}
			return _sharedScheduler;
		}

		/** purges the shared scheduler. It releases the retained instance.
		  @since v0.99.0
		 */
		//+(void)purgeSharedScheduler;
		public function purgeSharedScheduler() : void {
			_sharedScheduler = null;
		}

		/** 'tick' the scheduler.
		  You should NEVER call this method, unless you know what you are doing.
		 */
		//-(void) tick:(ccTime)dt;

		private var lastTime:Date;
		private function getTick() : Number {
			var now:Date = new Date();
			if (lastTime == null) {
				lastTime = now;
			}

			var dt:Number = now.getTime() - lastTime.getTime();
			dt /= 1000;
			dt *= timeScale_;
			lastTime = now;
			return dt;
		}

		public function pause(p:Boolean) : void {
			if (p) {
				tick();
			} else {
				lastTime = new Date();
			}
		}

		public function tick(/*dt:Number*/) : void {
			//TODO:
			//WriteLog("CCScheduler::tick");
			var tdt:Number = getTick();

			var _start:Date = new Date();

			var c1:int = 0;
			var c2:int = 0;

			while(tdt > 0) {
				var dt:Number = ((tdt > 0.1) ? 0.1 : tdt);
				tdt -= dt;
				for each(var elt:tHashSelectorEntry in hashForSelectors) {
					c1 ++;
					currentTarget = elt;
					currentTargetSalvaged = false;
					if(!currentTarget.paused) {
						// The 'timers' ccArray may change while inside this loop.
						for(elt.timerIndex = 0; elt.timerIndex < elt.timers.length; elt.timerIndex++) {
							c2 ++;
							elt.currentTimer = elt.timers[elt.timerIndex];
							elt.currentTimerSalvaged = false;

							elt.currentTimer.update(dt);
							//impMethod( elt->currentTimer, updateSelector, dt);

							if( elt.currentTimerSalvaged ) {
								// The currentTimer told the remove itself. To prevent the timer from
								// accidentally deallocating itself before finishing its step, we retained
								// it. Now that step is done, it's safe to release it.
								elt.currentTimer = null;
							}

							elt.currentTimer = null;
						}			
					}

					// elt, at this moment, is still valid
					// so it is safe to ask this here (issue #490)
					//elt = elt->hh.next;

					// only delete currentTarget if no actions were scheduled during the cycle (issue #481)
					if (currentTargetSalvaged && currentTarget.timers.length == 0) {
						removeHashElement(currentTarget);
					}
				}
			}

			var _end:Date = new Date();
			var take_dt:Number = _end.getTime() - _start.getTime();


			WriteLog("CCScheduler::tick take " + take_dt + " msec " + c1 + "," + c2);
		}

		/** The scheduled method will be called every 'interval' seconds.
		  If paused is YES, then it won't be called until it is resumed.
		  If 'interval' is 0, it will be called every frame, but if so, it recommened to use 'scheduleUpdateForTarget:' instead.
		  If the selector is already scheduled, then only the interval parameter will be updated without re-scheduling it again.

		  @since v0.99.3
		 */
		//-(void) scheduleSelector:(SEL)selector forTarget:(id)target interval:(ccTime)interval paused:(BOOL)paused;
		public function scheduleSelector(selector:Function,
				target:*,
				interval:Number = 0,
				paused:Boolean = false,
				repeat:uint = 0xfffffffe,
				delay:Number = 0) : void {
			Assert( selector != null, "Argument selector must be non-nil");
			Assert( target != null, "Argument target must be non-nil");	
	
			var element:tHashSelectorEntry = hashForSelectors[target];
			if(!element ) {
				element = new tHashSelectorEntry();
				element.target = target;
				//HASH_ADD_INT( hashForSelectors, target, element );
				hashForSelectors[target] = element;

				element.timerIndex = 0;
				element.currentTimerSalvaged = false;
				element.currentTimer = null;

				// Is this the 1st element ? Then set the pause level to all the selectors of this target
				element.paused = paused;
	
			} else {
				Assert(element.paused == paused, 
						"CCScheduler. Trying to schedule a selector with a pause value different than the target");
			}
	
			var timer:CCTimer = null;
			if( element.timers == null) {
				element.timers = new Array();
			} else {
				for(var i:uint =0; i < element.timers.length; i++ ) {
					timer = element.timers[i] as CCTimer;
					if(selector == timer.selector ) {
						trace("CCScheduler#scheduleSelector. Selector already scheduled. Updating interval from: %.2f to %.2f", timer.interval, interval);
						timer.interval = interval;
						return;
					}
				}
				//ccArrayEnsureExtraCapacity(element->timers, 1);
			}

			timer = new CCTimer(target, selector, interval, repeat, delay);
			element.timers.push(timer);
		}

		/** Unshedules a selector for a given target.
		  If you want to unschedule the "update", use unscheudleUpdateForTarget.
		  @since v0.99.3
		 */
		public function unscheduleSelector(selector:Function, target:Object) : void {
			//TODO:
			if(target == null && selector == null) {
				return;
			}

			Assert( target != null, "Target MUST not be nil");
			Assert( selector != null, "Selector MUST not be NULL");

			var element:tHashSelectorEntry = hashForSelectors[target];
			if(element == null) {
				return;
			}

			for(var i:uint = 0; i < element.timers.length; i++ ) {
				var timer:CCTimer = element.timers[i];
				if(selector == timer.selector) {
					if( timer == element.currentTimer && !element.currentTimerSalvaged ) {
						element.currentTimerSalvaged = true;
					}

					element.timers.splice(i, 1);

					// update timerIndex in case we are in tick:, looping over the actions
					if( element.timerIndex >= i )
						element.timerIndex--;

					if( element.timers.length == 0) {
						if(currentTarget == element)
							currentTargetSalvaged = true;
						else
							removeHashElement(element);
					}
					return;
				}
			}
		}

		private function removeHashElement(element:tHashSelectorEntry) : void {
			element.timers = null;
			delete hashForSelectors[element.target];
		}

		/** Unschedules all selectors for a given target.
		  This also includes the "update" selector.
		  @since v0.99.3
		 */
		public function unscheduleAllSelectorsForTarget(target:*) : void  {
			//TODO:
			// explicit nil handling
			if (target == null) {
				return;
			}

			// Custom Selectors
			var element:tHashSelectorEntry = hashForSelectors[target];
			if (element) {
				var index:int = element.timers.indexOf(element.currentTimer);
				if (index != -1 && !element.currentTimerSalvaged)  {
					element.currentTimer = null;
					element.currentTimerSalvaged = true;
				}

				element.timers = new Array();
				if(currentTarget == element)
					currentTargetSalvaged = true;
				else
					removeHashElement(element);
			}

			// Update Selector
			//[self unscheduleUpdateForTarget:target];
		}

		/** Unschedules all selectors from all targets.
		  You should NEVER call this method, unless you know what you are doing.

		  @since v0.99.3
		 */
		//-(void) unscheduleAllSelectors;
		public function unscheduleAllSelectors() : void {
			//TODO:
			for each(var element:tHashSelectorEntry in hashForSelectors) {
				var target:* = element.target;
				unscheduleAllSelectorsForTarget(target);
			}

/*
			// Updates selectors
			tListEntry *entry, *tmp;
			DL_FOREACH_SAFE( updates0, entry, tmp ) {
				[self unscheduleUpdateForTarget:entry->target];
			}
			DL_FOREACH_SAFE( updatesNeg, entry, tmp ) {
				[self unscheduleUpdateForTarget:entry->target];
			}
			DL_FOREACH_SAFE( updatesPos, entry, tmp ) {
				[self unscheduleUpdateForTarget:entry->target];
			}
*/
		}

		/** Pauses the target.
		  All scheduled selectors/update for a given target won't be 'ticked' until the target is resumed.
		  If the target is not present, nothing happens.
		  @since v0.99.3
		 */
		//-(void) pauseTarget:(id)target;
		public function pauseTarget(target:*) : void {
			//TODO:
			Assert( target != null, "target must be non nil" );

			// Custom selectors
			var element:tHashSelectorEntry  = hashForSelectors[target];
			if( element )
				element.paused = true;
/*
			// Update selector
			tHashUpdateEntry * elementUpdate = NULL;
			HASH_FIND_INT(hashForUpdates, &target, elementUpdate);
			if( elementUpdate ) {
				NSAssert( elementUpdate->entry != NULL, @"pauseTarget: unknown error");
				elementUpdate->entry->paused = YES;
			}
*/
		}

		/** Resumes the target.
		  The 'target' will be unpaused, so all schedule selectors/update will be 'ticked' again.
		  If the target is not present, nothing happens.
		  @since v0.99.3
		 */
		//-(void) resumeTarget:(id)target;
		public function resumeTarget(target:*) : void {
			//TODO:
			Assert(target != null, "target must be non nil" );

			// Custom Selectors
			var element:tHashSelectorEntry = hashForSelectors[target];
			if (element)
				element.paused = false;

/*
			// Update selector
			tHashUpdateEntry * elementUpdate = NULL;
			HASH_FIND_INT(hashForUpdates, &target, elementUpdate);
			if( elementUpdate ) {
				NSAssert( elementUpdate->entry != NULL, @"resumeTarget: unknown error");
				elementUpdate->entry->paused = NO;
			}	
*/
		}

		/** Returns whether or not the target is paused
		  @since v1.0.0
		 */
		//-(BOOL) isTargetPaused:(id)target;
		public function isTargetPaused(target:Object) : Boolean {
			//TODO:
			Assert( target != null, "target must be non nil" );

			// Custom selectors
			var element:tHashSelectorEntry = hashForSelectors[target];
			if( element ) {
				return element.paused;
			}
			return false;  // should never get here
		}
	}
}

import org.cocos2d.*;

/*
// A list double-linked list used for "updates with priority"
class tListEntry {
	public var impMethod:Function;
	public var target:*;
	public var property:int;
	public var paused:Boolean;
	public var markedForDeletion:Boolean;
};

class tHashUpdateEntry
{
	//tListEntry		**list;		// Which list does it belong to ?
	public var list:Vector.<tListEntry>;

	//tListEntry		*entry;		// entry in the list
	public var entity:tListEntry;

	//id				target;		// hash key (retained)
	public var target:*;
};
*/

// Hash Element used for "selectors with interval"
class tHashSelectorEntry
{
	//struct ccArray	*timers;
	public var timers:Array;
	//id				target;		// hash key (retained)
	public var target:*;

	//unsigned int	timerIndex;
	public var timerIndex:uint;

	//CCTimer			*currentTimer;
	public var currentTimer:CCTimer;

	//BOOL			currentTimerSalvaged;
	public var currentTimerSalvaged:Boolean;

	//BOOL			paused;
	public var paused:Boolean; 
};
