package org.cocos2d.Actions
{
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	public class CCAction extends CCObject {
		private var originalTarget_:*;
		protected var target_:*;
		private var tag_:int;

		protected static const M_E:Number        = 2.71828182845904523536028747135266250;   /* e */
		protected static const M_LOG2E:Number    = 1.44269504088896340735992468100189214;   /* log2(e) */
		protected static const M_LOG10E:Number   = 0.434294481903251827651128918916605082;  /* log10(e) */
		protected static const M_LN2:Number      = 0.693147180559945309417232121458176568;  /* loge(2) */
		protected static const M_LN10:Number     = 2.30258509299404568401799145468436421;   /* loge(10) */
		protected static const M_PI:Number       = 3.14159265358979323846264338327950288;   /* pi */
		protected static const M_PI_2:Number     = 1.57079632679489661923132169163975144;   /* pi/2 */
		protected static const M_PI_4:Number     = 0.785398163397448309615660845819875721;  /* pi/4 */
		protected static const M_1_PI:Number     = 0.318309886183790671537767526745028724;  /* 1/pi */
		protected static const M_2_PI:Number     = 0.636619772367581343075535053490057448;  /* 2/pi */
		protected static const M_2_SQRTPI:Number = 1.12837916709551257389615890312154517;   /* 2/sqrt(pi) */
		protected static const M_SQRT2:Number    = 1.41421356237309504880168872420969808;   /* sqrt(2) */
		protected static const M_SQRT1_2:Number  = 0.707106781186547524400844362104849039;  /* 1/sqrt(2) */

		public function CCAction() {
			originalTarget_ = target_ = null;
			tag_ = 1;
		}

		public function get target() : *{
			return target_;
		}

		public function get originalTarget() : * {
			return originalTarget_;
		}

		public function get tag() : int {
			return tag_;
		}

		public function set tag(t:int) : void  {
			tag_ = t;
		}

		public function fmodf(v1:Number, v2:Number) : Number {
			return v1 % v2;
			/*
			if (v1 < 0 || v2 <= 0.05) {
				throw Error("");
			}
			return v1 - int(v1 / v2) * v2;
			*/
		}

		//override function 
		public function startWithTarget(aTarget:*) : void {
			if (target_ != null && target_ != aTarget) {
				throw Error("CCAction::startWithTarget error -- different target --");
			}
			//WriteLog("CCAction::startWithTarget");
			originalTarget_ = target_ = aTarget;
			//aTarget.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function stop() : void {
			//WriteLog("CCAction::stop");
			//target_.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			target_ = null;
		}

		public function isDone() : Boolean {
			//WriteLog("CCAction::isDone");
			return true;
		}

		public function step(dt:Number) : void {
			//WriteLog("CCAction::step. override me");
			//update(dt);
		}

		public function update(dt:Number) : void {
			//WriteLog("CCAction::update. override me");
		}
	}
}
