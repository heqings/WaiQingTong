//
//  NotifyPoiServices.m
//  Pickers
//
//  Created by 张飞 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyPoiServices.h"

@implementation NotifyPoiServices
@dynamic dataBase;
static NotifyPoiServices *conn;

+(NotifyPoiServices *)getConnection{
    if(conn==nil){
        conn=[[NotifyPoiServices alloc]init];
    }

    return conn;
}
-(void)cleanAll
{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"delete from notify_poi"];
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


-(void)insertNotify:(NotifyPoi*)poi{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"insert into notify_poi(np_id,sp_id,poi_name,poi_address,poi_imgUrl,start_time,end_time,is_finish)values(%i,%i,'%@','%@','%@','%@','%@','%@')",poi.npId,poi.spId,poi.poiName,poi.poiAddress,poi.poiImgUrl,poi.startTime,poi.endTime,poi.isFinish];
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
            NSString *sql=[NSString stringWithFormat:@"select * from notify_poi order by np_id desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int poiId=(int)sqlite3_column_int(stmt, 0);
                    int npId=(int)sqlite3_column_int(stmt, 1);
                    int spId=(int)sqlite3_column_int(stmt, 2);
                    char *poiAddress=(char *)sqlite3_column_text(stmt, 3);
                    char *poiName=(char *)sqlite3_column_text(stmt, 4);
                    char *poiImgUrl=(char *)sqlite3_column_text(stmt, 5);
                    char *startTime=(char *)sqlite3_column_text(stmt, 6);
                    char *endTime=(char *)sqlite3_column_text(stmt, 7);
                    char *isFinish=(char *)sqlite3_column_text(stmt, 8);
                    
                    NotifyPoi *poi=[[NotifyPoi alloc]init];
                    poi.poiId=poiId;
                    poi.npId=npId;
                    poi.spId=spId;
                    
                    if(poiAddress!=nil){
                        poi.poiAddress=[NSString stringWithUTF8String:(const char *)poiAddress];
                    }
                    if(poiName!=nil){
                        poi.poiName=[NSString stringWithUTF8String:(const char *)poiName];
                    }
                    if(poiImgUrl!=nil){
                        poi.poiImgUrl=[NSString stringWithUTF8String:(const char *)poiImgUrl];
                    }
                    if(startTime!=nil){
                        poi.startTime=[NSString stringWithUTF8String:(const char *)startTime];
                    }
                    if(endTime!=nil){
                        poi.endTime=[NSString stringWithUTF8String:(const char *)endTime];
                    }
                    if(isFinish!=nil){
                        poi.isFinish=[NSString stringWithUTF8String:(const char *)isFinish];
                    }
                    [array addObject:poi];
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

-(NSMutableArray *)findByFinish:(NSString *)isFinish npId:(NSInteger)npId{
    @try {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from notify_poi where is_finish='%@' and np_id=%i order by np_id desc",isFinish,npId];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int poiId=(int)sqlite3_column_int(stmt, 0);
                    int npId=(int)sqlite3_column_int(stmt, 1);
                    int spId=(int)sqlite3_column_int(stmt, 2);
                    char *poiAddress=(char *)sqlite3_column_text(stmt, 3);
                    char *poiName=(char *)sqlite3_column_text(stmt, 4);
                    char *poiImgUrl=(char *)sqlite3_column_text(stmt, 5);
                    char *startTime=(char *)sqlite3_column_text(stmt, 6);
                    char *endTime=(char *)sqlite3_column_text(stmt, 7);
                    char *isFinish=(char *)sqlite3_column_text(stmt, 8);
                    
                    NotifyPoi *poi=[[NotifyPoi alloc]init];
                    poi.poiId=poiId;
                    poi.npId=npId;
                    poi.spId=spId;
                    
                    if(poiAddress!=nil){
                        poi.poiAddress=[NSString stringWithUTF8String:(const char *)poiAddress];
                    }
                    if(poiName!=nil){
                        poi.poiName=[NSString stringWithUTF8String:(const char *)poiName];
                    }
                    if(poiImgUrl!=nil){
                        poi.poiImgUrl=[NSString stringWithUTF8String:(const char *)poiImgUrl];
                    }
                    if(startTime!=nil){
                        poi.startTime=[NSString stringWithUTF8String:(const char *)startTime];
                    }
                    if(endTime!=nil){
                        poi.endTime=[NSString stringWithUTF8String:(const char *)endTime];
                    }
                    if(isFinish!=nil){
                        poi.isFinish=[NSString stringWithUTF8String:(const char *)isFinish];
                    }
                    [array addObject:poi];
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

-(void)updatePoiByStartTime:(NSInteger)spId isFinish:(NSString *)isFinish startTime:(NSString*)startTime{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            
            NSString *sql=[NSString stringWithFormat:@"update notify_poi set start_time='%@' where sp_id=%i and is_finish='%@'" ,startTime,spId,isFinish];
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

-(void)updatePoiByEndTime:(NSInteger)spId isFinish:(NSString *)isFinish endTime:(NSString*)endTime{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            
            NSString *sql=[NSString stringWithFormat:@"update notify_poi set is_finish='%@',end_time='%@' where sp_id=%i and is_finish='N' ",isFinish,endTime,spId];
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
@end
