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

@interface EventsTableVC ()

@end

@implementation EventsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHud.labelText = @"Retrieving events...";
    
    [[EventsController sharedInstance] getPublicEventsWithCompletion:^(BOOL success, NSString *message, EventsController *completion) {
        if (success) {
            [progressHud hide:YES];
            self.eventsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *eventDictionary in completion.eventsArray) {
                Event *event = [Event initWithDictionary:eventDictionary];
                [self.eventsArray addObject:event];
            }
            [self.tableView reloadData];
        } else {
            [progressHud hide:YES];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(8.0f, 8.0f, 59.0f, 59.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.eventsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        Event *event = self.eventsArray[indexPath.row];
        cell.textLabel.text = event.project_name;
        int colorHEX = [[event.color stringByReplacingOccurrencesOfString:@"#" withString:@""] intValue];
        cell.imageView.image = [self imageWithColor:UIColorFromRGB(colorHEX)];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

@end
