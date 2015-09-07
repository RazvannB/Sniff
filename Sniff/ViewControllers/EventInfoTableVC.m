//
//  EventInfoTableVC.m
//  Sniff
//
//  Created by Razvan Balint on 11/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventInfoTableVC.h"
#import "EventTextTVC.h"
#import "EventImageTVC.h"
#import "EventsController.h"
#import "ButtonsTVC.h"
#import "MBProgressHUD.h"
#import "ScheduleTableVC.h"
#import "AuthenticationController.h"
#import "FeedbackTableVC.h"

@interface EventInfoTableVC () <ButtonsTVCDelegate>

@end

@implementation EventInfoTableVC

- (void)initWithEvent:(Event*)event {
    self.event = event;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.event.project_name;
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHud.labelText = @"Retrieving event info...";
    
    [[EventsController sharedInstance] getInfoForEvent:self.event
                                            completion:^(BOOL success, NSString *message, EventsController *completion) {
                                                if (success) {
                                                    self.infoDictionary = [[NSDictionary alloc] initWithDictionary:completion.infoDictionary];
                                                    [self.tableView reloadData];
                                                } else {
                                                    [[[UIAlertView alloc] initWithTitle:nil
                                                                                message:@"There was an error retrieving this event's info"
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil] show];
                                                }
                                                [progressHud hide:YES];
                                            }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)dequeCellIdentifier:(NSString *)cellIdentifier {
    id cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil][0];
    }
    return cell;
}

#pragma mark - ButtonsTVCDelegate

- (void)scheduleButtonPressed {
    ScheduleTableVC *schedule = [[ScheduleTableVC alloc] initWithEvent:self.event];
    [self.navigationController pushViewController:schedule animated:YES];
}

- (void)feedbackButtonPressed {
    FeedbackTableVC *feedback = [[FeedbackTableVC alloc] init];
    [self.navigationController pushViewController:feedback animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell;
    if (cell == nil) {
        switch (indexPath.row) {
            case 0:
                cell = [self dequeCellIdentifier:@"EventImageTVC"];
                [[cell imageview] setImage:[UIImage imageNamed:@"black"]];
                break;
                
            case 1:
                cell = [self dequeCellIdentifier:@"EventTextTVC"];
                [cell setEventTextType:EventTextType_Date info:self.infoDictionary];
                break;
                
            case 2:
                cell = [self dequeCellIdentifier:@"EventTextTVC"];
                [cell setEventTextType:EventTextType_Location info:self.infoDictionary];
                break;
                
            case 3:
                cell = [self dequeCellIdentifier:@"EventTextTVC"];
                [cell setEventTextType:EventTextType_Description info:self.infoDictionary];
                break;
                
            case 4:
                cell = [self dequeCellIdentifier:@"EventTextTVC"];
                [cell setEventTextType:EventTextType_FBPage info:self.infoDictionary];
                break;
                
            case 5:
                cell = [self dequeCellIdentifier:@"ButtonsTVC"];
                [cell setDelegate:self];
                
            default:
                break;
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        // location
    } else if (indexPath.row == 4) {
        if ([self.infoDictionary[@"FbPage"] class] != [NSNull class] &&
            [self.infoDictionary[@"FbPage"] length]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.infoDictionary[@"FbPage"]]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 200;
            break;
            
        case 1:
            return [EventTextTVC getCellHeightWithText:self.infoDictionary[@"start_date"]];
            break;
            
        case 2:
            return [EventTextTVC getCellHeightWithText:self.infoDictionary[@"address"]];
            break;
            
        case 3:
            return [EventTextTVC getCellHeightWithText:self.infoDictionary[@"description"]];
            break;
            
        case 4:
            return [EventTextTVC getCellHeightWithText:self.infoDictionary[@"FbPage"]];
            break;
            
        default:
            return 50;
            break;
    }
}

@end
