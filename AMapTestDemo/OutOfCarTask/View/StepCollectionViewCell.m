//
//  StepCollectionViewCell.m
//  TMS
//
//  Created by jikun on 2019/4/24.
//  Copyright © 2019 anfa. All rights reserved.
//

#import "StepCollectionViewCell.h"

@implementation StepCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.refreshBtn.buttonImagePosition = ZJCustomButtonImagePositionRight;
}

-(void)setStepInfoModel:(AddressStepInfoModel *)stepInfoModel{
    _stepInfoModel = stepInfoModel;
    if (kObjectIsEmpty(stepInfoModel)) {
        return;
    }
    self.addressLabel.text = safeString(stepInfoModel.title);
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.stepNumLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
}

- (IBAction)refreshBtnAction {
    if (self.refreshBlock) {
        self.refreshBlock(self.indexPath);
    }
}


@end
