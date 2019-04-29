
//枚举类文件

#ifndef EnumConstant_h
#define EnumConstant_h

typedef NS_ENUM(NSInteger, DeliveryType) {
    DeliveryTaskType = 0,     //送货任务
    PickTaskType = 1,         //提货任务
    HasCompleteType = 2       //已完成
};

typedef NS_ENUM(NSInteger, DeliveryMoreType) {
    EmptyType = 0,
    MoreSendType = 1,      //多送
    MorePickType = 2       //多提
};

//提货流程
typedef NS_ENUM(NSInteger, PickUpGoodType) {
    ToPickUpAddressType = 0,         //前往提货地
    ArrivalPickUpPlaceType = 1,      //已到达提货地
    CompleteLoadingType = 2,         //装货完成
    PickUpEndType = 3                //提货结束
};

//送货流程
typedef NS_ENUM(NSInteger, SendUpGoodType) {
    ToSendUpAddressType = 0,         //前往送货地
    ArrivalSendUpPlaceType = 1,      //已到达提货地
    CompleteUnloadingType = 2 ,      //卸货完成
    SendUpEndType = 3                //送货结束
};

#endif /* EnumConstant_h */
