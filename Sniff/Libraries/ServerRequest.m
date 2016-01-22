//
//  ServerRequest.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "ServerRequest.h"
#import "AFNetworking.h"
#import "AuthenticationController.h"

@implementation ServerRequest

+ (ServerRequest *)requestWithFunction:(ServerRequestType)serverRequestType {
    return [[ServerRequest alloc] initWithServerRequestType:serverRequestType];
}

- (id)initWithServerRequestType:(ServerRequestType)serverRequestType {
    if (self = [super init]) {
        _serverRequestType = serverRequestType;
        _serverURL = @"http://sniff.as-mi.ro/services/";
    }
    return self;
}

- (BOOL)addValue:(id)value forParameter:(NSString *)parameter {
    if (!parameter || [parameter length] == 0 || !value) {
        return NO;
    } else {
        if (!self.parameters) {
            self.parameters = [NSMutableDictionary dictionary];
        }
        [self.parameters setObject:value forKey:parameter];
        return YES;
    }
}

- (void)post:(ServerRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text", nil];
    
    [manager POST:self.functionURL
       parameters:self.parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  self.responseData = responseObject;
              } else if ([responseObject isKindOfClass:[NSArray class]]) {
                  self.response = responseObject;
              } else if ([responseObject isKindOfClass:[NSString class]]){
                  self.response = responseObject;
              } else {
                  self.responseMessage = @"Invalid server response!";
                  self.response = nil;
                  self.responseData = nil;
              }
              if (completion){
                  completion(self);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              self.responseData = nil;
              self.response = nil;
              self.responseMessage = [NSString stringWithFormat:@"Request failed! %@", error.localizedDescription];
              
              if (completion){
                  completion(self);
              }
          }
     ];
}

- (void)get:(ServerRequestCompletion)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:self.functionURL
      parameters:self.parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 self.responseData = responseObject;
             } else if ([responseObject isKindOfClass:[NSArray class]]) {
                 self.response = responseObject;
             } else {
                 self.responseMessage = @"Invalid server response!";
                 self.response = nil;
                 self.responseData = nil;
             }
             if (completion){
                 completion(self);
             }

         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             self.responseData = nil;
             self.response = nil;
             self.responseMessage = [NSString stringWithFormat:@"Request failed! %@", error.localizedDescription];
             
             if (completion){
                 completion(self);
             }
         }
     ];
}

- (NSString *)functionURL {
    switch (self.serverRequestType) {
        case ServerRequestType_Login:
            return [self.serverURL stringByAppendingString:@"login.php"];
            
        case ServerRequestType_Register:
            return [self.serverURL stringByAppendingString:@"registerMobile.php"];
            
        case ServerRequestType_GetPublicEvents:
            return [self.serverURL stringByAppendingString:@"getPublicEvents.php"];
            
        case ServerRequestType_GetEventInfo:
            return [self.serverURL stringByAppendingString:@"getEventInfo.php"];
            
        case ServerRequestType_GetApprovedFeedback:
            return [self.serverURL stringByAppendingString:@"getAprovedFeedback.php"];
            
        case ServerRequestType_GetSchedule:
            return [self.serverURL stringByAppendingString:@"getSchandule.php"];
            
        case ServerRequestType_SendFeedback:
            return [self.serverURL stringByAppendingString:@"mobileTrimiteFeedback.php"];
            
        case ServerRequestType_SearchEvents:
            return [self.serverURL stringByAppendingString:@"searchiOS.php"];
            
        case ServerRequestType_JoinEvent:
            return [self.serverURL stringByAppendingString:@"joinEventiOS.php"];
            
        case ServerRequestType_CheckIfJoined:
            return [self.serverURL stringByAppendingString:@"ifJoin.php"];
            
        case ServerRequestType_GetFavouriteEvents:
            return [self.serverURL stringByAppendingString:@"getFavoritesiOS.php"];

        default:
            break;
    }
}

@end

