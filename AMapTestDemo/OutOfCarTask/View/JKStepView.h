//
//  JKStepView.h
//  TMS
//
//  Created by jikun on 2019/4/22.
//  Copyright © 2019 anfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TINTCOLOR [UIColor colorWithHexString:@"1890FF"]
#define NormalCOLOR [UIColor colorWithHexString:@"DDDDDD"]
NS_ASSUME_NONNULL_BEGIN

@interface JKStepView : UIView

@property (nonatomic, assign)NSMutableArray * _Nonnull titles;

/**
 当前选中位置
 */
@property (nonatomic, assign, readwrite) NSInteger stepIndex;

- (instancetype _Nonnull )initWithFrame:(CGRect)frame Titles:(nonnull NSMutableArray *)titles;

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated;

@property (nonatomic,copy) void (^indexBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
