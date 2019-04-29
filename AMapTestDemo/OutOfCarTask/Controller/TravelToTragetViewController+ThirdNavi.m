//
//  TravelToTragetViewController+ThirdNavi.m
//  TMS
//
//  Created by jikun on 2019/4/22.
//  Copyright © 2019 anfa. All rights reserved.
//

#import "TravelToTragetViewController+ThirdNavi.h"

@implementation TravelToTragetViewController (ThirdNavi)

-(void)toThirdNavi{
    NSString *urlScheme = @"28TMS://";
    NSString *appName = @"28TMS";
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude);//要导航的终点的经纬度
    
    BOOL hasAmap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
    BOOL hasBaidu = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
    BOOL hasGoogle = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
    BOOL hasTencent = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]];
    NSMutableArray *titleArr = [NSMutableArray array];
    if (hasAmap) {
        [titleArr addObject:@"高德地图"];
    }
    if (hasBaidu){
        [titleArr addObject:@"百度地图"];
    }
    if (hasGoogle){
        [titleArr addObject:@"谷歌地图"];
    }
    if (hasTencent){
        [titleArr addObject:@"腾讯地图"];
    }
    
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:@"请选择地图" cancelButtonTitle:@"取消" destructiveButtonTitle:@"苹果地图" otherButtonTitles:titleArr actionSheetBlock:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 0) {
            //苹果地图
            CLLocationCoordinate2D desCoordinate = coordinate;
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil]];
            toLocation.name = @"终点";//可传入目标地点名称
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }else if (buttonIndex == titleArr.count+1){
            //取消
            NSLog(@"点击取消");
        }else{
            NSString *mapString = titleArr[buttonIndex-1];
            if ([mapString isEqualToString:@"百度地图"]) {
                CLLocationCoordinate2D desCoordinate = [JKLocationConverter gcj02ToBd09:coordinate];//火星坐标转化为百度坐标
                //我的位置代表起点位置为当前位置，也可以输入其他位置作为起点位置，如天安门
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=%f,%f&mode=driving&src=JumpMapDemo", desCoordinate.latitude, desCoordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }else if ([mapString isEqualToString:@"高德地图"]){
                CLLocationCoordinate2D desCoordinate = coordinate;
                
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dev=0&m=0&t=0",@"我的位置",desCoordinate.latitude, desCoordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//@"我的位置"可替换为@"终点名称"
                
                NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }else if ([mapString isEqualToString:@"谷歌地图"]){
                CLLocationCoordinate2D desCoordinate = coordinate;
                
                NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,desCoordinate.latitude, desCoordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }else if ([mapString isEqualToString:@"腾讯地图"]){
                CLLocationCoordinate2D desCoordinate = coordinate;
                
                NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&to=%@&tocoord=%f,%f&policy=1&referer=%@", @"终点名称", desCoordinate.latitude, desCoordinate.longitude, appName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
        }
    }];
    [actionSheet show];
}

@end
