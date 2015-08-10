//
//  User.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "User.h"

@implementation User

- (void)setUserType:(UserType)userType {
    _userType = userType;
    
    switch (userType) {
        case UserType_Default:
            break;
            
        case UserType_Company:
            break;
            
        default:
            break;
    }
}

+ (User*)initWithDictionary:(NSDictionary*)dictionary {
    User *user = [[User alloc] init];
    user.first_name = dictionary[@"first_name"];
    user.last_name = dictionary[@"last_name"];
    user.id = dictionary[@"id"];
    user.email = dictionary[@"email"];
    
    return user;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.first_name forKey:@"first_name"];
    [encoder encodeObject:self.last_name forKey:@"last_name"];
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.email forKey:@"email"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]) {
        self.first_name = [decoder decodeObjectForKey:@"first_name"];
        self.last_name = [decoder decodeObjectForKey:@"last_name"];
        self.id = [decoder decodeObjectForKey:@"id"];
        self.email = [decoder decodeObjectForKey:@"email"];
    }
    return self;
}

@end
