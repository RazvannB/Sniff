//
//  AuthenticationController.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "AuthenticationController.h"

@implementation AuthenticationController

+ (instancetype)sharedInstance {
    static AuthenticationController *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[AuthenticationController alloc] init];
        
    });
    return instance;
}

- (User *)loggedUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"loggedUserKey"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return user;
}

- (void)setLoggedUser:(User *)loggedUser {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:loggedUser];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"loggedUserKey"];
    [defaults synchronize];
}

- (void)registerUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler)completion {
    
}

- (void)loginUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler) completion {
    
}

- (void)logout {
    
}

@end
