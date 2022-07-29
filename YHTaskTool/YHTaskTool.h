//
//  YHTaskTool.h
//  Example
//
//  Created by CCSH on 2022/7/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 任务组件配置工具
@interface YHTaskTool : NSObject

/// 注册任务组件
/// @param appId  APP标识
/// @param userId  用户标识
/// @param version  当前版本号
/// @param inView  显示View(默认window)
/// @param result  注册结果回调
+ (void)registerTaskWithAppId:(NSString *)appId
                       userId:(NSString *)userId
                      version:(NSString *)version
                       inView:(UIView *_Nullable)inView
                       result:(void (^_Nullable)(BOOL success, NSError *error))result;

/// 卸载
+ (void)uninstall;

@end

NS_ASSUME_NONNULL_END
