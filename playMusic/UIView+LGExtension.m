//
//  UIView+LGExtension.m
//
//  Created by linglee on 15/8/15.
//  Copyright (c) 2015年 sky5156. All rights reserved.
//

#import "UIView+LGExtension.h"

@implementation UIView (LGExtension)
#pragma mark - width的setter和getter方法
- (void)setLg_width:(CGFloat)lg_width
{
    CGRect frame = self.frame;
    frame.size.width = lg_width;
    self.frame = frame;
}

-(CGFloat)lg_width
{
    return self.frame.size.width;
}

#pragma mark - height的setter和getter方法
- (void)setLg_height:(CGFloat)lg_height
{
    CGRect frame = self.frame;
    frame.size.height = lg_height;
    self.frame = frame;
}

- (CGFloat)lg_height{
    return self.frame.size.height;
}

#pragma mark - x的setter和getter方法
- (void)setLg_x:(CGFloat)lg_x{
    CGRect frame = self.frame;
    frame.origin.x = lg_x;
    self.frame = frame;
}

- (CGFloat)lg_x{
    return self.frame.origin.x;
}

#pragma mark - y的setter和getter方法
- (void)setLg_y:(CGFloat)lg_y{
    CGRect frame = self.frame;
    frame.origin.y = lg_y;
    self.frame =frame;
}

- (CGFloat)lg_y{
    return self.frame.origin.y;
}
#pragma mark - centerX的setter和getter
- (void)setLg_centerX:(CGFloat)lg_centerX{
    CGPoint center = self.center;
    center.x = lg_centerX;
    self.center = center;
}

- (CGFloat)lg_centerX{
    return self.center.x;
}

#pragma mark - centerY的setter和getter方法
- (void)setLg_centerY:(CGFloat)lg_centerY{
    CGPoint center = self.center;
    center.y = lg_centerY;
    self.center = center;
}

- (CGFloat)lg_centerY{
    return self.center.y;
}

#pragma mark - top的setter和getter方法
- (void)setLg_top:(CGFloat)lg_top{
    CGRect frame = self.frame;
    frame.origin.y = lg_top;
    self.frame = frame;
}

- (CGFloat)lg_top{
    return self.frame.origin.y;
}
#pragma mark - size的setter和getter方法
- (void)setLg_size:(CGSize)lg_size{
    CGRect frame = self.frame;
    frame.size = lg_size;
    self.frame = frame;
}
- (CGSize)lg_size {
    return self.frame.size;
}

#pragma mark - origin的setter和getter方法
- (void)setLg_origin:(CGPoint)lg_origin{
    CGRect frame = self.frame;
    frame.origin =lg_origin;
    self.frame = frame;
}
- (CGPoint)lg_origin {
    return self.frame.origin;
}


#pragma mark - bottom的setter和getter方法
- (void)setLg_bottom:(CGFloat)lg_bottom{
    CGRect frame = self.frame;
    frame.origin.y = lg_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)lg_bottom {
    return self.frame.origin.y + self.frame.size.height;
}
#pragma mark - left的setter和getter方法
- (void)setLg_left:(CGFloat)lg_left{
    CGRect frame = self.frame;
    frame.origin.x = lg_left;
    self.frame = frame;
}
- (CGFloat)lg_left{
    return self.frame.origin.x;
}
#pragma mark - right的setting和getting方法
- (void)setLg_right:(CGFloat)lg_right{
    CGRect frame = self.frame;
    frame.origin.x = lg_right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)lg_right {
    return self.frame.origin.x + self.frame.size.width;
}
@end
