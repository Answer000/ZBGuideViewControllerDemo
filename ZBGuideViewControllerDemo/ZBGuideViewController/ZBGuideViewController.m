//
//  ZBGuideViewController.m
//  ZBGuideView
//
//  Created by 澳蜗科技 on 16/11/8.
//  Copyright © 2016年 AnswerXu. All rights reserved.
//

#import "ZBGuideViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

#define KBounds         [UIScreen mainScreen].bounds
#define KeyWindow       [UIApplication sharedApplication].keyWindow
#define KVersion        [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]
#define KOldVersionKey  @"oldVersionKey"
#define KDefault        [NSUserDefaults standardUserDefaults]

#pragma mark--------------------------ZBCollectionViewCell-------------------------
@interface ZBCollectionViewCell : UICollectionViewCell
//展示图片的UIImageView
@property (nonatomic,strong) UIImageView *imgView;

@end

@implementation ZBCollectionViewCell
#pragma mark-  懒加载
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    }
    return _imgView;
}

#pragma mark-  重写init方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imgView];
    }
    return self;
}
#pragma mark-  填充图片
- (void)setImgViewWithImage:(UIImage *)image{
    self.imgView.image = image;
}
@end


#pragma mark------------------------ZBAdvertisementView------------------------
typedef void(^ZBAdvertisementBlock)(BOOL isTransform);

@interface ZBAdvertisementView : UIView
//展示广告图
@property (nonatomic,strong) UIImageView *adverImgView;
//可自定义视图
@property (nonatomic,strong) UIView *customView;
//定时器
@property (nonatomic,weak) NSTimer *timer;
//倒计时按钮
@property (nonatomic,strong) UIButton *countDownBtn;
//点击广告图Block回调
@property (nonatomic,copy) ZBAdvertisementBlock advertisementBlock;
@end

//自定义视图的高度
#define KCustomViewHeight  150
//倒计时时间(s)
static int _countDownNum = 2;

@implementation ZBAdvertisementView
#pragma mark-  懒加载
//广告图
- (UIImageView *)adverImgView{
    if (!_adverImgView) {
        _adverImgView = [[UIImageView alloc] init];
        _adverImgView.backgroundColor = [UIColor whiteColor];
        _adverImgView.userInteractionEnabled = YES;
    }
    return _adverImgView;
}
//自定义视图
- (UIView *)customView{
    if (!_customView) {
        _customView = [[UIView alloc] init];
        _customView.backgroundColor = [UIColor whiteColor];
    }
    return _customView;
}
//定时器
-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMonitorMethod) userInfo:nil repeats:YES];
    }
    return _timer;
}
//倒计时按钮
-(UIButton *)countDownBtn{
    if (!_countDownBtn) {
        _countDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnWH = 30;
        _countDownBtn.bounds = CGRectMake(0, 0, btnWH, btnWH);
        _countDownBtn.center = CGPointMake(KBounds.size.width - btnWH*0.5 - 10, btnWH*0.5+25);
        _countDownBtn.layer.cornerRadius = btnWH * 0.5;
        _countDownBtn.layer.masksToBounds = YES;
        _countDownBtn.backgroundColor = [UIColor blackColor];
        _countDownBtn.alpha = 0.5;
        _countDownBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_countDownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.countDownBtn setTitle:[NSString stringWithFormat:@"%dS",_countDownNum + 1] forState:UIControlStateNormal];
        [_countDownBtn addTarget:self action:@selector(countDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countDownBtn;
}

#pragma mark-  重写init方法
-(instancetype)initWithAdvertisementImageUrlStr:(NSString *)imageUrlStr{
    if (self == [super initWithFrame:KBounds]) {
        [self setupUI];
        //加载图片
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrlStr] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                self.adverImgView.image = image;
            }else{
                self.adverImgView.image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:[KDefault valueForKey:@"advertisementImageUrlString"]];
            }
        }];
        //将imageUrlStr保存到本地
        [KDefault setObject:imageUrlStr forKey:@"advertisementImageUrlString"];
        [KDefault synchronize];
        
        //将定时器添加到主线程
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark-  设置UI
- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    //添加子控件
    [self addSubview:self.adverImgView];
    [self addSubview:self.customView];
    [self addSubview:self.countDownBtn];
    
    //关闭自动布局属性
    self.adverImgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.customView.translatesAutoresizingMaskIntoConstraints = NO;
    //VFL布局
    NSDictionary *views = @{@"adverImgView" : self.adverImgView,@"customView" : self.customView};
    NSMutableArray *sumCons = [NSMutableArray array];
    NSArray *cons_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[adverImgView]-0-|" options:0 metrics:nil views:views];
    [sumCons addObjectsFromArray:cons_H];
    NSArray *cons_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[adverImgView]-0-[customView(==customViewHeight)]-0-|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight  metrics:@{@"customViewHeight" : @(KCustomViewHeight)} views:views];
    [sumCons addObjectsFromArray:cons_V];
    [self addConstraints:sumCons];
}

#pragma mark-  事件监听
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches.allObjects){
        if ([touch.view isKindOfClass:[UIImageView class]]) {
            self.advertisementBlock(YES);
        }
    }
}
-(void)timerMonitorMethod{
    if (_countDownNum == 0) {
        [self countDownBtnClick];
    }else{
        [self.countDownBtn setTitle:[NSString stringWithFormat:@"%dS",_countDownNum] forState:UIControlStateNormal];
    }
    _countDownNum--;
}
-(void)countDownBtnClick{
    //跳转控制器
    self.advertisementBlock(NO);
    [self invalidateTimer];
}
#pragma mark-  销毁定时器
-(void)invalidateTimer{
    [self.timer invalidate];
    self.timer = nil;
}
@end

#pragma mark--------------------------ZBCollectionView-------------------------------
typedef void(^ZBGuidePageViewBlock)(void);
@interface ZBGuidePageView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
//collectionView
@property (nonatomic,strong) UICollectionView *collectionView;
//引导页图片
@property (nonatomic,strong) NSArray<NSString *> *images;
//pageControl
@property (nonatomic,strong) UIPageControl *pageControl;
//展示图片的UIImageView
@property (nonatomic,strong) UIImageView *imgView;
//进出MainVC的UIButton
@property (nonatomic,strong) UIButton *jumpBtn;
//切换根控制器的block回调
@property (nonatomic,copy) ZBGuidePageViewBlock guidePageViewBlock;

@end

#define KCellIdent       @"guidePageCell"

@implementation ZBGuidePageView

#pragma mark-  懒加载
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //设置布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = KBounds.size;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:KBounds collectionViewLayout:layout];
        //注册cell
        [_collectionView registerClass:[ZBCollectionViewCell class] forCellWithReuseIdentifier:KCellIdent];
        //翻页效果
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        //设置水平方向滚动
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentSize = CGSizeMake(KBounds.size.width * self.images.count, KBounds.size.height);
    }
    return _collectionView;
}
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(KBounds.size.width * 0.5, KBounds.size.height - 70);
        _pageControl.bounds = CGRectMake(0, 0, KBounds.size.width, 10);
        _pageControl.numberOfPages = self.images.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}
-(UIButton *)jumpBtn{
    if (!_jumpBtn) {
        _jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jumpBtn.center = CGPointMake(KBounds.size.width * 0.5, KBounds.size.height - 130);
        _jumpBtn.bounds = CGRectMake(0, 0, 80, 30);
        _jumpBtn.layer.borderColor = [UIColor redColor].CGColor;
        _jumpBtn.layer.borderWidth = 1;
        _jumpBtn.layer.cornerRadius = 5;
        _jumpBtn.layer.masksToBounds = YES;
        [_jumpBtn setTitle:@"进入主页" forState:UIControlStateNormal];
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_jumpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_jumpBtn addTarget:self action:@selector(jumpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpBtn;
}

#pragma mark-  单例
+(instancetype)shareInstance{
    static ZBGuidePageView *_instance= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZBGuidePageView alloc] initWithFrame:KBounds];
        _instance.backgroundColor = [UIColor whiteColor];
    });
    return _instance;
}

- (instancetype)showGuidePageViewWithImages:(NSArray <NSString *>*)images{
    self.images = images;
    //添加子控件
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    return self;
}

#pragma mark-  滚动监听
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger page = offset/KBounds.size.width;
    self.pageControl.currentPage = page;
}

#pragma mark-  数据源代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KCellIdent forIndexPath:indexPath];
    [cell setImgViewWithImage:[UIImage imageNamed:self.images[indexPath.item]]];
    if (indexPath.item == self.images.count - 1 && self.images.count > 0) {
        [cell.contentView addSubview:self.jumpBtn];
    }else{
        [self.jumpBtn removeFromSuperview];
    }
    return cell;
}

#pragma mark-  事件监听
-(void)jumpBtnClick{
    self.guidePageViewBlock();
}
@end

#pragma mark-----------------------------------自定义转场消失动画--------------------------
//修改跟控制器的回调
typedef void(^DismissAnimatorBlock)(void);
@interface DismissAnimator : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
@property (nonatomic,assign) BOOL isDismiss;
@property (nonatomic,copy) DismissAnimatorBlock dismissAnimatorBlock;
@end

@implementation DismissAnimator
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.isDismiss = YES;
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.23;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (self.isDismiss) {
        //修改跟控制器
        self.dismissAnimatorBlock();
        //关闭上下文
        [transitionContext completeTransition:YES];
    }
}

@end

#pragma mark--------------------------------ZBGuideViewController----------------
@interface ZBGuideViewController ()
//真正的根控制器
@property (nonatomic,strong) UIViewController *mainViewController;
//广告视图
@property (nonatomic,strong) ZBAdvertisementView *advertisementView;
//引导视图
@property (nonatomic,strong) ZBGuidePageView *guidePageView;
//引导页图片数组
@property (nonatomic,strong) NSArray  *guidePageImages;
//广告图地址
@property (nonatomic,strong) NSString *adverImageUrlStr;
//自定义转场代理
@property (nonatomic,strong) DismissAnimator *dismissAnimator;
@end

#define KUpdateFlag   [KVersion floatValue] > [[KDefault valueForKey:KOldVersionKey] floatValue]
@implementation ZBGuideViewController
#pragma mark-  懒加载
-(DismissAnimator *)dismissAnimator{
    if (!_dismissAnimator) {
        _dismissAnimator = [[DismissAnimator alloc] init];
    }
    return _dismissAnimator;
}
-(ZBAdvertisementView *)advertisementView{
    if(!_advertisementView){
        _advertisementView = [[ZBAdvertisementView alloc] initWithAdvertisementImageUrlStr:self.adverImageUrlStr];
        __weak typeof(self) weakSelf = self;
        _advertisementView.advertisementBlock = ^(BOOL isTransform){
            if (isTransform) {
                if (weakSelf.detailVC) {
                    //跳转控制器之前先消耗定时器
                    [weakSelf.advertisementView.timer invalidate];
                    weakSelf.advertisementView.timer = nil;
                    //跳转到其他控制器
                    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:weakSelf.detailVC];
                    if(!weakSelf.detailVC.navigationItem.leftBarButtonItem) weakSelf.detailVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:weakSelf action:@selector(cancelClick)];
                    navi.modalPresentationStyle = UIModalPresentationCustom;
                    navi.transitioningDelegate = weakSelf.dismissAnimator;
                    weakSelf.dismissAnimator.dismissAnimatorBlock = ^(){
                        [weakSelf changeRootViewController];
                    };
                    [weakSelf presentViewController:navi animated:YES completion:nil];
                }
            }else{
                //改变根控制器
                [weakSelf changeRootViewController];
            }
        };
    }
    return _advertisementView;
}

-(void)cancelClick{
    [self.detailVC dismissViewControllerAnimated:YES completion:nil];
}

-(ZBGuidePageView *)guidePageView{
    if (!_guidePageView) {
        _guidePageView = [[ZBGuidePageView shareInstance] showGuidePageViewWithImages:self.guidePageImages];
        __weak typeof(self) weakSelf = self;
        _guidePageView.guidePageViewBlock = ^(){
            //跳转到MainRoot控制器
            [weakSelf changeRootViewController];
        };
    }
    return _guidePageView;
}

#pragma mark-  自定义init方法
-(instancetype)initWithMainRootViewController:(UIViewController *)mainRootVC guideImages:(NSArray<NSString*> *)images adverUrlStr:(NSString *)urlStr{
    if (self == [super init]) {
        self.guidePageImages = images;
        self.adverImageUrlStr = urlStr;
        self.mainViewController = mainRootVC;
    }
    return self;
}
#pragma mark-  自定义广告图CustomView
- (void)reSetAdverCustomView:(void(^)(UIView *customView))customViewBlock{
    if(customViewBlock && KUpdateFlag == NO){
        customViewBlock(self.advertisementView.customView);
    }
}
#pragma mark-  自定义引导页跳转按钮
- (void)reSetGPJumpBtnBlock:(void(^)(UIButton *jumpBtn))jumpBtnBlock{
    if (jumpBtnBlock && KUpdateFlag == YES){
        jumpBtnBlock(self.guidePageView.jumpBtn);
    }
}
#pragma mark-  清除本地保存的version
- (void)clearLocalVersion{
    [KDefault removeObjectForKey:@"oldVersionKey"];
    [KDefault synchronize];
}
#pragma mark-  修改根控制器
- (void)changeRootViewController{
    if ([KeyWindow.rootViewController isKindOfClass:[ZBGuideViewController class]]) {
        KeyWindow.rootViewController = self.mainViewController;
    }else{
        KeyWindow.rootViewController = [[ZBGuideViewController alloc] init];
    }
}
#pragma mark-  系统回调方法
-(void)loadView{
    [super loadView];
    self.view = KUpdateFlag ? self.guidePageView : self.advertisementView;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    if (KUpdateFlag == YES) {
        [KDefault setValue:@([KVersion floatValue]) forKey:KOldVersionKey];
        [KDefault synchronize];
    }
}
-(void)dealloc{
    NSLog(@"%s--%d",__func__,__LINE__);
}

@end
