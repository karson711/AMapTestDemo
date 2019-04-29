//
//  ZJCustomButton.h
//  ZJCustomButtonDemo
//
//  Created by huim on 2017/6/13.
//  Copyright © 2017年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

typedef enum : NSUInteger {
    ZJCustomButtonImagePositionLeft,//图片在左
    ZJCustomButtonImagePositionRight,//图片在右
    ZJCustomButtonImagePositionTop,//图片在上
    ZJCustomButtonImagePositionBottom,//图片在下
} ZJCustomButtonImagePosition;


@interface ZJCustomButton : UIButton

/**
 图片位置
 */
@property (nonatomic, assign) ZJCustomButtonImagePosition buttonImagePosition;

/**
 文字颜色自动跟随tintColor调整,default NO
 */
@property(nonatomic, assign)IBInspectable BOOL adjustsTitleTintColorAutomatically;

/**
 图片颜色自动跟随tintColor调整,default NO
 */
@property(nonatomic, assign)IBInspectable BOOL adjustsImageTintColorAutomatically;

/**
 default YES;相当于系统的adjustsImageWhenHighlighted
 */
@property(nonatomic, assign) IBInspectable BOOL adjustsButtonWhenHighlighted;

/**
 default YES,相当于系统的adjustsImageWhenDisabled
 */
@property(nonatomic, assign) IBInspectable BOOL adjustsButtonWhenDisabled;

/**
 高亮状态button背景色，default nil，设置此属性后默认adjustsButtonWhenHighlighted=NO
 */
@property(nonatomic, strong) IBInspectable UIColor *highlightedBackgroundColor;

/**
 高亮状态边框颜色，default nil，设置此属性后默认adjustsButtonWhenHighlighted=NO
 */
@property(nonatomic, strong) IBInspectable UIColor *highlightedBorderColor;

/** 
 可视化设置边框宽度 
 */
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
/** 
 可视化设置边框颜色 
 */
@property (nonatomic, strong)IBInspectable UIColor *borderColor;

/** 
 可视化设置圆角 
 */
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;

@end
