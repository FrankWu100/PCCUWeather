//
//  Weather.m
//  PCCUCLG
//
//  Created by FrankWu on 2014/11/26.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import "Weather.h"
#import <objc/runtime.h>

@implementation Weather

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
    
    self.Location = @"";
    self.Tempature = @"";
    self.Humidity = @"";
    self.WindDirection = @"";
    self.WindSpeed = @"";
    self.Atmosph = @"";
    self.RainFall = @"";
    self.UpdateTime = @"";
    self.InfoSource = @"";
    self.WeatherDesciption = @"";
    
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
    self = [self init];
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
    self = [self init];
    if (self) {
        
        NSError *error = nil;
        
        if (!error && JSONDictionary) {
            
            NSMutableDictionary *JSONDictionary_lowercase = [[NSMutableDictionary alloc] init];
            for (NSString* key in JSONDictionary) {
                [JSONDictionary_lowercase setObject:[JSONDictionary objectForKey:key] forKey:[key lowercaseString]];
            }
            
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
            
            for (unsigned int i = 0; i < propertyCount; ++i) {
                objc_property_t property = properties[i];
                const char * propertyName = property_getName(property);
                
                NSString *propertyName_String = [NSString stringWithUTF8String:propertyName];
                NSString *propertyName_lowercaseString = [propertyName_String lowercaseString];
                
                if ([[JSONDictionary_lowercase allKeys] containsObject:propertyName_lowercaseString])
                {
                    if ([[JSONDictionary_lowercase valueForKey:propertyName_lowercaseString] isKindOfClass:[NSNumber class]]) {
                        
                        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
                        
                        formatter.numberStyle = NSNumberFormatterNoStyle;
                        formatter.minimumFractionDigits = 0;
                        formatter.maximumFractionDigits = 1;
                        
                        formatter.minimumIntegerDigits = 1;
                        
                        // NSNumberFormatter を使用して、数値を小数点数 3 桁～ 6 桁までで表現した文字列を取得します。
                        NSString* numString = [formatter stringFromNumber:[JSONDictionary_lowercase valueForKey:propertyName_lowercaseString]];
                        
                        [self setValue:numString forKey:[self lowercaseFirstText:propertyName_String]];
                    }
                    else {
                        [self setValue:[JSONDictionary_lowercase valueForKey:propertyName_lowercaseString] forKey:[self lowercaseFirstText:propertyName_String]];
                    }
                }
            }
            free(properties);
        }
    }
    return self;
}

- (NSString *)Tempature_withUnit
{
    NSString *temp = self.Tempature;
    if ([temp length]) return [temp stringByAppendingString:@" ℃"];
    else return @"";
}

- (NSString *)Humidity_withUnit
{
    NSString *temp = self.Humidity;
    if ([temp length]) return [temp stringByAppendingString:@" %"];
    else return @"";
}

- (NSString *)WindSpeed_withUnit
{
    NSString *temp = self.WindSpeed;
    if ([temp length]) return [temp stringByAppendingString:@" m/s"];
    else return @"";
}

- (NSString *)Atmosph_withUnit
{
    NSString *temp = self.Atmosph;
    if ([temp length]) return [temp stringByAppendingString:@" hPa"];
    else return @"";
}

- (NSString *)RainFall_withUnit
{
    NSString *temp = self.RainFall;
    if ([temp length]) return [temp stringByAppendingString:@" mm"];
    else return @"";
}

@end
