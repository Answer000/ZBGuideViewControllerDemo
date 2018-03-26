//
//  ZBGuideViewController.h
//  ZBGuideView
//
//  Created by 澳蜗科技 on 16/11/8.
//  Copyright © 2016年 AnswerXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBAdvertisementView;
@class ZBGuidePageView;


@interface ZBGuideViewController : UIViewController

//****** 倒计时时间(默认3S) ******//
@property (nonatomic,assign) NSInteger countDownNum;

//****** 进入广告详情后是否切换窗口根控制器(默认YES) ******//
@property (nonatomic,assign) BOOL changeRootWhenEnterAdvertisingDetails;

//****** 广告详情控制器(不跳转可不传) ******//
@property (nonatomic,strong) UIViewController *detailVC;

//****** 自定义广告图customView的block ******//
- (void)reSetAdverCustomView:(void(^)(UIView *customView))customViewBlock;

//****** 自定义引导页JoinNow按钮的block ******//
- (void)reSetGPJumpBtnBlock:(void(^)(UIButton *jumpBtn))jumpBtnBlock;



/*
     mainRootViewController : 主根控制器
     guideImageNames        : 引导页(APP第一次启动时加载本地图片)
     advertisingImageUrlStr : 广告图(APP非第一次启动时加载网络图片)
 */
-(instancetype)initWithMainRootViewController:(UIViewController *)mainRootViewController
                              guideImageNames:(NSArray<NSString*> *)imageNames
                       advertisingImageUrlStr:(NSString *)urlStr;

@end

