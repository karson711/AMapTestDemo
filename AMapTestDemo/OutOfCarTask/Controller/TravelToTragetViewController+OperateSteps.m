//
//  TravelToTragetViewController+OperateSteps.m
//  TMS
//
//  Created by jikun on 2019/4/25.
//  Copyright © 2019 anfa. All rights reserved.
//

#import "TravelToTragetViewController+OperateSteps.h"
#import "TravelToTragetViewController+AMap.h"


@implementation TravelToTragetViewController (OperateSteps)

-(void)operateStepsAction{
    if (self.currentStepModel.deliveryType == 1) {
        //提货
        if (self.currentStepModel.pickUpStatus == ToPickUpAddressType) {
            //前往提货地
            [self singleRoutePlan];
            self.currentStepModel.pickUpStatus++;
            [self changeFootBtnTitleWithStatus];
        }else if (self.currentStepModel.pickUpStatus == ArrivalPickUpPlaceType){
            //已到达提货地
            self.isNeedRefreshAnnotion = NO;
            [self.locationManager startUpdatingLocation];
            [self showPickUpArriveAlert];
        }else if (self.currentStepModel.pickUpStatus == CompleteLoadingType){
            //装货完成
            
        }
    }else if (self.currentStepModel.deliveryType == 2){
        //送货
        if (self.currentStepModel.sendUpStatus == ToSendUpAddressType) {
            //前往送货地
            [self singleRoutePlan];
            self.currentStepModel.sendUpStatus++;
            [self changeFootBtnTitleWithStatus];
        }else if (self.currentStepModel.sendUpStatus == ArrivalSendUpPlaceType){
            //已到达送货地
            self.isNeedRefreshAnnotion = NO;
            [self.locationManager startUpdatingLocation];
            [self showSendUpArriveAlert];
        }else if (self.currentStepModel.sendUpStatus == CompleteUnloadingType){
            //卸货完成
            
        }
    }
    
}

- (void)showPickUpArriveAlert
{
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:@"确定到达提货地？" cancelButtonTitle:@"未到达" destructiveButtonTitle:@"已到达" otherButtonTitles:nil actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            self.currentStepModel.pickUpStatus++;
            [self changeFootBtnTitleWithStatus];
        }
    }];
    [actionSheet show];
}

- (void)showSendUpArriveAlert
{
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:@"确定到达送货地？" cancelButtonTitle:@"未到达" destructiveButtonTitle:@"已到达" otherButtonTitles:nil actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            self.currentStepModel.sendUpStatus++;
            [self changeFootBtnTitleWithStatus];
        }
    }];
    [actionSheet show];
}

-(void)changeFootBtnTitleWithStatus{
    if (self.currentStepModel.deliveryType == 1) {
        //提货
        if (self.currentStepModel.pickUpStatus == PickUpEndType) {
            //提货结束
            
        }else{
            NSArray *pickUpArr = @[@"前往提货地",@"已到达提货地",@"装货完成"];
            [self.footFunBtn setTitle:pickUpArr[self.currentStepModel.pickUpStatus] forState:UIControlStateNormal];
        }
        
    }else if (self.currentStepModel.deliveryType == 2){
        //送货
        if (self.currentStepModel.pickUpStatus == SendUpEndType) {
            //送货结束
            
        }else{
            NSArray *pickUpArr = @[@"前往送货地",@"已到达送货地",@"卸货完成"];
            [self.footFunBtn setTitle:pickUpArr[self.currentStepModel.sendUpStatus] forState:UIControlStateNormal];
        }

    }
}

@end
