//
//  JoinButtonsView.m
//  Sniff
//
//  Created by Razvan Balint on 20/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "JoinButtonsView.h"
#import "AuthenticationController.h"
#import "EventsController.h"
#import "Colors.h"

@implementation JoinButtonsView

- (instancetype)initWithEvent:(Event *)event {
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"JoinButtonsView" owner:self options:nil][0];
        [self setEvent:event];
        _joinButton.layer.cornerRadius = 5;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.layer addSublayer:[EventsController drawMaskForFavouriteButtonWithView:self button:self.joinButton]];
    
    [self bringSubviewToFront:self.joinButton];
}

- (void)setEvent:(Event *)event {
    _event = event;
    
    NSArray *favouriteEventsIds = [[EventsController sharedInstance].favoriteEventsArray valueForKey:@"id"];
    BOOL isFavoriteEvent = [favouriteEventsIds containsObject:self.event.id];
    [self setIsFavourite:isFavoriteEvent];
}

- (void)setIsFavourite:(BOOL)isFavourite {
    _isFavourite = isFavourite;
    
    if (self.isFavourite) {
        [self.joinButton setBackgroundImage:[UIImage imageNamed:@"heart_full"] forState:UIControlStateNormal];
        [[EventsController sharedInstance] addEventToFavorites:self.event];
        
    } else {
        [self.joinButton setBackgroundImage:[UIImage imageNamed:@"heart_empty"] forState:UIControlStateNormal];
        [[EventsController sharedInstance] removeEventFromFavorites:self.event];
    }
}

- (IBAction)joinButtonTouched:(id)sender {
    
    if ([[AuthenticationController sharedInstance].loggedUser.id length]) {
        
        BOOL newState = !self.isFavourite;
        [self setIsFavourite:newState];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"Trebuie sa fiti autentificat ca sa puteti salva evenimente!"
                                   delegate:self
                          cancelButtonTitle:@"Inapoi"
                          otherButtonTitles:@"Autentificare", nil] show];
        
    }
}

+ (CGFloat)height {
    return 64;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(joinButtonsViewWIllGoToLogin)]) {
            [self.delegate joinButtonsViewWIllGoToLogin];
        }
    }
}

@end
