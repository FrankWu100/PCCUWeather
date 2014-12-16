//
//  TodayViewController.h
//  Weather Widget
//
//  Created by FrankWu on 2014/11/25.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *test;

@property (strong, nonatomic)
Weather *weather;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;


@end
