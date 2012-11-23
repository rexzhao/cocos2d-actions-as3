package org.cocos2d 
{
	import flash.utils.Dictionary;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class CCSpriteFrameCache {
		private static var sharedSpriteFrameCache_:CCSpriteFrameCache;

		public static function sharedSpriteFrameCache() : CCSpriteFrameCache {
			if (!sharedSpriteFrameCache_) {
				sharedSpriteFrameCache_ = new CCSpriteFrameCache();
			}
			return sharedSpriteFrameCache_;
		}

		private var spriteFrames_:Dictionary;
		public function CCSpriteFrameCache() {
			spriteFrames_ = new Dictionary();
		}


		public function spriteFrameByName(name:String) : CCSpriteFrame {
			var frame:CCSpriteFrame = spriteFrames_[name];
			return frame;
		}

		public function addSpriteFrames(plist:XML, image:BitmapData = null, prefix:String = null) : void {
			var texture:CCTexture2D = new CCTexture2D();
			if (image) {
				texture.image = image;
			} else {
				texture.LoadRemoteTexture(plist.@imagePath);
			}

			if (prefix == null) {
				prefix = "";
			}

			var spriteList:XMLList = plist.sprite;
			for each(var sprite:XML in spriteList) {
				//var rect:CCRect = new CCRect(Number(sprite.@x), Number(sprite.@y),
				//		Number(sprite.@w), Number(sprite.@h));

				//var offset:CCPoint = new CCPoint(0,0);

				var oX:Number = Number(sprite.@oX);
				var oY:Number = Number(sprite.@oY);
				var oW:Number = Number(sprite.@oW);
				var oH:Number = Number(sprite.@oH);

				var w:Number = Number(sprite.@w);
				var h:Number = Number(sprite.@h);
				var x:Number = Number(sprite.@x);
				var y:Number = Number(sprite.@y);

				if (oW == 0) { oW = w; }
				if (oH == 0) { oH = h; }

				var frame:CCSpriteFrame = new CCSpriteFrame(texture,
						new CCRect(x, y, w, h),
						false,
						new CCPoint(oX, oY),
						new CCSize(oW, oH));
			
				var name:String = sprite.@n;
				spriteFrames_[prefix + name] = frame;
			}
		}
	}
}
