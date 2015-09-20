//
//  Feedback.h
//  Sniff
//
//  Created by Razvan Balint on 07/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feedback : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *businessOk;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
