//
//  User.h
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UserType_Default,
    UserType_Company
} UserType;

@interface User : NSObject

@property (nonatomic) UserType userType;

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

- (void)setUserType:(UserType)userType;
+ (User*)initWithDictionary:(NSDictionary*)dictionary;

@end
