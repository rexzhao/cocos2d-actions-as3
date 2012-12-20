package
{
	import flash.events.*;

	import flash.net.URLRequest;
	import flash.display.LoaderInfo;
	import flash.display.Loader;

	import flash.display.Sprite;
	import org.cocos2d.*;
	import org.cocos2d.Actions.*;

	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#000000")]
	public class cocos2dMain extends Sprite {
		protected static function WriteLog(log:String) : void {
			Logger.getInstance().WriteLog(log);
		}

		public function cocos2dMain() {
			var request:URLRequest = new URLRequest("dayan.swf");
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,  onIOError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,         onLoaded);
			loader.load(request);
		}

		private function onIOError(event:IOErrorEvent) : void {
			WriteLog("load png failed");
		}

		private var node:CCNode;
		private function onLoaded(event:Event):void { 
			var loader:Loader = event.currentTarget.loader as Loader;
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);

			var _resource:Object = loader.content;
			var cache:CCSpriteFrameCache = CCSpriteFrameCache.sharedSpriteFrameCache();
			if (_resource) {
				cache.addSpriteFrames(_resource.xml, _resource.png.bitmapData);
                        } else {
				trace("failed");
				return;
			}

			var frames:Array = new Array();
			for(var i:int = 1; i <= 9; i++) {
				var n:String = "resource/fight/effect/dayan/0000" + i;
				var frame:CCSpriteFrame = cache.spriteFrameByName(n);
				frames.push(frame);
			}

			var animation:CCAnimation = new CCAnimation(0.12, frames);
			var animate:CCAnimate = new CCAnimate(animation);
	
			var sprite:CCSprite = new CCSprite();
			sprite.graphics.clear();
			sprite.graphics.lineStyle(1, 0x000000);
			sprite.graphics.drawRect(-50, -50, 100, 100);
			sprite.runAction(new CCRepeatForever(animate));

			node = new CCNode();
			node.addChild(sprite);
			node.x = 100;
			node.y = 100;
			addChild(node);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		private function onMouseDown(event:MouseEvent) : void {
			var dx:Number = event.stageX;
			var dy:Number = event.stageY;

			node.stopAllActions();
			node.runAction(new CCMoveTo(3, new CCPoint(dx, dy)));
		}
	}
}
