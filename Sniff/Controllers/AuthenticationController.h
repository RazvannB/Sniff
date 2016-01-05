//
//  AuthenticationController.h
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Event.h"

@class AuthenticationController;

typedef void(^AuthenticationControllerCompletionHandler)(BOOL success, NSString *message, AuthenticationController *completion);

@interface AuthenticationController : NSObject

@property (nonatomic, strong) User *loggedUser;
@property (nonatomic, strong) NSArray *favoriteEventsArray;

+ (instancetype)sharedInstance;
- (void)setLoggedUserWithObject:(id)object;
- (void)registerUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler)completion;
- (void)loginUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler) completion;
- (void)logout;

@end
