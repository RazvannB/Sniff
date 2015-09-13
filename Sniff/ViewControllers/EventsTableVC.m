//
//  EventsTableVC.m
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#import "EventsTableVC.h"
#import "EventsController.h"
#import "MBProgressHUD.h"
#import "Event.h"
#import "EventInfoTableVC.h"

@interface EventsTableVC ()

@end

@implementation EventsTableVC

BOOL isCheckingOnlineForEvents;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSMutableArray *)eventsArray {
    if (!_eventsArray || ![_eventsArray count]) {
        _eventsArray = [[NSMutableArray alloc] initWithArray:[EventsController sharedInstance].eventsArray];
        if ((!_eventsArray || ![_eventsArray count]) && !isCheckingOnlineForEvents) {
            [self checkServerForUpdatesWithIndicator:YES];
        }
    } else {

    }
    return _eventsArray;
}

- (void)checkServerForUpdatesWithIndicator:(BOOL)indicator {
    isCheckingOnlineForEvents = YES;
    MBProgressHUD *progressHud;
    if (indicator) {
        progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        progressHud.labelText = @"Retrieving events...";
    }
    
    [[EventsController sharedInstance] getPublicEventsWithCompletion:^(BOOL success, NSString *message, EventsController *completion) {
        if (success) {

            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"There was an error retrieving events"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        if (indicator) {
            [progressHud hide:YES];
        }
        isCheckingOnlineForEvents = NO;
    }];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(8.0f, 8.0f, 59.0f, 59.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    Event *event = self.eventsArray[indexPath.row];
    cell.textLabel.text = event.project_name;
    int colorHEX = [[event.color stringByReplacingOccurrencesOfString:@"#" withString:@""] intValue];
    cell.imageView.image = [self imageWithColor:UIColorFromRGB(colorHEX)];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventInfoTableVC *eventInfo = [[EventInfoTableVC alloc] init];
    [eventInfo initWithEvent:self.eventsArray[indexPath.row]];
    [self.navigationController pushViewController:eventInfo animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

@end
