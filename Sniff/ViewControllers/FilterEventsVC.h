//
//  FilterEventsVC.h
//  Sniff
//
//  Created by Razvan Balint on 05/12/15.
//  Copyright © 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterEventsVC;
@protocol FilterEventsVCDelegate <NSObject>

- (void)filterEventsVC:(FilterEventsVC*)filterEventsVC dismissViewWithValue:(NSInteger)index;

@end

@interface FilterEventsVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableBottomContraint;
@property (nonatomic) NSInteger selectedValue;

@property (nonatomic, strong) id<FilterEventsVCDelegate> delegate;

@end
