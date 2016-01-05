//
//  EventImageTVC.h
//  Sniff
//
//  Created by Razvan Balint on 11/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventImageTVC : UITableViewCell

@property (nonatomic, strong) Event *event;
@property (nonatomic, weak) IBOutlet UIImageView *imageview;

@end
