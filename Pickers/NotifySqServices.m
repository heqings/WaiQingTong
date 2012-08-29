//
//  NotifySqServices.m
//  Pickers
//
//  Created by 张飞 on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifySqServices.h"

@implementation NotifySqServices
@dynamic dataBase;
static NotifySqServices *conn;

+(NotifySqServices *)getConnection{
    if(conn==nil){
        conn=[[NotifySqServices alloc]init];
    }
    return conn;
}

-(void)insertNotifySq:(NSInteger)peopleId ntId:(NSInteger)ntId spId:(NSInteger)spId nsContent:(NSString *)nsContent nsCreateDate:(NSString *)nsCreateDate nsRemarkPeople:(NSString *)nsRemarkPeople nsRemarkContent:(NSString *)nsRemarkContent status:(NSString *)status nsType:(NSString *)nsType{
    @try {
        [self connDataBase];
        {
            char *error =nil;

            NSString *sql=[NSString stringWithFormat:@"insert into notify_sq(nt_id,people_id,sp_id,ns_content,ns_createDate,ns_remarkPeople,ns_remarkContent,status,ns_type,ns_remarkTime,ns_remarkType)values(%i,%i,%i,'%@','%@','%@','%@','%@','%@','','')",ntId,peopleId,spId,nsContent,nsCreateDate,nsRemarkPeople,nsRemarkContent,status,nsType];
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
            NSString *sql=[NSString stringWithFormat:@"select * from notify_sq order by ns_id desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int nsId=(int)sqlite3_column_int(stmt, 0);
                    int ntId=(int)sqlite3_column_int(stmt, 1);
                    int peopleId=(int)sqlite3_column_int(stmt, 2);
                    int spId=(int)sqlite3_column_int(stmt, 3);
                    char *nsContent=(char *)sqlite3_column_text(stmt, 4);
                    char *nsCreateDate=(char *)sqlite3_column_text(stmt, 5);
                    char *nsRemarkPeople=(char *)sqlite3_column_text(stmt, 6);
                    char *nsRemarkContent=(char *)sqlite3_column_text(stmt, 7);
                    char *status=(char *)sqlite3_column_text(stmt, 8);
                    char *nsType=(char *)sqlite3_column_text(stmt, 9);
                    char *nsRemarkTime=(char *)sqlite3_column_text(stmt, 10);
                    char *nsRemarkType=(char *)sqlite3_column_text(stmt, 11);

                    
                    NotifySq *notifySq=[[NotifySq alloc]init];
                    notifySq.nsId=nsId;
                    notifySq.peopleId=peopleId;
                    notifySq.ntId=ntId;
                    notifySq.spId=spId;
                    if(nsContent!=nil){
                        notifySq.nsContent=[NSString stringWithUTF8String:(const char *)nsContent];
                    }
                    if(nsCreateDate!=nil){
                        notifySq.nsCreateDate=[NSString stringWithUTF8String:(const char *)nsCreateDate];
                    }
                    if(nsRemarkPeople!=nil){
                        notifySq.nsRemarkPeople=[NSString stringWithUTF8String:(const char *)nsRemarkPeople];
                    }
                    if(nsRemarkContent!=nil){
                        notifySq.nsRemarkContent=[NSString stringWithUTF8String:(const char *)nsRemarkContent];
                    }
                    if(status!=nil){
                        notifySq.status=[NSString stringWithUTF8String:(const char *)status];
                    }
                    if(nsType!=nil){
                        notifySq.nsType=[NSString stringWithUTF8String:(const char *)nsType];
                    }
                    if(nsRemarkTime!=nil){
                        notifySq.nsRemarkTime=[NSString stringWithUTF8String:(const char *)nsRemarkTime];
                    }
                    if(nsRemarkType!=nil){
                        notifySq.nsRemarkType=[NSString stringWithUTF8String:(const char *)nsRemarkType];
                    }
                    [array addObject:notifySq];
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

-(NotifySq *)findByParam:(NSString *)field param:(NSInteger)param{
    @try {
        NotifySq *notifySq=[[NotifySq alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from notify_sq where %@=%i",field,param];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    int nsId=(int)sqlite3_column_int(stmt, 0);
                    int ntId=(int)sqlite3_column_int(stmt, 1);
                    int peopleId=(int)sqlite3_column_int(stmt, 2);
                    int spId=(int)sqlite3_column_int(stmt, 3);
                    char *nsContent=(char *)sqlite3_column_text(stmt, 4);
                    char *nsCreateDate=(char *)sqlite3_column_text(stmt, 5);
                    char *nsRemarkPeople=(char *)sqlite3_column_text(stmt, 6);
                    char *nsRemarkContent=(char *)sqlite3_column_text(stmt, 7);
                    char *status=(char *)sqlite3_column_text(stmt, 8);
                    char *nsType=(char *)sqlite3_column_text(stmt, 9);
                    char *nsRemarkTime=(char *)sqlite3_column_text(stmt, 10);
                    char *nsRemarkType=(char *)sqlite3_column_text(stmt, 11);
 
                    notifySq.nsId=nsId;
                    notifySq.peopleId=peopleId;
                    notifySq.ntId=ntId;
                    notifySq.spId=spId;
                    if(nsContent!=nil){
                        notifySq.nsContent=[NSString stringWithUTF8String:(const char *)nsContent];
                    }
                    if(nsCreateDate!=nil){
                        notifySq.nsCreateDate=[NSString stringWithUTF8String:(const char *)nsCreateDate];
                    }
                    if(nsRemarkPeople!=nil){
                        notifySq.nsRemarkPeople=[NSString stringWithUTF8String:(const char *)nsRemarkPeople];
                    }
                    if(nsRemarkContent!=nil){
                        notifySq.nsRemarkContent=[NSString stringWithUTF8String:(const char *)nsRemarkContent];
                    }
                    if(status!=nil){
                        notifySq.status=[NSString stringWithUTF8String:(const char *)status];
                    }
                    if(nsType!=nil){
                        notifySq.nsType=[NSString stringWithUTF8String:(const char *)nsType];
                    }
                    if(nsRemarkTime!=nil){
                        notifySq.nsRemarkTime=[NSString stringWithUTF8String:(const char *)nsRemarkTime];
                    }
                    if(nsRemarkType!=nil){
                        notifySq.nsRemarkType=[NSString stringWithUTF8String:(const char *)nsRemarkType];
                    }
                }
                sqlite3_finalize(stmt);
            }
        }
        return notifySq;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(void)updateByParam:(NSInteger)spId nsRemarkContent:(NSString *)nsRemarkContent nsRemarkPeople:(NSString *)nsRemarkPeople status:(NSString *)status nsRemarkTime:(NSString *)nsRemarkTime nsRemarkType:(NSString *)nsRemarkType{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"update notify_sq set ns_remarkPeople='%@', ns_remarkContent='%@', status='%@',ns_remarkTime='%@',ns_remarkType='%@' where sp_id=%i",nsRemarkPeople,nsRemarkContent,status,nsRemarkTime,nsRemarkType,spId];
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

-(void)deleteById:(NSInteger)spId{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"delete from notify_sq where sp_id=%i",spId];
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
            NSString *sql=[NSString stringWithFormat:@"delete from notify_sq where nt_id=%i",ntId];
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
