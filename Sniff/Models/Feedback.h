//
//  Feedback.h
//  Sniff
//
//  Created by Razvan Balint on 07/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feedback : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *comment;

@end
