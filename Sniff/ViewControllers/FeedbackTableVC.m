//
//  FeedbackTableVC.m
//  Sniff
//
//  Created by Razvan Balint on 27/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "FeedbackTableVC.h"

@interface FeedbackTableVC ()

@end

@implementation FeedbackTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.footerView = [[FeedbackFooterView alloc] init];
//    self.footerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 170);
//    self.tableView.tableFooterView = self.footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.footerView = [[FeedbackFooterView alloc] init];
    return self.footerView;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 170;
}

@end
