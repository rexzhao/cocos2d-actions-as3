package org.cocos2d
{
	public class CCObject {

		protected static function WriteLog(log:String) : void {
			//Logger.getInstance().WriteLog(log);
		}

		protected static function Assert(v:Boolean, str:String) : void {
			if (!v) {
				throw Error(str);
			}
		}

		public function CCObject() {

		}
	}
}
