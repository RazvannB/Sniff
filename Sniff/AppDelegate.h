//
//  AppDelegate.h
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "EventsTableVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) LoginVC *loginViewController;
@property (strong, nonatomic) EventsTableVC *eventsViewController;

@end

