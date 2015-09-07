//
//  EventsController.m
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventsController.h"
#import "ServerRequest.h"
#import "AuthenticationController.h"
#import "ScheduleEvent.h"

@implementation EventsController

+ (instancetype)sharedInstance {
    static EventsController *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[EventsController alloc] init];
        
    });
    return instance;
}

- (void)getPublicEventsWithCompletion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_GetPublicEvents];
    
    [request post:^(ServerRequest *serverRequest) {
        self.eventsArray = [[NSArray alloc] initWithArray:serverRequest.response];
        
        if (completion) {
            completion(YES, @"Events retrieved", self);
        }
    }];
}

- (void)getInfoForEvent:(Event*)event completion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_GetEventInfo];
    [request addValue:event.id forParameter:@"id"];
    
    [request post:^(ServerRequest *serverRequest) {
        self.infoDictionary = [[NSDictionary alloc] initWithDictionary:serverRequest.response[0]];
        
        if (completion) {
            completion(YES, @"Event info retrieved", self);
        }
    }];
}

- (void)getFeedbackForEvent:(Event*)event completion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_GetApprovedFeedback];
    [request addValue:event.id forParameter:@"id"];
    
    [request post:^(ServerRequest *serverRequest) {
        self.feedbackDictionary = [[NSDictionary alloc] initWithDictionary:serverRequest.response[0]];
        
        if (completion) {
            completion(YES, @"Event info retrieved", self);
        }
    }];
}

- (void)sendFeedbackForEvent:(Event*)event message:(NSString*)message completion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_SendFeedback];
    [request addValue:event.id forParameter:@"id"];
    [request addValue:message forParameter:@"msg"];
    NSString *username = @"";
    if ([AuthenticationController sharedInstance].loggedUser.id) {
        username = [AuthenticationController sharedInstance].loggedUser.first_name;
    }
    [request addValue:username forParameter:@"user"];

    [request post:^(ServerRequest *serverRequest) {
        
        if (completion) {
            completion(YES, @"Event feedback sent", self);
        }
    }];
}

- (void)getScheduleForEvent:(Event*)event completion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_GetSchedule];
    [request addValue:event.id forParameter:@"id"];
    
    [request post:^(ServerRequest *serverRequest) {
        NSMutableArray *scheduleMutableArray = [[NSMutableArray alloc] init];
        for (NSDictionary *scheduleDictionary in serverRequest.response) {
            ScheduleEvent *event = [[ScheduleEvent alloc] initWithDictionary:scheduleDictionary];
            [scheduleMutableArray addObject:event];
        }
        self.scheduleArray = scheduleMutableArray;
        if (completion) {
            completion(YES, @"Event schedule retrieved", self);
        }
    }];
}

@end
