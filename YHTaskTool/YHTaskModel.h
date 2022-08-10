//
//  YHTaskModel.h
//  Example
//
//  Created by CCSH on 2022/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHTaskModel : NSObject

#pragma mark 注册接口
//客户端用户唯一标识
@property (nonatomic, copy) NSString *token;

#pragma mark 更新接口
//更新版本
@property (nonatomic, copy) NSString *update_ver;
//更新链接
@property (nonatomic, copy) NSString *update_url;
//更新内容
@property (nonatomic, copy) NSString *update_content;

#pragma mark 任务接口
//任务列表
@property (nonatomic, strong) NSArray<YHTaskModel *> *task_list;
//任务累计积分
@property (nonatomic, copy) NSString *score;

// task_list内容
//任务ID
@property (nonatomic, copy) NSString *task_id;
//任务名称
@property (nonatomic, copy) NSString *task_name;
//任务积分
@property (nonatomic, copy) NSString *task_score;
//任务链接
@property (nonatomic, copy) NSString *task_url;
//评价链接
@property (nonatomic, copy) NSString *task_evaluation_url;
//任务状态(0 未评价、1 已完成、2 未体验)
@property (nonatomic, assign) NSInteger task_state;

@end

NS_ASSUME_NONNULL_END
