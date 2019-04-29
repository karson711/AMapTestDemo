//
//  CustomCalloutView.h
//  loveSport
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistanceTimeInfoModel.h"

@interface CustomCalloutView : UIView

+ (instancetype)calloutView;

@property (nonatomic,copy) void (^toDetailBlock)();
@property (nonatomic,strong)DistanceTimeInfoModel *currentDistanceTimeModel;

@end
