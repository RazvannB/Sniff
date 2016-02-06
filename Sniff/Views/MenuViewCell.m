//
//  MenuViewCell.m
//  Sniff
//
//  Created by Razvan Balint on 18/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "MenuViewCell.h"
#import "Colors.h"

@implementation MenuViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    if (selected) {
        self.containerView.backgroundColor = [Colors customGrayColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:NO animated:animated];
    
    if (highlighted) {
        self.containerView.backgroundColor = [Colors customGrayColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

+ (CGFloat)height {
    return 66.0;
}

@end
