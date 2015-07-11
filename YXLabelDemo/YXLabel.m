//
//  YXLabel.m
//  YXLabelDemo
//
//  Created by Qin Yuxiang on 7/9/15.
//  Copyright (c) 2015 YuxiangQ. All rights reserved.
//

#import "YXLabel.h"
#import <CoreText/CoreText.h>

@interface YXLabel ()

@property (strong,nonatomic) NSMutableArray *clickTextArray;

@end

@implementation YXLabel

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(id)init{
    if (self == [super init]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point {
    
    ////////
    
    NSMutableAttributedString* optimizedAttributedText = [self.attributedText mutableCopy];
    
    [self.attributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
        
        if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        }
        
        [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        
    }];
    
    ////////
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRect];
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    //////
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

- (CGRect)textRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    
    return textRect;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (self.clickTextArray) {
        for (YXLabelModel *model in self.clickTextArray) {
            NSRange range = [self.text rangeOfString:model.text];
            CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
            if (index >= range.location && index <= range.location + range.length - 1) {
                if (model.clickTextActionBlock) {
                    model.clickTextActionBlock();
                }
            }
        }
    }
//    NSRange r = [self.text rangeOfString:@"覃雨翔"];
//
//    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
//    if (index>=r.location&&index<=r.location+r.length-1) {
//        NSLog(@"选中了");
//    }
    [super touchesEnded:touches withEvent:event];
}

-(void)addClickText:(NSString*)text action:(ClickTextActionBlock)action{
    if (!self.clickTextArray) {
        self.clickTextArray = [NSMutableArray new];
    }
    YXLabelModel *model = [YXLabelModel new];
    model.text = text;
    model.clickTextActionBlock = action;
    [self.clickTextArray addObject:model];
}

@end

@implementation YXLabelModel


@end
