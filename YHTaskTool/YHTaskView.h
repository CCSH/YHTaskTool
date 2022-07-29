//
//  YHTaskView.h
//  Example
//
//  Created by CCSH on 2022/7/27.
//

#import "UIView+SHExtension.h"
#import "YHTaskModel.h"
#import <UIKit/UIKit.h>

// RGB颜色
#define kRGBA(R, G, B, A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]
#define kRGB(R, G, B) kRGBA(R, G, B, 1)

#define kColorMain kRGB(241, 55, 55)
#define kColorText kRGB(51, 51, 51)

NS_ASSUME_NONNULL_BEGIN

/// 任务图标
@interface YHTaskView : UIButton

@property (nonatomic, strong) YHTaskModel *data;

/// 单例初始化
+ (YHTaskView *)share;

/// 获取Window
+ (UIWindow *)getWindow;

/// 获取资源图片
+ (UIImage *)getImage:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
