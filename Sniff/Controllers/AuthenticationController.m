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

#pragma mark - User methods

- (User *)loggedUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"loggedUserKey"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return user;
}

- (void)setLoggedUserWithObject:(id)object {
    User *loggedUser;
    if ([object isKindOfClass:[NSDictionary class]]) {
        loggedUser = [User initWithDictionary:(NSDictionary*)object];
    } else if ([object isKindOfClass:[User class]]) {
        loggedUser = (User*)object;
    }
    
    if (loggedUser) {
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:loggedUser];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedObject forKey:@"loggedUserKey"];
        [defaults synchronize];
    }
}

- (void)registerUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_Register];
    [request addValue:user.first_name forParameter:@"nume"];
    [request addValue:user.last_name forParameter:@"prenume"];
    [request addValue:user.email forParameter:@"email"];
    [request addValue:user.password forParameter:@"pass1"];
    
    [request post:^(ServerRequest *serverRequest) {
        [[AuthenticationController sharedInstance] setLoggedUserWithObject:user];
        
        if (serverRequest.response) {
            completion(YES, @"Inregistrare cu succes", self);
        }
    }];
}

- (void)loginUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler) completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_Login];
    [request addValue:user.email forParameter:@"email"];
    [request addValue:user.password forParameter:@"pass"];
    
    [request post:^(ServerRequest *serverRequest) {
        
        if (serverRequest.responseData) {
            [[AuthenticationController sharedInstance] setLoggedUserWithObject:serverRequest.responseData];
            completion(YES, @"Autentificare cu succes", self);
        } else {
            completion(NO, @"A aparut o eroare. Incercati din nou", self);
        }
     }];
}

- (void)logout {
    
}

#pragma mark - AuthenticationVC methods

+ (void)addBlackTransluscentEffectOnView:(UIView*)view {
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    beView.frame = view.bounds;
    
    view.frame = view.bounds;
    view.backgroundColor = [UIColor clearColor];
    [view insertSubview:beView atIndex:0];
}

@end
