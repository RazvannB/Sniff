//
//  JoinButtonsView.h
//  Sniff
//
//  Created by Razvan Balint on 20/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JoinButtonsView <NSObject>

- (void)joinButtonsViewWillShowParticipants;
- (void)joinButtonsViewWIllGoToLogin;

@end

@interface JoinButtonsView : UIView <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *joinButton;
@property (nonatomic, weak) IBOutlet UIButton *participantsButton;
@property (nonatomic, strong) NSDictionary *infoDictionary;
@property (nonatomic, strong) NSNumber *numberOfParticipants;
@property (nonatomic, strong) id <JoinButtonsView> delegate;

- (IBAction)joinButtonTouched:(id)sender;
- (IBAction)participantsButtonTouched:(id)sender;
+ (CGFloat)height;

@end
