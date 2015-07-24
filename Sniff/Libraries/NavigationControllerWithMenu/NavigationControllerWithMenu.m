//
//  NavigationControllerWithMenu.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "NavigationControllerWithMenu.h"
#import "HomepageVC.h"

@interface NavigationControllerWithMenu () <MenuViewDelegate>

@end

@implementation NavigationControllerWithMenu

+ (NavigationControllerWithMenu *)newInstance {
    NavigationControllerWithMenu *navCtrl = [[NavigationControllerWithMenu alloc] initWithRootViewController:[[HomepageVC alloc] init]];
    return navCtrl;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        rootViewController.navigationItem.leftBarButtonItem = self.menuButton;
        
    }
    return self;
}

//- (MenuView *)menuView {
//    if (!_menuView) {
//        _menuView = [MenuView newInstanceWithItems:@[[CriteriaItem withType:CriteriaItemType_menu
//                                                                      title:@"My Workbooks"
//                                                                      items:nil
//                                                              selectedValue:[DashboardViewController class]],
//                                                     [CriteriaItem withType:CriteriaItemType_menu
//                                                                      title:@"Browse"
//                                                                      items:nil
//                                                              selectedValue:[BrowseVC class]]]];
//        _menuView.delegate = self;
//        _menuView.profileHeaderView.delegate = self;
//    }
//    return _menuView;
//}

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
    // Do any additional setup after loading the view.
}

- (void)menuButtonPressed:(id)sender {
    
}

#pragma mark - MenuViewDelegate

- (void)menuView:(MenuView *)menuView selectedMenuItemAtIndex:(NSInteger)menuIndex {
    [self.menuView presentWithAnimation:YES completion:nil];
    
}

@end
