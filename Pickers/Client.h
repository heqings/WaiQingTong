//
//  Client.h
//  Pickers
//
//  Created by 张飞 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//客户实体类
@interface Client : NSObject{
    NSInteger cId;//id
    NSInteger customId;//服务器id
    NSString *faxphone;//传真号码
    NSString *email;//电子邮箱
    NSString *address;//地址
    NSString *name;//名称
    NSString *namePinyin;//名称拼音
    NSString *uri;//公司网址
    NSString *telphone;//电话
    NSString *createtime;//创建时间
    NSString *groupPy;//拼音分组
    
}
@property(nonatomic,nonatomic) NSInteger cId;
@property(nonatomic,nonatomic) NSInteger customId;
@property(nonatomic,strong) NSString *faxphone;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *namePinyin;
@property(nonatomic,strong) NSString *uri;
@property(nonatomic,strong) NSString *telphone;
@property(nonatomic,strong) NSString *createtime;
@property(nonatomic,strong) NSString *groupPy;

@end
