//
//  ALTabBarController.m
//  ItcastLottery
//
//  Created by Huashen on 14-9-17.
//  Copyright (c) 2014年 aolaigo. All rights reserved.
//

#import "ALTabBarController.h"
#import "UINavigationItem+AL.h"
#import "ALClassifyViewController.h"
#import "AnimationView.h"
#import "ALAdvertisementView.h"
#import "ALAdvertisementItem.h"
#import "JudgeLogin.h"
#import "ALLoginViewController.h"
#import "ALShoppingCarViewController.h"
#import "ALUpdateBadge.h"
#import "ALZCOrderDetaileView.h"
#import "ALKeFuJump.h"
#import "ALTabBarItem.h"
#import "NTalkerChatViewController.h"
#import "XNGoodsInfoModel.h"
#import "ALTarBarIcon.h"

int versionFlag;
#define kAolaigoUpdate @"https://itunes.apple.com/cn/app/id973749625?mt=8"

static NSInteger const kHomeTag = 0; /**< 首页 */
static NSInteger const kLogoTag = 2; /**< LOGO */
static NSInteger const kImageCount = 8;
static ALTabBarController * _sharedInstance;
extern NSDictionary *pushUserInfo;
extern NSString *notificationPush;
extern NSString *notificationKeFu;
const NSInteger kBtnTotalNumber = 5;

@interface ALTabBarController ()<UINavigationControllerDelegate,ALAdvertisementViewDelegate, ALLoginViewControllerDelegate,UIAlertViewDelegate>
{
  ALTabBarButton *_selectedBtn;
  NSString * _local_icon_version;/*! 本地保存的version值 */
  NSString * _logoAddress;      /*! 图片下载地址 */
  NSString * _tabbarAddress;   /*! tabbar图片下载地址 */
  NSString * _update;         /*! 服务器返回的 参数（0、1、2） */
  NSString * _remark;        /*! 普通更新语言 */
  NSString * _remarkForce;  /*! 强制更新语言 */
  NSString * _link;        /*! 活动链接 */
  NSString * _title;      /*! 活动标题 */
  BOOL _isUpdateTabbar;
}

@property (strong, nonatomic) ALAdvertisementView *adView; /**< 启动广告页面 */
@property (copy, nonatomic) UIImageView * logoImageView; /**< logo 图片 */

@end

@implementation ALTabBarController

-(void)viewDidLoad
{
  [super viewDidLoad];
  /*! 添加启动页/推广页 */
  [self addLaunchView];
  versionFlag = -1;
  
  /*! 去服务器取logo图片 和 是否要更新 */
  [self getIconOrUpdate];
  
  /*! 请求tabbar的图片 */
  [self getTabBarIcon];
  
  /*! 启动页广告处理 */
  [self addAdView];
  
  /*! 处理app关掉后推送过来的信息 */
  [self checkPushInfo];
  
  /*! 处理客服推送过来的信息 */
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToKeFu) name:notificationKeFu object:nil];
}

- (void)jumpToKeFu
{
  /*!取数据 */
  NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
  NSString * imageUrl = data[@"imageUrl"];
  NSString * title = data[@"title"];
  NSString * price = data[@"price"];
  NSString * goodsId = data[@"goodsID"];
  XNGoodsInfoModel *info = [[XNGoodsInfoModel alloc] init];
  info.appGoods_type = @"3";
  info.clientGoods_Type = @"2";
  info.goods_id = goodsId;
  info.goods_showURL = imageUrl;
  info.goods_imageURL = imageUrl;
  info.goodsTitle = title;
  info.goodsPrice = [NSString stringWithFormat:@"￥%.2f元",[price doubleValue]];
  info.goods_URL = [NSString stringWithFormat:@"http://item.aolaigo.com/%@.html",goodsId];
  NTalkerChatViewController *ctrl = [[NTalkerChatViewController alloc] init];
  ctrl.productInfo = info;
  ctrl.settingid = @"kf_9141_1451977523930";
  ctrl.erpParams = @"";
  ctrl.kefuId = @"kf_9141";
  ctrl.isSingle = @"-1";
  ctrl.pageURLString  = [NSString stringWithFormat:@"http://item.aolaigo.com/%@.html",goodsId];
  ctrl.pageTitle  = title;
  ctrl.pushOrPresent = NO;
  if (ctrl.pushOrPresent == YES) {
    [self.navigationController pushViewController:ctrl animated:YES];
  } else {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    ctrl.pushOrPresent = NO;
    [self presentViewController:nav animated:YES completion:nil];
  }
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    for(UIControl *btn in self.tabBar.subviews)
    {
      [btn removeFromSuperview];
    }
    
    _sharedInstance = self;
    _btnArray = [NSMutableArray array];
    NSArray *viewcontrollers = self.viewControllers;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.bounds.size.width, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderWidth = 0.3;
    bottomView.layer.borderColor = [UIColor colorWithHexValue:0xd0d0d0 alpha:1].CGColor;
    bottomView.opaque = YES;
    [self.tabBar addSubview:bottomView];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * version =[ALSettingTool objectForKey:ALLocalIconVersion];// [user objectForKey:@"local_icon_version"];
    
    /*! 创建tabbar按钮 */
    for (int i = 0; i < kBtnTotalNumber; i++)
    {
      UIViewController *vc = viewcontrollers[i];
      UITabBarItem *item = vc.tabBarItem;
      if (version == nil)
      {
        NSString *imageName = [NSString stringWithFormat:@"tabbar%d",i+1];
        NSString *selImageName = [NSString stringWithFormat:@"%@sel",imageName];
        item.selectedImage =[UIImage imageNamed: selImageName];
        item.image = [UIImage imageNamed:imageName];
      }
      else
      {
        switch (i) {
          case 0:{
            UIImage * image = [UIImage imageWithData:[user objectForKey:@"tabBarImg0"]];
            UIImage * imageSel = [UIImage imageWithData:[user objectForKey:@"tabBarImg1"]];
            item.image = image;
            item.selectedImage = imageSel;
            break;
          }
          case 1:{
            UIImage * image = [UIImage imageWithData:[user objectForKey:@"tabBarImg2"]];
            UIImage * imageSel = [UIImage imageWithData:[user objectForKey:@"tabBarImg3"]];
            item.image = image;
            item.selectedImage = imageSel;
            break;
          }
          case 3:{
            UIImage * image = [UIImage imageWithData:[user objectForKey:@"tabBarImg4"]];
            UIImage * imageSel = [UIImage imageWithData:[user objectForKey:@"tabBarImg5"]];
            item.image = image;
            item.selectedImage = imageSel;
            break;
          }
          case 4:{
            UIImage * image = [UIImage imageWithData:[user objectForKey:@"tabBarImg6"]];
            UIImage * imageSel = [UIImage imageWithData:[user objectForKey:@"tabBarImg7"]];
            item.image = image;
            item.selectedImage = imageSel;
            break;
          }
            
          default:
            break;
        }
      }
      
      ALTabBarButton *button = [[ALTabBarButton alloc] initTabBarButtonWithItem:item index:i totalNumber:kBtnTotalNumber];
      [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
      if (i == kHomeTag)
      {
        [self clicked:button];
      }
      /*! tag只用于自控制器跳转到各个父控制器的接口 */
      button.tag = i;
      
      if (i != kLogoTag)
      {
        [button tapAnimationWithScale:CGPointMake(1.3, 1.3)];
      }
      [_btnArray addObject:button];
      [self.tabBar addSubview:button];
    }
    /*! 创建logo图片 */
    [self.tabBar addSubview:self.logoImageView];
  });
  [ALUpdateBadge requestShoppingNumbFromServer:self.viewControllers[kShoppingCartTag]];
  /*! 请求消息的 */
  //[ALUpdateBadge requestMessageNumbFromServer:self.viewControllers[kSettingTag]];
}

- (UIImageView *)logoImageView
{
  if (!_logoImageView)
  {
    /*! _logoImageView frame的值 */
    CGFloat width = kScreenWidth/5;
    CGFloat x = 2 * width;
    CGFloat y = 5;
    CGFloat height = 39;
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _logoImageView.image = [UIImage imageNamed:@"tabBar"];
  }
  return _logoImageView;
}
- (void)getTabBarIcon
{
  
  [ALRequestDataFromServer postDataFromServerWithType:urlTabBarIconType baseUrl:kAdvertisementUrl param:nil success:^(NSDictionary *result) {
    NSString * icon_version;
    NSMutableArray * allImg = [NSMutableArray array];
    if (![result[@"data"] isKindOfClass:[NSNull class]])
    {
      icon_version = result[@"data"][@"icon_version"];
      NSArray * data = result[@"data"][@"data"];
      /*! 取出本地的version */
      _local_icon_version = [ALSettingTool objectForKey:ALLocalIconVersion];
      /*! 数据为空就用本地图片 */
      if (![data isKindOfClass:[NSNull class]] && data.count > 0)
      {
        NSMutableArray * iconArr = [NSMutableArray array];
        for (int i = 0; i<data.count; i++) {
          NSDictionary * dic = data[i];
          ALTarBarIcon * item = [ALTarBarIcon objectWithKeyValues:dic];
          [iconArr addObject:item];
        }
        [iconArr enumerateObjectsUsingBlock:^(ALTarBarIcon *item, NSUInteger idx, BOOL * _Nonnull stop) {
          [allImg addObjectsFromArray:item.icons];
        }];
        
      }
      
    }
    
    /*! 判断后台是否有数据 */
    if ([icon_version integerValue] >0)
    {
      /*! 取本地local_icon_version值 说明后台第一次更新 */
      if (_local_icon_version == nil)
      {
        /*! 保存icon_version和data到本地 */
        [self saveDataToLocal:allImg saveVersion:icon_version];
      }
      else
      {
        /*! 需要更新 */
        if (_local_icon_version < icon_version)
        {
          /*! 保存icon_version和data到本地 */
          [self saveDataToLocal:allImg saveVersion:icon_version];
        }
      }
      
    }
    
    
  } failure:^(NSDictionary *error) {
    
  }];
}

- (void)saveDataToLocal:(NSArray *)imgArr saveVersion:(NSString *)version
{
  if (imgArr.count > 0)
  {
    //1.保存icon_version到local_icon_version
    //2.保存data的local_data
    //3.下⼀一次启动的时候使⽤用
    /*! 把icon_version保存到本地 */
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [ALSettingTool setObject:version forKey:ALLocalIconVersion];
    for (int i = 0; i<imgArr.count; i++)
    {
      if ([imgArr[i] rangeOfString:@"http://"].length == 0)
      {
        _tabbarAddress= [NSString stringWithFormat:@"%@%@",kImageUrl,imgArr[i]];
      }
      UIImageView * tabBarImg = [UIImageView new];
      tabBarImg.frame = CGRectMake(0, 0, 0, 0);
      [self.view addSubview:tabBarImg];
      [tabBarImg setImageWithURL:[NSURL URLWithString:_tabbarAddress] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
          
          data = UIImageJPEGRepresentation(image, 1);
          
        } else {
          
          data = UIImagePNGRepresentation(image);
        }
        [userDefaults setObject:data forKey:[NSString stringWithFormat:@"tabBarImg%d",i]];
        
      }];
      
    }
    
  }
  else
  {
    //1. 清掉local_icon_version的数据
    //2. 清掉local_data的数据
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    [ALSettingTool removerObjectForKey:ALLocalIconVersion];
    for (int i = 0 ; i<kImageCount; i++) {
      [userDefaults removeObjectForKey:[NSString stringWithFormat:@"tabBarImg%d",i]];
    }
    
  }
  
}
#pragma mark - 从服务器获取logo图片 和 是否需要强制更新
- (void)getIconOrUpdate
{
  [ALRequestDataFromServer postDataFromServerWithType:urlHomeIconAndUpdate baseUrl:kAdvertisementUrl param:nil success:^(NSDictionary *result) {
    
    if (![result[@"data"] isKindOfClass:[NSNull class]])
    {
      /*! 获取参数 */
      ALTabBarItem * item = [ALTabBarItem objectWithKeyValues:result[@"data"]];
      _remark = item.remark;
      _update = item.is_update;
      /*! 越狱设置检查版本更新 */
      versionFlag = _update.intValue;
      _remarkForce = item.remark_force;
      _link = item.href;
      _title = item.title;
      
      /*! logo图片地址 */
      /*! 有下载地址 */
      if (item.src.length !=0)
      {
        /*! 没有包含http */
        if ([item.src rangeOfString:@"http://"].length == 0)
        {
          _logoAddress= [NSString stringWithFormat:@"%@%@",kImageUrl,item.src];
        }
        /*! 下载图片 */
        [self.logoImageView setImageWithURL:[NSURL URLWithString:_logoAddress]  placeholderImage:[UIImage imageNamed:@"tabBar"]];
      }
      /*! 没有图片就 不让logo跳转 */
      else
      {
        _link = nil;
      }
      
      /*! 判断是否需要更新 */
      [self update:_update];
    }
    
  } failure:^(NSDictionary *error) {
    ALLog(@"%@",error);
  }];
}
#pragma mark - 是否需要更新或强制更新
- (void)update:(NSString *)isUpdate
{
  
  switch ([isUpdate intValue]) {
      
    case 1: /*! 普通更新 */
    {
      [self message:_remark title:@"有新的版本更新" cancleButtonTitle:@"取消" otherButtonTitles:@"去更新" tag:1];
    }
      break;
    case 2:  /*! 强制更新 */
    {
      [self message:_remarkForce title:@"有新的版本更新" cancleButtonTitle:@"退出APP" otherButtonTitles:@"去更新" tag:2];
    }
      break;
    default:
      break;
  }
}


- (void)message:(NSString *)message title:(NSString *)title cancleButtonTitle:(NSString *)buttonTitle otherButtonTitles:(NSString *)otherBUttonTitle tag:(NSInteger)tag
{
  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:otherBUttonTitle, nil];
  alert.tag = tag;
  
  /*! 延迟10秒显示 */
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [alert show];
  });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  /*! 普通更新 */
  if (alertView.tag == 1 )
  {
    if (buttonIndex == 1)
    {
      /*! 去AppStore更新 */
      [self goAppStore];
    }
  }
  /*! 强制更新 */
  else if (alertView.tag == 2)
  {
    if (buttonIndex == 1)
    {
      [self goAppStore];
    }
    else
      [self exitApplication]; /*! 退出APP */
  }
}
#pragma mark - 去AppStore更新
- (void)goAppStore
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAolaigoUpdate]];
}
#pragma mark - 退出APP
- (void)exitApplication
{
  
  [UIView beginAnimations:@"exitApplication" context:nil];
  [UIView setAnimationDuration:0.5];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
  [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
  self.view.bounds = CGRectMake(0, 0, 0, 0);
  [UIView commitAnimations];
}
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  if ([animationID compare:@"exitApplication"] == 0)
  {
    exit(0);
  }
}


/*
 把各viewcontroller的属性代替父类的navigation的属性
 */
-(void) rewriteTitle
{
  UIViewController *controller = self.viewControllers[self.selectedIndex];
  [self.navigationItem copyFromItem:controller.navigationItem];
}
/*
 单例模式
 */
+(id)sharedInstance
{
  @synchronized ([ALTabBarController class]) {
    if (_sharedInstance == nil) {
      _sharedInstance = [[ALTabBarController alloc] init];
    }
  }
  return _sharedInstance;
}


#pragma mark - tab点击事件

-(void)clicked:(ALTabBarButton *)button
{
  /*! 点击Logo无动作 */
  if (button.tag == kLogoTag)
  {
    if (_link.length != 0 )
    {
      NSString *url = [NSString stringWithFormat:@"%@%@",kLogoUrl,_link];
      [ALJumpToAnotherUI pushToAnotherUI:@"ALChannelViewController" withNavCtrl:self.navigationController param:@{@"url":url, @"title":_title}];
    }
    return;
  }
  _selectedBtn.selected = NO;
  button.selected = YES;
  _selectedBtn = button;
  _lastSeletecdIndex = self.selectedIndex;
  self.selectedIndex = button.tag;
  [self rewriteTitle];
}

#pragma mark - 加载页面

/*
 添加启动页/推广页
 */
-(void)addLaunchView
{
  AnimationView *animationView = [[AnimationView alloc] initWithFrame:self.view.bounds];
  
  [self.navigationController.view addSubview:animationView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPushInfo) name:notificationPush object:nil];
}

#pragma mark - 启动页广告

/*! 启动页广告 */
- (void)addAdView
{
  /*! 已下载完成的广告信息保存在本地 */
  NSFileManager *manager = [NSFileManager defaultManager];
  NSMutableDictionary *localItem = [NSMutableDictionary dictionaryWithDictionary:[ALSettingTool objectForKey:ALAdItem]];
  
  /*! 更新广告（后台） */
  [ALAdvertisementItem updateWithUrl:kAdvertisementUrl type:ALAdvertisementTypeLaunch];
  
  /*! 本地无广告信息则不显示 */
  if (!localItem) {
    return;
  }
  
  /*! 已开始，未过期。每次启动都会显示 */
  if (([[NSDate date] compare:localItem[@"stopTime"]] == NSOrderedAscending) && ([[NSDate date] compare:localItem[@"startTime"]] == NSOrderedDescending)) {
    
    /*! 显示广告 */
    [self showAdvertisement];
    
  }
  
  // 过期删除
  if ([[NSDate date] compare:localItem[@"stopTime"]] == NSOrderedDescending) {
    // 删除
    [ALSettingTool removerObjectForKey:ALAdItem];
    [manager removeItemAtPath:kAdImagePath error:nil];
  }
}

- (void)showAdvertisement
{
  self.adView = [[ALAdvertisementView alloc] initWithFrame:self.view.bounds];
  self.adView.delegate = self;
  [self.navigationController.view addSubview:self.adView];
  
  /*! 5秒后消失 */
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (self.adView.superview) {
      [self.adView removeFromSuperview];
      self.adView.delegate = nil;
      self.adView = nil;
    }
  });
}

#pragma mark - 点击广告图片跳转

- (void)jumpToViewController
{
  NSDictionary *adItem = [ALSettingTool objectForKey:ALAdItem];
  
  // 优惠券需要登录
  if ([adItem[@"jumpView"] isEqualToString:@"ALMineCouponViewController"]) {
    
    BOOL loginFlag = [JudgeLogin shareInstance].login;
    //登录了向服务器请求收藏
    if (loginFlag) {
      [ALJumpToAnotherUI pushToAnotherUI:adItem[@"jumpView"] withNavCtrl:self.navigationController param:adItem[@"jumpParam"]];
    }
    //未登录显示登录框
    else
    {
      ALLoginViewController *login = [ALJumpToAnotherUI presentToLoginUIWithControl:self.navigationController];
      login.tag = 1;
      login.delegate = self;
    }
  }
  // 跳转到其他页面
  else {
    [ALJumpToAnotherUI pushToAnotherUI:adItem[@"jumpView"] withNavCtrl:self.navigationController param:adItem[@"jumpParam"]];
  }
}

#pragma mark - login delegate

-(void)loginSuccess:(ALLoginViewController *)ctrl
{
  NSInteger tag = ctrl.tag;
  //登陆成功回来继续执行收藏的动作
  if (tag == 1) {
    [self jumpToViewController];
  }
  //登陆成功回来继续跳转到订单详情
  else if (tag == 2){
    [self jumpToOrderDetailPage];
  }
  
}

#pragma mark - 推送处理
/*
 处理app关掉后推送过来的信息
 */
-(void)checkPushInfo
{
  ALLog(@"%@",pushUserInfo);
  if (pushUserInfo && [Reachability networkAvailable]) {
    //活动页
    if ([pushUserInfo objectForKey:@"activity"]) {
      //跳转到活动页
      [self jumpToActivityPage];
    }
    //搜索结果页
    else if (pushUserInfo[@"search_params"]){
      [self jumpToSearchResult];
    }
    //订单到期通知
    else if ([pushUserInfo[@"description"] isEqualToString:@"order"]){
      [self jumpToOrderDetailPage];
    }
    /*! 优惠券到期通知 */
    else if (pushUserInfo[@"coupon_push"]){
      [self jumpToCouponPage];
    }
    else{
      ALLog(@"未处理的字段");
    }
  }
}

-(void)jumpToSearchResult
{
  NSString *title = pushUserInfo[@"title"];
  NSString *paramStr = pushUserInfo[@"search_params"];
  //标题和参数都为空（运营人员未填写）
  if ((title.length == 0 && paramStr.length == 0)||( [title isEqualToString:@"\"\""] && [paramStr isEqualToString:@"\"\""])) {
    [MBProgressHUD showWithText:@"Sorry，暂未找到此款商品"];
  }
  //标题或参数不为空
  else{
    //处理参数，返回字符串或字典类型
    id params = [self parseParam:title];
    [ALJumpToAnotherUI pushToAnotherUI:@"ALSearchResultViewController" withNavCtrl:self.navigationController param:params];
  }
}
-(void)jumpToCouponPage
{
  [ALJumpToAnotherUI pushToAnotherUI:@"ALMineCouponViewController" withNavCtrl:self.navigationController];
}

-(id)parseParam:(NSString *)title
{
  NSString *paramStr = pushUserInfo[@"search_params"];
  id param;
  //参数为空,keyword搜索
  if (paramStr.length == 0 || [paramStr isEqualToString:@"\"\""]) {
    param = title;
  }
  //参数不为空类似分类搜索，字典参数
  else{
    NSMutableDictionary *itemDictionary = [NSMutableDictionary dictionary];
    /*! 设置搜索结果页上的显示 */
    if (title) {
      [itemDictionary setObject:title forKey:@"name"];
    }
    // 传给搜索结果页的参数
    NSArray *itemArray = [NSArray arrayWithArray:[paramStr componentsSeparatedByString:@"&"]];
    for (NSString *string in itemArray) {
      NSArray *param = [string componentsSeparatedByString:@"="];
      [itemDictionary setObject:param[1] forKey:param[0]];
    }
    param = itemDictionary;
  }
  return param;
}
-(void)jumpToActivityPage
{
  // |title|为空则设为 @"活动页"
  NSString *title = [pushUserInfo objectForKey:@"title"] ? pushUserInfo[@"title"] : @"活动页";
  
  [ALJumpToAnotherUI pushToAnotherUI:@"ALActivityViewController" withNavCtrl:self.navigationController param:@{@"url":pushUserInfo[@"activity"], @"title":title}];
  
}

-(void)jumpToOrderDetailPage
{
  NSString *orderId = pushUserInfo[@"aps"][@"orderId"];
  JudgeLogin *login = [JudgeLogin shareInstance];
  if (login.login) {
    NSString *uid = pushUserInfo[@"aps"][@"activity"];
    if (uid && [uid isEqualToString:login.uid]) {
      ALZCOrderDetaileView  *ordevc = [[ALZCOrderDetaileView alloc]initWithNibName:@"ALBaseOrderDetailViewController" bundle:nil];
      ordevc.orderId = orderId;
      [self.navigationController pushViewController:ordevc animated:YES];
    }
    else{
      /*! 弹出警告框 */
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此订单不属于该账户"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
      [alert show];
    }
  }
  else{
    ALLoginViewController *login = [ALJumpToAnotherUI presentToLoginUIWithControl:self.navigationController];
    login.tag = 2;
    login.delegate = self;
  }
}


@end
