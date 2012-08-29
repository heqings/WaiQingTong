//
//  NotifyPoi.h
//  Pickers
//
//  Created by 张飞 on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息组详情实体类－－拜访poi
@interface NotifyPoi : NSObject{
    NSInteger poiId;//id
    NSInteger npId;//消息组拜访的id
    NSInteger spId;//服务器id
    NSString *poiAddress;//地址
    NSString *poiName;//名称
    NSString *poiImgUrl;//图片地址
    NSString *startTime;//开始时间
    NSString *endTime;//结束时间
    NSString *isFinish;//是否完成
}
@property(nonatomic,nonatomic) NSInteger poiId;
@property(nonatomic,nonatomic) NSInteger npId;
@property(nonatomic,nonatomic) NSInteger spId;
@property(nonatomic,strong) NSString *poiAddress;
@property(nonatomic,strong) NSString *poiName;
@property(nonatomic,strong) NSString *poiImgUrl;
@property(nonatomic,strong) NSString *startTime;
@property(nonatomic,strong) NSString *endTime;
@property(nonatomic,strong) NSString *isFinish;
@end
