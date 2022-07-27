//
//  YHTaskConfig.m
//  Example
//
//  Created by CCSH on 2022/7/27.
//

#import "YHTaskConfig.h"
#import "YHTaskView.h"

@implementation YHTaskConfig

#pragma mark - 注册任务组件
+ (void)registerTaskWithAppID:(NSString *)appId
                       userId:(NSString *)userId
                      version:(NSString *)version
                       inView:(UIView *_Nullable)inView
                       result:(void (^_Nullable)(BOOL success))result{
    //校验
    NSAssert(appId.length, @"请填入正确的应用标识 appid");
    NSAssert(userId.length, @"请填入正确的用户标识 userId");
    NSAssert(version.length, @"请填入正确的应用版本 version");
    if (!inView) {
        inView = [YHTaskView getWindow];
    }
    
    //视图处理
    YHTaskView *iconView = [YHTaskView share];
    //数据处理
    YHTaskModel *data = [[YHTaskModel alloc]init];
    data.appId = appId;
    data.userId = userId;
    data.version = version;
    
    iconView.data = data;
    CGFloat view_wh = 60;
    CGFloat space = 10;
    iconView.frame = CGRectMake(inView.width - view_wh - space, inView.centerY, view_wh, view_wh);
    iconView.dragEdge = UIEdgeInsetsMake(space, inView.width - view_wh - space, space, space);
    
    //先移除
    [iconView removeFromSuperview];
    
    //去注册

    //再添加
    [inView addSubview:iconView];
}

/// 卸载
+ (void)uninstall{
    [[YHTaskView share] removeFromSuperview];
}

@end
