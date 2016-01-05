//
//  CustomNavigationBar.h
//  Sniff
//
//  Created by Razvan Balint on 12/12/15.
//  Copyright © 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ButtonPosition_Right,
    ButtonPosition_Left
} ButtonPosition;

typedef enum {
    CustomNavigationBarType_Default,
    CustomNavigationBarType_CustomTitleView,
    CustomNavigationBarType_SearchBar
} CustomNavigationBarType;

@class CustomNavigationBar;
@protocol CustomNavigationBarDelegate <UINavigationBarDelegate>
@required
@optional
- (void)CustomNavigationBar:(CustomNavigationBar*)customNavigationBar didTouchTitleView:(UIView*)titleView;
- (void)CustomNavigationBar:(CustomNavigationBar *)customNavigationBar didTouchLeftBarButton:(id)sender;
- (void)CustomNavigationBar:(CustomNavigationBar *)customNavigationBar didTouchRightBarButton:(id)sender;

@end

@interface CustomNavigationBar : UINavigationBar

#pragma mark - Properties

@property (nonatomic) CustomNavigationBarType customNavigationBarType;

@property (nonatomic) ButtonPosition buttonPosition;

@property (nonatomic, weak) id<CustomNavigationBarDelegate> delegate;

#pragma mark - IB Outles

@property (nonatomic, weak) IBOutlet UIView *titleView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

#pragma mark - Methods

- (void)setBarButton:(id)content buttonPosition:(ButtonPosition)buttonPosition;

@end
