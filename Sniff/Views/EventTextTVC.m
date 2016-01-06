//
//  EventTextTVC.m
//  Sniff
//
//  Created by Razvan Balint on 11/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventTextTVC.h"
#import "Colors.h"
#import "EventsController.h"

@implementation EventTextTVC

@synthesize textLabel = _textLabel;

- (void)awakeFromNib {
    [self.layer addSublayer:[EventsController drawMaskForTextCellWithView:self.titleLabel]];
}

- (void)setEventTextType:(EventTextType)eventTextType info:(NSDictionary*)infoDictionary cellType:(EventTextCellType)eventTextCellType {
    _infoDictionary = [[NSDictionary alloc] initWithDictionary:infoDictionary];
    _eventTextType = eventTextType;
    _eventTextCellType = eventTextCellType;
    
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
                [self setMessage:self.infoDictionary[@"org_name"]];
            } else {
                [self setMessage:@"Anonim"];
            }
            break;
        }
            
        case EventTextType_Date: {
            if ([self.infoDictionary[@"start_date"] class] != [NSNull class] &&
                [self.infoDictionary[@"start_date"] length]) {
                
                self.titleLabel.text = @"Data";
                [self setMessage:[EventsController changeTextCellDateFormatFrom:self.infoDictionary[@"start_date"]]];
            } else {
                [self setMessage:@"Nicio data disponibila momentan"];
            }
            break;
        }
            
        case EventTextType_Location:
            if ([self.infoDictionary[@"address"] class] != [NSNull class] &&
                [self.infoDictionary[@"address"] length]) {
                
                self.titleLabel.text = @"Locatie";
                [self setMessage:self.infoDictionary[@"address"]];
            } else {
                [self setMessage:@"Nicio locatie disponibila momentan"];
            }
            break;
            
        case EventTextType_Description:
            if ([self.infoDictionary[@"description"] class] != [NSNull class] &&
                [self.infoDictionary[@"description"] length]) {
                
                self.titleLabel.text = @"Descriere";
                [self setMessage:self.infoDictionary[@"description"]];
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
    
    self.textHeightConstraint.constant = [EventsController getTextCellHeightWithText:message] + 1;
    self.textLabel.text = message;
    [self layoutIfNeeded];
}

+ (CGFloat)getCellHeightWithText:(NSString*)text {
    
    if ([text class] != [NSNull class] && [text length]) {
        return [EventsController getTextCellHeightWithText:text] + 16 + 21 + 8 + 1;
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
