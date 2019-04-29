//
//  TravelToTragetViewController.m
//  TMS
//
//  Created by jikun on 2019/4/20.
//  Copyright © 2019 anfa. All rights reserved.
//

#import "TravelToTragetViewController.h"
#import "TravelToTragetViewController+AMap.h"
#import "TravelToTragetViewController+ThirdNavi.h"
#import "TravelToTragetViewController+OperateSteps.h"

#import "TravelListCell.h"
#import "JKStepView.h"

#define rowHeight 40
#define topViewHeight 91
#define leastMapcreenHeight 100
#define footFixedHeight 204

@interface TravelToTragetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *stepIcon;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *topBackView;

@property (weak, nonatomic) IBOutlet UIImageView *tipIcon;
@property (weak, nonatomic) IBOutlet UIView *targetBackView;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (weak, nonatomic) IBOutlet UIImageView *upIcon;


@property (nonatomic,assign)DeliveryType tragetType;
@property (nonatomic,strong)NSMutableArray *addressArr;
@property (nonatomic,strong)JKStepView *stepView;
@property (nonatomic,assign)CGFloat tableShowHeight;
@property (nonatomic,assign)CGFloat orignY;
@property (nonatomic,assign)CGFloat orignCenterY;

@end

@implementation TravelToTragetViewController

# pragma mark - init via ID
- (instancetype)initWithDeliveryType:(DeliveryType)tragetType{
    if (self == [self init]) {
        _tragetType = tragetType;
    }
    return self;
}

-(NSMutableArray *)addressArr{
    if (!_addressArr) {
        _addressArr = [NSMutableArray array];
    }
    return _addressArr;
}

-(DistanceTimeInfoModel *)currentDistanceTimeModel{
    if (!_currentDistanceTimeModel) {
        _currentDistanceTimeModel = [[DistanceTimeInfoModel alloc] init];
    }
    return _currentDistanceTimeModel;
}

-(AddressStepInfoModel *)currentStepModel{
    if (!_currentStepModel) {
        _currentStepModel = [[AddressStepInfoModel alloc] init];
    }
    return _currentStepModel;
}

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"前往送货地";
    
    [self setUpTipIconGesture];
    
    [self setUpWithAMap];
    
    [self.listTable registerNib:[UINib nibWithNibName:@"TravelListCell" bundle:nil] forCellReuseIdentifier:@"TravelListCell"];
    
    //假数据
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:@[@{@"title":@"广州市橡树园小区",@"latitude":@0,@"longitude":@0,@"detailAddress":@"天河区",@"phone":@"13666666666",@"deliveryType":@1},
        @{@"title":@"广州市乐天大厦",@"latitude":@0,@"longitude":@0,@"detailAddress":@"天河区",@"phone":@"13111111111",@"deliveryType":@1},
   @{@"title":@"广州市东方之珠足球场",@"latitude":@23.142397,@"longitude":@113.343345,@"detailAddress":@"天河区",@"phone":@"13888888888",@"deliveryType":@1},
   @{@"title":@"广州市体育西路地铁站",@"latitude":@23.131297,@"longitude":@113.322345,@"detailAddress":@"天河区",@"phone":@"13777777777",@"deliveryType":@2},
    @{@"title":@"广州市天河区嘉怡苑",@"latitude":@23.142197,@"longitude":@113.331345,@"detailAddress":@"天河区",@"phone":@"13999999999",@"deliveryType":@2},
        @{@"title":@"广州东站",@"latitude":@0,@"longitude":@0,@"detailAddress":@"天河区",@"phone":@"13222222222",@"deliveryType":@2},
        @{@"title":@"广州南站",@"latitude":@0,@"longitude":@0,@"detailAddress":@"番禺区",@"phone":@"13555555555",@"deliveryType":@2},
        @{@"title":@"广州北站",@"latitude":@0,@"longitude":@0,@"detailAddress":@"花都区",@"phone":@"13444444444",@"deliveryType":@2},
        @{@"title":@"广州市南沙区碧桂园蜜柚",@"latitude":@0,@"longitude":@0,@"detailAddress":@"南沙区",@"phone":@"13222222222",@"deliveryType":@2},
        @{@"title":@"广州市天河客运站",@"latitude":@0,@"longitude":@0,@"detailAddress":@"天河区",@"phone":@"13000000000",@"deliveryType":@2}
                                                               ]];
    
    for (NSDictionary *dict in tempArr) {
        AddressStepInfoModel *stepInfoModel = [AddressStepInfoModel modelWithDictionary:dict];
        [self.addressArr addObject:stepInfoModel];
    }
    
    self.currentIndex = 0;
    [self changeCurrentIndex];
    
    //获取数据后执行
    [self setUpStepView];
    
    self.tableShowHeight = [self getTableMaxShowHeight];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Setting Action

-(void)setUpTipIconGesture{
    self.tipIcon.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [self.tipIcon addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.tipIcon addGestureRecognizer:panGesture];

    self.orignY = 0;
    self.orignCenterY = self.tipIcon.centerY;
}

-(void)setUpStepView{
    [self.targetBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _stepView = [[JKStepView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth-26 , 90) Titles:self.addressArr];
    _stepView.clipsToBounds = YES;
    WEAKSELF
    [_stepView setIndexBlock:^(NSInteger index) {
        if (weakSelf.currentIndex != index) {
            weakSelf.currentIndex = index;
            [weakSelf changeCurrentIndex];
        }
    }];
    [self.targetBackView addSubview:_stepView];
}

#pragma mark - Funcation Action
#pragma mark 切换inde
-(void)changeCurrentIndex{
   
    self.currentStepModel = self.addressArr[self.currentIndex];
    if (self.currentStepModel.latitude > 0) {
        self.endPoint   = [AMapNaviPoint locationWithLatitude:self.currentStepModel.latitude longitude:self.currentStepModel.longitude];
        self.isNeedRefreshAnnotion = YES;
        [self.locationManager startUpdatingLocation];
    }else{
        [[AddressSwitchManager sharedAddress] searchWithAddress:self.currentStepModel.title];
        WEAKSELF
        [[AddressSwitchManager sharedAddress] setSwitchBlock:^(GeocodeAnnotation * _Nonnull resultAnnotation) {
            NSLog(@"geocodeAnnotation====%@",resultAnnotation.modelToJSONObject);
            weakSelf.currentStepModel.latitude = resultAnnotation.geocode.location.latitude;
            weakSelf.currentStepModel.longitude = resultAnnotation.geocode.location.longitude;
            [weakSelf.addressArr replaceObjectAtIndex:weakSelf.currentIndex withObject:weakSelf.currentStepModel];
            weakSelf.endPoint   = [AMapNaviPoint locationWithLatitude:weakSelf.currentStepModel.latitude longitude:weakSelf.currentStepModel.longitude];
            weakSelf.isNeedRefreshAnnotion = YES;
            [weakSelf.locationManager startUpdatingLocation];
        }];
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    self.topBackView.hidden = NO;
    self.addressLabel.text = safeString(self.currentStepModel.title);
    self.detailAddress.text = safeString(self.currentStepModel.detailAddress);
    [self changeFootBtnTitleWithStatus];
    
}

#pragma mark 获取table最大高度
-(CGFloat)getTableMaxShowHeight{
    CGFloat lastHeight = kScreenHeight-SafeAreaTopHeight-SafeAreaBottomHeight-topViewHeight-leastMapcreenHeight-footFixedHeight;
    CGFloat expectedHeight = self.addressArr.count*rowHeight;
    return expectedHeight>lastHeight?lastHeight:expectedHeight;
}

#pragma mark 上拉手势方法
-(void)panGestureAction:(UIPanGestureRecognizer *)sender {
    UIView *view = sender.view;
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:view.superview];
        self.orignY -= translation.y;
        if (self.orignY >= self.tableShowHeight) {
            [self.tableHeight setConstant:self.tableShowHeight];
            [self.listTable setHidden:NO];
            self.upIcon.image = [UIImage imageNamed:@"downIcon"];
        }else if (self.orignY <= 0){
            [self.tableHeight setConstant:0];
            [self.listTable setHidden:YES];
            self.upIcon.image = [UIImage imageNamed:@"upIcon"];
        }else{
            [self.tableHeight setConstant:self.orignY];
            [self.listTable setHidden:NO];
        }
        [sender setTranslation:CGPointZero inView:view.superview];
    }
}

#pragma mark 点击手势方法
-(void)tapGestureAction{
    if (self.listTable.hidden == NO) {
        [self downAction];
    }else{
        [self upAction];
    }
}

#pragma mark 判断拖拽方向
-(void)upAction{
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.listTable.hidden = NO;
        weakSelf.tableHeight.constant = weakSelf.tableShowHeight;
        weakSelf.orignY = weakSelf.tableHeight.constant;
        weakSelf.upIcon.image = [UIImage imageNamed:@"downIcon"];
    }];
}

-(void)downAction{
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.listTable.hidden = YES;
        weakSelf.tableHeight.constant = 0;
        weakSelf.orignY = weakSelf.tableHeight.constant;
        weakSelf.upIcon.image = [UIImage imageNamed:@"upIcon"];
    }];
}

#pragma mark 拨打电话
- (IBAction)telephoneAction {
    NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.currentStepModel.phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark 开始导航
- (IBAction)startNavigationAction {
    [self toThirdNavi];
}

- (IBAction)footFunBtnAction {
    [self operateStepsAction];
}

#pragma mark - UITableViewDelegate and DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TravelListCell"];
    if (!kArrayIsEmpty(self.addressArr)) {
        cell.addressStepInfoModel = self.addressArr[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.stepView switchToIndex:indexPath.row animated:YES];
    
}


@end
