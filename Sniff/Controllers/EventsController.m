//
//  EventsController.m
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventsController.h"
#import "ServerRequest.h"

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

@end
