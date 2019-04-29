//
//  DistanceTimeInfoModel.m
//  TMS
//
//  Created by jikun on 2019/4/24.
//  Copyright © 2019 anfa. All rights reserved.
//

#import "DistanceTimeInfoModel.h"

@implementation DistanceTimeInfoModel

-(NSString *)showDistanceStr{
    if (self.distance > 1000) {
        return [NSString stringWithFormat:@"%.1lf公里",self.distance/1000.0];
    }
    return [NSString stringWithFormat:@"%ld米",self.distance];
}

-(NSString *)showTimeStr{
    if (self.secondes > 3600) {
        NSInteger lastSeconds = self.secondes%3600;
        NSInteger hours = self.secondes/3600;
        float minutes = ceilf(lastSeconds/60.0);
        if (minutes > 0.0) {
            return [NSString stringWithFormat:@"%ld小时%.0f分钟",hours,minutes];
        }else{
            return [NSString stringWithFormat:@"%ld小时",hours];
        }
    }else if (self.secondes > 60 && self.secondes < 3600) {
        return [NSString stringWithFormat:@"%.0f分钟",ceilf(self.secondes/60.0)];
    }
    return [NSString stringWithFormat:@"%ld秒",self.secondes];
}

-(NSString *)expectedTimeStr{
    NSDate *dates = [NSDate date];
    NSTimeInterval interval = self.secondes;
    NSDate *detea = [NSDate dateWithTimeInterval:interval sinceDate:dates];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"BeiJing"];
    [dateformatter setTimeZone:timeZone];
    NSString *  resultStr = [dateformatter stringFromDate:detea];
    return resultStr;
}

@end
