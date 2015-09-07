//
//  CustomRatingSlider.h
//  Sniff
//
//  Created by Razvan Balint on 07/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomRatingSlider;

@protocol CustomRatingSliderDelegate <NSObject>

- (void)rateValueChangedForSlider:(CustomRatingSlider *)slider;

@end

@interface CustomRatingSlider : UISlider

@property (nonatomic, weak) id <CustomRatingSliderDelegate> delegate;

- (void)setValue:(float)value animated:(BOOL)animated withCallback:(BOOL)callback;
+ (CGFloat)width;

@end
