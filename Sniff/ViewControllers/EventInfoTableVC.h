//
//  EventInfoTableVC.h
//  Sniff
//
//  Created by Razvan Balint on 11/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventInfoTableVC : UITableViewController

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) NSDictionary *infoDictionary;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;

- (instancetype)initWithEvent:(Event*)event;

@end
