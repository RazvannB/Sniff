//
//  MenuView.h
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoggedUserView.h"

@class MenuView;

typedef void(^MenuViewCompletionHandler)();

@protocol MenuViewDelegate <NSObject>

@optional
- (void)menuView:(MenuView *)menuView selectedMenuItemAtIndex:(NSInteger)menuIndex;
- (void)menuViewDidDismiss;

@end

@interface MenuView : UIView <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) LoggedUserView *loggedUserView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *shadowView;
@property (nonatomic, strong) NSArray *menuItemsArray;

@property (nonatomic) id <MenuViewDelegate> delegate;

+ (MenuView*)newInstance;
- (void)presentWithAnimation;
- (void)dismissMenuView;

@end
