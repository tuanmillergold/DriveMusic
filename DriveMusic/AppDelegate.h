//
//  AppDelegate.h
//  DriveMusic
//
//  Created by Jeames Gillett on 21/7/18.
//  Copyright © 2018 BLM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OIDAuthorizationFlowSession;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong, nullable) id<OIDAuthorizationFlowSession> currentAuthorizationFlow;


@end

