//
//  Global.m
//  Pickers
//
//  Created by 张飞 on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "User.h"
#import "Global.h"

@implementation Global
/******************************* 手机端和服务器端数据通讯的KEY值 **********************************/
static NSString *S2M_KEY = @"GO-TOP-COPY-RIGHT-2011-2012-WAIQINTONG-2";
//圆周率
static double PL=3.141592653589793;

//激活验证
static NSString *OAUTH=@"OAUTH";

//********************************即时消息推送  开始************************************
/*
 * 语音消息
 */
static NSString *AUDIO_MSG = @"AUDIO";
/*
 * 图片消息
 */
static NSString *IMAGE_MSG = @"IMAGE";

/*
 * 文字消息
 */
static NSString *TEXT_MSG = @"TEXT";

/*
 * 视频消息
 */
static NSString *VEDIO_MSG = @"";

/*
 * 表情消息
 */
static NSString *PHIZ_MSG = @"";
//********************************即时消息推送  结束************************************

//********************************工作日志  开始************************************
/*
 * 有新的工作日志待阅读
 */
static NSString *WORKLOG_REQ = @"WORKLOG_REQ";

/*
 * 有新的工作日志批阅到达
 */
static NSString *WORKLOG_REP = @"WORKLOG_REP";
//********************************工作日志  结束************************************

//********************************通知  开始************************************
/*
 * 服务器推送通知
 */
static NSString *NOTIFY = @"NOTIFY";

//********************************通知  结束************************************

//********************************工作任务  开始************************************
/*
 * 新增工作任务推送通知
 */
static NSString *WORKTASK = @"WORKTASK";

//********************************工作任务  结束************************************

//********************************申请  开始************************************
/*
 * 新增申请推送通知
 */
static NSString *AUDIT_REQ = @"AUDIT_REQ";

/*
 * 申请批阅推送通知
 */
static NSString *AUDIT_REP = @"AUDIT_REP";

/*
 * 申请转移
 */
static NSString *AUDIT_DVH = @"AUDIT_DVH";
//********************************申请  结束************************************

//********************************拜访  开始************************************
/*
 * 新增拜访推送通知
 */
static NSString *PLAN_NEW = @"PLAN_NEW";

/*
 * 新增拜访计划领导审核推送通知
 */
static NSString *PLAN_REQ = @"PLAN_REQ";

/*
 * 新增领导审核完拜访推送通知
 */
static NSString *PLAN_REP = @"PLAN_REP";

//********************************拜访  结束************************************


//工作日志
static NSString *NOTIFY_GZRZ = @"NOTIFY_GZRZ";

//工作任务
static NSString *NOTIFY_GZRW = @"NOTIFY_GZRW";

//申请
static NSString *NOTIFY_SQ = @"NOTIFY_SQ";

//拜访
static NSString *NOTIFY_BF = @"NOTIFY_BF";

//语音
static NSString *NOTIFY_YY = @"NOTIFY_YY";

//通知
static NSString *NOTIFY_TZ = @"NOTIFY_TZ";

typedef enum {
	Beijing54,Xian80,WGS84
}GaussSphere;

+(NSString *)getKey{

    return S2M_KEY;
}

+(NSString *)getServerIp{
    return @"new.ydwqt.com";
}

+(int)getServerPort{
    return 7900;
}

+(double)DistanceOfTwoPoints:(double)lng1 lat1:(double)lat1 lng2:(double)lng2 lat2:(double)lat2  gs:(Global*)gs{
    double radLat1 =lat1 * PL/ 180.0;
    double radLat2 =lat2 * PL/ 180.0;
    double a = radLat1 - radLat2;
    double b = lng1 * PL/ 180.0 - lng2 * PL/ 180.0;
    double s = 2 * asin(sqrt(pow(sin(a/2),2) +
                             cos(radLat1) * cos(radLat2) * pow(sin(b/2),2)));
    
    //s = s * (gs == GaussSphere.WGS84 ? 6378137.0 : (gs == Global.Xian80 ? 6378140.0 : 6378245.0));
    s=s*6378245.0;
    s = round(s * 10000) / 10000;
    return s;
}

+(NSString *)getAUDIO_MSG{
    return AUDIO_MSG;
}

+(NSString *)getIMAGE_MSG{
    return IMAGE_MSG;
}

+(NSString *)getTEXT_MSG{
    return TEXT_MSG;
}

+(NSString *)getVEDIO_MSG{
    return VEDIO_MSG;
}

+(NSString *)getPHIZ_MSG{
    return PHIZ_MSG;
}

+(NSString *)getWORKLOG_REQ{
    return WORKLOG_REQ;
}

+(NSString *)getWORKLOG_REP{
    return WORKLOG_REP;
}

+(NSString *)getNOTIFY{
    return NOTIFY;
}

+(NSString *)getWORKTASK{
    return WORKTASK;
}

+(NSString *)getAUDIT_REQ{
    return AUDIT_REQ;
}

+(NSString *)getAUDIT_REP{
    return AUDIT_REP;
}

+(NSString *)getAUDIT_DVH{
    return AUDIT_DVH;
}

+(NSString *)getPLAN_NEW{
    return PLAN_NEW;
}

+(NSString *)getPLAN_REQ{
    return PLAN_REQ;
}

+(NSString *)getPLAN_REP{
    return PLAN_REP;
}

+(NSString *)getOAUTH{
    return OAUTH;
}

+(NSString *)getNOTIFY_GZRZ{
    return NOTIFY_GZRZ;
}

+(NSString *)getNOTIFY_GZRW{
    return NOTIFY_GZRW;
}

+(NSString *)getNOTIFY_SQ{
    return NOTIFY_SQ;
}

+(NSString *)getNOTIFY_BF{
    return NOTIFY_BF;
}

+(NSString *)getNOTIFY_YY{
    return NOTIFY_YY;
}

+(NSString *)getNOTIFY_TZ{
    return NOTIFY_TZ;
}

//截取字符串
+(NSString *)getString:(NSString *)string{
    if(string!=nil){
        NSRange idsRange = NSMakeRange(0,[string length]-1);
        return [[NSString stringWithFormat:@"%@",string] substringWithRange:idsRange];
    }
    return nil;
}

//获取当前年月日 时分秒 日期
+(NSString *)getCurrentTime{
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* temp =  [formatter stringFromDate:nowDate];
    return temp;
}

//nsdata转文件
+(BOOL)writeFile:(NSString *)path writeData:(NSData *)data{
    BOOL isSuccess=[data writeToFile:path atomically:NO];
    return isSuccess;
}

//创建document文件路径
+(NSString *)getDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//录音路径
+(NSString *)getRecordPath{
    return [[Global getDocumentPath] stringByAppendingPathComponent:@"record"];
}

//照片路径
+(NSString *)getImgPath{
    return[[Global getDocumentPath] stringByAppendingPathComponent:@"img"];
}

//把fm和touser的联系人id进行排序
+(NSString *)getSortIdentity:(NSString *)fm toUser:(NSString *)toUser{
    NSMutableArray *nsArray=[[NSMutableArray alloc]init];
    [nsArray addObject:[NSNumber numberWithInteger:[fm intValue]]];
    
    NSArray *toUsers=[toUser componentsSeparatedByString:@"|"];
  
    for(int i=0;i<[toUsers count];i++){
        [nsArray addObject:[NSNumber numberWithInteger:[[toUsers objectAtIndex:i]intValue]]];
    }  
    NSArray* arrayIds = [nsArray sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *identity=[[NSMutableString alloc]init];
    for(int i=0;i<[arrayIds count];i++){
        [identity appendString:[NSString stringWithFormat:@"%@",[arrayIds objectAtIndex:i]]];
    }
    

    NSString* temp = [NSString stringWithFormat:@"%@",identity];
    return temp;
}

+(NSString *)getNotifyType:(NSString *)type{
    if([type isEqualToString:[Global getWORKLOG_REP]]||[type isEqualToString:[Global getWORKLOG_REQ]]){
        return [Global getNOTIFY_GZRZ];//工作日志
    }else if([type isEqualToString:[Global getNOTIFY]]){
        return [Global getNOTIFY_TZ];//通知
    }else if([type isEqualToString:[Global getWORKTASK]]){
        return [Global getNOTIFY_GZRW];//工作任务
    }else if([type isEqualToString:[Global getAUDIT_REP]]||[type isEqualToString:[Global getAUDIT_REQ]]||[type isEqualToString:[Global getAUDIT_DVH]]){
        return [Global getNOTIFY_SQ];//申请
    }else if([type isEqualToString:[Global getPLAN_NEW]]||[type isEqualToString:[Global getPLAN_REP]]||[type isEqualToString:[Global getPLAN_REQ]]){
        return [Global getNOTIFY_BF];//拜访
    }else if([type isEqualToString:[Global getAUDIO_MSG]]||[type isEqualToString:[Global getIMAGE_MSG]]||[type isEqualToString:[Global getTEXT_MSG]]||[type isEqualToString:[Global getVEDIO_MSG]]||[type isEqualToString:[Global getPHIZ_MSG]]){
        return [Global getNOTIFY_YY];//语音
    }
    return @"";
}
+(UIImage*)getUserTopImage:(User*)p
{
    if(![p.topimage isEqualToString:@""])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* fileName= [p.topimage lastPathComponent];
        NSString *strPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        UIImage* image = [UIImage imageWithContentsOfFile:strPath];
        return image;
        
    }else
    {
        UIImage* image = [UIImage imageNamed:@"header70"];
        return image;
    }
}
+(UIImage*)getPeopleTopImage:(People*)p
{
    if(![p.topimg isEqualToString:@""])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* fileName= [p.topimg lastPathComponent];
        NSString *strPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        UIImage* image = [UIImage imageWithContentsOfFile:strPath];
        return image;
        
    }else
    {
        UIImage* image = [UIImage imageNamed:@"header70"];
        return image;
    }
}
//保存图像
+(NSString*)saveImageAsPng:(UIImage*)image 
{
    NSString *strPath;
 
    NSString *strDocPath = [[NSString alloc] initWithString:[Global getImgPath]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:strDocPath attributes:nil];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString *strTime = [myFormatter stringFromDate:[NSDate date]] ;
    NSString *strName = [strTime stringByAppendingString:@".png"];
    strPath= [strDocPath stringByAppendingPathComponent:strName];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:strPath atomically:YES];
    return strPath;
}

//如果传入的字符串是nil,返回""
+(NSString *)getNullString:(NSString*)param{
    if(param==nil)
        return @"";
    else
        return param;
}
@end


