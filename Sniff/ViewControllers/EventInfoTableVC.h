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

- (void)initWithEvent:(Event*)event;

@end
