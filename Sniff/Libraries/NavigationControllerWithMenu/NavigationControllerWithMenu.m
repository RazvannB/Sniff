//
//  NavigationControllerWithMenu.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "NavigationControllerWithMenu.h"
#import "LoginVC.h"
#import "EventsTableVC.h"
#import "EventsController.h"

@interface NavigationControllerWithMenu () <MenuViewDelegate, LoggedUserViewDelegate> {
    NSString *currentViewTitle;
}

@end

@implementation NavigationControllerWithMenu

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        if (![rootViewController isKindOfClass:[LoginVC class]]) {
            rootViewController.navigationItem.leftBarButtonItem = self.menuButton;
        }
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
    UIViewController *viewController = self.viewControllers[0];
    currentViewTitle = self.navigationItem.title;

    [UIView animateWithDuration:0.2
                     animations:^{
                         [viewController.view setFrame:CGRectMake(250, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
                         self.navigationBar.frame = CGRectMake(250, [UIApplication sharedApplication].statusBarFrame.size.height, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
                     }];
}

- (void)menuViewDidDismiss {
    UIViewController *viewController = self.viewControllers[0];
    [UIView animateWithDuration:0.1
                     animations:^{
                         [viewController.view setFrame:CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
                         self.navigationBar.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
                     }];
}

- (void)loginButtonPressed {
    [self.menuView dismissMenuView];
    if ([self.viewControllers[0] isKindOfClass:[LoginVC class]]) {
        return;
    }

    self.viewControllers = @[[[LoginVC alloc] init]];
}

- (void)userLoggedIn {
    EventsTableVC *events = [[EventsTableVC alloc] init];
    events.navigationItem.leftBarButtonItem = self.menuButton;
    [self setViewControllers:@[events] animated:YES];
    self.menuView = nil;
    [self.menuView reloadInputViews];
}

#pragma mark - MenuViewDelegate

- (void)menuView:(MenuView *)menuView selectedMenuItemAtIndex:(NSInteger)menuIndex {
    switch (menuIndex) {
        case 0:{
            if ([[self.viewControllers firstObject] isKindOfClass:[EventsTableVC class]] &&
                [[self.viewControllers firstObject] eventsType] == EventsTableVCType_Default) {
                break;
            }
            EventsTableVC *events = [[EventsTableVC alloc] initWithType:EventsTableVCType_Default];
            events.navigationItem.leftBarButtonItem = self.menuButton;
            [self setViewControllers:@[events] animated:YES];
            break;
        }
            
        case 1: {
            if ([[self.viewControllers firstObject] isKindOfClass:[EventsTableVC class]] &&
                [[self.viewControllers firstObject] eventsType] == EventsTableVCType_Favorite) {
                break;
            }
            EventsTableVC *events = [[EventsTableVC alloc] initWithType:EventsTableVCType_Favorite];
            events.navigationItem.leftBarButtonItem = self.menuButton;
            [self setViewControllers:@[events] animated:YES];
            break;
        }
            
        case 3: {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:@"loggedUserKey"];
            [defaults synchronize];
            [EventsController sharedInstance].favoriteEventsArray = nil;
            
            [self setViewControllers:@[[[LoginVC alloc] init]] animated:YES];
            self.menuView = nil;
            break;
        }
            
        default:
            break;
    }
}

@end
