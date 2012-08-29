//
//  NotifiInfo.h
//  Pickers
//
//  Created by 张飞 on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息组详情实体类－－语音
@interface NotifyInfo : NSObject{
    NSInteger niId;//id
    NSInteger ntId;//消息组id
    NSInteger peopelId;//联系人id
    NSString *niType;//信息类型
    NSString *niName;//附件名称
    NSString *niPath;//附件路径
    NSString *niStatus;//状态
    NSString *niDate;//创建时间
    NSString *isRead;//是否已读
    NSString *isMySpeaking;//是否是我发的
    NSString *niContent;//文字内容
    NSString *recordTime;//语音时长
}
@property(nonatomic,nonatomic) NSInteger niId;
@property(nonatomic,nonatomic) NSInteger ntId;
@property(nonatomic,nonatomic) NSInteger peopelId;
@property(nonatomic,strong) NSString *niType;
@property(nonatomic,strong) NSString *niName;
@property(nonatomic,strong) NSString *niPath;
@property(nonatomic,strong) NSString *niStatus;
@property(nonatomic,strong) NSString *niDate;
@property(nonatomic,strong) NSString *isRead;
@property(nonatomic,strong) NSString *isMySpeaking;
@property(nonatomic,strong) NSString *niContent;
@property(nonatomic,strong) NSString *recordTime;
@end
