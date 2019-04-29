
//工具类宏定义文件
/*
目录：
1、空值判断
2、强弱引用
3、设备型号、系统判断
4、Debug 打印
5、屏幕尺寸
6、圆角
7、获取系统当前版本和语言类型
8、Appdelegate
9、存取数据
 */
#ifndef ToolConfig_h
#define ToolConfig_h

/*------------空值判断-----------*/
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), \
[[UIScreen mainScreen] currentMode].size) : \
NO)


#define isWidthLargeThaniP5    ([[UIScreen mainScreen] bounds].size.width > 320)

#define isiPhone4               ([[UIScreen mainScreen] bounds].size.height == 480)

//判断iphone6
#define isiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6+
#define isiPhone6Plus ([[UIScreen mainScreen] currentMode].size.width == 1242||[[UIScreen mainScreen] currentMode].size.width == 1125)

// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/*------------模型字段打印-----------*/
#define ZJModelToolMakeDictToModel(dic,modelName)  \
id fanClass =  dic;\
if (!([fanClass isKindOfClass:[NSDictionary class]]||[fanClass isKindOfClass:[NSArray class]])) {\
NSLog(@"\n\n参数有误，Value是 %@ 不是字典 也不是数组",[fanClass class]);\
return; }\
NSDictionary *fanDict ; \
if ([fanClass isKindOfClass:[NSDictionary class]]){ \
fanDict  = [NSDictionary dictionaryWithDictionary:fanClass]; \
}else{  fanDict  = [NSDictionary dictionaryWithDictionary:fanClass[0]]; }\
NSLog(@"\n\n@interface %s :NSObject\n",modelName.UTF8String);\
for (NSString *key in fanDict) {\
id Value = fanDict[key];\
NSString *type ;\
if ([Value isKindOfClass:[NSString class]]) {\
type = @"NSString";\
}else if ([Value isKindOfClass:[NSNumber class]]){\
type = @"NSNumber";\
}else if ([Value isKindOfClass:[NSDictionary class]]){\
type = @"NSDictionary";\
}else if ([Value isKindOfClass:[NSArray class]]){\
type = @"NSArray";\
}else if ([Value isKindOfClass:[NSNull class]]){\
type = @"NSString";\
}else{\
type = @"待定类型";\
}\
printf("@property (nonatomic,copy) %s *%s;\n",type.UTF8String,key.UTF8String);\
}\
printf("@end\n\n");\

/*------------强弱引用-----------*/
// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;


/*------------设备型号、系统判断-----------*/
// 是否iPad
#define isPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) ) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneXS_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)


// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/**
 * 屏幕适配--iPhoneX全系
 */
#define kiPhoneXAll ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

/**导航栏高度
 * iPhoneX全系导航栏增加高度 (64->88)
 */
#define kiPhoneX_Top_Height (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)?24:0)

/** home indicator高度
 * iPhoneX全系TabBar增加高度 (49->83)
 */
#define kiPhoneX_Bottom_Height  (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)?34:0)

/*------------Alert 提示-----------*/
#define ALERT(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

/*------------Debug 打印-----------*/
#ifdef DEBUG

#define ZJLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define ZJLog( s, ... )

#endif

/*------------屏幕尺寸-----------*/
///  获取屏幕高度
static inline CGFloat _getScreenHeight () {
    static CGFloat _screenHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    });
    return _screenHeight;
}

static inline BOOL _isIPhoneX () {
    static BOOL iphonex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iphonex = _getScreenHeight() >= 812.0;
    });
    return iphonex;
}

#define ZJScreenHeight      [[UIScreen mainScreen] bounds].size.height
#define ZJScreenWidth       [[UIScreen mainScreen] bounds].size.width
#define ScreenScale       [[UIScreen mainScreen] bounds].size.width/375


// 适配iPhoneX
#define isIPhoneX _isIPhoneX()
#define SafeAreaTopHeight (_isIPhoneX() ? 88 : 64)
#define StatusBarHeight (_isIPhoneX() ? 44 : 20)
#define SafeAreaTabBarHeight (_isIPhoneX() ? 84 : 50)
#define SafeAreaBottomHeight (_isIPhoneX() ? 34 : 0)

/*------------圆角-----------*/
// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角无边框
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


#define ADDNOTIFICATION(NAME,SEL) \
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SEL) name:NAME object:nil];

/*------------获取系统当前版本和语言类型-----------*/
// 当前版本
#define ZJSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define ZJSystemBuildVersion          ([[UIDevice currentDevice] systemVersion])[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]
// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])


/*------------Appdelegate-----------*/
#define APPDELEGATE	(AppDelegate *)[[UIApplication sharedApplication] delegate]

/*------------存取数据-----------*/
//NSUserDefault 存取数据
#define UNSaveObject(obj,key) \
if(obj && key){ \
[[NSUserDefaults standardUserDefaults] setObject:obj forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \
}

#define UNSaveBOOL(bool,key) \
if(key){ \
[[NSUserDefaults standardUserDefaults] setBool:bool forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \
}


#define UNRemoveObject(key) \
if(key){ \
[[NSUserDefaults standardUserDefaults] removeObjectForKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \
}

#define UNSaveInteger(obj,key) \
if(obj && key){ \
[[NSUserDefaults standardUserDefaults] setInteger:obj forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \
}


#define UNGetBool(key)    (key ? [[NSUserDefaults standardUserDefaults] boolForKey:key] : false)

#define UNGetInteger(key)    (key ? [[NSUserDefaults standardUserDefaults] integerForKey:key] : 0)

#define UNGetObject(key)    (key ? [[NSUserDefaults standardUserDefaults] objectForKey:key] : nil)


//NSUserDefault 序列化存取数据
#define UNSaveSerializedObject(obj,key) \
NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:obj];\
if(serialized){ \
[[NSUserDefaults standardUserDefaults] setObject:serialized forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \
}

#define UNGetSerializedObject(key)  key ? ([[NSUserDefaults standardUserDefaults] objectForKey:key] ? [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:key]] : nil) : nil

//NSUserDefault 删除数据
#define UNDeletedSerializedObject(key) { [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize]; \
}

typedef  void (^TextFieldBeginEdit)(NSString * text);
typedef  void (^TextFieldChanged)(NSString * text);
typedef  void (^UIButtonClick)(void);
typedef  void (^SwitchToggle)(BOOL isSwitchOn);

typedef void (^SelectedFloat)(float selectedFloat);
typedef void (^SelectIndex)(NSInteger selectedIndex);


typedef  void (^SendBackOBJ)(id object);

typedef  void (^SendBackOBJMore)(id object,id object2,id object3);

typedef  void (^SendBackArray)(NSMutableArray *array);

#endif /* ToolConfig_h */
