//
//  AuthenticationController.h
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class AuthenticationController;

typedef void(^AuthenticationControllerCompletionHandler)(BOOL success, NSString *message, AuthenticationController *completion);

@interface AuthenticationController : NSObject

@property (nonatomic, strong) User *loggedUser;

+ (instancetype)sharedInstance;
- (void)setLoggedUserWithDictionary:(NSDictionary*)dictionary;
- (void)registerUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler)completion;
- (void)loginUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler) completion;
- (void)logout;

@end
