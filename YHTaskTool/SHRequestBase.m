

//
//  SHRequestBase.m
//  SHNetworkRequest
//
//  Created by CSH on 2019/5/31.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "SHRequestBase.h"

@implementation SHRequestBase

//请求队列
static NSMutableDictionary *netQueueDic;

#pragma mark - 请求方法
#pragma mark 原生GET
- (void)requestNativeGet {
    NSString *url = [NSString stringWithFormat:@"%@%@", self.url, [self setUrlPara:self.param]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    req.URL = [NSURL URLWithString:url];
    req.allHTTPHeaderFields = self.headers;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:req
                                                                 completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            if (self.retry > 0) {
                //重新请求
                self.retry--;
                [self requestNativeGet];
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleFailure:error];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self handleSuccess:data];
            });
        }
    }];
    
    //启动
    [task resume];
    [self handleTag:task];
}

#pragma mark 原生POST
- (void)requestNativePOST {
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    req.URL = [NSURL URLWithString:self.url];
    req.HTTPBody = [NSJSONSerialization dataWithJSONObject:self.param options:kNilOptions error:nil];
    req.HTTPMethod = @"POST";
    req.allHTTPHeaderFields = self.headers;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:req
                                                                 completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            if (self.retry > 0) {
                //重新请求
                self.retry--;
                [self requestNativeGet];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleFailure:error];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self handleSuccess:data];
            });
        }
    }];
    
    //启动
    [task resume];
    [self handleTag:task];
}

#pragma mark - 公共方法
#pragma mark 获取请求队列
- (NSDictionary *)getRequestQueue {
    return netQueueDic;
}

#pragma mark 取消所有网络请求
- (void)cancelAllOperations {
    NSDictionary *temp = [NSDictionary dictionaryWithDictionary:netQueueDic];
    
    [temp enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        //取消网络请求
        [self cancelOperationsWithTag:key];
    }];
}

#pragma mark 取消某个网络请求
- (void)cancelOperationsWithTag:(NSString *)tag {
    if (tag) {
        //取消请求
        NSURLSessionTask *task = netQueueDic[tag];
        if (task) {
            [task cancel];
            //移除队列
            [netQueueDic removeObjectForKey:tag];
        }
    }
}

#pragma mark - 私有方法
#pragma mark 处理成功
- (void)handleSuccess:(id)responseObject {
    //移除队列
    [self cancelOperationsWithTag:self.tag];
    
    //    id obj = [responseObject mj_JSONObject];
    //    if (!obj) {
    //        obj = [responseObject mj_JSONString];
    //    }
    
    //回调
    if (self.success) {
        self.success(responseObject);
    }
}

#pragma mark 处理失败
- (void)handleFailure:(NSError *)error {
    //移除队列
    [self cancelOperationsWithTag:self.tag];
    //回调
    if (self.failure) {
        self.failure(error);
    }
}

#pragma mark 处理tag
- (void)handleTag:(NSURLSessionTask *)task {
    if (self.tag.length) {
        //添加队列
        netQueueDic[self.tag] = task;
    }
}

#pragma mark 设置Url参数
- (NSString *)setUrlPara:(NSDictionary *)para {
    if (!para.count) {
        return @"";
    }
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [para enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
        [temp addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    
    return [NSString stringWithFormat:@"?%@", [temp componentsJoinedByString:@"&"]];
}

@end
