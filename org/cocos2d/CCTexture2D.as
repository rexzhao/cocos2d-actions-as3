package org.cocos2d
{
	import org.cocos2d.*;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import flash.display.Loader;
	import flash.net.URLRequest;

	public class CCTexture2D extends CCObject {
		private var image_:BitmapData;
		private var image_name_:String = "";
		private var notification_:EventDispatcher;

		/** Intializes with a texture2d with data */
		public function CCTexture2D(image:BitmapData = null) {
			image_ = image;
		}

		public function get image_name() : String {
			return image_name_;
		}

		/** load image from remote **/
		public function LoadRemoteTexture(url:String) : void {
			//trace("CCTexture2D loadRemoteTexture " + url);

			var request:URLRequest = new URLRequest(url);

			var loader:flash.display.Loader = new flash.display.Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			loader.load(request); 

			image_name_ = url;
		}

		public function RegisterCallback(cb:Function) : void {
			if (notification_ == null) {
				notification_ = new EventDispatcher();
			}
			notification_.addEventListener("texture_loaded", cb);
		}

		public function unRegisterCallback(cb:Function) : void {
			if (notification_) {
				notification_.removeEventListener("texture_loaded", cb);
			}
		}

		private function onIOError(e:IOErrorEvent) : void {
			//WriteLog("CCTexture2D::onIOError " + e.text)
			trace("load image : " + image_name + " failed");
		}

		private function onImageLoaded(e:Event):void { 
			//WriteLog("CCTexture2D::onImageLoaded");
			var bitmap:Bitmap = e.currentTarget.content as Bitmap;
			image_ = bitmap.bitmapData;

			if (notification_) {
				notification_.dispatchEvent(new Event("texture_loaded"));
				notification_ = null;
			}
		}

		public static function textureFromURL(url:String) : CCTexture2D {
			var texture:CCTexture2D = new CCTexture2D();
			texture.LoadRemoteTexture(url);
			return texture;
		}

		/** These functions are needed to create mutable textures */
		//public function releaseData:(void*)data;

		//- (void*) keepData:(void*)data length:(NSUInteger)length;

		/** width in pixels */
		//@property(nonatomic,readonly) NSUInteger pixelsWide;
		public function get pixelsWide() : uint {
			return image_.width;
		}

		public function get width() : uint {
			return image_.width;
		}

		/** hight in pixels */
		//@property(nonatomic,readonly) NSUInteger pixelsHigh;
		public function get pixelsHigh() : uint {
			return image_.height;
		}

		public function get height() : uint {
			return image_.height;
		}

		public function get image() : BitmapData {
			return image_;
		}

		public function set image(img:BitmapData) : void {
			image_ = img;
		}

		/** texture name */
		//@property(nonatomic,readonly) GLuint name;

		/** returns content size of the texture in pixels */
		//@property(nonatomic,readonly, nonatomic) CGSize contentSizeInPixels;

		/** texture max S */
		//@property(nonatomic,readwrite) GLfloat maxS;
		/** texture max T */
		//@property(nonatomic,readwrite) GLfloat maxT;
		/** whether or not the texture has their Alpha premultiplied */
		//@property(nonatomic,readonly) BOOL hasPremultipliedAlpha;
		
		public function drawInRect(rect:CCRect) : BitmapData {
			if (image == null) {
				return null;
			}

			if (rect == null) {
				return image;
			} else {
				//WriteLog("CCTexture2D::drawInRect " + rect.x + "," + rect.y);
				var bmd:BitmapData = new BitmapData(rect.width, rect.height);
				bmd.copyPixels(image, rect, new CCPoint(0, 0));
				return bmd;
			}
		}
	}
}
