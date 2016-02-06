//
//  AuthenticationController.h
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "Event.h"

@class AuthenticationController;

typedef void(^AuthenticationControllerCompletionHandler)(BOOL success, NSString *message, AuthenticationController *completion);

@interface AuthenticationController : NSObject

@property (nonatomic, strong) User *loggedUser;
@property (nonatomic, strong) NSArray *favoriteEventsArray;

+ (instancetype)sharedInstance;
+ (NSString *)uuid;
+ (NSString *)hashString:(NSString *)string withKey:(NSString *)key;
+ (BOOL)verifyEmail:(NSString *)email;

#pragma mark - User methods

- (void)setLoggedUserWithObject:(id)object;
- (void)registerUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler)completion;
- (void)loginUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler)completion;
- (void)editUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler)completion;
- (void)logout;

#pragma mark - AuthenticationVC methods

+ (void)addBlackTransluscentEffectOnView:(UIView*)view;

@end
