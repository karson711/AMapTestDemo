//
//  CustomCalloutView.m
//  loveSport
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CustomCalloutView.h"

@interface CustomCalloutView ()

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;

@end

@implementation CustomCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)calloutView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

-(void)setCurrentDistanceTimeModel:(DistanceTimeInfoModel *)currentDistanceTimeModel{
    _currentDistanceTimeModel = currentDistanceTimeModel;
    if (kObjectIsEmpty(currentDistanceTimeModel)) {
        return;
    }
    
    self.topLabel.text = [NSString stringWithFormat:@"预计%@到达",currentDistanceTimeModel.expectedTimeStr];
    //1890FF
    self.contentLabel.attributedText = [self formattedCurrent];

}

/**
 返回当前时间格式
 @return 返回组装好的字符串
 */
- (NSAttributedString *)formattedCurrent{

    //假设这就是我们国际化后的字符串
    NSString *localizedFormatString = [NSString stringWithFormat:@"距离提货地还有%@预计%@到达",self.currentDistanceTimeModel.showDistanceStr,self.currentDistanceTimeModel.showTimeStr];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:localizedFormatString];
    NSRange minRange, secRange;
    if (@available(iOS 9.0, *)) {
        minRange = [localizedFormatString localizedStandardRangeOfString:self.currentDistanceTimeModel.showDistanceStr];
        secRange = [localizedFormatString localizedStandardRangeOfString:self.currentDistanceTimeModel.showTimeStr];
    } else {
        minRange = [localizedFormatString rangeOfString:self.currentDistanceTimeModel.showDistanceStr];
        secRange = [localizedFormatString rangeOfString:self.currentDistanceTimeModel.showTimeStr];
    }
    NSDictionary *timeAttrs = @{ NSForegroundColorAttributeName : [UIColor colorWithHexString:@"1890FF"],
                                 NSFontAttributeName : [UIFont systemFontOfSize:12.0f]};
    [attributeStr addAttributes:timeAttrs range:minRange];
    [attributeStr addAttributes:timeAttrs range:secRange];
    return [[NSAttributedString alloc] initWithAttributedString:attributeStr];
}

- (IBAction)toDetailAction {
    if (self.toDetailBlock) {
        self.toDetailBlock();
    }
}

#pragma mark - draw rect
- (void)drawRect:(CGRect)rect
{

}

@end
