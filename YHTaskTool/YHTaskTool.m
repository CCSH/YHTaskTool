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
    return [NSError errorWithDomain:kDomain code:-1 userInfo:@{@"msg" : name ? : @"请求错误"}];
    ;
}

#pragma mark - 注册任务组件
+ (void)registerTaskWithAppId:(NSInteger)appId
                       userId:(NSString *)userId
                     userName:(NSString *)userName
                      version:(NSString *)version
                       inView:(UIView *)inView
                       result:(void (^)(NSError * _Nullable))result {
    //校验
    if (!userId.length) {
        if (result) {
            result([self getError:@"请填入正确的 userId"]);
        }
        return;
    }
    if (!userName.length) {
        if (result) {
            result([self getError:@"请填入正确的 userName"]);
        }
        return;
    }
    if (!version.length) {
        if (result) {
            result([self getError:@"请填入正确的 version"]);
        }
        return;
    }

    //配置视图
    if (!inView) {
        inView = [YHTaskView getWindow];
    }
    
    //先移除
    [self uninstall];
    
    //视图处理
    YHTaskView *iconView = [YHTaskView share];
    
    CGFloat view_wh = 60;
    CGFloat space = 10;
    iconView.frame = CGRectMake(inView.width - view_wh - space, inView.centerY, view_wh, view_wh);
    iconView.dragEdge = UIEdgeInsetsMake(space, inView.width - view_wh - space, space, space);
    
    //去注册
    NSString *url = [NSString stringWithFormat:@"%@%@",kHost,kMobileRegisterInterface];
    //数据处理
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"applicationPlatform"] = @"0";

    if (appId) {
        param[@"appId"] = @(appId);
    }
    if (userId) {
        param[@"userFlag"] = userId;
    }
    if (version) {
        param[@"version"] = version;
    }
    if (userName) {
        param[@"userName"] = userName;
    }
    //请求
    SHRequestBase *request = [[SHRequestBase alloc] init];
    request.url = url;
    request.param = param;
    request.success = ^(id _Nonnull responseObj) {
        NSDictionary *data = responseObj;
        if ([data[@"code"] intValue] == 200) {
            [inView addSubview:iconView];
            YHTaskModel *model = [[YHTaskModel alloc]init];
            model.token = data[@"data"][@"registerUniqueID"];
            iconView.data = model;
            if (result) {
                result(nil);
            }
        }else{
            if (result) {
                result([self getError:data[@"msg"]]);
            }
        }
    };
    request.failure = ^(NSError *_Nonnull error) {
        if (result) {
            result([self getError:@"请求错误"]);
        }
    };
    [request requestNativePOST];
}

/// 卸载
+ (void)uninstall {
    [[YHTaskView share] removeFromSuperview];
}

@end
