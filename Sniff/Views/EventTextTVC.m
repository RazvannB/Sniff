//
//  EventTextTVC.m
//  Sniff
//
//  Created by Razvan Balint on 11/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventTextTVC.h"

@implementation EventTextTVC

- (void)awakeFromNib {
    // Initialization code
}

- (void)initWithInfo:(NSDictionary*)dictionary {
    self.infoDictionary = [[NSDictionary alloc] initWithDictionary:dictionary];
}

- (void)setEventTextType:(EventTextType)eventTextType info:(NSDictionary*)infoDictionary {
    self.infoDictionary = [[NSDictionary alloc] initWithDictionary:infoDictionary];
    self.eventTextType = eventTextType;
    switch (eventTextType) {
            
        case EventTextType_Date: {
            if ([self.infoDictionary[@"start_date"] class] != [NSNull class]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dateFromString = [formatter dateFromString:self.infoDictionary[@"start_date"]];
                [formatter setDateFormat:@"dd.MM.yyyy"];
                NSString *stringFromDate = [formatter stringFromDate:dateFromString];
                self.textview.text = [NSString stringWithFormat:@"Data: %@", stringFromDate];
            } else {
                self.textview.text = @"Nicio data disponibila momentan";
            }
            break;
        }
            
        case EventTextType_Location:
            if ([self.infoDictionary[@"address"] class] != [NSNull class]) {
                self.textview.text = [NSString stringWithFormat:@"Locatie: %@", self.infoDictionary[@"address"]];
            } else {
                self.textview.text = @"Nicio locatie disponibila momentan";
            }
            break;
            
        case EventTextType_Description:
            if ([self.infoDictionary[@"description"] class] != [NSNull class]) {
                self.textview.text = [NSString stringWithFormat:@"%@", self.infoDictionary[@"description"]];
            } else {
                self.textview.text = @"Nicio descriere disponibila momentan";
            }
            break;
            
        case EventTextType_FBPage:
            if ([self.infoDictionary[@"FbPage"] class] != [NSNull class]) {
                self.textview.text = self.infoDictionary[@"FbPage"];
            } else {
                self.textview.text = @"Niciun link disponibil momentan";
            }
            self.textview.textAlignment = NSTextAlignmentCenter;
            break;
            
        default:
            break;
    }
}

+ (CGFloat)getCellHeightWithText:(NSString*)text {
    if ([text class] != [NSNull class] && [text length]) {
        return [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                               attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Verdana" size:14.0]}
                                  context:nil].size.height * 1.75 + 32;
    } else {
        return 44;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
