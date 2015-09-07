//
//  ScheduleEvent.m
//  Sniff
//
//  Created by Razvan Balint on 18/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "ScheduleEvent.h"

@implementation ScheduleEvent

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.id = dictionary[@"id"];
        self.event_id = dictionary[@"event_id"];
        self.start_hour = dictionary[@"start_hour"];
        self.end_hour = dictionary[@"end_hour"];
        self.desc = dictionary[@"s_desc"];
        self.date = dictionary[@"s_date"];
    }
    return self;
}

@end
