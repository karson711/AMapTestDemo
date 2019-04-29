//
//  TravelListCell.h
//  TMS
//
//  Created by jikun on 2019/4/20.
//  Copyright © 2019 anfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressStepInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TravelListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipIcon;
@property (nonatomic,strong)AddressStepInfoModel *addressStepInfoModel;

@end

NS_ASSUME_NONNULL_END
