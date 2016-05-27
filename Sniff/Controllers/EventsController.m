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
#import "AuthenticationController.h"

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
        if ([serverRequest.response isKindOfClass:[NSArray class]] &&
            [serverRequest.response count]) {
            
            self.eventsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *eventDictionary in serverRequest.response) {
                Event *event = [Event initWithDictionary:eventDictionary];
                [self.eventsArray addObject:event];
            }
        }
        
        if (completion) {
            completion(YES, @"Events retrieved", self);
        }
    }];
}

- (void)getFavoriteEventsWithCompletion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_GetFavouriteEvents];
    [request addValue:[AuthenticationController sharedInstance].loggedUser.id forParameter:@"id"];
    
    [request post:^(ServerRequest *serverRequest) {
        if ([serverRequest.response isKindOfClass:[NSArray class]] &&
            [serverRequest.response count]) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *eventDictionary in serverRequest.response) {
                Event *event = [Event initWithDictionary:eventDictionary];
                [tempArray addObject:event];
            }
            self.favoriteEventsArray = [[NSArray alloc] initWithArray:tempArray];
        }
        
        if (completion) {
            completion(YES, @"Favorite events retrieved", self);
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
        if ([serverRequest.response isKindOfClass:[NSArray class]]) {
            for (NSDictionary *eventDictionary in serverRequest.response) {
                Event *event = [Event initWithDictionary:eventDictionary];
                [self.searchArray addObject:event];
            }
        }
        if (completion) {
            completion(YES, @"Events retrieved", self);
        }
    }];

}

- (void)addOrRemoveEvent:(Event *)event fromFavoritesWithCompletion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_JoinEvent];
    [request addValue:[AuthenticationController sharedInstance].loggedUser.id forParameter:@"user_id"];
    [request addValue:event.id forParameter:@"event_id"];
    
    BOOL eventIsFavourite = [[self.favoriteEventsArray valueForKey:@"id"] containsObject:event.id];
    [request addValue:[@(eventIsFavourite) stringValue] forParameter:@"action"];
    
    [request post:^(ServerRequest *serverRequest) {
        [self getFavoriteEventsWithCompletion:nil];
        if (completion) {
            completion(YES, @"Event modified", self);
        }
    }];
}

- (void)checkIfEvent:(Event *)event isFavoriteWithCompletion:(EventsControllerCompletionHandler)completion {
    ServerRequest *request = [ServerRequest requestWithFunction:ServerRequestType_CheckIfJoined];
    [request addValue:[AuthenticationController sharedInstance].loggedUser.id forParameter:@"user_id"];
    [request addValue:event.id forParameter:@"event_id"];
    
    [request post:^(ServerRequest *serverRequest) {
        
    }];
}

- (void)saveEventInCalendar:(Event *)event completion:(EventsControllerCompletionHandler)completion {
    self.eventStore = [[EKEventStore alloc] init];
    __block EKCalendar *homeCalendar = nil;
    
    [self.eventStore
     requestAccessToEntityType:EKEntityTypeEvent
     completion:^(BOOL granted, NSError * _Nullable error) {
         
         if (granted && !error) {
             NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
             for (EKCalendar *calendar in allCalendars) {
                 if ([calendar.title isEqualToString:@"Home"]) {
                     homeCalendar = calendar;
                 }
             }
             
             NSString *errorMessage;
             if (homeCalendar) {
                 
                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                 [formatter setDateFormat:@"yyyy-MM-dd"];
                 
                 EKEvent *newEvent = [EKEvent eventWithEventStore:self.eventStore];
                 newEvent.calendar = homeCalendar;
                 newEvent.title = event.project_name;
                 newEvent.startDate = [formatter dateFromString:event.start_date];
                 newEvent.endDate = [formatter dateFromString:event.end_date];
                 
                 if ([self checkEvent:newEvent localCalendar:homeCalendar]) {
                     
                     errorMessage = @"Evenimentul exista deja in calendarul dumneavoastra!";
                     
                 } else {
                     
                     NSError *newEventError;
                     if ([self.eventStore saveEvent:newEvent span:EKSpanFutureEvents commit:YES error:&newEventError]) {
                         
                         NSLog(@"Eveniment salvat: %@", newEvent.title);
                         errorMessage = @"";
                         
                     } else {
                         
                         NSLog(@"Eroare salvare eveniment: %@", [error localizedDescription]);
                         errorMessage = @"A aparut o problema. Evenimentul nu a putut fi salvat!";
                         
                     }
                 }
                 
             } else {
                 
                 errorMessage = @"A aparut o problema. Evenimentul nu a putut fi salvat!";
             }
             
             if (completion) {
                 completion([errorMessage length] ? NO : YES, errorMessage, self);
             }
         }
     }];
}

- (BOOL)checkEvent:(EKEvent *)event localCalendar:(EKCalendar *)calendar {
    
    int yearSeconds = 365 * (60 * 60 * 24);
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-yearSeconds]
                                                                      endDate:[NSDate dateWithTimeIntervalSinceNow:yearSeconds]
                                                                    calendars:@[calendar]];
    
    NSArray *localEventsArray = [self.eventStore eventsMatchingPredicate:predicate];
    return [[localEventsArray valueForKey:@"title"] containsObject:event.title];
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

#pragma mark - Feedback methods

+ (CAShapeLayer *)drawMaskForSendFeedbackView:(UIView *)view {
    
    CAShapeLayer *viewMaskLayer = [[CAShapeLayer alloc] init];
    viewMaskLayer.fillColor = [[Colors customGrayColor] CGColor];
    viewMaskLayer.strokeColor = [[UIColor whiteColor] CGColor];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(-1, 0)];
    [path addLineToPoint:CGPointMake(-1, CGRectGetMaxY(view.frame))];
    
    for (float i = 0; i < CGRectGetWidth([[UIScreen mainScreen] bounds])/40; i++) {
        [path addLineToPoint:CGPointMake(i * 40 + 20, CGRectGetMaxY(view.frame) - 10)];
        [path addLineToPoint:CGPointMake( (i + 1) * 40, CGRectGetMaxY(view.frame))];
    }
    
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(view.frame), 0)];
    
    viewMaskLayer.path = path.CGPath;
    
    return viewMaskLayer;
}

+ (CAShapeLayer *)drawMaskForFeedbackView:(UIView *)view {
    
    CAShapeLayer *viewMaskLayer = [[CAShapeLayer alloc] init];
    viewMaskLayer.fillColor = [[UIColor whiteColor] CGColor];
    
    UIBezierPath *maskPath = [[UIBezierPath alloc] init];
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(20.0, 20.0)];
    
    viewMaskLayer.frame = view.bounds;
    viewMaskLayer.path = maskPath.CGPath;
    
    return viewMaskLayer;
}

+ (NSArray *)sortFeedbackArray:(NSArray *)array {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return
    [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [formatter dateFromString:[(Feedback *)obj1 date]];
        NSDate *date2 = [formatter dateFromString:[(Feedback *)obj2 date]];
        return [date1 compare:date2];
    }];
}

@end
