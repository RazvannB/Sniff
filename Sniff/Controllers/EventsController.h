//
//  EventsController.h
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Event.h"

@class EventsController;

typedef void(^EventsControllerCompletionHandler)(BOOL success, NSString *message, EventsController *completion);

@interface EventsController : NSObject

@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) NSArray *favoriteEventsArray;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSDictionary *infoDictionary;
@property (nonatomic, strong) NSArray *feedbackArray;
@property (nonatomic, strong) NSArray *scheduleArray;

+ (instancetype)sharedInstance;

#pragma mark - Server request methods

- (void)getPublicEventsWithCompletion:(EventsControllerCompletionHandler)completion;
- (void)getInfoForEvent:(Event*)event completion:(EventsControllerCompletionHandler)completion;
- (void)getFeedbackForEvent:(Event*)event completion:(EventsControllerCompletionHandler)completion;
- (void)sendFeedbackForEvent:(Event*)event username:(NSString*)username message:(NSString*)message completion:(EventsControllerCompletionHandler)completion;
- (void)getScheduleForEvent:(Event*)event completion:(EventsControllerCompletionHandler)completion;
- (void)searchEventsWithTerm:(NSString *)term completion:(EventsControllerCompletionHandler)completion;

#pragma mark - Favorite events methods

- (void)addEventToFavorites:(Event *)event;
- (void)removeEventFromFavorites:(Event *)event;

#pragma mark - Navigation Bar Settings

+ (void)makeNavigationBarTranslucent:(UINavigationBar *)navigationBar;
+ (void)makeNavigationBarBackToDefault:(UINavigationBar *)navigationBar;

#pragma mark - EventsTableVC methods

+ (NSString *)getPredicateTermWithIndex:(NSInteger)index;

#pragma mark - EventsListTVC methods

+ (CAShapeLayer *)drawMaskForTextCellWithView:(UIView *)view;
+ (CGFloat)getTextCellHeightWithText:(NSString *)text;
+ (NSString *)changeTextCellDateFormatFrom:(NSString *)string;

#pragma mark - JoinButtonsView methods

+ (CAShapeLayer *)drawMaskForFavouriteButtonWithView:(UIView *)view button:(UIView *)button;

@end
