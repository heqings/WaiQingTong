//
//  Apply.h
//  Pickers
//
//  Created by air macbook on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//申请实体类
@interface Apply : NSObject{
    NSInteger appId;//申请id
    NSString *appType;//申请类型
    NSString *content;//申请内容
    NSString *handler;//审核人
    NSString *applyTime;//申请时间
    NSString *handlerTime;//审批时间
    NSString *remark;//审批意见
    NSString *status;//当前状态
}
@property(nonatomic,nonatomic) NSInteger appId;
@property(nonatomic,strong) NSString *appType;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *handler;
@property(nonatomic,strong) NSString *applyTime;
@property(nonatomic,strong) NSString *handlerTime;
@property(nonatomic,strong) NSString *remark;
@property(nonatomic,strong) NSString *status;
@end
