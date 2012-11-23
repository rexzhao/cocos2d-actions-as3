package org.cocos2d
{
	import flash.display.DisplayObjectContainer;

	public class CCDirector extends CCObject {
		//CC_GLVIEW	*openGLView_;
		private var view_:DisplayObjectContainer;

		// internal timer
		//NSTimeInterval animationInterval_;
		//NSTimeInterval oldAnimationInterval_;	

		//NSUInteger frames_;
		//NSUInteger totalFrames_;

		//ccTime accumDt_;
		//ccTime frameRate_;
	
		/* is the running scene paused */
		private var isPaused_:Boolean;

		/* The running scene */
		private var runningScene_:CCScene;

		/* This object will be visited after the scene. Useful to hook a notification node */
		//id notificationNode_;

		/* will be the next 'runningScene' in the next frame
		   nextScene is a weak reference. */
		private var nextScene_:CCScene;

		/* If YES, then "old" scene will receive the cleanup message */
		private var sendCleanupToScene_:Boolean;

		/* scheduled scenes */
		private var scenesStack_:Vector.<CCScene>; //NSMutableArray *scenesStack_;

		/* last time the main loop was updated */
		//struct timeval lastUpdate_;
		/* delta time since last tick to main loop */
		//ccTime dt;
		/* whether or not the next delta time will be zero */
		//BOOL nextDeltaTimeZero_;

		/* projection used */
		//ccDirectorProjection projection_;

		/* Projection protocol delegate */
		//id<CCProjectionProtocol>	projectionDelegate_;

		/* window size in points */
		//CGSize	winSizeInPoints_;

		/* window size in pixels */
		//CGSize	winSizeInPixels_;

		/* the cocos2d running thread */
		//NSThread	*runningThread_;

		// profiler

		public function CCDirector() {
			scenesStack_ = new Vector.<CCScene>();
			isPaused_ = false;
		}

		//@property (nonatomic,readonly) CCScene* runningScene;
		public function get runningScene() : CCScene {
			return runningScene_;
		}

		/** The FPS value */
		//@property (nonatomic,readwrite, assign) NSTimeInterval animationInterval;

		/** The OpenGLView, where everything is rendered */
		//@property (nonatomic,readwrite,retain) CC_GLVIEW *openGLView;
		public function get flashView() : DisplayObjectContainer {
			return view_;
		}

		public function set flashView(v:DisplayObjectContainer) : void {
			if(v != view_) {
				view_ = v;

				//v.stage.stageWidth;
				//v.stage.stageHeight;

				setStageDefaultValues();
			}
		}

		private function setStageDefaultValues() : void {

		}

		/** whether or not the next delta time will be zero */
		//@property (nonatomic,readwrite,assign) BOOL nextDeltaTimeZero;

		/** Whether or not the Director is paused */
		//@property (nonatomic,readonly) BOOL isPaused;
		public function get isPaused() : Boolean {
			return isPaused_;		
		}

		/** Sets an OpenGL projection
		  @since v0.8.2
		 */
		//@property (nonatomic,readwrite) ccDirectorProjection projection;
		/** How many frames were called since the director started */
		//@property (nonatomic,readonly) NSUInteger	totalFrames;

		/** Whether or not the replaced scene will receive the cleanup message.
		  If the new scene is pushed, then the old scene won't receive the "cleanup" message.
		  If the new scene replaces the old one, the it will receive the "cleanup" message.
		  @since v0.99.0
		 */
		//@property (nonatomic, readonly) BOOL sendCleanupToScene;

		/** This object will be visited after the main scene is visited.
		  This object MUST implement the "visit" selector.
		  Useful to hook a notification object, like CCNotifications (http://github.com/manucorporat/CCNotifications)
		  @since v0.99.5
		 */
		//@property (nonatomic, readwrite, retain) id	notificationNode;

		/** This object will be called when the OpenGL projection is udpated
		  and only when the kCCDirectorProjectionCustom projection is used.
		  @since v0.99.5
		 */
		//@property (nonatomic, readwrite, retain) id<CCProjectionProtocol> projectionDelegate;

		/** returns a shared instance of the director */

		private static var _instance:CCDirector;

		public static function sharedDirector() : CCDirector {
			if (_instance == null) {
				_instance = new CCDirector();
			}
			return _instance;
		}


		// Window size

		/** returns the size of the OpenGL view in points.
		  It takes into account any possible rotation (device orientation) of the window
		 */
		public function winSize() : CCSize {
			return new CCSize(view_.stage.stageWidth, view_.stage.stageHeight);
		}

		/** returns the size of the OpenGL view in pixels.
		  It takes into account any possible rotation (device orientation) of the window.
		  On Mac winSize and winSizeInPixels return the same value.
		 */
		//- (CGSize) winSizeInPixels;
		/** returns the display size of the OpenGL view in pixels.
		  It doesn't take into account any possible rotation of the window.
		 */
		//-(CGSize) displaySizeInPixels;

		/** changes the projection size */
		//-(void) reshapeProjection:(CGSize)newWindowSize;

		/** converts a UIKit coordinate to an OpenGL coordinate
		  Useful to convert (multi) touchs coordinates to the current layout (portrait or landscape)
		 */
		//-(CGPoint) convertToGL: (CGPoint) p;
		/** converts an OpenGL coordinate to a UIKit coordinate
		  Useful to convert node points to window points for calls such as glScissor
		 */
		//-(CGPoint) convertToUI:(CGPoint)p;

		/// XXX: missing description
		//-(float) getZEye;

		// Scene Management

		/**Enters the Director's main loop with the given Scene. 
		 * Call it to run only your FIRST scene.
		 * Don't call it if there is already a running scene.
		 */
		public function runWithScene(scene:CCScene) : void {
			Assert( scene != null, "Argument must be non-nil");
			Assert( runningScene_ == null, "You can't run an scene if another Scene is running. Use replaceScene or pushScene instead");
			pushScene(scene);
			//startAnimation();
		}

		/**Suspends the execution of the running scene, pushing it on the stack of suspended scenes.
		 * The new scene will be executed.
		 * Try to avoid big stacks of pushed scenes to reduce memory allocation. 
		 * ONLY call it if there is a running scene.
		 */
		//- (void) pushScene:(CCScene*) scene;
		public function pushScene(scene:CCScene) : void {
			Assert( scene != null, "Argument must be non-nil");
			scenesStack_.push(scene);
			nextScene_ = scene;
			sendCleanupToScene_ = false;
			setNextScene();
		}

		/**Pops out a scene from the queue.
		 * This scene will replace the running one.
		 * The running scene will be deleted. If there are no more scenes in the stack the execution is terminated.
		 * ONLY call it if there is a running scene.
		 */
		//- (void) popScene;
		public function popScene() : void {
			Assert( runningScene_ != null, "A running Scene is needed");

			scenesStack_.pop();
			var c:uint = scenesStack_.length;
			if( c == 0 ) {
				//TODO:no scene?
			} else {
				sendCleanupToScene_ = true;
				nextScene_ = scenesStack_[scenesStack_.length - 1];
				setNextScene();
			}
		}

		/** Replaces the running scene with a new one. The running scene is terminated.
		 * ONLY call it if there is a running scene.
		 */
		//-(void) replaceScene: (CCScene*) scene;
		public function replaceScene(scene:CCScene) : void {
			Assert( scene != null, "Argument must be non-nil");
			var index:uint = scenesStack_.length;

			sendCleanupToScene_ = true;
			scenesStack_.pop();
			scenesStack_.push(scene);
			nextScene_ = scene;	// nextScene_ is a weak ref

			setNextScene();
		}

		private function setNextScene() : void {
			//Class transClass = [CCTransitionScene class];
			//BOOL runningIsTransition = [runningScene_ isKindOfClass:transClass];
			//BOOL newIsTransition = [nextScene_ isKindOfClass:transClass];

			// If it is not a transition, call onExit/cleanup
			//if( ! newIsTransition ) {
			//	[runningScene_ onExit];

				// issue #709. the root node (scene) should receive the cleanup message too
				// otherwise it might be leaked.
			//	if( sendCleanupToScene_)
			//		[runningScene_ cleanup];
			//}

			//runningScene_ release];

			if (runningScene_) {
				runningScene_.onExit();
				if (sendCleanupToScene_) {
					runningScene_.cleanup();
				}
				view_.removeChild(runningScene_);
			}

			runningScene_ = nextScene_;
			nextScene_ = null;

			if (runningScene_) {
				view_.addChild(runningScene_);
				runningScene_.onEnter();
			}
			//if( ! runningIsTransition ) {
			//	[runningScene_ onEnter];
			//	[runningScene_ onEnterTransitionDidFinish];
			//}
		}

		/** Ends the execution, releases the running scene.
		  It doesn't remove the OpenGL view from its parent. You have to do it manually.
		 */
		//-(void) end;

		/** Pauses the running scene.
		  The running scene will be _drawed_ but all scheduled timers will be paused
		  While paused, the draw rate will be 4 FPS to reduce CPU consuption
		 */
		//-(void) pause;
		public function pause() : void {
			
		}

		/** Resumes the paused scene
		  The scheduled timers will be activated again.
		  The "delta time" will be 0 (as if the game wasn't paused)
		 */
		//-(void) resume;
		public function resume() : void {

		}

		/** Stops the animation. Nothing will be drawn. The main loop won't be triggered anymore.
		  If you wan't to pause your animation call [pause] instead.
		 */
		//-(void) stopAnimation;
		public function stopAnimation() : void {
			
		}

		/** The main loop is triggered again.
		  Call this function only if [stopAnimation] was called earlier
		  @warning Dont' call this function to start the main loop. To run the main loop call runWithScene
		 */
		//-(void) startAnimation;
		public function startAnimation() : void {
		}
	}
}
