//
//  SendFeedbackVC.m
//  Sniff
//
//  Created by Razvan Balint on 19/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "SendFeedbackVC.h"
#import "AuthenticationController.h"
#import "EventsController.h"
#import "MBProgressHUD.h"

@interface SendFeedbackVC () <UITextViewDelegate>

@end

@implementation SendFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Trimite Feedback";
    self.sendButton.layer.cornerRadius = 5;
    self.nameLabel.layer.cornerRadius = 5;
    self.comment.layer.cornerRadius = 5;
    self.checkmark.layer.cornerRadius = 5;
    
    [self setSendFeedbackVCType:SendFeedbackVCType_Name];
    self.previousRect = CGRectZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSendFeedbackVCType:(SendFeedbackVCType)sendFeedbackVCType {
    _sendFeedbackVCType = sendFeedbackVCType;
    
    switch (sendFeedbackVCType) {
        case SendFeedbackVCType_Name:
            [self.checkmark setBackgroundImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
            self.nameLabel.text = [AuthenticationController sharedInstance].loggedUser.fullname;
            self.nameLabel.backgroundColor = [UIColor whiteColor];
            break;
            
        case SendFeedbackVCType_Anonim:
            [self.checkmark setBackgroundImage:nil forState:UIControlStateNormal];
            self.nameLabel.text = @"Anonim";
            self.nameLabel.backgroundColor = [UIColor lightGrayColor];
            break;
            
        default:
            break;
    }
}

- (IBAction)checkmarkTouched:(id)sender {
    switch (self.sendFeedbackVCType) {
        case SendFeedbackVCType_Name:
            [self setSendFeedbackVCType:SendFeedbackVCType_Anonim];
            break;
            
        case SendFeedbackVCType_Anonim:
            [self setSendFeedbackVCType:SendFeedbackVCType_Name];
            break;
            
        default:
            break;
    }
}

- (IBAction)sendFeedbackTouched:(id)sender {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHud.labelText = @"Se trimite feedback-ul...";
    
    [[EventsController sharedInstance] sendFeedbackForEvent:self.event
                                                    message:self.comment.text
                                                 completion:^(BOOL success, NSString *message, EventsController *completion) {
                                                     if (success) {
                                                         [[[UIAlertView alloc] initWithTitle:nil
                                                                                     message:@"Feedback trimis"
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"OK"
                                                                           otherButtonTitles: nil] show];
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }
                                                     [progressHud hide:YES];
                                                 }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    UITextPosition *pos = self.comment.endOfDocument;
    
    CGRect currentRect = [self.comment caretRectForPosition:pos];
    if (currentRect.origin.y > self.previousRect.origin.y) {
        self.commentHeightConstraint.constant += currentRect.size.height;
        [self.view layoutIfNeeded];
    }
    
    self.previousRect = currentRect;
}

@end
