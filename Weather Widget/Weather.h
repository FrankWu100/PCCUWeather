//
//  Weather.h
//  PCCUCLG
//
//  Created by FrankWu on 2014/11/26.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *tempature;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *windDirection;
@property (nonatomic, strong) NSString *windSpeed;
@property (nonatomic, strong) NSString *atmosph;
@property (nonatomic, strong) NSString *rainFall;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *infoSource;

- (id)initWithJSONString:(NSString *)JSONString;
- (id)initWithJSONDictionary:(NSDictionary *)JSONDictionary;

@end
