//
//  NotifyGzrw.h
//  Pickers
//
//  Created by 张飞 on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息组详情实体类－－工作任务
@interface NotifyGzrw : NSObject{
    NSInteger ngId;//id
    NSInteger ntId;//消息组id
    NSInteger peopleId;//联系人id
    NSInteger spId;//服务器id
    NSString *ngTitle;//标题
    NSString *ngContent;//内容
    NSString *ngCreateDate;//创建时间
    NSString *finishTime;//完成时间
    NSString *ngLevel;
    NSString *status;//状态
    NSString *createUser;//创建人
    NSString *remarkUser;//回复人
    NSString *remarkContent;//回复内容
    NSString *rlTime;
}
@property(nonatomic,nonatomic) NSInteger ngId;
@property(nonatomic,nonatomic) NSInteger ntId;
@property(nonatomic,nonatomic) NSInteger peopleId;
@property(nonatomic,nonatomic) NSInteger spId;
@property(nonatomic,strong) NSString *ngTitle;
@property(nonatomic,strong) NSString *ngContent;
@property(nonatomic,strong) NSString *ngCreateDate;
@property(nonatomic,strong) NSString *finishTime;
@property(nonatomic,strong) NSString *ngLevel;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *createUser;
@property(nonatomic,strong) NSString *remarkUser;
@property(nonatomic,strong) NSString *remarkContent;
@property(nonatomic,strong) NSString *rlTime;
@end
