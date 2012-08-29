//
//  Notify.h
//  Pickers
//
//  Created by air macbook on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息组实体类
@interface Notify : NSObject{
    NSInteger ntId;//id
    NSString *ntTitle;//消息组标题
    NSString *isRead;//是否阅读
    NSInteger readCount;//待阅读条数
    NSString *ntDate;//创建时间
    NSString *toUser;//发送给谁
    NSString *groupId;//消息组id,用发送人和被发送人id排序后组合
    NSString *ntType;//消息组类型
    NSString *detailText;//消息组下描述信息
}
@property(nonatomic,nonatomic) NSInteger ntId;
@property(nonatomic,strong) NSString *ntTitle;
@property(nonatomic,strong) NSString *isRead;
@property(nonatomic,nonatomic) NSInteger readCount;
@property(nonatomic,strong) NSString *ntDate;
@property(nonatomic,strong) NSString *toUser;
@property(nonatomic,strong) NSString *groupId;
@property(nonatomic,strong) NSString *ntType;
@property(nonatomic,strong) NSString *detailText;
@end
