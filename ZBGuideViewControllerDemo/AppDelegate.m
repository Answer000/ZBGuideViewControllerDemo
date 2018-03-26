//
//  AppDelegate.m
//  ZBGuideViewControllerDemo
//
//  Created by 澳蜗科技 on 16/11/11.
//  Copyright © 2016年 AnswerXu. All rights reserved.
//

#import "AppDelegate.h"
#import "ZBGuideViewController.h"

@interface AppDelegate ()
{
    UIViewController *_detailVC;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UITabBarController *tabbarVC = [[UITabBarController alloc] init];
    NSArray *titles = @[@"首页",@"关注",@"活动",@"清单",@"个人"];
    
    for (int i=0; i<titles.count; i++) {
        [tabbarVC addChildViewController:({
            UIViewController *vc= [[UIViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.title = titles[i];
            
            vc.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"tarbarImage%d",i]];
            vc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tarbarImage%dH",i]];
            
            [[UINavigationController alloc] initWithRootViewController:vc];
        })];
    }

    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i=1;i<=4;i++){
        [images addObject:[NSString stringWithFormat:@"%ld.png",i]];
    }
    
    NSArray *urlStr = @[@"http://pic1.win4000.com/pic/c/cd/bc2e1165677.jpg",
                        @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1478689535&di=97a9f15fb61ae9ff8c7cb69f7bb4513d&src=http://cdn.duitang.com/uploads/item/201302/16/20130216192410_iBkhY.jpeg",
                        @"http://g.hiphotos.baidu.com/image/pic/item/d6ca7bcb0a46f21f2090cf53f4246b600c33ae0e.jpg",
                        @"http://d.hiphotos.baidu.com/image/pic/item/3812b31bb051f819ddd39d7ddfb44aed2e73e717.jpg"];

    //设置为根控制器
    self.window.rootViewController = ({
        ZBGuideViewController *guideVC = [[ZBGuideViewController alloc] initWithMainRootViewController:tabbarVC guideImageNames:images advertisingImageUrlStr:urlStr[arc4random() % urlStr.count]];
        guideVC.countDownNum = 10;
        guideVC.changeRootWhenEnterAdvertisingDetails = NO;
        
        //自定义广告页customView
        __weak typeof(self) weakSelf = self;
        [guideVC reSetAdverCustomView:^(UIView *customView) {
            [weakSelf advertisementCustomView:customView];
        }];
        
        //自定义引导页跳转按钮
        [guideVC reSetGPJumpBtnBlock:^(UIButton *jumpBtn) {
            [jumpBtn setTitle:@"Join Now" forState:UIControlStateNormal];
        }];
        
        //自定义广告详情控制器
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:({
            UIViewController *detailVC = [[UIViewController alloc] init];
            detailVC.title = @"广告详情";
            detailVC.view.backgroundColor = [UIColor redColor];
            detailVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
            _detailVC = detailVC;
            detailVC;
        })];
        guideVC.detailVC = navi;
        guideVC;
    });
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)cancelClick {
    [_detailVC dismissViewControllerAnimated:YES completion:nil];
}

//自定义广告页customView
- (void)advertisementCustomView:(UIView *)customView{
    UIImageView *view1 = [[UIImageView alloc] init];
    UIImageView *view2 = [[UIImageView alloc] init];
    
    UIImage *image1 = [UIImage imageNamed:@"adverIcon"];
    UIImage *image2 = [UIImage imageNamed:@"adverAPP"];
    
    view1.image = image1;
    view2.image = image2;
    
    [customView addSubview:view1];
    [customView addSubview:view2];
    
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *cons = [NSMutableArray array];
    NSDictionary *views = @{@"view1" : view1, @"view2" : view2};
    
    [cons addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-view1_X-[view1(image1_W)]" options:0 metrics:@{@"image1_W":@(image1.size.width),@"view1_X":@(([UIScreen mainScreen].bounds.size.width - image1.size.width)*0.5)} views:views]];
    [cons addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-view2_X-[view2(image2_W)]" options:0 metrics:@{@"image2_W":@(image2.size.width),@"view2_X":@(([UIScreen mainScreen].bounds.size.width - image2.size.width)*0.5)} views:views]];
    [cons addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view1(image1_H)]-14-[view2(image2_H)]-28-|" options:0 metrics:@{@"image1_H":@(image1.size.height),@"image2_H":@(image2.size.height)} views:views]];
    [customView addConstraints:cons];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
