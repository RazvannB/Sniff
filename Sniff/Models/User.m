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

@end
