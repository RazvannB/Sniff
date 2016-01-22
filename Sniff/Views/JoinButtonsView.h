//
//  JoinButtonsView.h
//  Sniff
//
//  Created by Razvan Balint on 20/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@protocol JoinButtonsView <NSObject>

- (void)joinButtonsViewWIllGoToLogin;
//- (void)

@end

@interface JoinButtonsView : UIView <UIAlertViewDelegate>

@property (nonatomic, weak) Event *event;
@property (nonatomic, weak) IBOutlet UIButton *joinButton;
@property (nonatomic, strong) id <JoinButtonsView> delegate;

@property (nonatomic, assign) BOOL isFavourite;

- (instancetype)initWithEvent:(Event *)event;
- (IBAction)joinButtonTouched:(id)sender;
+ (CGFloat)height;

@end
