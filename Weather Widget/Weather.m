//
//  Weather.m
//  PCCUCLG
//
//  Created by FrankWu on 2014/11/26.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import "Weather.h"

@implementation Weather

//@dynamic tempature;
//@dynamic humidity;
//@dynamic windDirection;
//@dynamic windSpeed;
//@dynamic atmosph;
//@dynamic rainFall;
//@dynamic updateTime;

//{
//Tempature: "18.9",
//Humidity: "87.0",
//WindDirection: "東北",
//WindSpeed: "1.7",
//Atmosph: "1013.9",
//RainFall: "0.00",
//UpdateTime: "2014-11-25 23:45"
//}


//@dynamic location;
//@dynamic infoSource;

//{
//    "Location": "大義館7F",
//    "Tempature": 10.7,
//    "Humidity": 93.0,
//    "WindDirection": "東",
//    "WindSpeed": 3.9,
//    "Atmosph": 1022.5,
//    "RainFall": 19.75,
//    "UpdateTime": "2015-03-11T16:45:00+08:00",
//    "InfoSource": "大氣系"
//}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    
    self.location = @"";
    self.tempature = @"";
    self.humidity = @"";
    self.windDirection = @"";
    self.windSpeed = @"";
    self.atmosph = @"";
    self.rainFall = @"";
    self.updateTime = @"";
    self.infoSource = @"";
    
    return self;
}

- (NSString *)lowercaseFirstText:(NSString*) theString
{
    NSString *ansString = [theString stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                              withString:[[theString  substringToIndex:1] lowercaseString]];
    return ansString;
}

- (id)initWithJSONString:(NSString *)JSONString
{
    self = [super init];
    if (self) {
        
        NSError *error = nil;
        NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
        
        if (!error && JSONDictionary) {
            
            //Loop method
            for (NSString* key in JSONDictionary) {
                [self setValue:[JSONDictionary valueForKey:key] forKey:[self lowercaseFirstText:key]];
            }
            // Instead of Loop method you can also use:
            // thanks @sapi for good catch and warning.
            // [self setValuesForKeysWithDictionary:JSONDictionary];
        }
    }
    return self;
}

- (id)initWithJSONDictionary:(NSDictionary *)JSONDictionary
{
    self = [super init];
    if (self) {
        
        NSError *error = nil;
        
        if (!error && JSONDictionary) {
            
            //Loop method
            for (NSString* key in JSONDictionary) {
                [self setValue:[JSONDictionary valueForKey:key] forKey:[self lowercaseFirstText:key]];
            }
            // Instead of Loop method you can also use:
            // thanks @sapi for good catch and warning.
            // [self setValuesForKeysWithDictionary:JSONDictionary];
        }
    }
    return self;
}

@end
