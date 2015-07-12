//
//  ViewController.m
//  YXLabelDemo
//
//  Created by Qin Yuxiang on 7/9/15.
//  Copyright (c) 2015 YuxiangQ. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "YXLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    YXLabel *label = [[YXLabel alloc] initWithFrame:CGRectMake(10, 40, 200, 44)];
    label.backgroundColor = [UIColor whiteColor];

    label.text = @"段誉回复张宝山";
 
    [label addClickText:@"张宝山" action:^{
        NSLog(@"点击了:张宝山");
    }];
    [label addClickText:@"段誉" action:^{
         NSLog(@"点击了:段誉");
    }];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
