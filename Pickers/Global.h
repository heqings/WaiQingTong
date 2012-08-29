//
//  Global.h
//  Pickers
//
//  Created by 张飞 on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "People.h"
@interface Global : NSObject

+(NSString *)getKey;

+(double)DistanceOfTwoPoints:(double)lng1 lat1:(double)lat1 lng2:(double)lng2 lat2:(double)lat2  gs:(Global*)gs;

+(NSString *)getServerIp;

+(int)getServerPort;

+(NSString *)getAUDIO_MSG;

+(NSString *)getIMAGE_MSG;

+(NSString *)getTEXT_MSG;

+(NSString *)getVEDIO_MSG;

+(NSString *)getPHIZ_MSG;

+(NSString *)getWORKLOG_REQ;

+(NSString *)getWORKLOG_REP;

+(NSString *)getNOTIFY;

+(NSString *)getWORKTASK;

+(NSString *)getAUDIT_REQ;

+(NSString *)getAUDIT_REP;

+(NSString *)getAUDIT_DVH;

+(NSString *)getPLAN_NEW;

+(NSString *)getPLAN_REQ;

+(NSString *)getPLAN_REP;

+(NSString *)getOAUTH;

+(NSString *)getNOTIFY_GZRZ;

+(NSString *)getNOTIFY_GZRW;

+(NSString *)getNOTIFY_SQ;

+(NSString *)getNOTIFY_BF;

+(NSString *)getNOTIFY_YY;

+(NSString *)getNOTIFY_TZ;

+(NSString *)getString:(NSString *)string;

+(NSString *)getCurrentTime;

+(BOOL)writeFile:(NSString *)path writeData:(NSData *)data;

+(NSString *)getDocumentPath;

+(NSString *)getRecordPath;

+(NSString *)getImgPath;

+(NSString *)getSortIdentity:(NSString *)fm toUser:(NSString *)toUser;

+(NSString *)getNotifyType:(NSString *)type;

+(UIImage*)getPeopleTopImage:(People*)p;
+(UIImage*)getUserTopImage:(User*)p;
+(NSString*)saveImageAsPng:(UIImage*)image;

+(NSString *)getNullString:(NSString*)param;
@end
