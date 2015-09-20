//
//  SendFeedbackVC.h
//  Sniff
//
//  Created by Razvan Balint on 19/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

typedef enum {
    SendFeedbackVCType_Name,
    SendFeedbackVCType_Anonim
} SendFeedbackVCType;

#import <UIKit/UIKit.h>
#import "Event.h"

@interface SendFeedbackVC : UIViewController

@property (nonatomic, strong) Event *event;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextView *comment;
@property (nonatomic, weak) IBOutlet UIButton *checkmark;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *commentHeightConstraint;
@property (nonatomic) CGRect previousRect;
@property (nonatomic) NSInteger numberOfRows;

@property (nonatomic) SendFeedbackVCType sendFeedbackVCType;
- (IBAction)sendFeedbackTouched:(id)sender;

@end
