//
//  ScheduleTableVC.h
//  Sniff
//
//  Created by Razvan Balint on 18/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface ScheduleTableVC : UITableViewController

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) NSArray *scheduleArray;
@property (nonatomic, strong) NSMutableDictionary *scheduleDictionarySorted;

- (id)initWithEvent:(Event*)event;

@end
