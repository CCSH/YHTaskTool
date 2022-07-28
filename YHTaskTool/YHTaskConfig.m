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
                       result:(void (^_Nullable)(BOOL success, NSError *error))result{
    //校验
    if (!appId.length) {
        if (result) {
            NSError *error = [NSError errorWithDomain:@"YHTaskTool" code:-1 userInfo:@{@"msg":@"请填入正确的应用标识 appId"}];
            result(NO,error);
        }
        return;
    }
    if (!userId.length) {
        if (result) {
            NSError *error = [NSError errorWithDomain:@"YHTaskTool" code:-1 userInfo:@{@"msg":@"请填入正确的应用标识 userId"}];
            result(NO,error);
        }
        return;
    }
    if (!version.length) {
        if (result) {
            NSError *error = [NSError errorWithDomain:@"YHTaskTool" code:-1 userInfo:@{@"msg":@"请填入正确的应用标识 version"}];
            result(NO,error);
        }
        return;
    }
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
