//
//  DistanceTimeInfoModel.h
//  TMS
//
//  Created by jikun on 2019/4/24.
//  Copyright © 2019 anfa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DistanceTimeInfoModel : NSObject

@property (nonatomic,assign)NSInteger distance;//长度（米）
@property (nonatomic,assign)NSInteger secondes;//预估时间(秒)

@property (nonatomic,strong)NSString *showDistanceStr;
@property (nonatomic,strong)NSString *showTimeStr;
@property (nonatomic,strong)NSString *expectedTimeStr;

@end

NS_ASSUME_NONNULL_END
