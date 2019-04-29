//
//  JKStepView.m
//  TMS
//
//  Created by jikun on 2019/4/22.
//  Copyright © 2019 anfa. All rights reserved.
//

#import "JKStepView.h"
#import "StepCollectionViewCell.h"
#import "AddressStepInfoModel.h"

#define kRouteIndicatorViewHeight 50
#define cellItemWidth  270

@interface JKStepView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    CGFloat _dragStartX;
    CGFloat _dragEndX;
}

@property (nonatomic, strong)UIView *lineUndo;
@property (nonatomic, strong)UIView *lineDone;
@property (nonatomic, strong)UICollectionView *routeIndicatorView;

@property (nonatomic, retain)NSMutableArray *cricleMarks;
@property (nonatomic, strong)UILabel *lblIndicator;
@property (nonatomic, assign)BOOL isRight;//是否向右滑动
@property (nonatomic, assign)CGRect viewFrame;

@end

@implementation JKStepView

- (instancetype)initWithFrame:(CGRect)frame Titles:( NSMutableArray *)titles
{
    if ([super initWithFrame:frame])
    {
        _viewFrame = frame;
        _stepIndex = 0;
        
        _titles = titles;
        
        _lineUndo = [[UIView alloc]init];
        _lineUndo.backgroundColor = NormalCOLOR;//未选择时的线
        [self addSubview:_lineUndo];
        
        _lineDone = [[UIView alloc]init];
        _lineDone.backgroundColor = TINTCOLOR;//选择后的线
        [self addSubview:_lineDone];
        
        for (int i = 0; i < self.titles.count; i++) {
            UIView *cricle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            cricle.backgroundColor = NormalCOLOR;
            cricle.layer.cornerRadius = 5;
            [self addSubview:cricle];
            [self.cricleMarks addObject:cricle];
        }
        
        _lblIndicator = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        _lblIndicator.backgroundColor = TINTCOLOR;
        _lblIndicator.layer.cornerRadius = 7.5;
        _lblIndicator.layer.masksToBounds = YES;
        [self addSubview:_lblIndicator];
        
        [self initRouteIndicatorView];
    }
    return self;
}

- (void)initRouteIndicatorView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(cellItemWidth, 40);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    flowLayout.minimumLineSpacing = 10;
    
    _routeIndicatorView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 40, self.viewFrame.size.width-20, kRouteIndicatorViewHeight) collectionViewLayout:flowLayout];
    
//    _routeIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _routeIndicatorView.showsHorizontalScrollIndicator = NO;
    _routeIndicatorView.backgroundColor = [UIColor clearColor];
    _routeIndicatorView.bounces = NO;
    _routeIndicatorView.contentSize = CGSizeMake((cellItemWidth+10)*self.titles.count+10, 0);
    _routeIndicatorView.clipsToBounds = YES;
    
    _routeIndicatorView.delegate = self;
    _routeIndicatorView.dataSource = self;
    

    [_routeIndicatorView registerNib:[UINib nibWithNibName:@"StepCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StepCollectionViewCell"];
    
    [self addSubview:_routeIndicatorView];
}

#pragma mark - method

- (void)layoutSubviews
{
    NSInteger perWidth = self.viewFrame.size.width / self.titles.count;
    
    _lineUndo.frame = CGRectMake(0, 0, self.viewFrame.size.width - perWidth-7.5, 3);
    _lineUndo.center = CGPointMake(self.viewFrame.size.width / 2, self.viewFrame.size.height / 4);
    
    CGFloat startX = _lineUndo.frame.origin.x;
    
    for (int i = 0; i < _titles.count; i++)
    {
        UIView *cricle = [_cricleMarks objectAtIndex:i];
        if (cricle != nil)
        {
            cricle.center = CGPointMake(i * perWidth + startX, _lineUndo.center.y);
        }
    }
    _lblIndicator.center = ((UIView *)[_cricleMarks objectAtIndex:_stepIndex]).center;
    [self.routeIndicatorView reloadData];

}

- (NSMutableArray *)cricleMarks
{
    if (_cricleMarks == nil)
    {
        _cricleMarks = [NSMutableArray arrayWithCapacity:self.titles.count];
    }
    return _cricleMarks;
}

#pragma mark - public method
- (void)setCricleWithIndex
{
    if (_stepIndex >= 0 && _stepIndex < self.titles.count)
    {
        CGFloat perWidth = self.viewFrame.size.width / _titles.count;
        
        _lineDone.frame = CGRectMake(_lineUndo.frame.origin.x, _lineUndo.frame.origin.y, perWidth * _stepIndex-7.5, _lineUndo.frame.size.height);
        
        for (int i = 0; i < _titles.count; i++)
        {
            UIView *cricle = [_cricleMarks objectAtIndex:i];
            if (cricle != nil)
            {
                if (i <= _stepIndex)
                {
                    cricle.backgroundColor = TINTCOLOR;
                    if (i == _stepIndex) {
                        [_lblIndicator setCenter:cricle.center];
                    }
                }
                else
                {
                    cricle.backgroundColor = NormalCOLOR;
                }
            }
        }
    }
}

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated {
    _stepIndex = index;
    [self scrollToCenter];
    [self setCricleWithIndex];
    
}

//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _stepIndex -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _stepIndex += 1;//向左
    }
    NSInteger maxIndex = [self.routeIndicatorView numberOfItemsInSection:0] - 1;
    _stepIndex = _stepIndex <= 0 ? 0 : _stepIndex;
    _stepIndex = _stepIndex >= maxIndex ? maxIndex : _stepIndex;
    NSLog(@"_stepIndex===%ld",_stepIndex);
    [self scrollToCenter];
    [self setCricleWithIndex];
}

//滚动到中间
- (void)scrollToCenter {
    [self.routeIndicatorView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_stepIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    if (self.indexBlock) {
        self.indexBlock(_stepIndex);
    }
}

#pragma mark - UIScrollowDelegate
//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.routeIndicatorView.visibleCells.count) {return;}
    if (!scrollView.isDragging) {return;}
    CGRect currentRect = self.routeIndicatorView.bounds;
    currentRect.origin.x = self.routeIndicatorView.contentOffset.x;
    for (StepCollectionViewCell *card in self.routeIndicatorView.visibleCells) {
        if (CGRectContainsRect(currentRect, card.frame)) {
            NSInteger index = [self.routeIndicatorView indexPathForCell:card].row;
            if (index != _stepIndex) {
                _stepIndex = index;
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StepCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StepCollectionViewCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (!kArrayIsEmpty(self.titles)) {
        cell.stepInfoModel = self.titles[indexPath.row];
        WEAKSELF
        [cell setRefreshBlock:^(NSIndexPath * _Nonnull index) {
            
        }];
    }
    
    return cell;
}

@end
