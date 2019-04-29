//
//  NaviPointAnnotation.h
//  AMapNaviKit
//
//  Created by 刘博 on 16/3/8.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

typedef NS_ENUM(NSInteger, NaviPointAnnotationType)
{
    NaviPointAnnotationStart,
    NaviPointAnnotationWay,
    NaviPointAnnotationEnd
};

@interface NaviPointAnnotation : MAPointAnnotation

@property (nonatomic, assign) NaviPointAnnotationType navPointType;

@end
