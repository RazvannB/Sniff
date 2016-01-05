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

typedef enum {
    EventTextCellType_Default,
    EventTextCellType_Arrow
} EventTextCellType;

#import <UIKit/UIKit.h>

@interface EventTextTVC : UITableViewCell

@property (nonatomic) EventTextType eventTextType;
@property (nonatomic) EventTextCellType eventTextCellType;
@property (nonatomic) NSDictionary *infoDictionary;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UIImageView *rightArrowImageView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelTrailingConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textLabelTrailingConstraint;

- (void)initWithInfo:(NSDictionary*)dictionary;
- (void)setEventTextType:(EventTextType)eventTextType info:(NSDictionary*)infoDictionary cellType:(EventTextCellType)eventTextCellType;
+ (CGFloat)getCellHeightWithText:(NSString*)text;

@end
