//
//  MessageTVC.h
//  Sniff
//
//  Created by Razvan Balint on 02/01/16.
//  Copyright © 2016 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MessageTVCType_NoEvents,
    MessageTVCType_NoFavoriteEvents,
    MessageTVCType_NoCategoryEvents
} MessageTVCType ;

@interface MessageTVC : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@property (nonatomic) MessageTVCType messageTVCType;

+ (CGFloat)height;

@end
