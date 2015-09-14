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

@interface FeedbackTableVC () <FeedbackFooterViewDelegate>

@end

@implementation FeedbackTableVC

- (id)initWithEvent:(Event *)event {
    if (self = [super init]) {
        self.event = event;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSArray *)feedbackArray {
    _feedbackArray = [EventsController sharedInstance].feedbackArray;
    if (!_feedbackArray || ![_feedbackArray count]) {
        [self checkServerForUpdatesWithIndicator:YES];
    } else {
        [self checkServerForUpdatesWithIndicator:NO];
    }
    return _feedbackArray;
}

- (void)checkServerForUpdatesWithIndicator:(BOOL)indicator {
    MBProgressHUD *progressHud;
    if (indicator) {
        progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        progressHud.labelText = @"Retrieving feedback...";
    }
    
    [[EventsController sharedInstance] getFeedbackForEvent:self.event
                                                completion:^(BOOL success, NSString *message, EventsController *completion) {
                                                    if (success) {
                                                        _feedbackArray = completion.feedbackArray;
                                                    }
                                                    
                                                    if (indicator) {
                                                        [progressHud hide:YES];
                                                    }
                                                }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [EventsController sharedInstance].feedbackArray = nil;
    }
}

#pragma mark - FeedbackFooterViewDelegate

- (void)sendFeedbackWithRating:(int)ratingValue Comment:(NSString *)comment {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHud.labelText = @"Sending feedback...";
    
    [[EventsController sharedInstance] sendFeedbackForEvent:self.event
                                                    message:comment
                                                 completion:^(BOOL success, NSString *message, EventsController *completion) {
                                                     if (success) {
                                                         
                                                     }
                                                     [progressHud hide:YES];
                                                 }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FeedbackTVC";
    FeedbackTVC *cell = (FeedbackTVC*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.footerView = [[FeedbackFooterView alloc] init];
    return self.footerView;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 170;
}

@end
