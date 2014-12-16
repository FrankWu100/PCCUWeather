//
//  TodayViewController.m
//  Weather Widget
//
//  Created by FrankWu on 2014/11/25.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Reachability.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.weather = [[Weather alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.label7.text = @"更新中...";
    [self performUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
    
//    NCUpdateResult updateResult;
//    if (/* Hey look, I have new content! */) {
//        updateResult = NCUpdateResultNewData;
//    } else if ( /* Hm, nothing new here. */) {
//        updateResult = NCUpdateResultNoData;
//    } else if ( /* Uh-oh... */) {
//        updateResult = NCUpdateResultFailed;
//    }
//    completionHandler(updateResult);
    
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

- (void)performUpdate {
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    NSString *jsonUrlString = [NSString stringWithFormat:@"https://mobi.pccu.edu.tw/DataAPI/weather"];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"Error = %@", error);
        NSLog(@"%@", [NSString stringWithFormat:@"%ld %@", (long)[error code], [[error userInfo] valueForKey:@"NSLocalizedDescription"]]);
        
        if (![self connected]) {
            // not connected
            self.label7.text = @"沒有網路連線";
        } else {
            // connected, do some internet stuff
            self.label7.text = [[error userInfo] valueForKey:@"NSLocalizedDescription"];
        }
    }
    else {
        
        //-- JSON Parsing
        NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"Result = %@", result);
        
        self.weather.tempature = [result valueForKey:@"Tempature"];
        self.weather.humidity = [result valueForKey:@"Humidity"];
        self.weather.windDirection = [result valueForKey:@"WindDirection"];
        self.weather.windSpeed = [result valueForKey:@"WindSpeed"];
        self.weather.atmosph = [result valueForKey:@"Atmosph"];
        self.weather.rainFall = [result valueForKey:@"RainFall"];
        self.weather.updateTime = [result valueForKey:@"UpdateTime"];
        
        //    self.label1.text = @"溫度：";
        //    if (self.weather.tempature.doubleValue < 10.0) {
        //        self.label1.text = [self.label1.text stringByAppendingString:@"  "];
        //    }
        //    self.label1.text = [self.label1.text stringByAppendingFormat:@"%.1f ℃", self.weather.tempature.doubleValue];
        //
        //    self.label2.text = @"濕度：";
        //    if (self.weather.humidity.doubleValue < 10.0) {
        //        self.label2.text = [self.label2.text stringByAppendingString:@"  "];
        //    }
        //    self.label2.text = [self.label2.text stringByAppendingFormat:@"%.1f %%", self.weather.humidity.doubleValue];
        //
        //    self.label3.text = [NSString stringWithFormat:@"風向：%@", self.weather.windDirection];
        //
        //    self.label4.text = @"風速：";
        //    if (self.weather.windSpeed.doubleValue < 10.0) {
        //        self.label4.text = [self.label4.text stringByAppendingString:@"  "];
        //    }
        //    self.label4.text = [self.label4.text stringByAppendingFormat:@"%.1f m/s", self.weather.windSpeed.doubleValue];
        //
        //    self.label5.text = [NSString stringWithFormat:@"氣壓：%.1f hPa", self.weather.atmosph.doubleValue];
        //
        //    self.label6.text = [NSString stringWithFormat:@"雨量：%.2f mm", self.weather.rainFall.doubleValue];
        //
        //    self.label7.text = [NSString stringWithFormat:@"更新時間：%@", self.weather.updateTime];
        
        self.label1.text = [NSString stringWithFormat:@"溫度：%@ ℃", self.weather.tempature];
        
        self.label2.text = [NSString stringWithFormat:@"濕度：%@ %%", self.weather.humidity];
        
        self.label3.text = [NSString stringWithFormat:@"風向：%@", self.weather.windDirection];
        
        self.label4.text = [NSString stringWithFormat:@"風速：%@ m/s", self.weather.windSpeed];
        
        self.label5.text = [NSString stringWithFormat:@"氣壓：%@ hPa", self.weather.atmosph];
        
        self.label6.text = [NSString stringWithFormat:@"雨量：%@ mm", self.weather.rainFall];
        
        self.label7.text = [NSString stringWithFormat:@"更新時間：%@", self.weather.updateTime];
    }
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
