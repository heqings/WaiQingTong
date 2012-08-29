//
//  NotifyGzrwServices.m
//  Pickers
//
//  Created by 张飞 on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyGzrwServices.h"

@implementation NotifyGzrwServices
@dynamic dataBase;
static NotifyGzrwServices *conn;

+(NotifyGzrwServices *)getConnection{
    if(conn==nil){
        conn=[[NotifyGzrwServices alloc]init];
    }
    return conn;
}

-(void)insertNotifySq:(NSInteger)peopleId ntId:(NSInteger)ntId spId:(NSInteger)spId ngTitle:(NSString *)ngTitle ngContent:(NSString *)ngContent ngCreateDate:(NSString *)ngCreateDate ngLevel:(NSString *)ngLevel status:(NSString *)status finishTime:(NSString *)finishTime createUser:(NSString *)createUser remarkUser:(NSString *)remarkUser remarkContent:(NSString *)remarkContent{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"insert into notify_gzrw(nt_id,people_id,sp_id,ng_title,ng_content,ng_createDate,finish_time,ng_level,status,create_user,remark_user,remark_content,rl_time)values(%i,%i,%i,'%@','%@','%@','%@','%@','%@','%@','%@','%@','')",ntId,peopleId,spId,ngTitle,ngContent,ngCreateDate,finishTime,ngLevel,status,createUser,remarkUser,remarkContent];
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
            NSString *sql=[NSString stringWithFormat:@"select * from notify_gzrw order by ng_id desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {

                    int ngId=(int)sqlite3_column_int(stmt, 0);
                    int ntId=(int)sqlite3_column_int(stmt, 1);
                    int peopleId=(int)sqlite3_column_int(stmt, 2);
                    int spId=(int)sqlite3_column_int(stmt, 3);
                    char *ngTitle=(char *)sqlite3_column_text(stmt, 4);
                    char *ngContent=(char *)sqlite3_column_text(stmt, 5);
                    char *ngCreateDate=(char *)sqlite3_column_text(stmt, 6);
                    char *finishTime=(char *)sqlite3_column_text(stmt, 7);
                    char *ngLevel=(char *)sqlite3_column_text(stmt, 8);
                    char *status=(char *)sqlite3_column_text(stmt, 9);
                    char *createUser=(char *)sqlite3_column_text(stmt, 10);
                    char *remarkUser=(char *)sqlite3_column_text(stmt, 11);
                    char *remarkContent=(char *)sqlite3_column_text(stmt, 12);
                    char *rlTime=(char *)sqlite3_column_text(stmt, 13);
                    
                    
                    NotifyGzrw *notifyGzrw=[[NotifyGzrw alloc]init];
                    notifyGzrw.ngId=ngId;
                    notifyGzrw.peopleId=peopleId;
                    notifyGzrw.ntId=ntId;
                    notifyGzrw.spId=spId;
                    if(ngTitle!=nil){
                        notifyGzrw.ngTitle=[NSString stringWithUTF8String:(const char *)ngTitle];
                    }
                    if(ngContent!=nil){
                        notifyGzrw.ngContent=[NSString stringWithUTF8String:(const char *)ngContent];
                    }
                    if(ngCreateDate!=nil){
                        notifyGzrw.ngCreateDate=[NSString stringWithUTF8String:(const char *)ngCreateDate];
                    }
                    if(finishTime!=nil){
                        notifyGzrw.finishTime=[NSString stringWithUTF8String:(const char *)finishTime];
                    }
                    if(ngLevel!=nil){
                        notifyGzrw.ngLevel=[NSString stringWithUTF8String:(const char *)ngLevel];
                    }
                    if(status!=nil){
                        notifyGzrw.status=[NSString stringWithUTF8String:(const char *)status];
                    }
                    if(createUser!=nil){
                        notifyGzrw.createUser=[NSString stringWithUTF8String:(const char *)createUser];
                    }
                    if(remarkUser!=nil){
                        notifyGzrw.remarkUser=[NSString stringWithUTF8String:(const char *)remarkUser];
                    }
                    if(remarkContent!=nil){
                        notifyGzrw.remarkContent=[NSString stringWithUTF8String:(const char *)remarkContent];
                    }
                    if(rlTime!=nil){
                        notifyGzrw.rlTime=[NSString stringWithUTF8String:(const char *)rlTime];
                    }
                    [array addObject:notifyGzrw];
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

-(void)updateByParam:(NSInteger)spId rlTime:(NSString *)rlTime status:(NSString *)status{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"update notify_gzrw set rl_time='%@',status='%@' where sp_id=%i",rlTime,status,spId];
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

-(void)updateByParam:(NSInteger)spId remarkUser:(NSString *)remarkUser remarkContent:(NSString *)remarkContent status:(NSString *)status{
    @try {
        [self connDataBase];
        {
            char *error =nil;

            NSString *sql=[NSString stringWithFormat:@"update notify_gzrw set remark_user='%@',remark_content='%@',status='%@' where sp_id=%i",remarkUser,remarkContent,status,spId];
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
            NSString *sql=[NSString stringWithFormat:@"delete from notify_gzrw where nt_id=%i",ntId];
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
