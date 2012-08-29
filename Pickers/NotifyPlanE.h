//
//  NotifyPlanE.h
//  Pickers
//
//  Created by 张飞 on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息组详情实体类－－拜访
@interface NotifyPlanE : NSObject{
    NSInteger npId;//id
    NSInteger ntId;//消息组id
    NSInteger spId;//服务器id
    NSString *createDate;//创建日期
    NSString *startTime;//开始时间
    NSString *endTime;//结束时间
    NSString *npContent;//内容
    NSString *createUser;//创建人
    NSString *handlerName;//审核时间
    NSInteger handlerId;//审核人
}
@property(nonatomic,nonatomic) NSInteger npId;
@property(nonatomic,nonatomic) NSInteger ntId;
@property(nonatomic,nonatomic) NSInteger spId;
@property(nonatomic,retain) NSString *createDate;
@property(nonatomic,retain) NSString *startTime;
@property(nonatomic,retain) NSString *endTime;
@property(nonatomic,retain) NSString *npContent;
@property(nonatomic,nonatomic) NSString *createUser;
@property(nonatomic,retain)NSString *handlerName;
@property(nonatomic,nonatomic)NSInteger handlerId;
@end
