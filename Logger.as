package 
{
	public class Logger {
		private static var _instance:Logger = null;
		public static function getInstance() : Logger {
			if (_instance == null) {
				_instance = new Logger();
			}
			return _instance;
		}

		public function WriteLog(log:String):void {
			trace(log);
		}

		public function Logger() {
		}
	}
}	
