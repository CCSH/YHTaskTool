# YHTaskTool


> 使用中如果有其他问题可以[`告诉我`](https://github.com/CCSH/YHTaskTool/issues/new)

# 体验任务组件

# 使用 pod 导入
[![Pod Version](http://img.shields.io/cocoapods/v/YHTaskTool.svg?style=flat)](https://github.com/CCSH/YHTaskTool/releases)
```
pod 'YHTaskTool'
```

# 使用方法
```
        [YHTaskConfig registerTaskWithAppID:@"APP标识"
                                     userId:@"用户标识"
                                    version:@"当前版本"
                                     inView:nil
                                     result:^(BOOL success, NSError * _Nonnull error) {
            if (success) {
                NSLog(@"注册成功");
            }else{
                NSLog(@"注册失败:%@",error.userInfo[@"msg"]);
            }
        }];
```
