//
//  GameViewController.h
//  GameTest
//

//  Copyright (c) 2015 Jack Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

typedef NS_ENUM(NSInteger, Animation) {
	AnimationIdle = 0,
	AnimationWalk,
	AnimationRun,
	AnimationMax
};

@interface GameViewController : UIViewController

@end
