//
//  AppDelegate.m
//
//  Created by Leo Natan on 7/16/15.
//  Copyright © 2015 Leo Natan. All rights reserved.
//

#import "AppDelegate.h"
@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window.layer.speed = 0.2;
    
// Un-comment line below to enable Google Firebase
//    [FIRApp configure];

	return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13.0))
{
	// Called when a new scene session is being created.
	// Use this method to select a configuration to create the new scene with.
	return [[UISceneConfiguration alloc] initWithName:@"LNPopupExample" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0))
{
	// Called when the user discards a scene session.
	// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
	// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
