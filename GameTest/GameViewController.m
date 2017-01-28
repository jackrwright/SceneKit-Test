//
//  GameViewController.m
//  GameTest
//
//  Created by Jack Wright on 7/13/15.
//  Copyright (c) 2015 Jack Wright. All rights reserved.
//

#define kSingleSceneFile 0

#define kSceneName @"art.scnassets/Test_Character/idle.dae"
#define kAnimation @"idle-1"
#define kWalkKey @"walk"

#import "GameViewController.h"

int _animationSequence[] = {AnimationWalk, AnimationRun, AnimationWalk, AnimationIdle};

@implementation GameViewController {
	NSMutableArray *_animations;
	Animation _currentAnimation;
	NSInteger _currentAnimationIndex;
	NSArray *_animationKeys;
	NSString *_currentKey;
	NSString *_previousKey;
	SCNView *_scnView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_currentAnimationIndex = 0;
	
	_animations = [NSMutableArray array];

	// this needs to match the order defined for the Animation enum
	_animationKeys = @[@"idle", @"walk", @"run"];
	
	// create a new scene
	
	NSDictionary *options = @{SCNSceneSourceAnimationImportPolicyKey : SCNSceneSourceAnimationImportPolicyDoNotPlay};
	
	// load the main scene
	NSURL *theURL   = [[NSBundle mainBundle] URLForResource:@"art.scnassets/scene" withExtension:@"dae"];
	SCNScene *sceneDefault = [SCNScene sceneWithURL:theURL options:options error:nil];
	
	// load the idle scene
	theURL   = [[NSBundle mainBundle] URLForResource:@"art.scnassets/Test_Character/idle.dae" withExtension:nil];
	SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:theURL options:options];
	
	// instantiate the scene from the scene source
	SCNScene *sceneFromSource1 = [sceneSource sceneWithOptions:options error:nil];
	
	// retrieve the SCNView
	_scnView = (SCNView *)self.view;
	
	_scnView.scene = sceneDefault;
	
	_scnView.antialiasingMode = SCNAntialiasingModeMultisampling4X;
	
	// Merge the loaded scene into our main scene in order to
	//   place the character in our own scene
	for (SCNNode *child in sceneFromSource1.rootNode.childNodes) {
		[_scnView.scene.rootNode addChildNode:child];
	}
	
	[self loadAnimation:AnimationIdle inSceneNamed:@"art.scnassets/Test_Character/idle" withIdentifier:@"idle-1"];
	[self loadAnimation:AnimationWalk inSceneNamed:@"art.scnassets/Test_Character/walk2" withIdentifier:@"walk2-1"];
	[self loadAnimation:AnimationRun inSceneNamed:@"art.scnassets/Test_Character/run2" withIdentifier:@"run2-1"];
	
	// allows the user to manipulate the camera
    _scnView.allowsCameraControl = YES;
        
    // show statistics such as fps and timing information
    _scnView.showsStatistics = YES;

    // configure the view
    _scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer to the SCNView's list of camera controlling recognizers
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	NSMutableArray *gestureRecognizers = [NSMutableArray arrayWithObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:_scnView.gestureRecognizers];
    _scnView.gestureRecognizers = gestureRecognizers;
	
	_currentAnimationIndex = 0;
	_currentAnimation = _animationSequence[_currentAnimationIndex];
	[self playAnimation:_currentAnimation];
	
	
}

#pragma mark - Playing animations

- (void)playAnimation:(Animation)animation {

	// remove the previous animation
	if (_previousKey) {
		[_scnView.scene.rootNode removeAnimationForKey:_previousKey];
	}
	
	_previousKey = _currentKey;
	
	NSString *key = _animationKeys[animation];
	
	// Add the animation - it will start playing right away
	[_scnView.scene.rootNode addAnimation:_animations[animation] forKey:key];
	
	_currentKey = key;
}

#pragma mark - Animation loading

- (void)loadAnimation:(Animation)animation inSceneNamed:(NSString *)sceneName withIdentifier:(NSString *)animationIdentifier
{
	NSURL          *sceneURL        = [[NSBundle mainBundle] URLForResource:sceneName withExtension:@"dae"];
	SCNSceneSource *sceneSource     = [SCNSceneSource sceneSourceWithURL:sceneURL options:nil];
	CAAnimation    *animationObject = [sceneSource entryWithIdentifier:animationIdentifier withClass:[CAAnimation class]];
	
	// Store the animation for later use
	[_animations addObject:animationObject];
	
	// Whether or not the animation should loop
	if (animation == AnimationIdle || animation == AnimationRun || animation == AnimationWalk) {
		animationObject.repeatCount = MAXFLOAT;
	}
	
	animationObject.fadeInDuration = 0.25;
//	animationObject.fadeOutDuration = 0.25;
}


- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
	NSInteger maxSeq = sizeof(_animationSequence) / sizeof(NSInteger);
	_currentAnimationIndex++;
	if (_currentAnimationIndex >= maxSeq) {
		_currentAnimationIndex = 0;
	}
	_currentAnimation = _animationSequence[_currentAnimationIndex];
	
	[self playAnimation:_currentAnimation];
	
	return;
	
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
