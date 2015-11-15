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

@interface EventsTableVC () <UIActionSheetDelegate>

@end

@implementation EventsTableVC

BOOL isCheckingOnlineForEvents;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"Evenimente";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filtreaza"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(chooseSort)];
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

- (void)chooseSort {
    [[[UIActionSheet alloc] initWithTitle:@"Alege o categorie"
                                 delegate:self
                        cancelButtonTitle:@"Inapoi"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Toate categoriile", @"Educational", @"Concurs", nil] showInView:self.view];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(8.0f, 8.0f, 59.0f, 59.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSPredicate *predicate = [[NSPredicate alloc] init];
    BOOL shouldFilter = YES;
    switch (buttonIndex) {
        case 0:
            predicate = [NSPredicate predicateWithFormat:@"categoryName contains %@", @""];
            break;
        
        case 1:
            predicate = [NSPredicate predicateWithFormat:@"categoryName like %@", @"Educational"];
            break;
            
        case 2:
            predicate = [NSPredicate predicateWithFormat:@"categoryName like %@", @"Concurs"];
            break;
            
        default:
            shouldFilter = NO;
            break;
    }
    
    if (shouldFilter) {
        self.eventsArray = [[self.allEventsArray filteredArrayUsingPredicate:predicate] mutableCopy];
        [self.tableView reloadData];
    }
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
