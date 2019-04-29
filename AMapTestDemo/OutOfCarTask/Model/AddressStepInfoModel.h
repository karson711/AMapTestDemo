//
//  AddressStepInfoModel.h
//  TMS
//
//  Created by jikun on 2019/4/24.
//  Copyright © 2019 anfa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressStepInfoModel : NSObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *detailAddress;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,assign)CGFloat latitude;
@property (nonatomic,assign)CGFloat longitude;
@property (nonatomic,assign)NSInteger deliveryType;//1-提货  2-送货
@property (nonatomic,assign)PickUpGoodType pickUpStatus;//提货状态
@property (nonatomic,assign)SendUpGoodType sendUpStatus;//送货状态

@end

NS_ASSUME_NONNULL_END
