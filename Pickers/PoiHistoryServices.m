//
//  PoiHistoryServices.m
//  Pickers
//
//  Created by 张飞 on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PoiHistoryServices.h"

@implementation PoiHistoryServices
@dynamic dataBase;
static PoiHistoryServices *conn;

+(PoiHistoryServices *)getConnection{
    if(conn==nil){
        conn=[[PoiHistoryServices alloc]init];
    }
    return conn;
}

-(void)insertPoiInfo:(PoiHistory *)info{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"insert into poi_history(sp_id,poi_name,poi_type,poi_address,poi_imgUrl,sl_id,o_lat,o_lng,create_time,end_time,is_finish)values(%i,'%@','%@','%@','%@',%i,'%f','%f','%@','%@','%@')",info.spId,info.poiName,info.poiType,info.poiAddress,info.poiImgUrl,info.slId,info.OLat,info.OLng,info.createTime,info.endTime,info.isFinish];
            int count=sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error);    
            if(error !=nil)
            {
                NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                                   [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                        userInfo:nil];
                @throw e;
                
            }
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(void)updatePoiInfo:(NSInteger)spId endTime:(NSString *)endTime isFinish:(NSString*)isFinish{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"update poi_history set end_time='%@',is_finish='%@' where sp_id=%i",endTime,isFinish,spId];
            int count=sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error);    
            if(error !=nil)
            {
                NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                                   [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                        userInfo:nil];
                @throw e;
                
            }
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(NSMutableArray *)findAll{
    @try {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from poi_history order by create_time desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int piId=(int)sqlite3_column_int(stmt, 0);
                    int spId=(int)sqlite3_column_int(stmt, 1);
                    char *poiName=(char *)sqlite3_column_text(stmt, 2);
                    char *poiType=(char *)sqlite3_column_text(stmt, 3);
                    char *poiAddress=(char *)sqlite3_column_text(stmt, 4);
                    char *poiImgUrl=(char *)sqlite3_column_text(stmt, 5);
                    int slId=(int)sqlite3_column_int(stmt, 6);
                    double OLat=(float)sqlite3_column_double(stmt, 7);
                    double OLng=(float)sqlite3_column_double(stmt, 8);  
                    char *createTime=(char *)sqlite3_column_text(stmt, 9);
                    char *endTime=(char *)sqlite3_column_text(stmt, 10);
                    char *isFinish=(char *)sqlite3_column_text(stmt, 11);
                    
                    PoiHistory *poiInfo=[[PoiHistory alloc]init];
                    
                    poiInfo.piId=piId;
                    poiInfo.spId=spId; 
                    poiInfo.slId=slId;
                    poiInfo.OLat=OLat;
                    poiInfo.OLng=OLng;
                    if(poiName!=nil){
                        poiInfo.poiName=[NSString stringWithUTF8String:(const char *)poiName];
                    }
                    if(poiType!=nil){
                        poiInfo.poiType=[NSString stringWithUTF8String:(const char *)poiType];
                    }
                    if(poiAddress!=nil){
                        poiInfo.poiAddress=[NSString stringWithUTF8String:(const char *)poiAddress];
                    }
                    if(poiImgUrl!=nil){
                        poiInfo.poiImgUrl=[NSString stringWithUTF8String:(const char *)poiImgUrl];
                    }
                    if(createTime!=nil){
                        poiInfo.createTime=[NSString stringWithUTF8String:(const char *)createTime];
                    }
                    if(endTime!=nil){
                        poiInfo.endTime=[NSString stringWithUTF8String:(const char *)endTime];
                    }
                    if(isFinish!=nil){
                        poiInfo.isFinish=[NSString stringWithUTF8String:(const char *)isFinish];
                    }
                    [array addObject:poiInfo];
                }
                sqlite3_finalize(stmt);
            }
        }
        
        return array;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}
@end
