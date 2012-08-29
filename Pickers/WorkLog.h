//
//  WorkLog.h
//  Pickers
//
//  Created by air macbook on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//工作日志实体类
@interface WorkLog : NSObject{
    NSInteger *workId;//工作日志id
    NSString  *type;//工作日志类型
    NSString *content;//日志内容
    NSString *startTime;//开始时间
    NSString *endTime;//结束时间
    NSString *createTime;//创建时间
}
@property(nonatomic,nonatomic) NSInteger *workId;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *startTime;
@property(nonatomic,strong) NSString *endTime;
@property(nonatomic,strong) NSString *createTime;
@end
