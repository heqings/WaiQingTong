//
//  NotifyInfoServices.m
//  Pickers
//
//  Created by 张飞 on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyInfoServices.h"

@implementation NotifyInfoServices
@dynamic dataBase;
static NotifyInfoServices *conn;

+(NotifyInfoServices *)getConnection{
    if(conn==nil){
        conn=[[NotifyInfoServices alloc]init];
    }
    return conn;
}

-(void)insertNotifyInfo:(NSInteger)ntId peopelId:(NSInteger)peopelId niType:(NSString *)niType niName:(NSString *)niName niPath:(NSString *)niPath niStatus:(NSString *)niStatus niDate:(NSString *)niDate isRead:(NSString *)isRead isMySpeaking:(NSString *)isMySpeaking niContent:(NSString *)niContent recordTime:(NSString *)recordTime{
    @try {
        [self connDataBase];
        { 
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"insert into notifycation_info(nt_id,peopel_id,ni_type,ni_name,ni_path,ni_status,ni_date,is_read,is_myspeaking,ni_content,record_time)values(%i,%i,'%@','%@','%@','%@','%@','%@','%@','%@','%@')",ntId,peopelId,niType,niName,niPath,niStatus,niDate,isRead,isMySpeaking,niContent,recordTime];
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

-(NSMutableArray *)findAll:(NSInteger)ntId{
    @try {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from notifycation_info where nt_id=%i order by ni_date asc",ntId];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int niId=(int)sqlite3_column_int(stmt, 0);
                    int ntId=(int)sqlite3_column_int(stmt, 1);
                    int peopelId=(int)sqlite3_column_int(stmt, 2);
                    char *niType=(char *)sqlite3_column_text(stmt, 3);
                    char *niName=(char *)sqlite3_column_text(stmt, 4);
                    char *niPath=(char *)sqlite3_column_text(stmt, 5);
                    char *niStatus=(char *)sqlite3_column_text(stmt, 6);
                    char *niDate=(char *)sqlite3_column_text(stmt, 7);
                    char *isRead=(char *)sqlite3_column_text(stmt, 8);
                    char *isMySpeaking=(char *)sqlite3_column_text(stmt, 9);
                    char *niContent=(char *)sqlite3_column_text(stmt, 10);
                    char *recordTime=(char *)sqlite3_column_text(stmt, 11);
                    
                    NotifyInfo *notifyInfo=[[NotifyInfo alloc]init];
                    notifyInfo.niId=niId;
                    notifyInfo.ntId=ntId;
                    notifyInfo.peopelId=peopelId;
                    if(niType!=nil){
                        notifyInfo.niType=[NSString stringWithUTF8String:(const char *)niType];
                    }
                    if(niName!=nil){
                        notifyInfo.niName=[NSString stringWithUTF8String:(const char *)niName];
                    }
                    if(niPath!=nil){
                        notifyInfo.niPath=[NSString stringWithUTF8String:(const char *)niPath];
                    }
                    if(niStatus!=nil){
                        notifyInfo.niStatus=[NSString stringWithUTF8String:(const char *)niStatus];
                    }
                    if(niDate!=nil){
                        notifyInfo.niDate=[NSString stringWithUTF8String:(const char *)niDate];
                    }
                    if(isRead!=nil){
                        notifyInfo.isRead=[NSString stringWithUTF8String:(const char *)isRead];
                    }
                    if(isMySpeaking!=nil){
                        notifyInfo.isMySpeaking=[NSString stringWithUTF8String:(const char *)isMySpeaking];
                    }
                    if(niContent!=nil){
                        notifyInfo.niContent=[NSString stringWithUTF8String:(const char *)niContent];
                    }
                    if(recordTime!=nil){
                        notifyInfo.recordTime=[NSString stringWithUTF8String:(const char *)recordTime];
                    }
                    [array addObject:notifyInfo];
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

-(void)deleteByNtId:(NSInteger)ntId{
    @try{
        [self connDataBase];
        {
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"delete from notifycation_info where nt_id=%i",ntId];
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
