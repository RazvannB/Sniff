//
//  NavigationControllerWithMenu.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "NavigationControllerWithMenu.h"
#import "HomepageVC.h"
#import "LoginVC.h"
#import "EventsTableVC.h"

@interface NavigationControllerWithMenu () <MenuViewDelegate, LoggedUserViewDelegate>

@end

@implementation NavigationControllerWithMenu

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        rootViewController.navigationItem.leftBarButtonItem = self.menuButton;
    }
    return self;
}

- (MenuView *)menuView {
    if (!_menuView) {
        _menuView = [MenuView newInstance];
        _menuView.delegate = self;
    }
    return _menuView;
}

- (UIBarButtonItem *)menuButton {
    if (!_menuButton) {
        _menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_button"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(menuButtonPressed:)];
    }
    return _menuButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginButtonPressed) name:@"LoginButtonPressedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn) name:@"UserSuccessfullyLoggedInNotification" object:nil];
}

- (void)menuButtonPressed:(id)sender {
    self.showingSideMenu = YES;
    [self.menuView presentWithAnimation];
}

- (void)loginButtonPressed {
    [self.menuView dismissMenuView];
    LoginVC *login = [[LoginVC alloc] init];
    [self pushViewController:login animated:YES];
}

- (void)userLoggedIn {
    HomepageVC *homepage = [[HomepageVC alloc] init];
    homepage.navigationItem.leftBarButtonItem = self.menuButton;
    [self setViewControllers:@[homepage] animated:YES];
    self.menuView = nil;
    [self.menuView reloadInputViews];
}

#pragma mark - MenuViewDelegate

- (void)menuView:(MenuView *)menuView selectedMenuItemAtIndex:(NSInteger)menuIndex {
    switch (menuIndex) {
        case 0: {
            HomepageVC *homepage = [[HomepageVC alloc] init];
            homepage.navigationItem.leftBarButtonItem = self.menuButton;
            [self setViewControllers:@[homepage] animated:YES];
            break;
        }
            
        case 1:{
            EventsTableVC *events = [[EventsTableVC alloc] init];
            events.navigationItem.title = @"Events";
            events.navigationItem.leftBarButtonItem = self.menuButton;
            [self setViewControllers:@[events] animated:YES];
            break;
        }
            
        case 2: {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:@"loggedUserKey"];
            [defaults synchronize];
            HomepageVC *homepage = [[HomepageVC alloc] init];
            homepage.navigationItem.leftBarButtonItem = self.menuButton;
            [self setViewControllers:@[homepage] animated:YES];
            self.menuView = nil;
            break;
        }
            
        default:
            break;
    }
}

@end
