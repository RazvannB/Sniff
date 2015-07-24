//
//  MenuView.h
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuView;

typedef void(^MenuViewCompletionHandler)();

@protocol MenuViewDelegate <NSObject>

@optional
- (void)menuView:(MenuView *)menuView selectedMenuItemAtIndex:(NSInteger)menuIndex;

@end

@interface MenuView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuItemsArray;

@property (nonatomic) id <MenuViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)presentWithAnimation:(BOOL)animated completion:(MenuViewCompletionHandler)completion;

@end
