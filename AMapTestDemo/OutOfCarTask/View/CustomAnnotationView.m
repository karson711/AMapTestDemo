//
//  CustomAnnotationView.m
//  loveSport
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CustomAnnotationView.h"
#define kWidth  150.f
#define kHeight 80.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   250.0f
#define kCalloutHeight  105.0f
@interface CustomAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;


@end
@implementation CustomAnnotationView
- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            
            self.calloutView = [CustomCalloutView calloutView];
            self.calloutView.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            WEAKSELF
            [self.calloutView setToDetailBlock:^{
                if (weakSelf.detailBlock) {
                    weakSelf.detailBlock();
                }
            }];
        }
        if (!self.isStart) {
            [self addSubview:self.calloutView];
        }else{
            [self.calloutView removeFromSuperview];
        }
        
    }else{
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

-(void)setCurrentDistanceTimeModel:(DistanceTimeInfoModel *)currentDistanceTimeModel{
    _currentDistanceTimeModel = currentDistanceTimeModel;
    if (kObjectIsEmpty(currentDistanceTimeModel)) {
        return;
    }
    self.calloutView.currentDistanceTimeModel = currentDistanceTimeModel;
}

-(void)setIsStart:(BOOL)isStart{
    _isStart = isStart;
    if (self.isStart) {
        [self.portraitImageView setFrame:CGRectMake(0, 0, 20, 30)];
        self.portraitImageView.image = [UIImage imageNamed:@"car1"];
    }else{
        [self.portraitImageView setFrame:CGRectMake(0, 0, 19.5, 30)];
        self.portraitImageView.image = [UIImage imageNamed:@"dingwei"];
    }
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 40, 40);
        
        self.backgroundColor = [UIColor clearColor];
     
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19.5, 30)];
        self.portraitImageView.center = CGPointMake(20, 20);
        self.portraitImageView.image = [UIImage imageNamed:@"dingwei"];
        [self addSubview:self.portraitImageView];
    }
    
    return self;
}
@end
