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
    
    self.label7.text = @"更新中...";
    
    _weather = [[Weather alloc] init];
    _weatherArray = [[NSMutableArray alloc] init];
    
    _locationArray = @[@"大義館7F", @"竹子湖", @"臺北"];
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *weatherDictionary = [defs objectForKey:@"WeatherDictionary"];
    NSLog(@"WeatherDictionary: %@", weatherDictionary);
    if (weatherDictionary != nil)
    {
        for (NSDictionary *result in weatherDictionary) {
            [_weatherArray addObject:[[Weather alloc] initWithJSONDictionary:result]];
        }
    }
    
    NSInteger selectedIndex = [defs integerForKey:@"SelectedIndex"];
    NSLog(@"SelectedIndex: %ld", (long)selectedIndex);
    [_locationSegmented setSelectedSegmentIndex:selectedIndex];
    
    [_locationSegmented setTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
    [_locationSegmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.75]} forState:UIControlStateNormal];
    [_locationSegmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]} forState:UIControlStateSelected];
    
    [self refreshWeatherLabels];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.label7.text = @"更新中...";
//    [self performUpdate];
    [self updateWeather];
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

- (void)refreshWeatherLabels
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSInteger selectedIndex = [defs integerForKey:@"SelectedIndex"];
    NSLog(@"SelectedIndex: %ld", (long)selectedIndex);
    
    Weather *theWeather = [self findWeatherFromArray:_locationArray[selectedIndex]];
    
    [self setWeatherLabels:theWeather];
}

- (void)setWeatherLabels:(Weather *)theWeather
{
    
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
    
    self.label1.text = [NSString stringWithFormat:@"溫度：%@ ℃", theWeather.tempature];
    
    self.label2.text = [NSString stringWithFormat:@"濕度：%@ %%", theWeather.humidity];
    
    self.label3.text = [NSString stringWithFormat:@"風向：%@", theWeather.windDirection];
    
    self.label4.text = [NSString stringWithFormat:@"風速：%@ m/s", theWeather.windSpeed];
    
    self.label5.text = [NSString stringWithFormat:@"氣壓：%@ hPa", theWeather.atmosph];
    
    self.label6.text = [NSString stringWithFormat:@"雨量：%@ mm", theWeather.rainFall];
    
    self.label7.text = [NSString stringWithFormat:@"測量時間：%@", [self getUpdateTime:theWeather.updateTime]];

//    if (![self connected]) {
//        // not connected
//        self.label7.text = [NSString stringWithFormat:@"測量時間：%@\n(離線)", [self getUpdateTime:theWeather.updateTime]];
//    }
//    else
    if ([_errorMsg length]) {
        self.label7.text = [NSString stringWithFormat:@"測量時間：%@\n(%@)", [self getUpdateTime:theWeather.updateTime], _errorMsg];
    }
    
//    self.label7.text = [NSString stringWithFormat:([self connected] ? @"測量時間：%@" : @"測量時間：%@\n（沒有網路連線）"),  [self getUpdateTime:theWeather.updateTime]];
}

- (void)updateWeather
{
    //https://mobi.pccu.edu.tw/m/weather.json
    
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    NSString *jsonUrlString = [NSString stringWithFormat:@"https://mobi.pccu.edu.tw/m/weather.json"];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    _errorMsg = [[NSString alloc] init];
    
    if (error) {
        NSLog(@"Error = %@", error);
        NSLog(@"%@", [NSString stringWithFormat:@"%ld %@", (long)[error code], [[error userInfo] valueForKey:@"NSLocalizedDescription"]]);
        
        if (![self connected]) {
            // not connected
            self.label7.text = @"沒有網路連線";
            //_errorMsg = @"沒有網路連線";
            _errorMsg = [[error userInfo] valueForKey:@"NSLocalizedDescription"];
        } else {
            // connected, do some internet stuff
            self.label7.text = [[error userInfo] valueForKey:@"NSLocalizedDescription"];
            _errorMsg = [[error userInfo] valueForKey:@"NSLocalizedDescription"];
        }
    }
    else {
        
        //-- JSON Parsing
        NSMutableDictionary *resultArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"Result = %@", resultArray);
        
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        [defs setObject:resultArray forKey:@"WeatherDictionary"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [_weatherArray removeAllObjects];
        for (NSDictionary *result in resultArray) {
            [_weatherArray addObject:[[Weather alloc] initWithJSONDictionary:result]];
        }
    }
    
    [self refreshWeatherLabels];
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (Weather *)findWeatherFromArray:(NSString *)theLocation
{
    for (Weather *theWeather in _weatherArray) {
        if ([theWeather.location isEqualToString:theLocation]) {
            return theWeather;
        }
    }
    return [[Weather alloc] init];
}

- (NSString *)getUpdateTime:(NSString *)theTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
//    2015-03-11T16:45:00+08:00
    
    NSDateFormatter *dateFormatter_s = [[NSDateFormatter alloc] init];
    //[dateFormatter_s setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter_s setDateFormat:@"yyyy-MM-dd HH:mm"];
//    2015-03-11 15:27
    
    NSDate *date = [NSDate date];
    NSString *strDate = [[NSString alloc] init];
    
    date = [dateFormatter dateFromString:theTime];
    strDate = [dateFormatter_s stringFromDate:date];
    
    return strDate;
}

- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    NSLog(@"index: %ld", (long)selectedSegment);
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setInteger:selectedSegment forKey:@"SelectedIndex"];
    
    NSLog(@"SelectedIndex: %ld", (long)[defs integerForKey:@"SelectedIndex"]);
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateWeather];
    [self refreshWeatherLabels];
}

@end
