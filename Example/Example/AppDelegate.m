//
//  AppDelegate.m
//  Example
//
//  Created by CCSH on 2022/7/27.
//

#import "AppDelegate.h"
#import "YHTaskTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YHTaskTool registerTaskWithAppId:1
                                   userId:@"17600075339"
                                 userName:@"17600075339"
                                  version:@"0.0.3"
                                   inView:nil
                                   result:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"YHTaskTool注册成功");
            }else{
                NSLog(@"YHTaskTool注册失败：%@",error.userInfo[@"msg"]);
            }
        }];
    });
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
