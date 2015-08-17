//
//  ButtonsTVC.h
//  Sniff
//
//  Created by Razvan Balint on 17/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonsTVCDelegate <NSObject>
@required
- (void)scheduleButtonPressed;
- (void)feedbackButtonPressed;

@end

@interface ButtonsTVC : UITableViewCell

@property (nonatomic, strong) id<ButtonsTVCDelegate> delegate;

- (IBAction)schedulePressed:(id)sender;
- (IBAction)feedbackPressed:(id)sender;

@end
