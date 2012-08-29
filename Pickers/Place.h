//
//  Place.h
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//位置查询实体类
@interface Place : NSObject{
    NSInteger pId;//id
    NSInteger spId;//终端服务器id
    NSString *imei;//imei
    NSString *namePinyin;//名字拼音
    NSString *topimg;//头像
    NSString *type;//性别
    NSString *email;//电子邮箱
    NSString *nicke;//昵称
    NSString *name;//名称
    NSString *nickPinyin;//昵称拼音
    NSString *mobile;//电话
    NSString *groupPy;//拼音分组
    NSString *groupDp;//部门分组
}
@property(nonatomic,nonatomic) NSInteger pId;
@property(nonatomic,nonatomic) NSInteger spId;
@property(nonatomic,strong) NSString *imei;
@property(nonatomic,strong) NSString *namePinyin;
@property(nonatomic,strong) NSString *topimg;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *nicke;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *nickPinyin;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *groupPy;
@property(nonatomic,strong) NSString *groupDp;
@end
