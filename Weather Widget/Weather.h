//
//  Weather.h
//  PCCUCLG
//
//  Created by FrankWu on 2014/11/26.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic, strong) NSString *Location;
@property (nonatomic, strong) NSString *Tempature;
@property (nonatomic, strong) NSString *Humidity;
@property (nonatomic, strong) NSString *WindDirection;
@property (nonatomic, strong) NSString *WindSpeed;
@property (nonatomic, strong) NSString *Atmosph;
@property (nonatomic, strong) NSString *RainFall;
@property (nonatomic, strong) NSString *UpdateTime;
@property (nonatomic, strong) NSString *InfoSource;
@property (nonatomic, strong) NSString *WeatherDesciption;

- (id)initWithJSONString:(NSString *)JSONString;
- (id)initWithJSONDictionary:(NSDictionary *)JSONDictionary;

- (NSString *)Tempature_withUnit;
- (NSString *)Humidity_withUnit;
- (NSString *)WindSpeed_withUnit;
- (NSString *)Atmosph_withUnit;
- (NSString *)RainFall_withUnit;

@end
