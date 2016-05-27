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
@property (strong, nonatomic) EventsTableVC *eventsViewController;
@property(nonatomic, readonly, strong) NSString *registrationKey;
@property(nonatomic, readonly, strong) NSString *messageKey;
@property(nonatomic, readonly, strong) NSString *gcmSenderID;
@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;

@end

