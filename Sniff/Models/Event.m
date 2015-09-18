//
//  Event.m
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "Event.h"

@implementation Event

+ (Event*)initWithDictionary:(NSDictionary*)dictionary {
    Event *event = [[Event alloc] init];
    event.id = dictionary[@"event_id"];
    event.project_name = dictionary[@"project_name"];
    event.categoryName = dictionary[@"categoryName"];
    event.first_name = dictionary[@"first_name"];
    event.last_name = dictionary[@"last_name"];
    event.org_name = dictionary[@"org_name"];
    event.address = dictionary[@"address"];
    event.start_date = dictionary[@"start_date"];
    event.end_date = dictionary[@"end_date"];
    event.location_name = dictionary[@"location_name"];
    event.color = dictionary[@"color"];
    event.FbPage = dictionary[@"FbPage"];
    event.DiffDate = dictionary[@"DiffDate"];
    return event;
}

@end
