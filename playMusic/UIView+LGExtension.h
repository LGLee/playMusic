//
//  UIView+LGExtension.h
//  Created by linglee on 15/8/15.
//  Copyright (c) 2015年 sky5156. All rights reserved.
// 直接拿到当前控件的frame等值

#import <UIKit/UIKit.h>

@interface UIView (LGExtension)
/* width*/
@property (nonatomic, assign) CGFloat lg_width;
/* height*/
@property (nonatomic, assign) CGFloat lg_height;
/* x*/
@property (nonatomic, assign) CGFloat lg_x;
/* y*/
@property (nonatomic, assign) CGFloat lg_y;
/* centerX*/
@property (nonatomic, assign) CGFloat lg_centerX;
/* centerY*/
@property (nonatomic, assign) CGFloat lg_centerY;
/** size */
@property (nonatomic, assign) CGSize lg_size;
/** origin */
@property (nonatomic, assign) CGPoint lg_origin;


/** top */
@property (nonatomic, assign) CGFloat lg_top;
/** bottom */
@property (nonatomic, assign) CGFloat lg_bottom;
/** right */
@property (nonatomic, assign) CGFloat lg_right;
/** left */
@property (nonatomic, assign) CGFloat lg_left;
@end
