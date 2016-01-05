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
#import "MessageTVC.h"

@interface EventsTableVC () <FilterEventsVCDelegate>

@end

@implementation EventsTableVC

BOOL isCheckingOnlineForEvents;

- (instancetype)initWithType:(EventsTableVCType)eventsType {
    if (self = [super init]) {
        _eventsType = eventsType;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filtreaza"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(chooseFilter)];
    
    if (self.eventsType == EventsTableVCType_Default) {
        self.title = @"Evenimente";
        if ([self.eventsArray count]) {
            [self checkServerForUpdatesWithIndicator:NO];
        } else {
            [self checkServerForUpdatesWithIndicator:YES];
        }
    } else {
        self.title = @"Evenimente favorite";
        self.allEventsArray = [EventsController sharedInstance].favoriteEventsArray;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSMutableArray *)eventsArray {
    
    if (!_eventsArray) {

        if (self.eventsType == EventsTableVCType_Default) {
            _eventsArray = [[NSMutableArray alloc] initWithArray:[EventsController sharedInstance].eventsArray];
        } else {
            _eventsArray = [[NSMutableArray alloc] initWithArray:[EventsController sharedInstance].favoriteEventsArray];
        }
    }
    
    return _eventsArray;
}

- (NSArray *)allEventsArray {
    
    if (!_allEventsArray || ![_allEventsArray count]) {
        _allEventsArray = self.eventsArray;
    }
    
    return _allEventsArray;
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
        
        if (typeSelected == 0) {
            self.eventsArray = nil;
        }
        
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
            
            self.eventsArray = [[NSMutableArray alloc] initWithArray:[EventsController sharedInstance].eventsArray];
            
            if (!self.allEventsArray || ![self.allEventsArray count]) {
                self.allEventsArray = _eventsArray;
            }
            
            [self setTypeSelected:0];
            
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

#pragma mark - FilterEventsVCDelegate

- (void)filterEventsVC:(FilterEventsVC *)filterEventsVC dismissViewWithValue:(NSInteger)index {
    
    [self setTypeSelected:index];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.alpha = 1;
        
        [self dismissViewControllerAnimated:filterEventsVC completion:nil];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventsArray count] ? [self.eventsArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell;
    static NSString *cellIdentifier = @"EventsListTVC";
    static NSString *noCellIdentifier = @"MessageTVC";
    
    if ([self.eventsArray count]) {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[EventsListTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell = [[NSBundle mainBundle] loadNibNamed:@"EventsListTVC" owner:self options:nil][0];
        }
        [cell setEvent:self.eventsArray[indexPath.row]];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:noCellIdentifier];
        if (cell == nil) {
            cell = [[MessageTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noCellIdentifier];
            cell = [[NSBundle mainBundle] loadNibNamed:@"MessageTVC" owner:self options:nil][0];
        }
        
        if (![self.allEventsArray count]) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
            if (self.eventsType == EventsTableVCType_Default) {
                [cell setMessageTVCType:MessageTVCType_NoEvents];
            } else {
                [cell setMessageTVCType:MessageTVCType_NoFavoriteEvents];
            }
        } else {
            [cell setMessageTVCType:MessageTVCType_NoCategoryEvents];
        }
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.eventsArray count]) {
        EventInfoTableVC *eventInfo = [[EventInfoTableVC alloc] initWithEvent:self.eventsArray[indexPath.row]];
        [self.navigationController pushViewController:eventInfo animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.eventsArray count] ? [EventsListTVC height] : [MessageTVC height];
}

@end
