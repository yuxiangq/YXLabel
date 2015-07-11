//
//  ViewController.m
//  YXLabelDemo
//
//  Created by Qin Yuxiang on 7/9/15.
//  Copyright (c) 2015 YuxiangQ. All rights reserved.
//

#import "ViewController.h"
#import "YXLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    YXLabel *label = [[YXLabel alloc] initWithFrame:CGRectMake(10, 40, 200, 44)];
    //label.frame = CGRectMake(10, 40, 100, 44);
    label.backgroundColor = [UIColor greenColor];
    label.text = @"覃雨翔回复张宝山";
    [label addClickText:@"张宝山" action:^{
        NSLog(@"点击了:张宝山");
    }];
    [label addClickText:@"覃雨翔" action:^{
         NSLog(@"点击了:覃雨翔");
    }];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
