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
        _participantsButton.layer.cornerRadius = 5;
        _numberOfParticipants = @100;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CAShapeLayer *viewMaskLayer = [[CAShapeLayer alloc] init];
    viewMaskLayer.fillColor = [[Colors customGrayColor] CGColor];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 64)];
    [path addLineToPoint:CGPointMake(0, 32)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.frame) - CGRectGetWidth(self.joinButton.frame)/2 - 20, 32)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.frame) - CGRectGetWidth(self.joinButton.frame)/2, 2)];
    
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.frame) + CGRectGetWidth(self.joinButton.frame)/2, 2)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.frame) + CGRectGetWidth(self.joinButton.frame)/2 + 20, 32)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 32)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 64)];
    
    viewMaskLayer.path = path.CGPath;
    
    [self.layer addSublayer:viewMaskLayer];
    
    [self bringSubviewToFront:self.joinButton];
}

- (void)setEvent:(Event *)event {
    _event = event;
    
    BOOL isFavoriteEvent = [[[EventsController sharedInstance].favoriteEventsArray valueForKey:@"id"]  containsObject:self.event.id];
    [self setIsFavourite:isFavoriteEvent];
}

- (void)setInfoDictionary:(NSDictionary *)infoDictionary {
    _infoDictionary = infoDictionary;
    
    if ([[self.infoDictionary allKeys] containsObject:@"participanti"] && [self.infoDictionary[@"participanti"] class] != [NSNull class]) {
        self.numberOfParticipants = @([self.infoDictionary[@"participanti"] integerValue]);
    }
    
    [self.participantsButton setTitle:[NSString stringWithFormat:@"%@ Participanti", self.numberOfParticipants] forState:UIControlStateNormal];
    
    if ([self.numberOfParticipants compare:@0] != 0) {
        self.participantsButton.enabled = YES;
    } else {
        self.participantsButton.enabled = NO;
    }
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
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
    }
}

- (IBAction)participantsButtonTouched:(id)sender {
    if ([AuthenticationController sharedInstance].loggedUser) {
        if ([self.delegate respondsToSelector:@selector(joinButtonsViewWillShowParticipants)]) {
            [self.delegate joinButtonsViewWillShowParticipants];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"Trebuie sa fiti autentificat ca sa puteti vedea persoanele care participa"
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
