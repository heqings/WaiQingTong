//
//  NotifyPlanServices.m
//  Pickers
//
//  Created by 张飞 on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyPlanServices.h"

@implementation NotifyPlanServices
@dynamic dataBase;
static NotifyPlanServices *conn;

+(NotifyPlanServices *)getConnection{
    if(conn==nil){
        conn=[[NotifyPlanServices alloc]init];
    }
    return conn;
}
-(void)clearAll
{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"delete from notify_plan"];
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
-(void)insertNotifyPlan:(NotifyPlanE *)notifyPlanE{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"insert into notify_plan(nt_id,sp_id,np_content,create_date,create_user,end_time,start_time,handler_name,handler_id)values(%i,%i,'%@','%@','%@','%@','%@','%@',%i)",notifyPlanE.ntId,notifyPlanE.spId,notifyPlanE.npContent,notifyPlanE.createDate,notifyPlanE.createUser,notifyPlanE.endTime,notifyPlanE.startTime,notifyPlanE.handlerName,notifyPlanE.handlerId];
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
            NSString *sql=[NSString stringWithFormat:@"select * from notify_plan order by np_id desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int npId=(int)sqlite3_column_int(stmt, 0);
                    int ntId=(int)sqlite3_column_int(stmt, 1);
                    int spId=(int)sqlite3_column_int(stmt, 2);
                    char *npContent=(char *)sqlite3_column_text(stmt, 3);
                    char *createDate=(char *)sqlite3_column_text(stmt, 4);
                    char *createUser=(char *)sqlite3_column_text(stmt, 5);
                    char *endTime=(char *)sqlite3_column_text(stmt, 6);
                    char *startTime=(char *)sqlite3_column_text(stmt, 7);
                    char *handlerName=(char *)sqlite3_column_text(stmt, 8);
                    int handlerId=(int)sqlite3_column_int(stmt, 9);
  
                    
                    NotifyPlanE *notifyPlanE=[[NotifyPlanE alloc]init];
                    notifyPlanE.npId=npId;
                    notifyPlanE.ntId=ntId;
                    notifyPlanE.spId=spId;
                    notifyPlanE.handlerId=handlerId;
                    if(npContent!=nil){
                        notifyPlanE.npContent=[NSString stringWithUTF8String:(const char *)npContent];
                    }
                    if(createDate!=nil){
                        notifyPlanE.createDate=[NSString stringWithUTF8String:(const char *)createDate];
                    }
                    if(endTime!=nil){
                        notifyPlanE.endTime=[NSString stringWithUTF8String:(const char *)endTime];
                    }
                    if(startTime!=nil){
                        notifyPlanE.startTime=[NSString stringWithUTF8String:(const char *)startTime];
                    }
                    if(createUser!=nil){
                        notifyPlanE.createUser=[NSString stringWithUTF8String:(const char *)createUser];
                    }
                    if(handlerName!=nil){
                        notifyPlanE.handlerName=[NSString stringWithUTF8String:(const char *)handlerName];
                    }
                    [array addObject:notifyPlanE];
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

-(NotifyPlanE *)findBySpId:(NSInteger)spId{
    @try {
       NotifyPlanE *notifyPlanE=[[NotifyPlanE alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from notify_plan where sp_id=%i",spId];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int npId=(int)sqlite3_column_int(stmt, 0);
                    int ntId=(int)sqlite3_column_int(stmt, 1);
                    int spId=(int)sqlite3_column_int(stmt, 2);
                    char *npContent=(char *)sqlite3_column_text(stmt, 3);
                    char *createDate=(char *)sqlite3_column_text(stmt, 4);
                    int createUser=(int)sqlite3_column_int(stmt, 5);
                    char *endTime=(char *)sqlite3_column_text(stmt, 6);
                    char *startTime=(char *)sqlite3_column_text(stmt, 7);
                    char *handlerName=(char *)sqlite3_column_text(stmt, 8);
                    int handlerId=(int)sqlite3_column_int(stmt, 9);
                    
                    notifyPlanE.npId=npId;
                    notifyPlanE.ntId=ntId;
                    notifyPlanE.spId=spId;
                    notifyPlanE.handlerId=handlerId;
                    if(npContent!=nil){
                        notifyPlanE.npContent=[NSString stringWithUTF8String:(const char *)npContent];
                    }
                    if(createDate!=nil){
                        notifyPlanE.createDate=[NSString stringWithUTF8String:(const char *)createDate];
                    }
                    if(endTime!=nil){
                        notifyPlanE.endTime=[NSString stringWithUTF8String:(const char *)endTime];
                    }
                    if(startTime!=nil){
                        notifyPlanE.startTime=[NSString stringWithUTF8String:(const char *)startTime];
                    }
                    if(createUser!=nil){
                        notifyPlanE.createUser=[NSString stringWithUTF8String:(const char *)createUser];
                    }
                    if(handlerName!=nil){
                        notifyPlanE.handlerName=[NSString stringWithUTF8String:(const char *)handlerName];
                    }
                }
                sqlite3_finalize(stmt);
            }
        }
        return notifyPlanE;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}
@end
