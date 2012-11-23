package org.cocos2d.Actions
{
	public class CCEaseInOut extends CCEaseRateAction {
		public function CCEaseInOut(action:CCActionInterval, rate:Number) {
			super(action, rate);
		}

		override public function update(t:Number) : void {
			var sign:int =1;
			var r:int = rate;
			if (r % 2 == 0)
				sign = -1;
			t *= 2;
			if (t < 1) 
				other.update(0.5 * Math.pow(t, rate));
			else
				other.update(sign*0.5 * (Math.pow(t-2, rate) + sign*2));	
		}

		override public function reverse() : CCActionInterval {
			return new CCEaseInOut(other.reverse(), rate);
		}
	}
}
