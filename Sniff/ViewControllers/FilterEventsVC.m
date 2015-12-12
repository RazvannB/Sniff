//
//  FilterEventsVC.m
//  Sniff
//
//  Created by Razvan Balint on 05/12/15.
//  Copyright © 2015 Razvan Balint. All rights reserved.
//

#import "FilterEventsVC.h"

@interface FilterEventsVC ()
@end

@implementation FilterEventsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setModalPresentationStyle:UIModalPresentationCustom];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissView)];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableBottomContraint.constant = (self.view.frame.size.height - 66 - self.tableView.frame.size.height)/2;
}

- (void)setSelectedValue:(NSInteger)selectedValue {
    _selectedValue = selectedValue;
}

- (void)dismissView {
    if ([self.delegate respondsToSelector:@selector(filterEventsVC:dismissViewWithValue:)]) {
        [self.delegate filterEventsVC:self dismissViewWithValue:self.selectedValue];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch {
    BOOL isInsideTableView = CGRectContainsPoint(self.tableView.frame, [touch locationInView:gesture.view]);
    if (isInsideTableView) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"categoryCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Toate categoriile";
            break;
            
        case 1:
            cell.textLabel.text = @"Educational";
            break;
            
        case 2:
            cell.textLabel.text = @"Cariera";
            break;
            
        case 3:
            cell.textLabel.text = @"Social";
            break;
            
        case 4:
            cell.textLabel.text = @"Distractie";
            break;
            
        case 5:
            cell.textLabel.text = @"Concurs";
            break;
            
        case 6:
            cell.textLabel.text = @"Training";
            break;
            
        default:
            break;
    }
    
    if (indexPath.row == self.selectedValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedValue = indexPath.row;
    [self dismissView];
}

@end
