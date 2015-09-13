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
    
    self.navigationItem.title = @"Schedule";
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
        progressHud.labelText = @"Retrieving schedule...";
    }
    
    [[EventsController sharedInstance] getScheduleForEvent:self.event
                                                completion:^(BOOL success, NSString *message, EventsController *completion) {
                                                    if (success) {
                                                        
                                                        [self.tableView reloadData];
                                                    } else {
                                                        [[[UIAlertView alloc] initWithTitle:nil
                                                                                    message:@"There was an error retrieving this event's schedule"
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

- (void)sortScheduleByDate {
    self.scheduleArray = [self.scheduleArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        obj1 = [self getDateFromString: [(ScheduleEvent*)obj1 date]];
        obj2 = [self getDateFromString: [(ScheduleEvent*)obj2 date]];
        if ([obj1 isEqualToDate:obj2]) {
            obj1 = [self getHourFromString: [(ScheduleEvent*)obj1 start_hour]];
            obj2 = [self getHourFromString: [(ScheduleEvent*)obj2 start_hour]];
        }
        return [obj1 compare:obj2];
    }];
}

- (NSMutableDictionary *)scheduleDictionarySorted {
    if (!_scheduleDictionarySorted || [_scheduleDictionarySorted count] == 0) {
        _scheduleDictionarySorted = [[NSMutableDictionary alloc] init];
        [self sortScheduleByDate];
        for (ScheduleEvent* event in self.scheduleArray) {
            if (!_scheduleDictionarySorted[event.date]) {
                NSMutableArray *hoursArray = [[NSMutableArray alloc] init];
                [hoursArray addObject:event];
                _scheduleDictionarySorted[event.date] = hoursArray;
            } else {
                [_scheduleDictionarySorted[event.date] addObject:event];
            }
        }
    }
    return _scheduleDictionarySorted;
}

- (void)reverseDate {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [EventsController sharedInstance].scheduleArray = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.scheduleDictionarySorted allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.scheduleDictionarySorted[[self.scheduleDictionarySorted allKeys][section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleEvent *currentScheduleEvent = self.scheduleDictionarySorted[[self.scheduleDictionarySorted allKeys][indexPath.section]][indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@ %@", currentScheduleEvent.start_hour, currentScheduleEvent.end_hour, currentScheduleEvent.desc];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self reverseDate:[self.scheduleDictionarySorted allKeys][section]];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor darkGrayColor];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
