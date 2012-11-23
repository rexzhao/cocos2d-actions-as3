package org.cocos2d
{
	public class CCTimer extends CCObject {
		private var target:*;
		//private var impMethod_:Function;
		private var elapsed:Number;

		public  var interval:Number;
		public  var selector:Function;


		private var runForever:Boolean;
		private var useDelay:Boolean;

		private var nTimesExecuted:uint; 
		private var repeat:uint; //0 = once, 1 is 2 x executed
		private var delay:uint; 

		public static const kCCRepeatForever:uint = 0xfffffffe;

		/** interval in seconds */
		//@property (nonatomic,readwrite,assign) ccTime interval;

		//             target   selecter     interval    repeat  delay
		public function CCTimer(t:*, s:Function, sec:Number = 0, r:uint = 0, d:Number = 0.0) {
			// target is not retained. It is retained in the hash structure
			target = t;
			selector = s;
			//impMethod = (TICK_IMP) [t methodForSelector:s];
			elapsed = -1;
			interval = sec;

			repeat = r;
			delay = d;
			useDelay = (delay > 0) ? true : false;
			//repeat = r;
			runForever = (repeat == kCCRepeatForever) ? true : false; 
		}

		public function update(dt:Number) : void {
			if( elapsed == -1) {	
				elapsed = 0;
				nTimesExecuted = 0;
			} else {	
				if (runForever && !useDelay) {
					//standard timer usage
					elapsed += dt;
					if( elapsed >= interval ) {
						selector.apply(target, [elapsed]);
						elapsed = 0;
					}
				} else {
					//advanced usage 
					elapsed += dt;
					if (useDelay) {
						if( elapsed >= delay ) {
							selector.apply(target, [elapsed]);
							elapsed = elapsed - delay;
							nTimesExecuted+=1;
							useDelay = false;
						}
					} else {
						if (elapsed >= interval) {
							selector.apply(target, [elapsed]);
							elapsed = 0;
							nTimesExecuted += 1; 
						}
					}

					if (nTimesExecuted > repeat) {
						//unschedule timer
						CCScheduler.sharedScheduler().unscheduleSelector(selector, target);
					}
				}
			}
		}
	}
}
