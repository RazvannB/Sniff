//
//  ParticipantsVC.m
//  Sniff
//
//  Created by Razvan Balint on 20/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "ParticipantsVC.h"

@interface ParticipantsVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ParticipantsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Participanti";
}

- (NSArray *)participantsArray {
    _participantsArray = @[@"Razvan Balint", @"Liviu Nicu", @"Oana Stamate", @"Andreea Popa", @"Simina Craiciu", @"Moroe Teodora", @"Bogdan Raduta"];
    return _participantsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.participantsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleCellIdentifier = @"SimpleCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleCellIdentifier];
    }
    
    cell.textLabel.text = self.participantsArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:@"sniff_head"];
    cell.imageView.layer.cornerRadius = 22;
    cell.backgroundColor = [UIColor colorWithRed:22.0f/255.0f green:44.0f/255.0f blue:66.0f/255.0f alpha:1];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
