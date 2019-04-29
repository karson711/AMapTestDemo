//
//  StepCollectionViewCell.h
//  TMS
//
//  Created by jikun on 2019/4/24.
//  Copyright © 2019 anfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJCustomButton.h"
#import "AddressStepInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StepCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *stepNumLabel;
@property (weak, nonatomic) IBOutlet ZJCustomButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,copy) void (^refreshBlock)(NSIndexPath *indexPath);
@property (nonatomic,strong)AddressStepInfoModel *stepInfoModel;

@end

NS_ASSUME_NONNULL_END
