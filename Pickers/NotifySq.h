//
//  NotifySq.h
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息组详情实体类－－申请
@interface NotifySq : NSObject{
    NSInteger nsId;//id
    NSInteger peopleId;//联系人id
    NSInteger ntId;//消息组id
    NSInteger spId;//服务器id
    NSString *nsContent;//内容
    NSString *nsCreateDate;//创建时间
    NSString *nsRemarkContent;//回复内容
    NSString *nsRemarkPeople;//回复人
    NSString *status;//状态
    NSString *nsType;//类别
    NSString *nsRemarkTime;//回复时间
    NSString *nsRemarkType;//回复类型－－通过｜拒绝
}
@property(nonatomic,nonatomic) NSInteger nsId;
@property(nonatomic,nonatomic) NSInteger peopleId;
@property(nonatomic,nonatomic) NSInteger ntId;
@property(nonatomic,nonatomic) NSInteger spId;
@property(nonatomic,strong) NSString *nsContent;
@property(nonatomic,strong) NSString *nsCreateDate;
@property(nonatomic,strong) NSString *nsRemarkContent;
@property(nonatomic,strong) NSString *nsRemarkPeople;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *nsType;
@property(nonatomic,strong) NSString *nsRemarkTime;
@property(nonatomic,strong) NSString *nsRemarkType;
@end
