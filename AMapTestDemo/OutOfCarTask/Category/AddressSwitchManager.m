//
//  AddressSwitchManager.m
//  TMS
//
//  Created by jikun on 2019/4/25.
//  Copyright © 2019 anfa. All rights reserved.
//

#import "AddressSwitchManager.h"

@interface AddressSwitchManager ()

@property (nonatomic,strong)AMapSearchAPI *search;

@end

@implementation AddressSwitchManager

+ (instancetype)sharedAddress{
    static AddressSwitchManager *_sharedAddress = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedAddress = [[super allocWithZone:NULL] init];
    });
    return _sharedAddress;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return self;
}

-(void)searchWithAddress:(NSString *)address{
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = address;
    [self.search AMapGeocodeSearch:geo];
}

#pragma mark - AMapSearchDelegate
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    //解析response获取地理信息，具体解析见 Demo
    AMapGeocode *obj = response.geocodes[0];
    GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
    
    if (self.switchBlock) {
        self.switchBlock(geocodeAnnotation);
    }
}

#pragma mark - 单例方法
// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [AddressSwitchManager sharedAddress];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [AddressSwitchManager sharedAddress];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [AddressSwitchManager sharedAddress];
}

@end
