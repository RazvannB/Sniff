//
//  SendFeedbackVC.h
//  Sniff
//
//  Created by Razvan Balint on 19/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

typedef enum {
    SendFeedbackVCType_Name,
    SendFeedbackVCType_Anonim
} SendFeedbackVCType;

@class SendFeedbackVC;
@protocol SendFeedbackVCDelegate <NSObject>

- (void)sendFeedbackVC:(SendFeedbackVC *)sendFeedbackVC backButtonTouched:(id)sender;

@end

@interface SendFeedbackVC : UIViewController

@property (nonatomic, strong) Event *event;
@property (nonatomic, weak) IBOutlet UITextView *nameLabel;
@property (nonatomic, weak) IBOutlet UITextView *comment;
@property (nonatomic, weak) IBOutlet UIButton *checkmark;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *commentHeightConstraint;
@property (nonatomic) CGRect previousRect;
@property (nonatomic) NSInteger numberOfRows;

@property (nonatomic) SendFeedbackVCType sendFeedbackVCType;

@property (nonatomic, strong) id<SendFeedbackVCDelegate> delegate;

- (IBAction)sendFeedbackTouched:(id)sender;

@end
