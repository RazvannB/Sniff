//
//  EventsController.h
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EventsController;

typedef void(^EventsControllerCompletionHandler)(BOOL success, NSString *message, EventsController *completion);

@interface EventsController : NSObject

@property (nonatomic, strong) NSArray *eventsArray;

+ (instancetype)sharedInstance;
- (void)getPublicEventsWithCompletion:(EventsControllerCompletionHandler)completion;

@end
