# YHTaskTool

体验任务组件


> 使用中如果有其他问题可以[`告诉我`](https://github.com/CCSH/YHTaskTool/issues/new)

## 使用 pod 导入
[![Pod Version](http://img.shields.io/cocoapods/v/YHTaskTool.svg?style=flat)](https://github.com/CCSH/YHTaskTool/releases)

```
pod 'YHTaskTool'
```

## 使用方法

### 1、配置Info.plist文件

```
添加 App Transport Security Settings
下方再添加 Allow Arbitrary Loads 设置为YES
```

### 2、引入头文件

```
#import <YHTaskTool.h>
```

### 3、注册位置写入代码

```
        [YHTaskTool registerTaskWithAppId:应用标识
                                   userId:@"用户id"
                                 userName:@"用户名"
                                  version:@"版本号"
                                   inView:nil
                                   result:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"YHTaskTool注册成功");
            }else{
                NSLog(@"YHTaskTool注册失败：%@",error.userInfo[@"msg"]);
            }
        }];
```
