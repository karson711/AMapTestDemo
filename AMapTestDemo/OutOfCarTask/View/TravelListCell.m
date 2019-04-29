//
//  TravelListCell.m
//  TMS
//
//  Created by jikun on 2019/4/20.
//  Copyright © 2019 anfa. All rights reserved.
//

#import "TravelListCell.h"

@implementation TravelListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setAddressStepInfoModel:(AddressStepInfoModel *)addressStepInfoModel{
    _addressStepInfoModel = addressStepInfoModel;
    if (kObjectIsEmpty(addressStepInfoModel)) {
        return;
    }
    
    self.addressLabel.text = safeString(addressStepInfoModel.title);
    self.tipIcon.image = addressStepInfoModel.deliveryType==1?[UIImage imageNamed:@"提"]:[UIImage imageNamed:@"送"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
