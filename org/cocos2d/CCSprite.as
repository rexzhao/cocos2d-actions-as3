package org.cocos2d
{
	import flash.display.Sprite;
	import flash.display.BitmapData;

	import flash.events.*;

	import flash.geom.Matrix;
	
	public class CCSprite extends CCNode {
		private var displayFrame_:CCSpriteFrame;

		public static var forceSmoothing:Boolean = false;

		public var _smoothing:Boolean = false;

		public function set smoothing(v:Boolean) : void {
			if (v != _smoothing) {
				_smoothing = v;
				if (displayFrame &&
						displayFrame_.texture &&
						displayFrame_.texture.image) {
					adjectImage();
				}
			}
		}

		public function get smoothing() : Boolean {
			return _smoothing;
		}

		public function CCSprite(spriteFrame:CCSpriteFrame = null) {
			displayFrame_ = null;
			setDisplayFrame(spriteFrame);
		}

		public function get flipX() : Boolean {
			return this.transform.matrix.a == -1;
		}

		public function set flipX(b:Boolean) : void {
			var matrix:Matrix = this.transform.matrix;
			if (b) {
				matrix.a = -1;//沿x = 0轴翻转
			} else {
				matrix.a = 1;
			}
			this.transform.matrix = matrix;
		}

		public function get flipY() : Boolean {
			return this.transform.matrix.d == -1;
		}

		public function set flipY(b:Boolean) : void {
			var matrix:Matrix = this.transform.matrix;
			if (b) {
				matrix.d = -1;//沿x = 0轴翻转
			} else {
				matrix.d = 1;
			}
			this.transform.matrix = matrix;
		}

		public function get displayFrame() : CCSpriteFrame {
			return displayFrame_;
		}

		public function set displayFrame(newFrame:CCSpriteFrame) : void  {
			setDisplayFrame(newFrame);
		}

		private function adjectImage() : void {
			var image:BitmapData = displayFrame_.texture.image; 

			var rect:CCRect = displayFrame_.rect;
			if (rect == null) {
				rect = new CCRect(0, 0, image.width, image.height);
			}

			var offset:CCPoint = displayFrame_.offset;
			if (offset == null) {
				offset = new CCPoint(0, 0);
			}

			var originalSize:CCSize = displayFrame_.originalSize;
			if (originalSize == null) {
				originalSize = new CCSize(rect.width, rect.height);
			}

			var ptCent:CCPoint = new CCPoint(0, 0);
			ptCent.x = rect.x - offset.x + originalSize.width / 2;
			ptCent.y = rect.y - offset.y + originalSize.height / 2;

			this.graphics.clear();

			var matrix:Matrix = new Matrix(); 
			matrix.translate(-ptCent.x, -ptCent.y);
			this.graphics.beginBitmapFill(image, matrix, true, forceSmoothing ? true : _smoothing);
			this.graphics.drawRect(-ptCent.x + rect.x, -ptCent.y + rect.y, rect.width, rect.height);
			this.graphics.endFill();
		}

		public function setDisplayFrame(newFrame:CCSpriteFrame) : void {
			if (displayFrame_ && displayFrame_.texture) {
				displayFrame_.texture.unRegisterCallback(onTextureLoaded);
			}

			displayFrame_ = newFrame;

			if (displayFrame_) {
				if (displayFrame_.texture.image == null) {
					displayFrame_.texture.RegisterCallback(onTextureLoaded);
				} else {
					adjectImage();
				}
			
				//displayFrameContainer_.rotation = displayFrame_.rotation;

				/*
				if (this.flipX == displayFrame_.flipX) {
					this.flipX = false;
				} else {
					this.flipX = true;
				}

				if (this.flipY == displayFrame_.flipY) {
					this.flipY = false;
				} else {
					this.flipY = true;
				}
				*/

				//this.flipX = displayFrame_.flipX;
				//this.flipY = displayFrame_.flipY;
				/*
				if (displayFrame_.offset) {
					displayFrameContainer_.x = displayFrame_.offset.x;
					displayFrameContainer_.y = displayFrame_.offset.y;
				} else {
					displayFrameContainer_.x = 0;
					displayFrameContainer_.y = 0;
				}
				*/
			} else {
				this.graphics.clear();
			}
		}

		private function onTextureLoaded(event:Event) : void {
			displayFrame_.texture.unRegisterCallback(onTextureLoaded);
			if (displayFrame_.texture.image) {
				adjectImage();
			}
		}

		public function getDisplayFrame() : CCSpriteFrame {
			return displayFrame_;
		}

		private function RectEQ(r1:CCRect, r2:CCRect) : Boolean {
			if (r1 == null || r2 == null) {
				return false;
			}
			return (r1.x == r2.x 
				&& r1.y == r2.y 
				&& r1.width == r2.width 
				&& r1.height == r2.height);
		}

		public function isFrameDisplayed(frame:CCSpriteFrame) : Boolean {
			if (frame == null || displayFrame_ == null) {
				return false;
			}
			return frame.texture.image == displayFrame_.texture.image && RectEQ(frame.rect, displayFrame_.rect);
		}

		public function set scale(s:Number) : void {
			this.scaleX = this.scaleY = s;
		}

		public function get scale() : Number {
			return this.scaleX;
		}	
	}
}
