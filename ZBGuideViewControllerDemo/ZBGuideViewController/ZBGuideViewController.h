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
//广告详情控制器
@property (nonatomic,strong) UIViewController *detailVC;
//自定义广告图customView的block
- (void)reSetAdverCustomView:(void(^)(UIView *customView))customViewBlock;
//自定义引导页JoinNow按钮的block
- (void)reSetGPJumpBtnBlock:(void(^)(UIButton *jumpBtn))jumpBtnBlock;
-(instancetype)initWithMainRootViewController:(UIViewController *)mainRootVC guideImages:(NSArray<NSString*> *)images adverUrlStr:(NSString *)urlStr;
-(void)cancelClick;

@end

