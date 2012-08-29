//
//  PoiHistory.h
//  Pickers
//
//  Created by 张飞 on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//poi历史实体类
@interface PoiHistory : NSObject{
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
    NSString *isFinish;//是否完成
}
@property(nonatomic,nonatomic) NSInteger piId;
@property(nonatomic,nonatomic) NSInteger spId;
@property(nonatomic,retain) NSString *poiType;
@property(nonatomic,retain) NSString *poiAddress;
@property(nonatomic,retain) NSString *poiName;
@property(nonatomic,retain) NSString *poiImgUrl;
@property(nonatomic,nonatomic) NSInteger slId;
@property(nonatomic,nonatomic) double OLng;
@property(nonatomic,nonatomic) double OLat;
@property(nonatomic,retain) NSString *createTime;
@property(nonatomic,retain) NSString *endTime;
@property(nonatomic,retain) NSString *isFinish;
@end
