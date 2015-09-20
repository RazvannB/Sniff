//
//  JoinButtonsView.m
//  Sniff
//
//  Created by Razvan Balint on 20/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "JoinButtonsView.h"
#import "AuthenticationController.h"

@implementation JoinButtonsView

- (instancetype)init {
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"JoinButtonsView" owner:self options:nil][0];
        self.joinButton.layer.cornerRadius = 5;
        self.participantsButton.layer.cornerRadius = 5;
        self.numberOfParticipants = @100;
    }
    return self;
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

- (IBAction)joinButtonTouched:(id)sender {
    
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
    return 46;
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
