//
//  EventsTableVC.m
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#import "EventsTableVC.h"
#import "EventsController.h"
#import "MBProgressHUD.h"
#import "Event.h"
#import "EventInfoTableVC.h"
#import "EventsListTVC.h"
#import "FilterEventsVC.h"

@interface EventsTableVC () <FilterEventsVCDelegate>

@end

@implementation EventsTableVC

BOOL isCheckingOnlineForEvents;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"Evenimente";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filtreaza"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(chooseFilter)];
    
    [self setTypeSelected:0];
}

- (NSMutableArray *)eventsArray {
    if (!_eventsArray || ![_eventsArray count]) {
        _eventsArray = [[NSMutableArray alloc] initWithArray:[EventsController sharedInstance].eventsArray];
        if ((!_eventsArray || ![_eventsArray count]) && !isCheckingOnlineForEvents) {
            [self checkServerForUpdatesWithIndicator:YES];
        }
    }
    
    if (!self.allEventsArray || ![self.allEventsArray count]) {
        self.allEventsArray = _eventsArray;
    }
    
    return _eventsArray;
}

- (void)setTypeSelected:(NSInteger)typeSelected {
    _typeSelected = typeSelected;
    
    BOOL shouldFilter = YES;
    NSString *predicateTerm = @"";
    switch (typeSelected) {
        case 0:
            break;
            
        case 1:
            predicateTerm = @"Educational";
            break;
            
        case 2:
            predicateTerm = @"Cariera";
            break;
            
        case 3:
            predicateTerm = @"Social";
            break;
            
        case 4:
            predicateTerm = @"Distractie";
            break;
            
        case 5:
            predicateTerm = @"Concurs";
            break;
            
        case 6:
            predicateTerm = @"Training";
            break;
            
        default:
            shouldFilter = NO;
            break;
    }
    
    if (shouldFilter) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryName contains %@", predicateTerm];
        self.eventsArray = [[self.allEventsArray filteredArrayUsingPredicate:predicate] mutableCopy];
        [self.tableView reloadData];
    }
    
    [self.tableView reloadData];
}

- (void)checkServerForUpdatesWithIndicator:(BOOL)indicator {
    isCheckingOnlineForEvents = YES;
    MBProgressHUD *progressHud;
    if (indicator) {
        progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        progressHud.labelText = @"Se cauta evenimentele...";
    }
    
    [[EventsController sharedInstance] getPublicEventsWithCompletion:^(BOOL success, NSString *message, EventsController *completion) {
        if (success) {

            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"Este o problema cu descarcarea evenimentelor"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        if (indicator) {
            [progressHud hide:YES];
        }
        isCheckingOnlineForEvents = NO;
    }];
}

- (void)chooseFilter {
    FilterEventsVC *filterVC = [[FilterEventsVC alloc] init];
    filterVC.view.backgroundColor = [UIColor clearColor];
    filterVC.providesPresentationContextTransitionStyle = YES;
    filterVC.definesPresentationContext = YES;
    filterVC.delegate = self;
    [filterVC setSelectedValue:self.typeSelected];
    self.view.alpha = 0.3;
    
    [self.navigationController presentViewController:filterVC animated:YES completion:nil];
}

//- (void)sortArrayOfEvents {
//    NSMutableArray *tempEventsArray = [self.allEventsArray mutableCopy];
//    for (Event *event in self.allEventsArray) {
//        if (self.eventsType == EventsTableVCType_Default && [event.DiffDate intValue] < 0) {
//            [tempEventsArray removeObject:event];
//        } else if (self.eventsType == EventsTableVCType_PastEvents && [event.DiffDate intValue] >= 0) {
//            [tempEventsArray removeObject:event];
//        }
//    }
//    self.allEventsArray = [tempEventsArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        
//        int amr1 = [[obj1 DiffDate] intValue];
//        int amr2 = [[obj2 DiffDate] intValue];
//        
//        return [
//    }];
//    
//}

#pragma mark - FilterEventsVCDelegate

- (void)filterEventsVC:(FilterEventsVC *)filterEventsVC dismissViewWithValue:(NSInteger)index {
    
    [self setTypeSelected:index];
    
    [self dismissViewControllerAnimated:filterEventsVC completion:^{
        self.view.alpha = 1;
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EventsListTVC";
    id cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[EventsListTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [[NSBundle mainBundle] loadNibNamed:@"EventsListTVC" owner:self options:nil][0];
    }
    [cell setEvent:self.eventsArray[indexPath.row]];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventInfoTableVC *eventInfo = [[EventInfoTableVC alloc] init];
    [eventInfo initWithEvent:self.eventsArray[indexPath.row]];
    [self.navigationController pushViewController:eventInfo animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EventsListTVC height];
}

@end
