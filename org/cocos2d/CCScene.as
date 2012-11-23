package org.cocos2d
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import flash.net.URLRequest;
	import flash.display.Loader;

	public class CCScene extends CCNode {
		public function CCScene() {

		}

/*
		public function LoadRemoteScene(url:String) : void {
			var request:URLRequest = new URLRequest(url);

			var loader:flash.display.Loader = new flash.display.Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSceneLoaded);
			loader.load(request); 
			//notification_ = new EventDispatcher();
		}
	
		public static function sceneFromURL(url:String) : CCScene {
			var scene:CCScene = new CCScene();
			scene.LoadRemoteScene(url);
			return scene;
		}

		private function onIOError(e:IOErrorEvent) : void {
			//WriteLog("CCTexture2D::onIOError " + e.text)
			WriteLog("load scene failed");
		}

		private function onSceneLoaded(e:Event):void { 
			//WriteLog("CCTexture2D::onImageLoaded");
			var scene:CCScene = e.currentTarget.content as CCScene;

			addChild(scene);
			//notification_.dispatchEvent(new Event("texture_loaded"));
			//notification_ = null;
		}
*/

	};
}
