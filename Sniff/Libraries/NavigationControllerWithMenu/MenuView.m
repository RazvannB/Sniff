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
#import "MenuViewCell.h"
#import <QuartzCore/QuartzCore.h>

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
    
    self.tableView.layer.masksToBounds = NO;
    self.tableView.layer.shadowOffset = CGSizeMake(20, 0);
    self.tableView.layer.shadowRadius = 10;
    self.tableView.layer.shadowOpacity = 0.5;
}

- (NSArray *)menuItemsArray {
    _menuItemsArray = [NSArray alloc];
    if ([AuthenticationController sharedInstance].loggedUser) {
        _menuItemsArray = [_menuItemsArray initWithArray:@[@"Arata-mi evenimentele", @"Evenimentele mele", @"Setari cont", @"Iesire din cont"]];
    } else {
        _menuItemsArray = [_menuItemsArray initWithArray:@[@"Arata-mi evenimentele"]];
    }
    
    return _menuItemsArray;
}

- (void)presentWithAnimation {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.1
                     animations:^{
                         
                         self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                         [self.tableView reloadData];
                         
                     } completion:^(BOOL finished) {
                         [self.shadowView setAlpha:0.5];
                         [self layoutSubviews];
                     }];
}

- (void)dismissMenuView {
    [self.shadowView setAlpha:0];
    if ([self.delegate respondsToSelector:@selector(menuViewDidDismiss)]) {
        [self.delegate menuViewDidDismiss];
    }
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
    static NSString *cellIdentifier = @"MenuViewCell";
    MenuViewCell *cell = (MenuViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [[NSBundle mainBundle] loadNibNamed:@"MenuViewCell" owner:self options:nil][0];
    }    
    [cell titleLabel].text = self.menuItemsArray[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.imageview.image = [UIImage imageNamed:@"event"];
            break;
            
        case 1:
            cell.imageview.image = [UIImage imageNamed:@"heart"];
            break;
            
        case 2:
            cell.imageview.image = [UIImage imageNamed:@"settings"];
            break;
            
        case 3:
            cell.imageview.image = [UIImage imageNamed:@"logout"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
    self.loggedUserView = [[LoggedUserView alloc] initWithFrame:CGRectMake(0, 0, 250, 100)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MenuViewCell height];
}

@end
