//
//  EventsController.m
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventsController.h"
#import "ServerRequest.h"
#import "ScheduleEvent.h"
#import "Feedback.h"
#import "Colors.h"

@implementation EventsController

+ (instancetype)sharedInstance {
    static EventsController *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[EventsController alloc] init];
        
    });
    return instance;
}

#pragma mark - Server request methods

- (void)getPublicEventsWithCompletion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_GetPublicEvents];
    
    [request post:^(ServerRequest *serverRequest) {
        self.eventsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *eventDictionary in serverRequest.response) {
            Event *event = [Event initWithDictionary:eventDictionary];
            [self.eventsArray addObject:event];
        }
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
        NSMutableArray *feedbackMutableArray = [[NSMutableArray alloc] init];
        for (NSDictionary *feedbackDictionary in serverRequest.response) {
            Feedback *feedback = [[Feedback alloc] initWithDictionary:feedbackDictionary];
            [feedbackMutableArray addObject:feedback];
        }
        self.feedbackArray = feedbackMutableArray;

        if (completion) {
            completion(YES, @"Event info retrieved", self);
        }
    }];
}

- (void)sendFeedbackForEvent:(Event*)event username:(NSString*)username message:(NSString*)message completion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_SendFeedback];
    [request addValue:event.id forParameter:@"id"];
    [request addValue:message forParameter:@"msg"];
    if ([username isEqualToString:@"Anonim"]) {
        username = @"";
    }
    [request addValue:username forParameter:@"user"];

    [request post:^(ServerRequest *serverRequest) {
        
        if (serverRequest.response) {
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

- (void)searchEventsWithTerm:(NSString *)term completion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_SearchEvents];
    [request addValue:term forParameter:@"event_name"];
    
    [request post:^(ServerRequest *serverRequest) {
        self.searchArray = [[NSMutableArray alloc] init];
        for (NSDictionary *eventDictionary in serverRequest.response) {
            Event *event = [Event initWithDictionary:eventDictionary];
            [self.searchArray addObject:event];
        }
        if (completion) {
            completion(YES, @"Events retrieved", self);
        }
    }];

}

#pragma mark - Favorite events methods

- (void)addEventToFavorites:(Event *)event {
    
    if (!self.favoriteEventsArray) {
        self.favoriteEventsArray = [[NSArray alloc] init];
    }
    
    if (![[[EventsController sharedInstance].favoriteEventsArray valueForKey:@"id"]  containsObject:event.id]) {
        NSMutableArray *mutableArray = [self.favoriteEventsArray mutableCopy];
        [mutableArray addObject:event];
        self.favoriteEventsArray = [mutableArray copy];
    }
}

- (void)removeEventFromFavorites:(Event *)event {
    
    for (Event *favEvent in self.favoriteEventsArray) {
        if ([favEvent.id isEqualToString:event.id]) {
            NSMutableArray *mutableArray = [self.favoriteEventsArray mutableCopy];
            [mutableArray removeObject:favEvent];
            self.favoriteEventsArray = [mutableArray copy];
            break;
        }
    }
}

#pragma mark - Navigation Bar Settings

+ (void)makeNavigationBarTranslucent:(UINavigationBar *)navigationBar {
    
    [navigationBar setBackgroundImage:[UIImage new]
                        forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];
    navigationBar.translucent = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

+ (void)makeNavigationBarBackToDefault:(UINavigationBar *)navigationBar {
    
    [navigationBar setBackgroundImage:[UIImage new]
                        forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];
    navigationBar.translucent = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - EventsTableVC methods

+ (NSString *)getPredicateTermWithIndex:(NSInteger)index {
    
    NSString *predicateTerm = @"";
    switch (index) {
            
        case 1:
            predicateTerm = @"Educational";
            break;
            
        case 2:
            predicateTerm = @"Cariera";
            break;
            
        case 3:
            predicateTerm = @"Social";
            break;
            
        case 4:
            predicateTerm = @"Distractie";
            break;
            
        case 5:
            predicateTerm = @"Concurs";
            break;
            
        case 6:
            predicateTerm = @"Training";
            break;
            
        default:
            break;
    }
    
    return predicateTerm;
}

#pragma mark - EventsListTVC methods

+ (CAShapeLayer *)drawMaskForTextCellWithView:(UIView *)view {
    
    CAShapeLayer *viewMaskLayer = [[CAShapeLayer alloc] init];
    viewMaskLayer.fillColor = [[Colors customGrayColor] CGColor];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(7, CGRectGetMinY(view.frame))];
    [path addLineToPoint:CGPointMake(10 + 7, CGRectGetMidY(view.frame))];
    [path addLineToPoint:CGPointMake(7, CGRectGetMaxY(view.frame))];
    
    viewMaskLayer.path = path.CGPath;
    
    return viewMaskLayer;
}

+ (CGFloat)getTextCellHeightWithText:(NSString *)text {
    
    return [text boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 64, CGFLOAT_MAX)
                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}
                              context:nil].size.height;
}

+ (NSString *)changeTextCellDateFormatFrom:(NSString *)string {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [formatter dateFromString:string];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    return [formatter stringFromDate:dateFromString];
}

#pragma mark - JoinButtonsView methods

+ (CAShapeLayer *)drawMaskForFavouriteButtonWithView:(UIView *)view button:(UIView *)button {
    
    CAShapeLayer *viewMaskLayer = [[CAShapeLayer alloc] init];
    viewMaskLayer.fillColor = [[Colors customGrayColor] CGColor];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 64)];
    [path addLineToPoint:CGPointMake(0, 32)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(view.frame) - CGRectGetWidth(button.frame)/2 - 20, 32)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(view.frame) - CGRectGetWidth(button.frame)/2, 2)];
    
    [path addLineToPoint:CGPointMake(CGRectGetMidX(view.frame) + CGRectGetWidth(button.frame)/2, 2)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(view.frame) + CGRectGetWidth(button.frame)/2 + 20, 32)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(view.frame), 32)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(view.frame), 64)];
    
    viewMaskLayer.path = path.CGPath;
    
    return viewMaskLayer;
}

@end
