//
//  ScheduleTableVC.m
//  Sniff
//
//  Created by Razvan Balint on 18/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "ScheduleTableVC.h"
#import "EventsController.h"
#import "MBProgressHUD.h"
#import "ScheduleEvent.h"
#import "ScheduleTVC.h"
#import "Colors.h"

@interface ScheduleTableVC ()

@end

@implementation ScheduleTableVC

BOOL isCheckingOnlineForSchedule;

- (id)initWithEvent:(Event *)event {
    if (self = [super init]) {
        self.event = event;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Program";
}

- (NSArray *)scheduleArray {
    if (!_scheduleArray || ![_scheduleArray count]) {
        self.scheduleArray = [EventsController sharedInstance].scheduleArray;
        if ((!_scheduleArray || ![_scheduleArray count]) && !isCheckingOnlineForSchedule) {
            [self checkServerForUpdatesWithIndicator:YES];
        }
    }
    
    return _scheduleArray;
}

- (void)checkServerForUpdatesWithIndicator:(BOOL)indicator {
    isCheckingOnlineForSchedule = YES;
    MBProgressHUD *progressHud;
    if (indicator) {
        progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        progressHud.labelText = @"Se descarca programul...";
    }
    
    [[EventsController sharedInstance] getScheduleForEvent:self.event
                                                completion:^(BOOL success, NSString *message, EventsController *completion) {
                                                    if (success) {
                                                        
                                                        [self.tableView reloadData];
                                                    } else {
                                                        [[[UIAlertView alloc] initWithTitle:nil
                                                                                    message:@"Este o problema cu descarcarea programului"
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil] show];
                                                    }
                                                    if (indicator) {
                                                        [progressHud hide:YES];
                                                    }
                                                    isCheckingOnlineForSchedule = NO;
                                                }];
}

- (NSDate*)getHourFromString:(NSString*)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter dateFromString:string];
}

- (NSDate*)getDateFromString:(NSString*)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:string];
}

- (NSString*)reverseDate:(NSString*)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    return [formatter stringFromDate:[self getDateFromString:string]];
}

//- (NSArray *)sortScheduleEventsByDateInArray:(NSArray *)scheduleArray {
//    
//    scheduleArray = [scheduleArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        obj1 = [self getDateFromString: [(ScheduleEvent*)obj1 date]];
//        obj2 = [self getDateFromString: [(ScheduleEvent*)obj2 date]];
//        if ([obj1 isEqualToDate:obj2]) {
//            obj1 = [self getHourFromString: [(ScheduleEvent*)obj1 start_hour]];
//            obj2 = [self getHourFromString: [(ScheduleEvent*)obj2 start_hour]];
//        }
//        return [obj1 compare:obj2];
//    }];
//    
//    return scheduleArray;
//}

- (NSArray *)sortDatesInArray:(NSArray *)array {
    
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        obj1 = [self getDateFromString:obj1];
        obj2 = [self getDateFromString:obj2];
        return [obj1 compare:obj2];
    }];
    
    return array;
}

- (NSMutableDictionary *)scheduleDictionary {
    
    if (!_scheduleDictionary || [_scheduleDictionary count] == 0) {
        _scheduleDictionary = [[NSMutableDictionary alloc] init];
        for (ScheduleEvent* event in self.scheduleArray) {
            if (!_scheduleDictionary[event.date]) {
                NSMutableArray *hoursArray = [[NSMutableArray alloc] init];
                [hoursArray addObject:event];
                _scheduleDictionary[event.date] = hoursArray;
            } else {
                [_scheduleDictionary[event.date] addObject:event];
            }
        }
    }
    return _scheduleDictionary;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [EventsController sharedInstance].scheduleArray = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.scheduleDictionary.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *currentDate = self.scheduleDictionary.allKeys[section];
    return [self.scheduleDictionary[currentDate] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *scheduleCellIdentifier = @"ScheduleTVC";
    
    NSArray *sortedDates = [self sortDatesInArray:self.scheduleDictionary.allKeys];
    NSArray *currentDate = sortedDates[indexPath.section];
    ScheduleEvent *currentScheduleEvent = self.scheduleDictionary[currentDate][indexPath.row];
    
    ScheduleTVC *cell = [tableView dequeueReusableCellWithIdentifier:scheduleCellIdentifier];
    if (cell == nil) {
        cell = [[ScheduleTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:scheduleCellIdentifier];
        cell = [[NSBundle mainBundle] loadNibNamed:@"ScheduleTVC" owner:self options:nil][0];
    }
    
    [cell setScheduleEvent:currentScheduleEvent];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 50, 7, 100, 30)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    NSArray *sortedKeys = [self sortDatesInArray:self.scheduleDictionary.allKeys];
    label.text = [self reverseDate:sortedKeys[section]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    view.backgroundColor = [Colors customGrayColor];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(24, CGRectGetMidY(view.frame))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(label.frame) - 16, CGRectGetMidY(view.frame))];
    [path moveToPoint:CGPointMake(CGRectGetMaxX(label.frame) + 16, CGRectGetMidY(view.frame))];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(view.frame) - 24    , CGRectGetMidY(view.frame))];
    
    CAShapeLayer *viewMaskLayer = [[CAShapeLayer alloc] init];
    viewMaskLayer.path = path.CGPath;
    viewMaskLayer.strokeColor = [[UIColor whiteColor] CGColor];
    viewMaskLayer.lineWidth = 1;
    [view.layer addSublayer:viewMaskLayer];
    
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ScheduleTVC height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
