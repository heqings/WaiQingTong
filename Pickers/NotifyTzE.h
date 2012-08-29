//
//  NotifyTzE.h
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息组详情实体类－－通知
@interface NotifyTzE : NSObject{
    NSInteger nteId;//id
    NSInteger peopleId;//联系人id
    NSInteger ntId;//消息组id
    NSInteger spId;//服务器id
    NSString *nteCreateDate;//创建时间
    NSString *nteContent;//内容
    NSString *nteCreateUser;//创建人
    NSString *ntTitle;//标题

}
@property(nonatomic,nonatomic) NSInteger nteId;
@property(nonatomic,nonatomic) NSInteger peopleId;
@property(nonatomic,nonatomic) NSInteger ntId;
@property(nonatomic,nonatomic) NSInteger spId;
@property(nonatomic,strong) NSString *nteCreateDate;
@property(nonatomic,strong) NSString *nteContent;
@property(nonatomic,strong) NSString *nteCreateUser;
@property(nonatomic,strong) NSString *ntTitle;
@end
