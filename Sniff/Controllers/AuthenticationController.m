//
//  AuthenticationController.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "AuthenticationController.h"
#import "ServerRequest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation AuthenticationController

+ (instancetype)sharedInstance {
    static AuthenticationController *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[AuthenticationController alloc] init];
        
    });
    return instance;
}

+ (NSString *)uuid {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

+ (NSString *)hashString:(NSString *)string withKey:(NSString *)key {
    if ([string length] == 0 || [key length] == 0)
        return nil;
    const char *stringVars = [string UTF8String];
    const char *keyVars = [key UTF8String];
    char result[3*strlen(stringVars) + 1];
    result[3*strlen(stringVars)] = '\0';
    for (int i=0; i<strlen(stringVars); i++) {
        result[3*i] = stringVars[i];
        result[3*i+1] = 'a' + stringVars[i] - '0';
        result[3*i+2] = keyVars[i%(strlen(keyVars))];
    }
    return [AuthenticationController md5:result];
}

+ (NSString *)md5:(char*)input {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( input, (CC_LONG)strlen(input), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (BOOL)verifyEmail:(NSString *)email {
    
    NSString *regExPattern =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSUInteger regExMatches = [regEx numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
    
    if (regExMatches == 0) {
        return NO;
    } else
        return YES;
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
    
    [request postHTTP:^(ServerRequest *serverRequest) {
        if (serverRequest.response) {
            [[AuthenticationController sharedInstance] setLoggedUserWithObject:user];
            completion(YES, @"Inregistrare cu succes", self);
        } else {
            if ([serverRequest.responseMessage isEqualToString:@"mobile_user_success"]) {
                completion(YES, @"Inregistrare cu success", self);
            } else if ([serverRequest.responseMessage isEqualToString:@"Exista"]) {
                completion(NO, @"Exista deja un cont cu aceasta adresa de email", self);
            } else {
                completion(NO, @"A aparut o eroare", self);
            }
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
            if (completion) {
                completion(YES, @"Autentificare cu succes", self);
            }
        } else if (completion) {
            if ([serverRequest.responseMessage isEqualToString:@"no_pass"] || [serverRequest.responseMessage isEqualToString:@"no_user"]) {
                completion(NO, @"Emailul sau parola sunt gresite", self);
            } else {
                completion(NO, @"A aparut o eroare. Incercati din nou", self);
            }
        }
     }];
}

- (void)editUser:(User *)user withCompletion:(AuthenticationControllerCompletionHandler)completion {
    
}

- (void)logout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"loggedUserKey"];
    [defaults synchronize];
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
