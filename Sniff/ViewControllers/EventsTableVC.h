//
//  EventsTableVC.h
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) NSArray *allEventsArray;

@end
