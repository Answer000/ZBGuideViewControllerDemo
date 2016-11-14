# ZBGuideViewController

### 框架作用
* 实现了引导页和广告页功能，只需将keyWindow的根控制器设置为ZBGuideViewController便可轻松实现引导及广告功能，且自定义程度高

* 如图所示



### 导入方法
* 手动导入(暂不支持cocoapods):将ZBGuideViewController文件夹拖入项目中即可

### 使用方法
```Objc
* 只需将主窗口的根控制器设置为ZBGuideViewController即可： 
    mainRootViewController:——> 原来的主窗口根控制；
    guideImages:——> 引导页图片数组；
    adverUrlStr:——> 广告页图片链接
    
    ZBGuideViewController *guideVC = [[ZBGuideViewController alloc] initWithMainRootViewController:tabbarVC guideImages:images        adverUrlStr:urlStr[arc4random() % urlStr.count]];
```

