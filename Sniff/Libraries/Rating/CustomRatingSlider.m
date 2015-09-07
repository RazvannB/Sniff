//
//  CustomRatingSlider.m
//  Sniff
//
//  Created by Razvan Balint on 07/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#define starPadding 4

#define kEmptyStarImageName @"star_empty"
#define kFilledStarImageName @"star_full"
#define kHalfStarImageName @"star_half"

#import "CustomRatingSlider.h"

@implementation CustomRatingSlider {
    NSMutableArray *_stars;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setMinimumValue:0.0];
    [self setMaximumValue:5];
    
}

+ (CGFloat)width {
    return (5 * (30 + starPadding)) - 2 * starPadding;
}

- (void)setValue:(float)value animated:(BOOL)animated {
    [self setValue:value animated:animated withCallback:YES];
}

- (void)setValue:(float)value animated:(BOOL)animated withCallback:(BOOL)callback {
    //stars before selected point are set to filled and the rest are set to empty
    
    for (int i = 0 ; i < 5; i++) {
        
        UIImageView * star = [_stars objectAtIndex:i];
        
        if (i < (int)value) {
            star.image = [UIImage imageNamed:kFilledStarImageName];
        } else {
            star.image = [UIImage imageNamed:kEmptyStarImageName];
        }
        
    }
    
    // fill the selected star accordingly
    int selectedStarIndex = value;
    
    if (selectedStarIndex < 5) {
        
        UIImageView * starImageView = [_stars objectAtIndex:selectedStarIndex];
        
        // fill last star
        float decimalValue = (value - (int)value);
        
        if (decimalValue < 0.33) {
            // first 33% - > no star
            
            [super setValue:(int)value - 0.33 animated:animated];
            starImageView.image = [UIImage imageNamed:kEmptyStarImageName];
            
        } else if(decimalValue < 0.67) {
            // between 33% and 66% - > half star
            
            [super setValue:(int)value + 0.34 animated:animated];
            starImageView.image = [UIImage imageNamed:kHalfStarImageName];
            
        } else {
            // more than 66% - > full star
            
            [super setValue:(int)value + 0.67 animated:animated];
            starImageView.image = [UIImage imageNamed:kFilledStarImageName];
            
        }
        
    }
    
    if (callback && [self.delegate respondsToSelector:@selector(rateValueChangedForSlider:)]) {
        [self.delegate rateValueChangedForSlider:self];
    }
    
}

- (void)layoutSubviews {
    
    if (!_stars) {
        
        self.frame = CGRectMake(self.frame.origin.x + (self.frame.size.width - [CustomRatingSlider width]) / 4.0,
                                self.frame.origin.y,
                                [CustomRatingSlider width],
                                self.frame.size.height);
        
        _stars = [NSMutableArray array];
        
        // init stars array
        for (int i = 0; i < 5; i++) {
            
            UIImageView * starView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kEmptyStarImageName]];
            starView.frame = CGRectMake(i * (30 + starPadding), (self.frame.size.height - 30) / 2.0, 30, 30);
            
            [_stars addObject:starView];
            
            [self addSubview:starView];
            
        }
        
    }
    
}


@end
