//
//  Cocos2DSimpleGameAppDelegate.m
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/21/10.
//  Copyright Ray Wenderlich 2010. All rights reserved.
//

#import "cocos2d.h"

#import "Cocos2DSimpleGameAppDelegate.h"
#import "GameConfig.h"
#import "HelloWorldScene.h"
#import "RootViewController.h"
#import "Level.h"
#import "GameOverScene.h"
#import "NewLevelScene.h"
#import "Playtomic.h"

@implementation Cocos2DSimpleGameAppDelegate

@synthesize window;
@synthesize curLevelIndex = _curLevelIndex;
@synthesize mainScene = _mainScene;
@synthesize gameOverScene = _gameOverScene;
@synthesize newLevelScene = _newLevelScene;
@synthesize levels = _levels;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[glView swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Load levels
    self.levels = [[[NSMutableArray alloc] init] autorelease];
    Level *level1 = [[[Level alloc] initWithLevelNum:1 spawnRate:1 bgImageName:@"bg.png"] autorelease];
    Level *level2 = [[[Level alloc] initWithLevelNum:2 spawnRate:2 bgImageName:@"bg2.png"] autorelease];

 	[_levels addObject:level1];
    [_levels addObject:level2];

	
    self.curLevelIndex = 0;
    
    self.mainScene = [HelloWorldScene scene];
    self.newLevelScene = [NewLevelScene node];
    self.gameOverScene = [GameOverScene node];
    
    [_mainScene.layer reset];
    [[CCDirector sharedDirector] runWithScene:_mainScene];	

	// Playtomic
	[[Playtomic alloc] initWithGameId:5091 andGUID:@"9c1c51dd5f564cc0" andAPIKey:@"28c07287469242bfa94b1983cc9c44"]; 
	[[Playtomic Log] view];
	
}

- (Level *)curLevel {
    return [_levels objectAtIndex:_curLevelIndex];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)loadGameOverScene {
    [_gameOverScene.layer.label setString:@"You Lose :["];
    [_gameOverScene.layer reset];
    [[CCDirector sharedDirector] replaceScene:_gameOverScene];

	// Track level loss (as custom metric)
	[[Playtomic Log] customMetricName:@"YouLose" andGroup:nil andUnique:NO];

}

- (void)loadWinScene {
    [_gameOverScene.layer.label setString:@"You Win!"];
    [_gameOverScene.layer reset];
    [[CCDirector sharedDirector] replaceScene:_gameOverScene];

	// Track level win (as custom metric)
	[[Playtomic Log] customMetricName:@"YouWin" andGroup:nil andUnique:NO];
}

- (void)loadNewLevelScene {
    [_newLevelScene.layer reset];
    [[CCDirector sharedDirector] replaceScene:_newLevelScene];
}

- (void)nextLevel {
    [_mainScene.layer reset];
    [[CCDirector sharedDirector] replaceScene:_mainScene];
}

- (void)restartGame {
    _curLevelIndex = 0;
    [self nextLevel];
}

- (void)levelComplete {    

	// Track level restart
	[[Playtomic Log] levelCounterMetricName:@"LevelComplete" andLevelNumber:_curLevelIndex andUnique:NO];
    
    _curLevelIndex++;
    if (_curLevelIndex >= [_levels count]) {
        _curLevelIndex = 0;
        [self loadWinScene];
    } else {
        [self loadNewLevelScene];
    }
	
    
}

- (void)dealloc {
    self.mainScene = nil;
    self.gameOverScene = nil;    
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
