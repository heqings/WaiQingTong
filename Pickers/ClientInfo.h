//
//  ClientInfo.h
//  Pickers
//
//  Created by 张飞 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//客户联系人实体类
@interface ClientInfo : NSObject{
    NSInteger ciId;//id
    NSInteger cId;//客户表id
    NSInteger spId;//服务器id
    NSString *linkmobile;//联系电话
    NSString *officetel;//办公电话
    NSString *remark;//备注
    NSString *email;//电子邮箱
    NSString *linkname;//联系人
}
@property(nonatomic,nonatomic) NSInteger ciId;
@property(nonatomic,nonatomic) NSInteger cId;
@property(nonatomic,nonatomic) NSInteger spId;
@property(nonatomic,strong) NSString *linkmobile;
@property(nonatomic,strong) NSString *officetel;
@property(nonatomic,strong) NSString *remark;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *linkname;

@end
