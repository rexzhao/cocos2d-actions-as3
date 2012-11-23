package org.cocos2d
{
	import org.cocos2d.*;

	public class CCSpriteFrame extends CCObject {
		public var rect:CCRect;
		public var texture:CCTexture2D;
		public var rotated:Boolean;
		public var offset:CCPoint;
		public var originalSize:CCSize;

		public static function frameWithTexture(texture:CCTexture2D, rect:CCRect = null,
				rotated:Boolean = false, offsat:CCPoint = null, originalSize:CCSize = null) : CCSpriteFrame {
			return new CCSpriteFrame(texture, rect, rotated, offsat, originalSize);
		}

		public function CCSpriteFrame(texture:CCTexture2D, rect:CCRect = null,
				rotated:Boolean = false, offsat:CCPoint = null, originalSize:CCSize = null) {
				this.texture = texture;
				this.rect = rect ? new CCRect(rect.x, rect.y, rect.width, rect.height) : null;
				this.rotated = rotated;
				this.offset = offsat;
				this.originalSize = originalSize;
		}
	}
}
