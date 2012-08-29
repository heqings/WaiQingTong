//
//  NotifyTzServices.m
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyTzServices.h"

@implementation NotifyTzServices
@dynamic dataBase;
static NotifyTzServices *conn;

+(NotifyTzServices *)getConnection{
    if(conn==nil){
        conn=[[NotifyTzServices alloc]init];
    }
    return conn;
}

//推送通知
-(void)insertNotifyTz:(NSInteger)peopleId ntId:(NSInteger)ntId spId:(NSInteger)spId nteContent:(NSString *)nteContent nteCreateDate:(NSString *)nteCreateDate nteCreateUser:(NSString*)nteCreateUser ntTitle:(NSString *)ntTitle{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"insert into notify_tz(nt_id,people_id,sp_id,nte_content,nte_createDate,nte_createUser,nt_title)values(%i,%i,%i,'%@','%@','%@','%@')",ntId,peopleId,spId,nteContent,nteCreateDate,nteCreateUser,ntTitle];
            
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
            NSString *sql=[NSString stringWithFormat:@"select * from notify_tz order by nte_id desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    int nteId=(int)sqlite3_column_int(stmt, 0);
                    int ntId=(int)sqlite3_column_int(stmt, 1);
                    int peopleId=(int)sqlite3_column_int(stmt, 2);
                    int spId=(int)sqlite3_column_int(stmt, 3);
                    char *nteContent=(char *)sqlite3_column_text(stmt, 4);
                    char *nteCreateDate=(char *)sqlite3_column_text(stmt, 5);
                    char *nteCreateUser=(char *)sqlite3_column_text(stmt, 6);
                    char *ntTitle=(char *)sqlite3_column_text(stmt, 7);
                    
                    
                    NotifyTzE *notifyTzE=[[NotifyTzE alloc]init];
                    notifyTzE.nteId=nteId;
                    notifyTzE.peopleId=peopleId;
                    notifyTzE.ntId=ntId;
                    notifyTzE.spId=spId;
                    if(nteContent!=nil){
                        notifyTzE.nteContent=[NSString stringWithUTF8String:(const char *)nteContent];
                    }
                    if(nteCreateDate!=nil){
                        notifyTzE.nteCreateDate=[NSString stringWithUTF8String:(const char *)nteCreateDate];
                    }
                    if(nteCreateUser!=nil){
                        notifyTzE.nteCreateUser=[NSString stringWithUTF8String:(const char *)nteCreateUser];
                    }
                    if(ntTitle!=nil){
                        notifyTzE.ntTitle=[NSString stringWithUTF8String:(const char *)ntTitle];
                    }
                    [array addObject:notifyTzE];
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
            NSString *sql=[NSString stringWithFormat:@"delete from notify_tz where nt_id=%i",ntId];
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
