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
#import "JoinButtonsView.h"
#import "LoginVC.h"
#import "ParticipantsVC.h"
#import <MapKit/MapKit.h>

@interface EventInfoTableVC () <ButtonsTVCDelegate, UIActionSheetDelegate, JoinButtonsView>

@end

@implementation EventInfoTableVC

BOOL isCheckingOnlineForInfo;

- (void)initWithEvent:(Event*)event {
    self.event = event;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.event.project_name;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (NSDictionary *)infoDictionary {
    if (!_infoDictionary || ![_infoDictionary count]) {
        _infoDictionary = [EventsController sharedInstance].infoDictionary;
        if ((!_infoDictionary || ![_infoDictionary count]) && !isCheckingOnlineForInfo) {
            [self checkServerForUpdatesWithIndicator:YES];
        }
    } else {

    }
    return _infoDictionary;
}

- (void)checkServerForUpdatesWithIndicator:(BOOL)indicator {
    isCheckingOnlineForInfo = YES;
    MBProgressHUD *progressHud;
    if (indicator) {
        progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        progressHud.labelText = @"Se descarca informatiile...";
    }
    
    [[EventsController sharedInstance] getInfoForEvent:self.event
                                            completion:^(BOOL success, NSString *message, EventsController *completion) {
                                                if (success) {
                                                    [self.tableView reloadData];
                                                } else {
                                                    [[[UIAlertView alloc] initWithTitle:nil
                                                                                message:@"Este o problema cu descarcarea informatiilor"
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil] show];
                                                }
                                                if (indicator) {
                                                    [progressHud hide:YES];
                                                }
                                                isCheckingOnlineForInfo = NO;
                                            }];
}

- (id)dequeCellIdentifier:(NSString *)cellIdentifier {
    id cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil][0];
    }
    return cell;
}

#pragma mark - JoinButtonsViewDelegate

- (void)joinButtonsViewWIllGoToLogin {
    LoginVC *loginPage = [[LoginVC alloc] initWithTurningBack:YES];
    [self.navigationController pushViewController:loginPage animated:YES];
}

- (void)joinButtonsViewWillShowParticipants {
    ParticipantsVC *participantsPage = [[ParticipantsVC alloc] init];
    [self.navigationController pushViewController:participantsPage animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    CLLocationCoordinate2D eventLocation =
    CLLocationCoordinate2DMake([self.infoDictionary[@"location_x"] doubleValue],
                               [self.infoDictionary[@"location_y"] doubleValue]);
    
    switch (buttonIndex) {
        case 0: {
            //Apple Maps, using the MKMapItem
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:eventLocation addressDictionary:nil];
            MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
            item.name = self.infoDictionary[@"project_name"];
            [item openInMapsWithLaunchOptions:nil];
            break;
        }
            
        case 1: {
            //Google Maps
            //construct a URL using the comgooglemaps schema
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f",eventLocation.latitude,eventLocation.longitude]];
            if (![[UIApplication sharedApplication] canOpenURL:url]) {
                NSLog(@"Google Maps app is not installed. Will open website");
                url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/maps/@%f,%f,18z",eventLocation.latitude,eventLocation.longitude]];
                [[UIApplication sharedApplication] openURL:url];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - ButtonsTVCDelegate

- (void)scheduleButtonPressed {
    ScheduleTableVC *schedule = [[ScheduleTableVC alloc] initWithEvent:self.event];
    [self.navigationController pushViewController:schedule animated:YES];
}

- (void)feedbackButtonPressed {
    FeedbackTableVC *feedback = [[FeedbackTableVC alloc] initWithEvent:self.event];
    [self.navigationController pushViewController:feedback animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [EventsController sharedInstance].infoDictionary = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell;
    if (cell == nil) {
        switch (indexPath.row) {
            case 0:
                cell = [self dequeCellIdentifier:@"EventImageTVC"];
                break;
                
            case 1:
                cell = [self dequeCellIdentifier:@"EventTextTVC"];
                [cell setEventTextType:EventTextType_Organiser info:self.infoDictionary];
                [cell textview].textAlignment = NSTextAlignmentCenter;
                break;
                
            case 2:
                cell = [self dequeCellIdentifier:@"EventTextTVC"];
                [cell setEventTextType:EventTextType_Date info:self.infoDictionary];
                [cell textview].textAlignment = NSTextAlignmentCenter;
                break;
                
            case 3:
                cell = [self dequeCellIdentifier:@"EventTextTVC"];
                [cell setEventTextType:EventTextType_Location info:self.infoDictionary];
                [cell textview].textAlignment = NSTextAlignmentCenter;
                break;
                
            case 4:
                cell = [self dequeCellIdentifier:@"EventTextTVC"];
                [cell setEventTextType:EventTextType_Description info:self.infoDictionary];
                break;
                
            case 5:
                cell = [self dequeCellIdentifier:@"EventTextTVC"];
                [cell setEventTextType:EventTextType_FBPage info:self.infoDictionary];
                break;
                
            case 6:
                cell = [self dequeCellIdentifier:@"ButtonsTVC"];
                [cell setDelegate:self];
                
            default:
                break;
        }
    }
    
    if (indexPath.row == 5 &&
        [self.infoDictionary[@"FbPage"] class] != [NSNull class] &&
        [self.infoDictionary[@"FbPage"] length]) {
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    } else if (indexPath.row == 3 &&
               [self.infoDictionary[@"location_x"] class] != [NSNull class] &&
               [self.infoDictionary[@"location_x"] length]) {
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    JoinButtonsView *joinView = [[JoinButtonsView alloc] init];
    [joinView setDelegate:self];
    [joinView setInfoDictionary:self.infoDictionary];
    return joinView;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        [[[UIActionSheet alloc] initWithTitle:@"Alege o harta"
                                     delegate:self
                            cancelButtonTitle:@"Inapoi"
                       destructiveButtonTitle:nil
                            otherButtonTitles:@"Apple Maps", @"Google Maps", nil] showInView:self.view];
        
    } else if (indexPath.row == 5) {
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
            return [EventTextTVC getCellHeightWithText:self.infoDictionary[@"org_name"]];
            break;
            
        case 2:
            return [EventTextTVC getCellHeightWithText:self.infoDictionary[@"start_date"]];
            break;
            
        case 3:
            return [EventTextTVC getCellHeightWithText:self.infoDictionary[@"address"]];
            break;
            
        case 4:
            return [EventTextTVC getCellHeightWithText:self.infoDictionary[@"description"]];
            break;
            
        case 5:
            return [EventTextTVC getCellHeightWithText:self.infoDictionary[@"FbPage"]];
            break;
            
        default:
            return 50;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [JoinButtonsView height];
}

@end
