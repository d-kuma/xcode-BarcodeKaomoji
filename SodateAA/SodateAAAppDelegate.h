//
//  SodateAAAppDelegate.h
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/05/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SodateAALogic.h"

@class SodateAAViewController;

@interface SodateAAAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SodateAAViewController *viewController;

@end
