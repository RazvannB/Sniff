//
//  ScheduleEvent.h
//  Sniff
//
//  Created by Razvan Balint on 18/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleEvent : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *start_hour;
@property (nonatomic, strong) NSString *end_hour;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *desc;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
