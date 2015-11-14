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
        case EventTextType_Organiser: {
            if ([self.infoDictionary[@"org_name"] class] != [NSNull class]) {
                [self setMessage:[NSString stringWithFormat:@"Organizator: %@", self.infoDictionary[@"org_name"]]];
            } else {
                [self setMessage:@"Organizator anonim"];
            }
            break;
        }
            
        case EventTextType_Date: {
            if ([self.infoDictionary[@"start_date"] class] != [NSNull class]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dateFromString = [formatter dateFromString:self.infoDictionary[@"start_date"]];
                [formatter setDateFormat:@"dd.MM.yyyy"];
                NSString *stringFromDate = [formatter stringFromDate:dateFromString];
                [self setMessage:[NSString stringWithFormat:@"Data: %@", stringFromDate]];
            } else {
                [self setMessage:@"Nicio data disponibila momentan"];
            }
            break;
        }
            
        case EventTextType_Location:
            if ([self.infoDictionary[@"address"] class] != [NSNull class]) {
                [self setMessage:[NSString stringWithFormat:@"Locatie: %@", self.infoDictionary[@"address"]]];
            } else {
                [self setMessage:@"Nicio locatie disponibila momentan"];
            }
            break;
            
        case EventTextType_Description:
            if ([self.infoDictionary[@"description"] class] != [NSNull class]) {
                [self setMessage:[NSString stringWithFormat:@"%@", self.infoDictionary[@"description"]]];
            } else {
                [self setMessage:@"Nicio descriere disponibila momentan"];
            }
            break;
            
        case EventTextType_FBPage:
            if ([self.infoDictionary[@"FbPage"] class] != [NSNull class]) {
                [self setMessage:self.infoDictionary[@"FbPage"]];
            } else {
                [self setMessage:@"Niciun link disponibil momentan"];
            }
            self.textview.textAlignment = NSTextAlignmentCenter;
            break;
            
        default:
            break;
    }
}

- (void)setMessage:(NSString *)message {
    self.textHeightConstraint.constant = [message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX)
                                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                            attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:17.0]}
                                                               context:nil].size.height;
    [self layoutIfNeeded];
    self.textview.text = message;
}

+ (CGFloat)getCellHeightWithText:(NSString*)text {
    if ([text class] != [NSNull class] && [text length]) {
        return [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                               attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:17.0]}
                                  context:nil].size.height + 16;
    } else {
        return 44;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithRed:22.0f/255.0f green:44.0f/255.0f blue:66.0f/255.0f alpha:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithRed:22.0f/255.0f green:44.0f/255.0f blue:66.0f/255.0f alpha:1];
    } 
}

@end
