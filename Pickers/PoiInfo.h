//
//  PoiInfo.h
//  Pickers
//
//  Created by 张飞 on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//poi实体类
@interface PoiInfo : NSObject{
    NSInteger piId;//poi表id
    NSInteger spId;//服务器id
    NSString *poiType;//poil类型
    NSString *poiAddress;//地址
    NSString *poiName;//名称
    NSString *poiImgUrl;//图片
    NSInteger slId;//标注后服务器id
    double OLng;//经度
    double OLat;//纬度
    NSString *createTime;//开始时间
    NSString *endTime;//结束时间
}
@property(nonatomic,nonatomic) NSInteger piId;
@property(nonatomic,nonatomic) NSInteger spId;
@property(nonatomic,strong) NSString *poiType;
@property(nonatomic,strong) NSString *poiAddress;
@property(nonatomic,strong) NSString *poiName;
@property(nonatomic,strong) NSString *poiImgUrl;
@property(nonatomic,nonatomic) NSInteger slId;
@property(nonatomic,nonatomic) double OLng;
@property(nonatomic,nonatomic) double OLat;
@property(nonatomic,strong) NSString *createTime;
@property(nonatomic,strong) NSString *endTime;
@end
