//
//  EventsTableVC.m
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventsTableVC.h"
#import "EventsController.h"
#import "MBProgressHUD.h"
#import "Event.h"
#import "EventInfoTableVC.h"
#import "EventsListTVC.h"
#import "FilterEventsVC.h"
#import "MessageTVC.h"
#import "Colors.h"

@interface EventsTableVC () <FilterEventsVCDelegate, UISearchBarDelegate>

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
    
    [EventsController makeNavigationBarBackToDefault:self.navigationController.navigationBar];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filtreaza"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(chooseFilter)];
    
    if (self.eventsType == EventsTableVCType_Default) {
        self.title = @"Evenimente";
        [self updateEvents];
        
    } else {
        self.title = @"Evenimente favorite";
        self.allEventsArray = [EventsController sharedInstance].favoriteEventsArray;
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [Colors customGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateEvents)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSMutableArray *)eventsArray {
    
    if (!_eventsArray) {

        if (self.eventsType == EventsTableVCType_Default) {
            _eventsArray = [[NSMutableArray alloc] initWithArray:[EventsController sharedInstance].eventsArray];
            [self sortEvents];
        } else {
            _eventsArray = [[NSMutableArray alloc] initWithArray:[EventsController sharedInstance].favoriteEventsArray];
            [self sortEvents];
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
    if (typeSelected > 6) {
        shouldFilter = NO;
    }
    
    if (shouldFilter) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryName contains %@", [EventsController getPredicateTermWithIndex:typeSelected]];
        _eventsArray = [[self.allEventsArray filteredArrayUsingPredicate:predicate] mutableCopy];
        
        if (typeSelected == 0) {
            _eventsArray = nil;
        }
    }
    
    [self sortEvents];
    [self.tableView reloadData];
}

- (void)updateEvents {
    
    if ([self.eventsArray count]) {
        [self checkServerForUpdatesWithIndicator:NO];
    } else {
        [self checkServerForUpdatesWithIndicator:YES];
    }
}

- (void)sortEvents {
    [_eventsArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        obj1 = @(abs([[(Event *)obj1 DiffDate] intValue]));
        obj2 = @(abs([[(Event *)obj2 DiffDate] intValue]));
        
        return [obj1 compare:obj2];
    }];
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
            
            _eventsArray = [[NSMutableArray alloc] initWithArray:[EventsController sharedInstance].eventsArray];
            
            if (!self.allEventsArray || ![self.allEventsArray count]) {
                self.allEventsArray = _eventsArray;
            }
            
            [self setTypeSelected:0];
            
            [[EventsController sharedInstance] getFavoriteEventsWithCompletion:^(BOOL success, NSString *message, EventsController *completion) {
                if (success) {
                    [self.tableView reloadData];
                }
            }];
            
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
        
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
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

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString *searchText = searchBar.text;
    
    if (![searchText length]) {
        [self.view endEditing:YES];
        
        if (self.eventsType == EventsTableVCType_Default) {
            
            self.eventsArray = [EventsController sharedInstance].eventsArray;
            [self setTypeSelected:self.typeSelected];
            
        } else if (self.eventsType == EventsTableVCType_Favorite) {
            self.eventsArray = [[EventsController sharedInstance].favoriteEventsArray mutableCopy];
        }
        
        [self.tableView reloadData];
        return;
    }
    
    [[EventsController sharedInstance] searchEventsWithTerm:searchText
                                                 completion:^(BOOL success, NSString *message, EventsController *completion) {
                                                     
                                                     if (success) {
                                                         self.eventsArray = completion.searchArray;
                                                     }
                                                     
                                                     [self.tableView reloadData];
                                                     
                                                 }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchBarSearchButtonClicked:searchBar];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"/n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
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
        }
        
        if (self.eventsType == EventsTableVCType_Default) {
            [cell setMessageTVCType:MessageTVCType_NoEvents];
        } else {
            [cell setMessageTVCType:MessageTVCType_NoFavoriteEvents];
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
    } else {
        [self.view endEditing:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.eventsArray count] ? [EventsListTVC height] : [MessageTVC height];
}

@end
