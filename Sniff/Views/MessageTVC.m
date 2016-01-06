//
//  MessageTVC.m
//  Sniff
//
//  Created by Razvan Balint on 02/01/16.
//  Copyright © 2016 Razvan Balint. All rights reserved.
//

#import "MessageTVC.h"

@implementation MessageTVC

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMessageTVCType:(MessageTVCType)messageTVCType {
    _messageTVCType = messageTVCType;
    
    switch (messageTVCType) {
        case MessageTVCType_NoEvents:
            self.messageLabel.text = @"Nu s-au gasit evenimente!";
            break;
            
        case MessageTVCType_NoFavoriteEvents:
            self.messageLabel.text = @"Nu aveti evenimente favorite!";
            break;
            
        case MessageTVCType_NoProgram:
            self.messageLabel.text = @"Nu exista un program momentan!";
            break;
            
        case MessageTVCType_NoFeedback:
            self.messageLabel.text = @"Nu exista feedback!";
            break;
            
        default:
            break;
    }
}

+ (CGFloat)height {
    return CGRectGetHeight([UIScreen mainScreen].bounds) - 64;
}

@end
