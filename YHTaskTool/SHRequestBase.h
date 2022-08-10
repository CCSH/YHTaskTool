//
//  SHRequestBase.h
//  SHNetworkRequest
//
//  Created by CSH on 2019/5/31.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 主机地址
#define kHost @"http://ecstest2018.10010.com/experienceCenter/mobileExperience/"

#pragma mark - 接口
#pragma mark 移动端注册接口
#define kMobileRegisterInterface @"mobileRegisterInterface"

#pragma mark 移动端查询版本更新接口
#define kMobileNewVersionUpdateInterface @"mobileNewVersionUpdateInterface"

#pragma mark 移动端任务列表接口
#define kMobileTaskListInterface @"mobileTaskListInterface"

#pragma mark 移动端任务列表变更状态接口
#define kMobileChangeStateInformation @"mobileChangeStateInformation"

NS_ASSUME_NONNULL_BEGIN

/**
网络请求基础
*/
@interface SHRequestBase : NSObject

// 必填
//地址
@property (nonatomic, copy) NSString *url;

// 选填
//进度
@property (nonatomic, copy) void (^progress)(NSProgress *progress);
//成功
@property (nonatomic, copy) void (^success)(id responseObj);
//失败
@property (nonatomic, copy) void (^failure)(NSError *error);

//公共参数
//参数
@property (nonatomic, strong) id param;
//请求头
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *headers;
//请求标记
@property (nonatomic, copy) NSString *tag;
//重试次数
@property (nonatomic, assign) NSInteger retry;

#pragma mark 原生GET
- (void)requestNativeGet;

#pragma mark 原生POST
- (void)requestNativePOST;

#pragma mark 获取请求队列
- (NSDictionary *)getRequestQueue;

#pragma mark 取消所有网络请求
- (void)cancelAllOperations;

#pragma mark 取消某个网络请求
- (void)cancelOperationsWithTag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
