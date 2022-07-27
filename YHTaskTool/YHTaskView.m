//
//  YHTaskView.m
//  Example
//
//  Created by CCSH on 2022/7/27.
//

#import "YHTaskView.h"
#import "SHRequestBase.h"
#import "MBProgressHUD.h"
#import "SHPopView.h"
#import "UIButton+SHExtension.h"
#import "SHWebViewController.h"


//引用
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

@interface YHTaskView ()

@property (nonatomic, strong) SHPopView *popView;

@end

@implementation YHTaskView

#pragma mark - 初始化
+ (YHTaskView *)share{
    static YHTaskView *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        _instance = [[YHTaskView alloc] init];
        [_instance setBackgroundImage:[_instance getImage:@"task_icon"] forState:UIControlStateNormal];
        [_instance addTarget:_instance action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    });

    return _instance;
}

#pragma mark - 私有方法
#pragma mark 更新弹窗
- (SHPopView *)showPopView:(YHTaskModel *)model isUpdate:(BOOL)isUpdate{
    
    SHPopView *popView = [[SHPopView alloc]init];
    
    //内容
    UIView *contentView = [[UIView alloc]init];
    popView.contentView = contentView;
    contentView.size = self.superview.size;
    
    //背景图片
    UIImageView *bgImg = [[UIImageView alloc]init];
    bgImg.userInteractionEnabled = YES;
    [contentView addSubview:bgImg];
    
    if (isUpdate) {
        //更新弹窗
        bgImg.image = [self getImage:@"task_update_bg"];
        bgImg.size = CGSizeMake(298, 385);
        //版本
        UILabel *version = [[UILabel alloc]init];
        [bgImg addSubview:version];
        version.text = [NSString stringWithFormat:@"发现新版本"];
        version.textColor = [UIColor whiteColor];
        version.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
        [version sizeToFit];
        version.x = 30;
        version.y = 28;
        version.height = 33;
        
        UILabel *ver = [[UILabel alloc]init];
        [bgImg addSubview:ver];
        ver.text = [NSString stringWithFormat:@"V%@",model.update_ver];
        ver.textColor = [UIColor whiteColor];
        ver.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];

        [ver sizeToFit];
        ver.x = version.x;
        ver.y = version.maxY;
        
        //升级
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [btn setTitle:@"升级" forState:UIControlStateNormal];
        btn.x = 39;
        btn.width = bgImg.width - 2*btn.x;
        btn.height = 38;
        btn.y = bgImg.height - 30 - btn.height;
        
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = btn.frame;
        
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0, 0, btn.width, btn.height);
        gl.startPoint = CGPointMake(0, 0.5);
        gl.endPoint = CGPointMake(1, 0.5);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:108/255.0 blue:78/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:231/255.0 green:40/255.0 blue:51/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        gl.cornerRadius = bgView.height/2;
        [bgView.layer addSublayer:gl];
        [bgImg addSubview:bgView];
        
        [bgImg addSubview:btn];
    
        [btn addClickBlock:^(UIButton * _Nonnull btn) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.update_url] options:@{} completionHandler:^(BOOL success) {
                    exit(1);
                }];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.update_url]];
            }
        }];
        
        //更新文案
        UIScrollView *scroll = [[UIScrollView alloc]init];
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        [bgImg addSubview:scroll];
        
        scroll.y = 163;
        scroll.x = 20;
        scroll.width = bgImg.width - 2*scroll.x;
        scroll.height = btn.y - scroll.y - 10;
        
        NSArray *temp = [model.update_content componentsSeparatedByString:@"\n"];
        
        __block UIView *view = nil;
        [temp enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //内容
            UILabel *lab = [[UILabel alloc]init];
            lab.numberOfLines = 0;
            lab.width = scroll.width;
            lab.text = obj;
            lab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
            lab.textColor = kColorText;
            [lab sizeToFit];
            [scroll addSubview:lab];
            if (view) {
                lab.y = view.maxY + 20;
            }else{
                lab.y = 0;
            }

            view = lab;
        }];
        
        [scroll layoutIfNeeded];
        scroll.contentSize = CGSizeMake(0, view.maxY + 10);
    }else{
        //任务弹窗
        bgImg.image = [self getImage:@"task_bg"];
        bgImg.size = CGSizeMake(298, 453);
        
        //文案
        UILabel *copyLab = [[UILabel alloc]init];
        [bgImg addSubview:copyLab];
        copyLab.numberOfLines = 0;
        copyLab.text = [NSString stringWithFormat:@"做体验任务\n赢联通积分"];
        copyLab.textColor = [UIColor whiteColor];
        copyLab.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
        [copyLab sizeToFit];
        copyLab.x = 30;
        copyLab.y = 25;
        
        //提醒
        UILabel *tipLab = [[UILabel alloc]init];
        [bgImg addSubview:tipLab];
        tipLab.textColor = kColorText;
        tipLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        tipLab.textAlignment = NSTextAlignmentCenter;
        NSString *tip = @"做任务，去评价，得联通积分";
        if ([model.score intValue] > 0) {
            tip = [NSString stringWithFormat:@"累计得  %@  积分",model.score];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:tip attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightRegular],NSForegroundColorAttributeName: kColorMain}];
            [att addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:36 weight:UIFontWeightRegular]} range:NSMakeRange(5, model.score.length)];
            
            tipLab.attributedText = att;
        }else{
            tipLab.text = tip;
        }
        tipLab.width = bgImg.width;
        tipLab.height = 64;
        tipLab.y = 137;
        
        //任务内容
        UIScrollView *scroll = [[UIScrollView alloc]init];
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        [bgImg addSubview:scroll];
        
        scroll.y = tipLab.maxY + 12;
        scroll.x = 22;
        scroll.width = bgImg.width - scroll.x - 20;
        scroll.height = bgImg.height - scroll.y - 25;
        
        __block UIView *view = nil;
        [model.task_list enumerateObjectsUsingBlock:^(YHTaskModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //内容
            UILabel *nameLab = [[UILabel alloc]init];
            nameLab.numberOfLines = 0;
            nameLab.width = scroll.width;
            nameLab.text = obj.task_name;
            nameLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
            nameLab.textColor = kColorText;
            [nameLab sizeToFit];
            [scroll addSubview:nameLab];
            if (view) {
                nameLab.y = view.maxY + 22;
            }else{
                nameLab.y = 0;
            }
            
            //积分
            UILabel *scoreLab = [[UILabel alloc]init];
            scoreLab.text = [NSString stringWithFormat:@"+%@积分",obj.task_score];
            scoreLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
            scoreLab.textColor = kColorMain;
            [scoreLab sizeToFit];
            [scroll addSubview:scoreLab];
            scoreLab.x = nameLab.x;
            scoreLab.y = nameLab.maxY + 13;
            
            //按钮
            switch (obj.task_state) {
                case 0://未体验
                {
                    //去体验
                    UIButton *btn = [self getBtn:0 data:obj];
                    btn.centerY = scoreLab.centerY;
                    btn.x = scroll.width - btn.width;
                    [scroll addSubview:btn];
                    
                    view = btn;
                }
                    break;
                case 1://未评价
                {
                    //查看任务
                    UIButton *btn = [self getBtn:3 data:obj];
                    btn.centerY = scoreLab.centerY;
                    btn.x = scroll.width - btn.width;
                    [scroll addSubview:btn];
                    
                    //去评价
                    UIButton *btn2 = [self getBtn:1 data:obj];
                    btn2.centerY = scoreLab.centerY;
                    btn2.x = btn.x - btn2.width - 10;
                    [scroll addSubview:btn2];
                    view = btn;
                }
                    break;
                case 2://任务完成
                {
                    //查看任务
                    UIButton *btn = [self getBtn:3 data:obj];
                    btn.centerY = scoreLab.centerY;
                    btn.x = scroll.width - btn.width;
                    [scroll addSubview:btn];
                    
                    //查看评价
                    UIButton *btn2 = [self getBtn:2 data:obj];
                    btn2.centerY = scoreLab.centerY;
                    btn2.x = btn.x - btn2.width - 10;
                    [scroll addSubview:btn2];
                    
                    view = btn;
                }
                    break;
                default:
                    break;
            }
        }];
        
        [scroll layoutIfNeeded];
        scroll.contentSize = CGSizeMake(0, view.maxY + 10);
    }
    
    bgImg.center = CGPointMake(contentView.width/2, contentView.height/2);
    
    return popView;
}

#pragma mark 获取按钮
- (UIButton *)getBtn:(NSInteger)type data:(YHTaskModel *)data{
    UIButton *btn = [[UIButton alloc]init];
    btn.size = CGSizeMake(85, 30);
    btn.backgroundColor = kColorMain;
    btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [btn borderRadius:btn.height/2 width:1 color:kColorMain];
    @weakify(self);
    [btn addClickBlock:^(UIButton * _Nonnull btn) {
        @strongify(self);
        [self.popView hide];
        switch (type) {
            case 0://去体验
            {
                [self requestTaskFinish:data];
            }
                break;
            case 1://去评价
            case 3://查看评价
            {
                [self openUrl:data.task_evaluation_url];
            }
                break;
            case 2://查看任务
            {
                [self openUrl:data.task_url];
            }
                break;
            default:
                break;
        }
    }];
    
    switch (type) {
        case 0:
        {
            [btn setTitle:@"去体验" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [btn setTitle:@"去评价" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [btn setTitle:@"查看任务" forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:kColorMain forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [btn setTitle:@"查看评价" forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:kColorMain forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    return btn;
}

#pragma mark 打开链接
- (void)openUrl:(NSString *)url{
    dispatch_async(dispatch_get_main_queue(), ^{
        SHWebViewController *vc = [[SHWebViewController alloc]init];
        vc.url = url;
        UIViewController *root = [self getCurrentVC];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [root presentViewController:nav animated:YES completion:nil];
    });
}

#pragma mark 获取最上方控制器
- (UIViewController *)getCurrentVC {
    UIWindow *window = [YHTaskView getWindow];
    UIViewController *rootVC = window.rootViewController;
    UIViewController *activeVC = nil;
    
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        activeVC = [(UINavigationController *)rootVC visibleViewController];
    } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        activeVC = [(UITabBarController *)rootVC selectedViewController];
    } else if (rootVC.presentedViewController) {
        activeVC = rootVC.presentedViewController;
    } else if (rootVC.childViewControllers.count > 0) {
        activeVC = [rootVC.childViewControllers lastObject];
    } else{
        activeVC = rootVC;
    }
    
    return activeVC;
}

#pragma mark 事件
- (void)btnAction:(YHTaskView *)btn{
    //请求
    [self requestUpdate];
}

#pragma mark - 请求
#pragma mark 版本更新
- (void)requestUpdate{
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[YHTaskView getWindow] animated:YES];
    
    //网址
    NSString *url = @"https://www.baidu.com";
    
    //数据处理
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];

    //请求
    SHRequestBase *request = [[SHRequestBase alloc]init];
    request.url = url;
    request.param = param;
    
    @weakify(self);
    request.success = ^(id _Nonnull responseObj) {
        @strongify(self);
        [hub hideAnimated:YES];
        BOOL update = arc4random() % 2;
        if (update) {
            YHTaskModel *model = [[YHTaskModel alloc]init];
            model.update_ver = @"9.2";
            model.update_content = @"1.人脸识别功能优化，提升识别的准确性；\n2.关怀版优化，增强了语音播报的准确性；\n3.修复了部分已知问题，提升APP的稳定性。";
            model.update_url = @"https://www.baidu.com";

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popView hide];
                self.popView = [self showPopView:model isUpdate:YES];
                [self.popView show];
            });
        }else{
            [self requestTask];
        }
    };
    request.failure = ^(NSError *_Nonnull error) {
        [hub hideAnimated:YES];
    };
    [request requestNativeGet];
}

#pragma mark 请求任务
- (void)requestTask{
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[YHTaskView getWindow] animated:YES];
    //网址
    NSString *url = @"https://www.baidu.com";
    
    //数据处理
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];

    //请求
    SHRequestBase *request = [[SHRequestBase alloc]init];
    request.url = url;
    request.param = param;
    
    @weakify(self);
    request.success = ^(id _Nonnull responseObj) {
        @strongify(self);
        [hub hideAnimated:YES];
        
        YHTaskModel *model = [[YHTaskModel alloc]init];
        model.score = @"1";
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 5; i++) {
            YHTaskModel *obj = [[YHTaskModel alloc]init];
            obj.task_url = @"https://www.baidu.com";
            obj.task_evaluation_url = @"https://www.hao123.com";
            obj.task_name = [NSString stringWithFormat:@"%d、随机任务---%u",i,arc4random()%100];
            obj.task_state = arc4random()%3;
            obj.task_score = [NSString stringWithFormat:@"%u",arc4random() % 10];
            [arr addObject:obj];
        }
        model.task_list = arr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.popView hide];
            self.popView = [self showPopView:model isUpdate:NO];
            [self.popView show];
        });

    };
    request.failure = ^(NSError *_Nonnull error) {
        [hub hideAnimated:YES];

    };
    [request requestNativeGet];
}

#pragma mark 任务完成
- (void)requestTaskFinish:(YHTaskModel *)data{
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[YHTaskView getWindow] animated:YES];
    //网址
    NSString *url = @"https://www.baidu.com";
    
    //数据处理
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];

    //请求
    SHRequestBase *request = [[SHRequestBase alloc]init];
    request.url = url;
    request.param = param;
    
    @weakify(self);
    request.success = ^(id _Nonnull responseObj) {
        @strongify(self);
        [hub hideAnimated:YES];
        [self openUrl:data.task_url];
    };
    request.failure = ^(NSError *_Nonnull error) {
        [hub hideAnimated:YES];

    };
    [request requestNativeGet];
}

#pragma mark - 公共方法
+ (UIWindow *)getWindow {
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *obj in windows) {
            if (obj.windowLevel == UIWindowLevelNormal) {
                window = obj;
                break;
            }
        }
    }
    return window;
}

#pragma mark 获取资源图片
/// 获取资源图片
+ (UIImage *)getImage:(NSString *)name{
    return [[YHTaskView new] getImage:name];
}
- (UIImage *)getImage:(NSString *)name{
    NSString *bundle = [[NSBundle bundleForClass:[self class]] pathForResource:@"YHTaskTool" ofType:@"bundle"];
    return [UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:bundle] pathForResource:name ofType:@"png"]];
}

@end
