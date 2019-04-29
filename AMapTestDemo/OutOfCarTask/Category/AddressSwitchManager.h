//
//  AddressSwitchManager.h
//  TMS
//
//  Created by jikun on 2019/4/25.
//  Copyright © 2019 anfa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "GeocodeAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressSwitchManager : NSObject<AMapSearchDelegate>

+ (instancetype)sharedAddress;

-(void)searchWithAddress:(NSString *)address;

@property (nonatomic,copy) void (^switchBlock)(GeocodeAnnotation *resultAnnotation);

@end

NS_ASSUME_NONNULL_END
