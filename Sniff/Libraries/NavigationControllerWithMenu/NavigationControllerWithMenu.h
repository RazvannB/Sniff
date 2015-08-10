//
//  NavigationControllerWithMenu.h
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"

@interface NavigationControllerWithMenu : UINavigationController

@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) UIBarButtonItem *menuButton;
@property (nonatomic, assign) BOOL showingSideMenu;

@end
