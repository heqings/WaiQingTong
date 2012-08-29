//
//  User.h
//  Pickers
//
//  Created by 张飞 on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//用户实体类
@interface User : NSObject<NSCoding>{
    int userId;
    int  qyId;
    int  modified;
    NSString *mobile;
    NSString *email;
    NSString *nicke;
    NSString *name;
    NSString *pwd;
    NSString *imei;
    NSString *token;
    NSString *sex;
    NSString *area;
    NSString *autograph;
    NSString *topimage;
    
}
@property(nonatomic,nonatomic)int userId;
@property(nonatomic,nonatomic)int qyId;
@property(nonatomic,nonatomic)int modified;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *nicke;
@property(nonatomic,strong)NSString *pwd;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)NSString *topimage;
@property(nonatomic,strong)NSString *autograph;
@property(nonatomic,strong)NSString *imei;

@end
