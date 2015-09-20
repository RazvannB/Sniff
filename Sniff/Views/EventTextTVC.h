//
//  EventTextTVC.h
//  Sniff
//
//  Created by Razvan Balint on 11/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

typedef enum {
    EventTextType_Date,
    EventTextType_Location,
    EventTextType_Description,
    EventTextType_FBPage,
    EventTextType_Organiser
} EventTextType;

#import <UIKit/UIKit.h>

@interface EventTextTVC : UITableViewCell

@property (nonatomic) EventTextType eventTextType;
@property (nonatomic) NSDictionary *infoDictionary;
@property (nonatomic, weak) IBOutlet UILabel *textview;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textHeightConstraint;

- (void)initWithInfo:(NSDictionary*)dictionary;
- (void)setEventTextType:(EventTextType)eventTextType info:(NSDictionary*)infoDictionary;
+ (CGFloat)getCellHeightWithText:(NSString*)text;

@end
