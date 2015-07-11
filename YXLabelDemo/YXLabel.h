//
//  YXLabel.h
//  YXLabelDemo
//
//  Created by Qin Yuxiang on 7/9/15.
//  Copyright (c) 2015 YuxiangQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTextActionBlock)();
@interface YXLabel : UILabel

-(void)addClickText:(NSString*)text action:(ClickTextActionBlock)action;

@end

@interface YXLabelModel : NSObject

@property (copy,nonatomic) NSString *text;
@property (copy,nonatomic) ClickTextActionBlock clickTextActionBlock;

@end
