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
#import "AuthenticationController.h"
#import "AuthenticationVC.h"
#import "AppDelegate.h"

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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showReceivedMessage:)
                                                 name:appDelegate.messageKey
                                               object:nil];
}

- (void)menuButtonPressed:(id)sender {
    self.showingSideMenu = YES;
    [self.menuView presentWithAnimation];
    UIViewController *viewController = [self.viewControllers firstObject];
    currentViewTitle = self.navigationItem.title;
    
    self.currentResponder = [self findFirstResponder];
    [viewController.view endEditing:YES];

    [UIView animateWithDuration:0.2
                     animations:^{
                         [viewController.view setFrame:CGRectMake(250, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
                         self.navigationBar.frame = CGRectMake(250, [UIApplication sharedApplication].statusBarFrame.size.height, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
                     }];
}

- (void)menuViewDidDismiss {
    UIViewController *viewController = [self.viewControllers firstObject];
    
    if (self.currentResponder) {
        [self setFirstResponder:self.currentResponder];
        self.currentResponder = nil;
    }
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         [viewController.view setFrame:CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
                         self.navigationBar.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
                     }];
}

- (void)loginButtonPressed {
    [self.menuView dismissMenuView];
    if ([[self.viewControllers firstObject] isKindOfClass:[LoginVC class]]) {
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

- (id)findFirstResponder {
    for (UIView *subView in self.viewControllers.firstObject.view.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}

- (void)setFirstResponder:(UIView *)view {
    for (UIView *subView in self.viewControllers.firstObject.view.subviews) {
        if (subView == view) {
            [subView becomeFirstResponder];
        }
    }
}

- (void) showReceivedMessage:(NSNotification *) notification {
    NSString *title = notification.userInfo[@"title"];
    NSString *message = notification.userInfo[@"text"];
    [self showAlert:title withMessage:message];
}

- (void)showAlert:(NSString *)title withMessage:(NSString *) message{

    //iOS 8 or later
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:nil];
    
    [alert addAction:dismissAction];
    [self presentViewController:alert animated:YES completion:nil];
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
            
        case 2: {
            if ([[self.viewControllers firstObject] isKindOfClass:[AuthenticationVC class]]) {
                break;
            }
            AuthenticationVC *auth = [[AuthenticationVC alloc] init];
            [auth setAuthType:AuthenticationVCType_Settings];
            auth.navigationItem.leftBarButtonItem = self.menuButton;
            
            [self setViewControllers:@[auth] animated:YES];
            break;
        }
            
        case 3: {
            [[AuthenticationController sharedInstance] logout];
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
