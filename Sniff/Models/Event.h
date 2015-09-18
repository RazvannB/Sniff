//
//  Event.h
//  Sniff
//
//  Created by Razvan Balint on 10/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *project_name;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *location_name;
@property (nonatomic, strong) NSString *start_date;
@property (nonatomic, strong) NSString *end_date;
@property (nonatomic, strong) NSString *org_name;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *FbPage;
@property (nonatomic, strong) NSString *DiffDate;

+ (Event*)initWithDictionary:(NSDictionary*)dictionary;

@end
