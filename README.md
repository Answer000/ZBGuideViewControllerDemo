# ZBGuideViewController

### 框架作用
* 实现了引导页和广告页功能，只需将keyWindow的根控制器设置为ZBGuideViewController便可轻松实现引导及广告功能，且自定义程度高

* 如图所示
![image](https://github.com/AnswerXu/ZBGuideViewControllerDemo/blob/master/ReadImages/guide.gif)


### 导入方法
* 手动导入:将ZBGuideViewController文件夹拖入项目中即可
* pods导入:
 ```
 pod 'ZBGuideViewController', '~> 0.0.2'
 ```

### 使用方法
*   只需在AppDelegate.m文件中将主窗口的根控制器设置为ZBGuideViewController即可：
```Objc 
    //mainRootViewController: 主窗口根控制
    //guideImageNames: 引导页图片数组
    //advertisingImageUrlStr: 广告页图片链接地址
    ZBGuideViewController *guideVC = [[ZBGuideViewController alloc] initWithMainRootViewController:tabbarVC guideImageNames:images advertisingImageUrlStr:urlStr[arc4random() % urlStr.count]];
    
    // 倒计时时间
    guideVC.countDownNum = 10;
    
    // 进入广告详情后是否切换根控制器
    guideVC.changeRootWhenEnterAdvertisingDetails = NO;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = guideVC;
    [self.window makeKeyAndVisible];
```

*   自定义引导页跳转按钮
```Objc
    [guideVC reSetGPJumpBtnBlock:^(UIButton *jumpBtn) {
        //自定义内容
        [jumpBtn setTitle:@"Join Now" forState:UIControlStateNormal];
    }];
```

*   自定义广告页customView
```Objc
    [guideVC reSetAdverCustomView:^(UIView *customView) {
        //自定义内容
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
    }];
```

* 自定义广告详情控制器
```Objc
    UIViewController *detailVC = [UIViewController new];
    detailVC.title = @"广告详情";
    detailVC.view.backgroundColor = [UIColor redColor];
    detailVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:guideVC action:@selector(cancelClick)];
    guideVC.detailVC = detailVC;
```

### 

	   谢谢支持，可能还有很多不完善的地方，期待您的建议！如对您有帮助，请不吝您的Star，您的支持与鼓励是我继续前行的动力。
	   邮箱：zhengbo073017@163.com
