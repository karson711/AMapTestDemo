//
//  TravelToTragetViewController.h
//  TMS
//
//  Created by jikun on 2019/4/20.
//  Copyright © 2019 anfa. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

//导航坐标转换
#import "JKLocationConverter.h"

#import "DistanceTimeInfoModel.h"
#import "AddressStepInfoModel.h"
#import "ACActionSheet.h"
#import "AddressSwitchManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface TravelToTragetViewController : UIViewController<MAMapViewDelegate, AMapNaviDriveManagerDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>

- (instancetype)initWithDeliveryType:(DeliveryType)tragetType;

@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *footFunBtn;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;
@property (nonatomic, strong) AMapSearchAPI *search;
//地图
@property (nonatomic, strong) NSMutableArray *routeIndicatorInfoArray;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong)DistanceTimeInfoModel *currentDistanceTimeModel;
@property (nonatomic,strong)AddressStepInfoModel *currentStepModel;
@property (nonatomic,assign)BOOL isNeedRefreshAnnotion;

@end

NS_ASSUME_NONNULL_END
