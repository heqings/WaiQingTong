//
//  NotifyGzrzServices.m
//  Pickers
//
//  Created by 张飞 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyGzrzServices.h"

@implementation NotifyGzrzServices
@dynamic dataBase;
static NotifyGzrzServices *conn;

+(NotifyGzrzServices *)getConnection{
    if(conn==nil){
        conn=[[NotifyGzrzServices alloc]init];
    }
    return conn;
}

//推送工作日志
-(void)insertNotifyGzrz:(NSInteger)peopleId ntId:(NSInteger)ntId spId:(NSInteger)spId ngContent:(NSString *)ngContent ngCreateDate:(NSString *)ngCreateDate ngRemarkContent:(NSString *)ngRemarkContent ngRemarkPeople:(NSString *)ngRemarkPeople status:(NSString *)status ngType:(NSString *)ngType{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"insert into notify_gzrz(nt_id,people_id,sp_id,ng_content,ng_createdate,ng_remarkpeople,ng_remarkcontent,status,ng_type,ng_remarkTime)values(%i,%i,%i,'%@','%@','%@','%@','%@','%@','')",ntId,peopleId,spId,ngContent,ngCreateDate,ngRemarkContent,ngRemarkPeople,status,ngType];
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
            NSString *sql=[NSString stringWithFormat:@"select * from notify_gzrz order by ng_id desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int ngId=(int)sqlite3_column_int(stmt, 0);
                    int ntId=(int)sqlite3_column_int(stmt, 1);
                    int peopleId=(int)sqlite3_column_int(stmt, 2);
                    int spId=(int)sqlite3_column_int(stmt, 3);
                    char *ngContent=(char *)sqlite3_column_text(stmt, 4);
                    char *ngCreateDate=(char *)sqlite3_column_text(stmt, 5);
                    char *ngRemarkPeople=(char *)sqlite3_column_text(stmt, 6);
                    char *ngRemarkContent=(char *)sqlite3_column_text(stmt, 7);
                    char *status=(char *)sqlite3_column_text(stmt, 8);
                    char *ngType=(char *)sqlite3_column_text(stmt, 9);
                    char *ngRemarkTime=(char *)sqlite3_column_text(stmt, 10);
                    
                    NotifyGzrz *gzrz=[[NotifyGzrz alloc]init];
                    gzrz.ngId=ngId;
                    gzrz.peopleId=peopleId;
                    gzrz.ntId=ntId;
                    gzrz.spId=spId;
                    if(ngContent!=nil){
                        gzrz.ngContent=[NSString stringWithUTF8String:(const char *)ngContent];
                    }
                    if(ngCreateDate!=nil){
                        gzrz.ngCreateDate=[NSString stringWithUTF8String:(const char *)ngCreateDate];
                    }
                    if(ngRemarkContent!=nil){
                        gzrz.ngRemarkContent=[NSString stringWithUTF8String:(const char *)ngRemarkContent];
                    }
                    if(ngRemarkPeople!=nil){
                        gzrz.ngRemarkPeople=[NSString stringWithUTF8String:(const char *)ngRemarkPeople];
                    }
                    if(status!=nil){
                        gzrz.status=[NSString stringWithUTF8String:(const char *)status];
                    }
                    if(ngType!=nil){
                        gzrz.ngType=[NSString stringWithUTF8String:(const char *)ngType];
                    }
                    if(ngRemarkTime!=nil){
                        gzrz.ngRemarkTime=[NSString stringWithUTF8String:(const char *)ngRemarkTime];
                    }
                    [array addObject:gzrz];
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

-(NotifyGzrz *)findByParam:(NSString *)field param:(NSInteger)param{
    @try {
        NotifyGzrz *gzrz=[[NotifyGzrz alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from notify_gzrz where %@=%i",field,param];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int ngId=(int)sqlite3_column_int(stmt, 0);
                    int ntId=(int)sqlite3_column_int(stmt, 1);
                    int peopleId=(int)sqlite3_column_int(stmt, 2);
                    int spId=(int)sqlite3_column_int(stmt, 3);
                    char *ngContent=(char *)sqlite3_column_text(stmt, 4);
                    char *ngCreateDate=(char *)sqlite3_column_text(stmt, 5);
                    char *ngRemarkContent=(char *)sqlite3_column_text(stmt, 6);
                    char *ngRemarkPeople=(char *)sqlite3_column_text(stmt, 7);
                    char *status=(char *)sqlite3_column_text(stmt, 8);
                    char *ngType=(char *)sqlite3_column_text(stmt, 9);
                    char *ngRemarkTime=(char *)sqlite3_column_text(stmt, 10);

                    gzrz.ngId=ngId;
                    gzrz.peopleId=peopleId;
                    gzrz.ntId=ntId;
                    gzrz.spId=spId;
                    if(ngContent!=nil){
                        gzrz.ngContent=[NSString stringWithUTF8String:(const char *)ngContent];
                    }
                    if(ngCreateDate!=nil){
                        gzrz.ngCreateDate=[NSString stringWithUTF8String:(const char *)ngCreateDate];
                    }
                    if(ngRemarkContent!=nil){
                        gzrz.ngRemarkContent=[NSString stringWithUTF8String:(const char *)ngRemarkContent];
                    }
                    if(ngRemarkPeople!=nil){
                        gzrz.ngRemarkPeople=[NSString stringWithUTF8String:(const char *)ngRemarkPeople];
                    }
                    if(status!=nil){
                        gzrz.status=[NSString stringWithUTF8String:(const char *)status];
                    }
                    if(ngType!=nil){
                        gzrz.ngType=[NSString stringWithUTF8String:(const char *)ngType];
                    }
                    if(ngRemarkTime!=nil){
                        gzrz.ngRemarkTime=[NSString stringWithUTF8String:(const char *)ngRemarkTime];
                    }
                }
                sqlite3_finalize(stmt);
            }
        }
        return gzrz;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(void)updateByParam:(NSInteger)spId ngRemarkContent:(NSString *)ngRemarkContent ngRemarkPeople:(NSString *)ngRemarkPeople status:(NSString *)status ngRemarkTime:(NSString *)ngRemarkTime{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"update notify_gzrz set ng_remarkpeople='%@', ng_remarkcontent='%@', status='%@',ng_remarkTime='%@' where sp_id=%i",ngRemarkPeople,ngRemarkContent,status,ngRemarkTime,spId];
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

-(void)deleteByNtId:(NSInteger)ntId{
    @try{
        [self connDataBase];
        {
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"delete from notify_gzrz where nt_id=%i",ntId];
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
