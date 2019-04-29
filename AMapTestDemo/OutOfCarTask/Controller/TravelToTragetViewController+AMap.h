//
//  TravelToTragetViewController+AMap.h
//  TMS
//
//  Created by jikun on 2019/4/22.
//  Copyright © 2019 anfa. All rights reserved.
//

#import "TravelToTragetViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TravelToTragetViewController (AMap)

- (void)initAnnotations;

- (void)singleRoutePlan;

- (void)setUpWithAMap;

@end

NS_ASSUME_NONNULL_END
