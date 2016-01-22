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
    
    self.navigationItem.title = @"Trimite Feedback";
    
    [self setSendFeedbackVCType:SendFeedbackVCType_Name];
    self.previousRect = self.comment.frame;
    [self.comment becomeFirstResponder];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDismiss)]];
}

- (void)setSendFeedbackVCType:(SendFeedbackVCType)sendFeedbackVCType {
    _sendFeedbackVCType = sendFeedbackVCType;
    
    switch (sendFeedbackVCType) {
        case SendFeedbackVCType_Name:
            [self.checkmark setBackgroundImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
            self.nameLabel.text = [AuthenticationController sharedInstance].loggedUser.fullname;
            self.nameLabel.font = [UIFont systemFontOfSize:16.0];
            self.nameLabel.backgroundColor = [UIColor whiteColor];
            break;
            
        case SendFeedbackVCType_Anonim:
            [self.checkmark setBackgroundImage:nil forState:UIControlStateNormal];
            self.nameLabel.text = @"Anonim";
            self.nameLabel.font = [UIFont systemFontOfSize:16.0];
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
    
    if (![self.comment.text length]) {
        [[[UIAlertView alloc] initWithTitle:@"Nu se poate trimite"
                                    message:@"Mesajul este gol"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
        return;
    }
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHud.labelText = @"Se trimite feedback-ul...";
    
    [[EventsController sharedInstance] sendFeedbackForEvent:self.event
                                                   username:self.nameLabel.text
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

- (void)keyboardDismiss {
    [self.comment resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    if (CGRectGetHeight(self.comment.frame) > 200.0f) {
        return;
    }
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    self.commentHeightConstraint.constant = CGRectGetHeight(newFrame);
    
    CGRect newButtonFrame = CGRectMake(CGRectGetMinX(self.sendButton.frame), CGRectGetMaxY(newFrame) + 8, CGRectGetWidth(self.sendButton.frame), CGRectGetHeight(self.sendButton.frame));
    self.sendButton.frame = newButtonFrame;
    
    self.previousRect = newFrame;
}

@end
