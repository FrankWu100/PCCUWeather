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
#import <AFNetworking.h>
#import "DeepCopy.h"

@interface TodayViewController () <NCWidgetProviding>

@property bool isUpdating;

@end

@implementation TodayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    float versionNumber = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (versionNumber >= 8.0 && versionNumber < 10.0) {
        [_locationSegmented setTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
        [_locationSegmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.75]} forState:UIControlStateNormal];
        [_locationSegmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]} forState:UIControlStateSelected];
    }
    else if (versionNumber >= 10.0){
        UIColor *blackC = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        self.label1.textColor = blackC;
        self.label2.textColor = blackC;
        self.label3.textColor = blackC;
        self.label4.textColor = blackC;
        self.label5.textColor = blackC;
        self.label6.textColor = blackC;
        self.label7.textColor = blackC;
        [_locationSegmented setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        [_locationSegmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]} forState:UIControlStateNormal];
        [_locationSegmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9]} forState:UIControlStateSelected];
    }
    
    // init
    self.label1.text = [NSString stringWithFormat:@"溫度：無資料"];
    self.label2.text = [NSString stringWithFormat:@"濕度：無資料"];
    self.label3.text = [NSString stringWithFormat:@"風向：無資料"];
    self.label4.text = [NSString stringWithFormat:@"風速：無資料"];
    self.label5.text = [NSString stringWithFormat:@"氣壓：無資料"];
    self.label6.text = [NSString stringWithFormat:@"雨量：無資料"];
    self.label7.text = [NSString stringWithFormat:@"更新中..."];
    
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
    
    [self refreshWeatherLabels];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.label7.text = [NSString stringWithFormat:@"更新中..."];

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
    if ([theWeather.Tempature_withUnit length]) {
        self.label1.text = [NSString stringWithFormat:@"溫度：%@", theWeather.Tempature_withUnit];
    }
    
    if ([theWeather.Humidity_withUnit length]) {
        self.label2.text = [NSString stringWithFormat:@"濕度：%@", theWeather.Humidity_withUnit];
    }
    
    if ([theWeather.WindDirection length]) {
        self.label3.text = [NSString stringWithFormat:@"風向：%@", theWeather.WindDirection];
    }
    
    if ([theWeather.WindSpeed_withUnit length]) {
        self.label4.text = [NSString stringWithFormat:@"風速：%@", theWeather.WindSpeed_withUnit];
    }
    
    if ([theWeather.Atmosph_withUnit length]) {
        self.label5.text = [NSString stringWithFormat:@"氣壓：%@", theWeather.Atmosph_withUnit];
    }
    
    if ([theWeather.RainFall_withUnit length]) {
        self.label6.text = [NSString stringWithFormat:@"雨量：%@", theWeather.RainFall_withUnit];
    }
    
    if (!self.isUpdating) {
        if ([_errorMsg length]) {
            self.label7.text = [NSString stringWithFormat:@"測量時間：%@\n(%@)", [self getUpdateTime:theWeather.UpdateTime], _errorMsg];
        } else {
            self.label7.text = [NSString stringWithFormat:@"測量時間：%@", [self getUpdateTime:theWeather.UpdateTime]];
        }
    }
}

- (void)updateWeather
{
    //https://mobi.pccu.edu.tw/m/weather.json
    if (!self.isUpdating) {
        self.isUpdating = true;
        
        NSURL *URL = [NSURL URLWithString:@"https://mobi.pccu.edu.tw/m/weather.json"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSMutableArray *responseObject_mutable = [responseObject mutableDeepCopy];
            
            for (NSMutableDictionary *result in responseObject_mutable) {
                for (NSString* key in result) {
                    if ((bool)[[result valueForKey:key] isKindOfClass:[NSNull class]]) {
                        [result setObject:@"" forKey:key];
                    }
                }
            }
            
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            //[defs removeObjectForKey:@"WeatherDictionary"];
            [defs setObject:responseObject_mutable forKey:@"WeatherDictionary"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [_weatherArray removeAllObjects];
            for (NSDictionary *result in responseObject_mutable) {
                [_weatherArray addObject:[[Weather alloc] initWithJSONDictionary:result]];
            }
            
            self.isUpdating = false;
            [self refreshWeatherLabels];
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSLog(@"%@", [NSString stringWithFormat:@"%ld %@", (long)[error code], [[error userInfo] valueForKey:@"NSLocalizedDescription"]]);
            if (![self connected]) {
                // not connected
                //self.label7.text = @"沒有網路連線";
                _errorMsg = [[error userInfo] valueForKey:@"NSLocalizedDescription"];
            }
            
            self.isUpdating = false;
            [self refreshWeatherLabels];
        }];
    }
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
        if ([theWeather.Location isEqualToString:theLocation]) {
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
