//
//  Feedback.m
//  Sniff
//
//  Created by Razvan Balint on 07/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "Feedback.h"

@implementation Feedback

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.id = dictionary[@"id"];
        self.event_id = dictionary[@"event_id"];
        self.name = dictionary[@"name"];
        self.message = dictionary[@"message"];
        self.date = dictionary[@"date"];
        self.grade = dictionary[@"grade"];
        self.businessOk = dictionary[@"businessOk"];
    }
    return self;
}

@end
