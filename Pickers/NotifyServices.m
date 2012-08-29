//
//  NotifyServices.m
//  Pickers
//
//  Created by 张飞 on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyServices.h"

@implementation NotifyServices
@dynamic dataBase;
static NotifyServices *conn;

+(NotifyServices *)getConnection{
    if(conn==nil){
        conn=[[NotifyServices alloc]init];
    }
    return conn;
}


//消息信息表保存
-(void)insertNotify:(NSString *)ntTitle isRead:(NSString *)isRead readCount:(NSInteger)readCount ntDate:(NSString *)ntDate toUser:(NSString *)toUser groupId:(NSString *)groupId ntType:(NSString*)ntType detailText:(NSString *)detailText{
    @try {
        [self connDataBase];
        {
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"insert into notifycation_table(nt_title,is_read,read_count,nt_date,to_user,group_id,nt_type,detail_text)values('%@','%@',%i,'%@','%@','%@','%@','%@')",ntTitle,isRead,readCount,ntDate,toUser,groupId,ntType,detailText];
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

//消息信息表根据id删除
-(void)deleteById:(NSInteger)ntId{
    @try{
        [self connDataBase];
        {
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"delete from notifycation_table where nt_id=%i",ntId];
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

//查询出所有的通知纪录
-(NSMutableArray *)findAll{
    @try {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [self connDataBase]; 
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from notifycation_table order by nt_date desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int ntId=(int)sqlite3_column_int(stmt, 0);
                    char *ntTitle=(char *)sqlite3_column_text(stmt, 1);
                    char *isRead=(char *)sqlite3_column_text(stmt, 2);
                    int readCount=(int)sqlite3_column_int(stmt, 3);
                    char *ntDate=(char *)sqlite3_column_text(stmt, 4);
                    char *toUser=(char *)sqlite3_column_text(stmt, 5);
                    char *groupId=(char *)sqlite3_column_text(stmt, 6);
                    char *ntType=(char *)sqlite3_column_text(stmt, 7);
                    char *detailText=(char *)sqlite3_column_text(stmt, 8);
                    

                    Notify *notify=[[Notify alloc]init];
                    notify.ntId=ntId;
                    notify.readCount=readCount;
                    if(ntTitle!=nil){
                        notify.ntTitle=[NSString stringWithUTF8String:(const char *)ntTitle];
                    }
                    if(isRead!=nil){
                        notify.isRead=[NSString stringWithUTF8String:(const char *)isRead];
                    }
                    if(ntDate!=nil){
                        notify.ntDate=[NSString stringWithUTF8String:(const char *)ntDate];
                    }
                    if(toUser!=nil){
                        notify.toUser=[NSString stringWithUTF8String:(const char *)toUser];
                    }
                    if(groupId!=nil){
                        notify.groupId=[NSString stringWithUTF8String:(const char *)groupId];
                    }
                    if(ntType!=nil){
                        notify.ntType=[NSString stringWithUTF8String:(const char *)ntType];
                    }
                    if(detailText!=nil){
                        notify.detailText=[NSString stringWithUTF8String:(const char *)detailText];
                    }
                    [array addObject:notify];
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

-(void)updateById:(NSInteger)ntId readCount:(NSInteger)readCount detailText:(NSString*)detailText ntDate:(NSString*)ntDate{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"update notifycation_table set read_count=%i,nt_date='%@',detail_text='%@' where nt_id =%i ",readCount,ntDate,detailText,ntId];
        int count=sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error);    

        if(error !=nil)
        {
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(void)updateById:(NSInteger)ntId readCount:(NSInteger)readCount{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"update notifycation_table set read_count=%i where nt_id =%i ",readCount,ntId];
        int count=sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error);    

        if(error !=nil)
        {
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(Notify *)findById:(NSInteger)ntId{
    @try {
        Notify *notify=[[Notify alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from notifycation_table where nt_id=%i order by nt_date desc",ntId];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    int ntId=(int)sqlite3_column_int(stmt, 0);
                    char *ntTitle=(char *)sqlite3_column_text(stmt, 1);
                    char *isRead=(char *)sqlite3_column_text(stmt, 2);
                    int readCount=(int)sqlite3_column_int(stmt, 3);
                    char *ntDate=(char *)sqlite3_column_text(stmt, 4);
                    char *toUser=(char *)sqlite3_column_text(stmt, 5);
                    char *groupId=(char *)sqlite3_column_text(stmt, 6);
                    char *ntType=(char *)sqlite3_column_text(stmt, 7);
                    char *detailText=(char *)sqlite3_column_text(stmt, 8);
                    
                    notify.ntId=ntId;
                    notify.readCount=readCount;
                    if(ntTitle!=nil){
                        notify.ntTitle=[NSString stringWithUTF8String:(const char *)ntTitle];
                    }
                    if(isRead!=nil){
                        notify.isRead=[NSString stringWithUTF8String:(const char *)isRead];
                    }
                    if(ntDate!=nil){
                        notify.ntDate=[NSString stringWithUTF8String:(const char *)ntDate];
                    }
                    if(toUser!=nil){
                        notify.toUser=[NSString stringWithUTF8String:(const char *)toUser];
                    }
                    if(groupId!=nil){
                        notify.groupId=[NSString stringWithUTF8String:(const char *)groupId];
                    }
                    if(ntType!=nil){
                        notify.ntType=[NSString stringWithUTF8String:(const char *)ntType];
                    }
                    if(detailText!=nil){
                        notify.detailText=[NSString stringWithUTF8String:(const char *)detailText];
                    }
                }
                sqlite3_finalize(stmt);
            }
        }
        return notify;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(Notify *)findByGroup:(NSString *)groupId{
    @try {
         Notify *notify = nil;
                [self connDataBase];
        {     
           
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from notifycation_table where group_id='%@'",groupId];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                     notify=[[Notify alloc]init];

                    int ntId=(int)sqlite3_column_int(stmt, 0);
                    char *ntTitle=(char *)sqlite3_column_text(stmt, 1);
                    char *isRead=(char *)sqlite3_column_text(stmt, 2);
                    int readCount=(int)sqlite3_column_int(stmt, 3);
                    char *ntDate=(char *)sqlite3_column_text(stmt, 4);
                    char *toUser=(char *)sqlite3_column_text(stmt, 5);
                    char *groupId=(char *)sqlite3_column_text(stmt, 6);
                    char *ntType=(char *)sqlite3_column_text(stmt, 7);
                    char *detailText=(char *)sqlite3_column_text(stmt, 8);
                    
                    
                    notify.ntId=ntId;
                    notify.readCount=readCount;
                    if(ntTitle!=nil){
                        notify.ntTitle=[NSString stringWithUTF8String:(const char *)ntTitle];
                    }
                    if(isRead!=nil){
                        notify.isRead=[NSString stringWithUTF8String:(const char *)isRead];
                    }
                    if(ntDate!=nil){
                        notify.ntDate=[NSString stringWithUTF8String:(const char *)ntDate];
                    }
                    if(toUser!=nil){
                        notify.toUser=[NSString stringWithUTF8String:(const char *)toUser];
                    }
                    if(groupId!=nil){
                        notify.groupId=[NSString stringWithUTF8String:(const char *)groupId];
                    }
                    if(ntType!=nil){
                        notify.ntType=[NSString stringWithUTF8String:(const char *)ntType];
                    }
                    if(detailText!=nil){
                        notify.detailText=[NSString stringWithUTF8String:(const char *)detailText];
                    }
                    
                }
                sqlite3_finalize(stmt);
            }
        }
        return notify;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(Notify *)findByParam:(NSString *)field param:(NSString *)param{
    @try {
        Notify *notify=[[Notify alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from notifycation_table where %@='%@'",field,param];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    int ntId=(int)sqlite3_column_int(stmt, 0);
                    char *ntTitle=(char *)sqlite3_column_text(stmt, 1);
                    char *isRead=(char *)sqlite3_column_text(stmt, 2);
                    int readCount=(int)sqlite3_column_int(stmt, 3);
                    char *ntDate=(char *)sqlite3_column_text(stmt, 4);
                    char *toUser=(char *)sqlite3_column_text(stmt, 5);
                    char *groupId=(char *)sqlite3_column_text(stmt, 6);
                    char *ntType=(char *)sqlite3_column_text(stmt, 7);
                    char *detailText=(char *)sqlite3_column_text(stmt, 8);
                    
                    notify.ntId=ntId;
                    notify.readCount=readCount;
                    if(ntTitle!=nil){
                        notify.ntTitle=[NSString stringWithUTF8String:(const char *)ntTitle];
                    }
                    if(isRead!=nil){
                        notify.isRead=[NSString stringWithUTF8String:(const char *)isRead];
                    }
                    if(ntDate!=nil){
                        notify.ntDate=[NSString stringWithUTF8String:(const char *)ntDate];
                    }
                    if(toUser!=nil){
                        notify.toUser=[NSString stringWithUTF8String:(const char *)toUser];
                    }
                    if(groupId!=nil){
                        notify.groupId=[NSString stringWithUTF8String:(const char *)groupId];
                    }
                    if(ntType!=nil){
                        notify.ntType=[NSString stringWithUTF8String:(const char *)ntType];
                    }
                    if(detailText!=nil){
                        notify.detailText=[NSString stringWithUTF8String:(const char *)detailText];
                    }
                    
                }
                sqlite3_finalize(stmt);
            }
        }
        return notify;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(void)updateDetailText:(NSString *)detailText type:(NSString*)type{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"update notifycation_table set detail_text='%@' where nt_type ='%@' ",detailText,type];
        int count=sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error);    

        if(error !=nil)
        {
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(void)updateToUser:(NSInteger)ntId toUser:(NSString*)toUser{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"update notifycation_table set to_user='%@' where nt_id =%i ",toUser,ntId];

        int count=sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error);    

        if(error !=nil)
        {
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
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
