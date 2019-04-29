//
//  TravelToTragetViewController+AMap.m
//  TMS
//
//  Created by jikun on 2019/4/22.
//  Copyright © 2019 anfa. All rights reserved.
//

#import "TravelToTragetViewController+AMap.h"
//自定义大头针
#import "CustomAnnotationView.h"
#define kCalloutViewMargin          -8

//地图
#define AMapNaviRoutePolylineDefaultWidth  30.f
#import "MultiDriveRoutePolyline.h"
#import "NaviPointAnnotation.h"
#import "SelectableOverlay.h"


@implementation TravelToTragetViewController (AMap)

- (void)dealloc {
    BOOL success = [AMapNaviDriveManager destroyInstance];
    NSLog(@"单例是否销毁成功 : %d",success);
}

-(void)setUpWithAMap{
    //自定义当前位置蓝点
//    self.mapView.showsUserLocation = YES;
//    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
//    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
//    r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
//    r.showsHeadingIndicator = NO;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
//    r.enablePulseAnnimation = NO;///内部蓝色圆点是否使用律动效果, 默认YES
//    r.image = [UIImage imageNamed:@"car1"]; ///定位图标, 与蓝色原点互斥
//    [self.mapView updateUserLocationRepresentation:r];
    
    self.isNeedRefreshAnnotion = YES;
    
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO; // 关闭指南针
    self.mapView.showsScale = NO; // 不显示比例尺
    
    //获取定位坐标
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.distanceFilter = 200;
    self.locationManager.locatingWithReGeocode = YES;
    self.locationManager.delegate = self;
    [self.locationManager setLocatingWithReGeocode:YES];
    
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    
    self.routeIndicatorInfoArray = [NSMutableArray array];
    
}

#pragma mark - 地图
- (void)initAnnotations {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MAPointAnnotation *beginAnnotation = [[MAPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude)];
    beginAnnotation.title = @"起始点";
    [self.mapView addAnnotation:beginAnnotation];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude) animated:YES];
    
    MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
    endAnnotation.title    = @"AutoNavi";
    endAnnotation.subtitle = @"CustomAnnotationView";
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude)];
    [self.mapView addAnnotation:endAnnotation];
    
}

#pragma mark 单路径规划
- (void)singleRoutePlan{
    self.isNeedRefreshAnnotion = NO;
    [self.locationManager startUpdatingLocation];
    //进行单路径规划
    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                                    endPoints:@[self.endPoint]
                                                                    wayPoints:nil
                                                              drivingStrategy:AMapNaviDrivingStrategySingleDefault];
    
}

#pragma mark - Handle Navi Routes

- (void)selectNaviRouteWithID:(NSInteger)routeID {
    //在开始导航前进行路径选择
    if ([[AMapNaviDriveManager sharedInstance] selectNaviRouteWithRouteID:routeID])   {
        [self selecteOverlayWithRouteID:routeID];
    }   else    {
        NSLog(@"路径选择失败!");
    }
}

- (void)selecteOverlayWithRouteID:(NSInteger)routeID {
    
    NSMutableArray *selectedPolylines = [NSMutableArray array];
    CGFloat backupRoutePolylineWidthScale = 0.8;  //备选路线是当前路线宽度0.8
    
    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop) {
        
        if ([overlay isKindOfClass:[MultiDriveRoutePolyline class]]) {
            MultiDriveRoutePolyline *multiPolyline = overlay;
            
            /* 获取overlay对应的renderer. */
            MAMultiTexturePolylineRenderer * overlayRenderer = (MAMultiTexturePolylineRenderer *)[self.mapView rendererForOverlay:multiPolyline];
            
            if (multiPolyline.routeID == routeID) {
                [selectedPolylines addObject:overlay];
            } else {
                // 修改备选路线的样式
                overlayRenderer.lineWidth = AMapNaviRoutePolylineDefaultWidth * backupRoutePolylineWidthScale;
                overlayRenderer.strokeTextureImages = multiPolyline.polylineTextureImages;
            }
        }
        self.mapView.zoomLevel-=1.7;
    }];
    
    [self.mapView removeOverlays:selectedPolylines];
    [self.mapView addOverlays:selectedPolylines];
}

- (void)showMultiColorNaviRoutes {
    if ([[AMapNaviDriveManager sharedInstance].naviRoutes count] <= 0) {
        return;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.routeIndicatorInfoArray removeAllObjects];
    
    //将路径显示到地图上
    for (NSNumber *aRouteID in [[AMapNaviDriveManager sharedInstance].naviRoutes allKeys]) {
        AMapNaviRoute *aRoute = [[[AMapNaviDriveManager sharedInstance] naviRoutes] objectForKey:aRouteID];
        int count = (int)[[aRoute routeCoordinates] count];
        
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < count; i++) {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        
        NSMutableArray<UIImage *> *textureImagesArrayNormal = [NSMutableArray new];
        NSMutableArray<UIImage *> *textureImagesArraySelected = [NSMutableArray new];
        
        // 添加路况图片
        for (AMapNaviTrafficStatus *status in aRoute.routeTrafficStatuses) {
            UIImage *img = [UIImage imageNamed:@"custtexture_green"];//[self defaultTextureImageForRouteStatus:status.status isSelected:NO];
            UIImage *selImg = [UIImage imageNamed:@"custtexture_green"];//[self defaultTextureImageForRouteStatus:status.status isSelected:YES];
            if (img && selImg) {
                [textureImagesArrayNormal addObject:img];
                [textureImagesArraySelected addObject:selImg];
            }
        }
        
        MultiDriveRoutePolyline *mulPolyline = [MultiDriveRoutePolyline polylineWithCoordinates:coords count:count drawStyleIndexes:@[@1,@3]];//aRoute.drawStyleIndexes
        mulPolyline.polylineTextureImages = textureImagesArrayNormal;
        mulPolyline.polylineTextureImagesSeleted = textureImagesArraySelected;
        mulPolyline.routeID = aRouteID.integerValue;
        
        [self.mapView addOverlay:mulPolyline];
        
        self.currentDistanceTimeModel.distance = aRoute.routeLength;
        self.currentDistanceTimeModel.secondes = aRoute.routeTime;
    NSLog(@"self.currentDistanceTimeModel====%@",self.currentDistanceTimeModel.modelToJSONObject);
        free(coords);
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
    
    [self selectNaviRouteWithID:[[self.routeIndicatorInfoArray firstObject] routeID]];
}

//根据交通状态获得纹理图片
- (UIImage *)defaultTextureImageForRouteStatus:(AMapNaviRouteStatus)routeStatus isSelected:(BOOL)isSelected {
    
    NSString *imageName = nil;
    
    if (routeStatus == AMapNaviRouteStatusSmooth) {
        imageName = @"custtexture_green";
    } else if (routeStatus == AMapNaviRouteStatusSlow) {
        imageName = @"custtexture_slow";
    } else if (routeStatus == AMapNaviRouteStatusJam) {
        imageName = @"custtexture_bad";
    } else if (routeStatus == AMapNaviRouteStatusSeriousJam) {
        imageName = @"custtexture_serious";
    } else {
        imageName = @"custtexture_no";
    }
    if (!isSelected) {
        imageName = [NSString stringWithFormat:@"%@_unselected",imageName];
    }
    
    return [UIImage imageNamed:imageName];
}

#pragma mark - AMapNaviDriveManager Delegate
- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error {
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteSuccessWithType:(AMapNaviRoutePlanType)type
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后显示路径
    [self showMultiColorNaviRoutes];
    
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error routePlanType:(AMapNaviRoutePlanType)type
{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForTrafficJam");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint:%d", wayPointIndex);
}

- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return NO;
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
}

- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onArrivedDestination");
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.isStart = [annotation.title isEqualToString:@"起始点"]?YES:NO;
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
            WEAKSELF
            [annotationView setDetailBlock:^{
                //运单详情
                
            }];
        }
        
        return annotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[SelectableOverlay class]]) {
        SelectableOverlay * selectableOverlay = (SelectableOverlay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
        
        return polylineRenderer;
    }else if ([overlay isKindOfClass:[MultiDriveRoutePolyline class]]) {
        MultiDriveRoutePolyline *mpolyline = (MultiDriveRoutePolyline *)overlay;
        MAMultiTexturePolylineRenderer *polylineRenderer = [[MAMultiTexturePolylineRenderer alloc] initWithMultiPolyline:mpolyline];
        
        polylineRenderer.lineWidth = AMapNaviRoutePolylineDefaultWidth;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.strokeTextureImages = mpolyline.polylineTextureImagesSeleted;
        
        return polylineRenderer;
        
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        if (!(self.currentStepModel.pickUpStatus > 0 || self.currentStepModel.sendUpStatus > 0)) {
            NSLog(@"状态：请先规划路线");
            return;
        }
        if (kObjectIsEmpty(self.currentDistanceTimeModel)) {
            NSLog(@"数据：请先规划路线");
            return;
        }
        cusView.currentDistanceTimeModel = self.currentDistanceTimeModel;
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    if (self.isNeedRefreshAnnotion == YES) {
        [self initAnnotations];
        if (self.currentStepModel.pickUpStatus > 0 || self.currentStepModel.sendUpStatus > 0) {
            [self singleRoutePlan];
        }
    }
    
    [self.locationManager stopUpdatingLocation];
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }
}


@end
