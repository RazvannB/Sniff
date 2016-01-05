//
//  EventTextTVC.m
//  Sniff
//
//  Created by Razvan Balint on 11/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventTextTVC.h"
#import "Colors.h"

@implementation EventTextTVC

@synthesize textLabel = _textLabel;

- (void)awakeFromNib {

    CAShapeLayer *viewMaskLayer = [[CAShapeLayer alloc] init];
    viewMaskLayer.fillColor = [[Colors customGrayColor] CGColor];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(7, CGRectGetMinY(self.titleLabel.frame))];
    [path addLineToPoint:CGPointMake(10 + 7, CGRectGetMidY(self.titleLabel.frame))];
    [path addLineToPoint:CGPointMake(7, CGRectGetMaxY(self.titleLabel.frame))];
    
    viewMaskLayer.path = path.CGPath;
    
    [self.layer addSublayer:viewMaskLayer];
}

- (void)initWithInfo:(NSDictionary*)dictionary {
    self.infoDictionary = [[NSDictionary alloc] initWithDictionary:dictionary];
}

- (void)setEventTextType:(EventTextType)eventTextType info:(NSDictionary*)infoDictionary cellType:(EventTextCellType)eventTextCellType {
    self.infoDictionary = [[NSDictionary alloc] initWithDictionary:infoDictionary];
    self.eventTextType = eventTextType;
    self.eventTextCellType = eventTextCellType;
    
    switch (eventTextCellType) {
        case EventTextCellType_Default:
            self.titleLabelTrailingConstraint.priority = 999;
            self.textLabelTrailingConstraint.priority = 999;
            self.rightArrowImageView.hidden = YES;
            break;
            
        case EventTextCellType_Arrow:
            self.titleLabelTrailingConstraint.priority = 997;
            self.textLabelTrailingConstraint.priority = 997;
            self.rightArrowImageView.hidden = NO;
            break;
            
        default:
            break;
    }
    
    switch (eventTextType) {
        case EventTextType_Organiser: {
            if ([self.infoDictionary[@"org_name"] class] != [NSNull class] &&
                [self.infoDictionary[@"org_name"] length]) {
                self.titleLabel.text = @"Organizator";
                [self setMessage:[NSString stringWithFormat:@"%@", self.infoDictionary[@"org_name"]]];
            } else {
                [self setMessage:@"Anonim"];
            }
            break;
        }
            
        case EventTextType_Date: {
            if ([self.infoDictionary[@"start_date"] class] != [NSNull class] &&
                [self.infoDictionary[@"start_date"] length]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dateFromString = [formatter dateFromString:self.infoDictionary[@"start_date"]];
                [formatter setDateFormat:@"dd.MM.yyyy"];
                NSString *stringFromDate = [formatter stringFromDate:dateFromString];
                self.titleLabel.text = @"Data";
                [self setMessage:[NSString stringWithFormat:@"%@", stringFromDate]];
            } else {
                [self setMessage:@"Nicio data disponibila momentan"];
            }
            break;
        }
            
        case EventTextType_Location:
            if ([self.infoDictionary[@"address"] class] != [NSNull class] &&
                [self.infoDictionary[@"address"] length]) {
                self.titleLabel.text = @"Locatie";
                [self setMessage:[NSString stringWithFormat:@"%@", self.infoDictionary[@"address"]]];
            } else {
                [self setMessage:@"Nicio locatie disponibila momentan"];
            }
            break;
            
        case EventTextType_Description:
            if ([self.infoDictionary[@"description"] class] != [NSNull class] &&
                [self.infoDictionary[@"description"] length]) {
                self.titleLabel.text = @"Descriere";
                [self setMessage:[NSString stringWithFormat:@"%@", self.infoDictionary[@"description"]]];
            } else {
                [self setMessage:@"Nicio descriere disponibila momentan"];
            }
            break;
            
        case EventTextType_FBPage:
            if ([self.infoDictionary[@"FbPage"] class] != [NSNull class] &&
                [self.infoDictionary[@"FbPage"] length]) {
                self.titleLabel.text = @"Link";
                [self setMessage:self.infoDictionary[@"FbPage"]];
            } else {
                [self setMessage:@"Niciun link disponibil momentan"];
            }
            break;
            
        default:
            break;
    }
}

- (void)setMessage:(NSString *)message {
    self.textHeightConstraint.constant = [message boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 64, CGFLOAT_MAX)
                                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}
                                                               context:nil].size.height + 1;
    self.textLabel.text = message;
    [self layoutIfNeeded];
}

+ (CGFloat)getCellHeightWithText:(NSString*)text {
    if ([text class] != [NSNull class] && [text length]) {
        return [text boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 64, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}
                                  context:nil].size.height + 16 + 21 + 8 + 1;
    } else {
        return 67;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.containerView.backgroundColor = [Colors customPinkColor];
    } else {
        self.containerView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.containerView.backgroundColor = [Colors customPinkColor];
    } else {
        self.containerView.backgroundColor = [UIColor whiteColor];
    }
}

@end
