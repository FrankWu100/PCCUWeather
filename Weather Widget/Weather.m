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

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    
    self.tempature = @"";
    self.humidity = @"";
    self.windDirection = @"";
    self.windSpeed = @"";
    self.atmosph = @"";
    self.rainFall = @"";
    self.updateTime = @"";
    
    return self;
}

@end
