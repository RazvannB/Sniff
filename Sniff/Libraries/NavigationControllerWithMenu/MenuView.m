//
//  MenuView.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "MenuView.h"
#import "LoggedUserView.h"
#import "AuthenticationController.h"

@implementation MenuView

+ (MenuView*)newInstance {
    MenuView *menuView = [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:nil options:nil][0];
    return menuView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = [UIScreen mainScreen].nativeBounds;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    self.tableView.contentInset = UIEdgeInsetsMake(22, 0, 0, 0);
    [self.tableView selectRowAtIndexPath:0 animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    [self.shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(dismissMenuView)]];
}

- (NSArray *)menuItemsArray {
    _menuItemsArray = [NSArray alloc];
    if ([AuthenticationController sharedInstance].loggedUser.id) {
        _menuItemsArray = [_menuItemsArray initWithArray:@[@"Homepage", @"Events", @"Log out"]];
    } else {
        _menuItemsArray = [_menuItemsArray initWithArray:@[@"Homepage", @"Events"]];
    }
    
    return _menuItemsArray;
}

- (void)presentWithAnimation {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                     } completion:^(BOOL finished) {
                         [self.shadowView setAlpha:0.5];
                         [self layoutSubviews];
                     }];
}

- (void)dismissMenuView {
    [self.shadowView setAlpha:0];
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         self.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
}

#pragma mark - UITabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }    
    cell.textLabel.text = self.menuItemsArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
    self.loggedUserView = [[LoggedUserView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    self.loggedUserView = [[NSBundle mainBundle] loadNibNamed:@"LoggedUserView" owner:nil options:nil][0];
    
    return self.loggedUserView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(menuView:selectedMenuItemAtIndex:)]) {
        [self dismissMenuView];
        [self.delegate menuView:self selectedMenuItemAtIndex:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

@end
