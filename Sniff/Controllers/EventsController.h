//
//  EventsController.h
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@class EventsController;

typedef void(^EventsControllerCompletionHandler)(BOOL success, NSString *message, EventsController *completion);

@interface EventsController : NSObject

@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) NSDictionary *infoDictionary;
@property (nonatomic, strong) NSArray *feedbackArray;
@property (nonatomic, strong) NSArray *scheduleArray;

+ (instancetype)sharedInstance;
- (void)getPublicEventsWithCompletion:(EventsControllerCompletionHandler)completion;
- (void)getInfoForEvent:(Event*)event completion:(EventsControllerCompletionHandler)completion;
- (void)getFeedbackForEvent:(Event*)event completion:(EventsControllerCompletionHandler)completion;
- (void)sendFeedbackForEvent:(Event*)event username:(NSString*)username message:(NSString*)message completion:(EventsControllerCompletionHandler)completion;
- (void)getScheduleForEvent:(Event*)event completion:(EventsControllerCompletionHandler)completion;

@end
