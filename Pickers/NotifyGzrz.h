//
//  NotifiGzrz.h
//  Pickers
//
//  Created by 张飞 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息组详情实体类－－工作日志
@interface NotifyGzrz : NSObject{
    NSInteger ngId;//id
    NSInteger peopleId;//联系人id
    NSInteger ntId;//消息组id
    NSInteger spId;//服务器id
    NSString *ngContent;//内容
    NSString *ngCreateDate;//创建时间
    NSString *ngRemarkContent;//回复内容
    NSString *ngRemarkPeople;//回复人
    NSString *status;//状态
    NSString *ngType;//类型
    NSString *ngRemarkTime;//回复时间
}
@property(nonatomic,nonatomic) NSInteger ngId;
@property(nonatomic,nonatomic) NSInteger ntId;
@property(nonatomic,nonatomic) NSInteger peopleId;
@property(nonatomic,nonatomic) NSInteger spId;
@property(nonatomic,strong) NSString *ngContent;
@property(nonatomic,strong) NSString *ngCreateDate;
@property(nonatomic,strong) NSString *ngRemarkContent;
@property(nonatomic,strong) NSString *ngRemarkPeople;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *ngType;
@property(nonatomic,strong) NSString *ngRemarkTime;
@end
