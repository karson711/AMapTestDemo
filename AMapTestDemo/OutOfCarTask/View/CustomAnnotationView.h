//
//  CustomAnnotationView.h
//  loveSport
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

#import "CustomCalloutView.h"
#import "DistanceTimeInfoModel.h"

@interface CustomAnnotationView : MAAnnotationView


@property (nonatomic, strong) CustomCalloutView *calloutView;
@property (nonatomic,copy) void (^detailBlock)(void);
@property (nonatomic, assign)BOOL isStart;//是否为起点
@property (nonatomic,strong)DistanceTimeInfoModel *currentDistanceTimeModel;

@end
