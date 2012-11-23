package org.cocos2d
{
	import org.cocos2d.*;

	public class CCAnimation extends CCObject {
		//NSString			*name_;
		private var delay_:Number;
		private var frames_:Array;

		public function CCAnimation(_delay:Number, _frames:Array = null) {
			frames_ = new Array;
			if (_frames) {
				for(var i:uint = 0; i < _frames.length; i++) {
					frames_.push(_frames[i]);
				}
			}
			delay_ = _delay;
		}

		public function get delay() : Number {
			return delay_;
		}

		public function set delay(d:Number) : void {
			delay_ = d;
		}

		public function get frames() : Array {
			return frames_;
		}

		public function addFrame(frame:CCSpriteFrame) : void {
			frames_.push(frame);
		}

		public function addFrameWithTexture(texture:CCTexture2D, rect:CCRect = null) : void {
			frames_.push(new CCSpriteFrame(texture, rect));
		}
	}
}

