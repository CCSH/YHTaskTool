//
//  YHTaskTool.m
//  Example
//
//  Created by CCSH on 2022/7/27.
//

#import "SHRequestBase.h"
#import "YHTaskTool.h"
#import "YHTaskView.h"

#define kDomain @"YHTaskTool"

@implementation YHTaskTool

#pragma mark - 私有方法
+ (NSError *)getError:(NSString *)name {
    return [NSError errorWithDomain:kDomain code:-1 userInfo:@{@"msg" : name}];
    ;
}

#pragma mark - 注册任务组件
+ (void)registerTaskWithAppId:(NSString *)appId
                       userId:(NSString *)userId
                      version:(NSString *)version
                       inView:(UIView *_Nullable)inView
                       result:(void (^_Nullable)(BOOL success, NSError *error))result {
    //校验
    if (!appId.length) {
        if (result) {
            result(NO, [self getError:@"请填入正确的应用标识 appId"]);
        }
        return;
    }
    if (!userId.length) {
        if (result) {
            result(NO, [self getError:@"请填入正确的应用标识 userId"]);
        }
        return;
    }
    if (!version.length) {
        if (result) {
            result(NO, [self getError:@"请填入正确的应用标识 version"]);
        }
        return;
    }
    //配置视图
    if (!inView) {
        inView = [YHTaskView getWindow];
    }
    
    //视图处理
    YHTaskView *iconView = [YHTaskView share];
    //数据处理
    YHTaskModel *data = [[YHTaskModel alloc] init];
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
    NSString *url = @"https://www.baidu.com";
    //数据处理
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    //请求
    SHRequestBase *request = [[SHRequestBase alloc] init];
    request.url = url;
    request.param = param;
    request.success = ^(id _Nonnull responseObj) {
        if (result) {
            result(YES, nil);
        }
        [inView addSubview:iconView];
    };
    request.failure = ^(NSError *_Nonnull error) {
        if (result) {
            result(NO, [self getError:@"请求错误"]);
        }
    };
    [request requestNativeGet];
}

/// 卸载
+ (void)uninstall {
    [[YHTaskView share] removeFromSuperview];
}

@end
