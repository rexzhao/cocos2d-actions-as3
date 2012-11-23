package org.cocos2d
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.events.*;
	//import flash.display.DisplayObject;
	//import flash.display.DisplayObjectContainer;

	import flash.geom.Matrix;
	
	public class CCSprite extends CCNode {
		private var displayFrame_:CCSpriteFrame;
		private var bitmap_:Bitmap;
		private var displayFrameContainer_:Sprite;

		public var _write_flip_log:Boolean;

		public function CCSprite(spriteFrame:CCSpriteFrame = null) {
			displayFrame_ = null;
			displayFrameContainer_= new Sprite;
			addChild(displayFrameContainer_);

			setDisplayFrame(spriteFrame);
		}

		public function removeAll() : void {
			
		};

		public function get flipX() : Boolean {
			return displayFrameContainer_.transform.matrix.a == -1;
		}

		public function set flipX(b:Boolean) : void {
			if(_write_flip_log) {
				WriteLog("set flipX " + b);
			}
			var matrix:Matrix = displayFrameContainer_.transform.matrix;
			if (b) {
				matrix.a = -1;//沿x = 0轴翻转
			} else {
				matrix.a = 1;
			}
			displayFrameContainer_.transform.matrix = matrix;
		}

		public function get flipY() : Boolean {
			return displayFrameContainer_.transform.matrix.d == -1;
		}

		public function set flipY(b:Boolean) : void {
			var matrix:Matrix = displayFrameContainer_.transform.matrix;
			if (b) {
				matrix.d = -1;//沿x = 0轴翻转
			} else {
				matrix.d = 1;
			}
			displayFrameContainer_.transform.matrix = matrix;
		}

		public function get displayFrame() : CCSpriteFrame {
			return displayFrame_;
		}

		public function set displayFrame(newFrame:CCSpriteFrame) : void  {
			setDisplayFrame(newFrame);
		}

		private function adjectImage() : void {
			var rect:CCRect = displayFrame_.rect;
			var offset:CCPoint = displayFrame_.offset;
			if (offset == null) {
				offset = new CCPoint(0, 0);
			}

			if (rect != null) {
				var originalSize:CCSize = displayFrame_.originalSize;
				if (originalSize == null) {
					originalSize = new CCSize(rect.width, rect.height);
				}

				var xx:CCPoint = new CCPoint(0,0);
				xx.x = originalSize.width  / 2 - offset.x - rect.width  / 2;
				xx.y = originalSize.height / 2 - offset.y - rect.height  / 2;

				bitmap_.scrollRect = rect;

				bitmap_.x = - rect.width / 2 - xx.x;
				bitmap_.y = - rect.height / 2 - xx.y;
			} else {
				bitmap_.x = - bitmap_.width / 2;
				bitmap_.y = - bitmap_.height / 2;
			}
		}

		public function setDisplayFrame(newFrame:CCSpriteFrame) : void {
			//WriteLog("CCSprite::setDisplayFrame");
			if (bitmap_ == null) {
				bitmap_ = new Bitmap();
				displayFrameContainer_.addChildAt(bitmap_, 0);
			}

			if (displayFrame_ && displayFrame_.texture) {
				displayFrame_.texture.unRegisterCallback(onTextureLoaded);
			}

			displayFrame_ = newFrame;

			if (displayFrame_) {
				bitmap_.bitmapData = displayFrame_.texture.image; 
				if (bitmap_.bitmapData == null) {
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
				displayFrameContainer_.x = 0;
				displayFrameContainer_.y = 0;
			} else {
				bitmap_.bitmapData = null;
			}
		}

		private function onTextureLoaded(event:Event) : void {
			displayFrame_.texture.unRegisterCallback(onTextureLoaded);
			bitmap_.bitmapData = displayFrame_.texture.image; //drawInRect(displayFrame_.rect);
			adjectImage();
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
