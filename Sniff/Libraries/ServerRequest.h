//
//  ServerRequest.h
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServerRequest;

typedef enum {
    ServerRequestType_Login,
    ServerRequestType_Register,
    ServerRequestType_GetPublicEvents,
    ServerRequestType_GetEventInfo,
    ServerRequestType_GetApprovedFeedback,
    ServerRequestType_GetSchedule,
    ServerRequestType_SendFeedback,
    ServerRequestType_SearchEvents,
    ServerRequestType_JoinEvent,
    ServerRequestType_CheckIfJoined,
    ServerRequestType_GetFavouriteEvents,
} ServerRequestType;

typedef void(^ServerRequestCompletion)(ServerRequest *serverRequest);

@interface ServerRequest : NSObject

@property (nonatomic, strong) NSString *serverURL;
@property (nonatomic, strong) NSString *functionURL;
@property (nonatomic, strong) NSMutableDictionary *parameters;
@property (readonly) ServerRequestType serverRequestType;

@property (nonatomic, strong) id response;
@property (nonatomic, strong) NSDictionary *responseData;
@property (nonatomic, strong) NSString *responseMessage;
@property (nonatomic) NSInteger statusCode;

+ (ServerRequest *)requestWithFunction:(ServerRequestType)serverRequestType;

- (BOOL)addValue:(id)value forParameter:(NSString *)parameter;
- (void)get:(ServerRequestCompletion)completion;
- (void)post:(ServerRequestCompletion)completion;
- (void)postHTTP:(ServerRequestCompletion)completion;

@end
