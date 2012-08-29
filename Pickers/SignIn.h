//
//  SignIn.h
//  Pickers
//
//  Created by  on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//标注实体类
@interface SignIn : NSObject{
    NSInteger signInId;//标注id
    NSString *signInType;//标注类型
    NSString *signInAddress;//标注地址
    NSString *signInName;//标注名称
    NSString *signInImgUrl;//标注图片，多张图片，中间以,分割
    NSString *signInRemark;//标注描述
    NSString *OLng;//经度
    NSString *OLat;//纬度
    NSString *createTime;//创建时间
}
@property(nonatomic,nonatomic) NSInteger signInId;
@property(nonatomic,strong) NSString *signInType;
@property(nonatomic,strong) NSString *signInAddress;
@property(nonatomic,strong) NSString *signInName;
@property(nonatomic,strong) NSString *signInImgUrl;
@property(nonatomic,strong) NSString *signInRemark;
@property(nonatomic,strong) NSString* OLng;
@property(nonatomic,strong) NSString* OLat;
@property(nonatomic,strong) NSString* createTime;
@end
