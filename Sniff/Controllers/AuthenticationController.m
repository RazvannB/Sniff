//
//  AuthenticationController.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "AuthenticationController.h"
#import "ServerRequest.h"

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

- (void)setLoggedUserWithDictionary:(NSDictionary*)dictionary {
    User *loggedUser = [User initWithDictionary:dictionary];    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:loggedUser];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"loggedUserKey"];
    [defaults synchronize];
}

- (void)registerUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_Register];
    [request addValue:user.first_name forParameter:@"nume"];
    [request addValue:user.last_name forParameter:@"prenume"];
    [request addValue:user.email forParameter:@"email"];
    [request addValue:user.password forParameter:@"pass1"];
    
    [request post:^(ServerRequest *serverRequest) {
        [[AuthenticationController sharedInstance] setLoggedUserWithDictionary:serverRequest.responseData];
        
        if (completion) {
            completion(YES, @"You have successfully registered", self);
        }
    }];
}

- (void)loginUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler) completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_Login];
    [request addValue:user.email forParameter:@"email"];
    [request addValue:user.password forParameter:@"pass"];
    
    [request post:^(ServerRequest *serverRequest) {
        [[AuthenticationController sharedInstance] setLoggedUserWithDictionary:serverRequest.responseData];
        
        if (completion) {
            completion(YES, @"You have successfully logged in", self);
        }
     }];
}

- (void)logout {
    
}

@end
