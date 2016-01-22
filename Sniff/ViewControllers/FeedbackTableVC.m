//
//  FeedbackTableVC.m
//  Sniff
//
//  Created by Razvan Balint on 27/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "FeedbackTableVC.h"
#import "EventsController.h"
#import "MBProgressHUD.h"
#import "Feedback.h"
#import "FeedbackTVC.h"
#import "SendFeedbackVC.h"
#import "AuthenticationController.h"
#import "LoginVC.h"
#import "MessageTVC.h"

@interface FeedbackTableVC () <FeedbackFooterViewDelegate, UIAlertViewDelegate> 

@end

@implementation FeedbackTableVC

BOOL isCheckingOnlineForFeedback;

- (id)initWithEvent:(Event *)event {
    if (self = [super init]) {
        self.event = event;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Feedback";
    _feedbackArray = [EventsController sharedInstance].feedbackArray;
    if ((!_feedbackArray || ![_feedbackArray count]) && !isCheckingOnlineForFeedback) {
        [self checkServerForUpdatesWithIndicator:YES];
    }
}

- (void)checkServerForUpdatesWithIndicator:(BOOL)indicator {
    isCheckingOnlineForFeedback = YES;
    MBProgressHUD *progressHud;
    if (indicator) {
        progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        progressHud.labelText = @"Se descarca feeddback-ul...";
    }
    
    [[EventsController sharedInstance] getFeedbackForEvent:self.event
                                                completion:^(BOOL success, NSString *message, EventsController *completion) {
                                                    if (success) {
                                                        self.feedbackArray = [EventsController sortFeedbackArray:completion.feedbackArray];
                                                        [self.tableView reloadData];
                                                    }
                                                    
                                                    if (indicator) {
                                                        [progressHud hide:YES];
                                                    }
                                                    isCheckingOnlineForFeedback = NO;
                                                }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [EventsController sharedInstance].feedbackArray = nil;
    }
}

- (id)dequeCellIdentifier:(NSString *)cellIdentifier {
    id cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil][0];
    }
    return cell;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        LoginVC *loginPage = [[LoginVC alloc] initWithTurningBack:YES];
        [self.navigationController pushViewController:loginPage animated:YES];
    }
}

#pragma mark - FeedbackFooterViewDelegate

- (void)feedbackFooterOpenSendPage {
    if (![AuthenticationController sharedInstance].loggedUser) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"Trebuie sa fiti autentificat ca sa puteti trimite un feedback"
                                   delegate:self
                          cancelButtonTitle:@"Inapoi"
                          otherButtonTitles:@"Autentificare", nil] show];
        return;
    }
    
    SendFeedbackVC *sendfeedback = [[SendFeedbackVC alloc] init];
    [sendfeedback setEvent:self.event];
    [self.navigationController pushViewController:sendfeedback animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feedbackArray count] ? [self.feedbackArray count] : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FeedbackTVC";
    static NSString *noCellIdentifier = @"MessageTVC";
    id cell;
    
    if ([self.feedbackArray count]) {
        
        cell = [self dequeCellIdentifier:cellIdentifier];
        [cell setFeedback:self.feedbackArray[indexPath.row]];
        
    } else {
        
        cell = [self dequeCellIdentifier:noCellIdentifier];
        [cell setMessageTVCType:MessageTVCType_NoFeedback];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.footerView = [[FeedbackFooterView alloc] init];
    self.footerView.delegate = self;
    return self.footerView;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [FeedbackFooterView height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.feedbackArray count]) {
        return [FeedbackTVC getCellHeightWithText:[self.feedbackArray[indexPath.row] message]];
    } else {
        return [MessageTVC height];
    }
}

@end
