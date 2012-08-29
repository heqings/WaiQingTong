//
//  WorkLogServices.m
//  Pickers
//
//  Created by air macbook on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WorkLogServices.h"

@implementation WorkLogServices
@dynamic dataBase;
static WorkLogServices *conn;

+(WorkLogServices *)getConnection{
    if(conn==nil){
        conn=[[WorkLogServices alloc]init];
    }
    return conn;
}

//工作计划插入
-(void)insertWorkLog:(NSString *)type content:(NSString *)content startTime:(NSString *)starttime endTime:(NSString *)endtime createTime:(NSString *)createtime{
    @try {
        [self connDataBase];
        {
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"insert into t_work_log(work_type,work_content,start_time,end_time,create_time)values('%@','%@','%@','%@','%@')",type,content,starttime,endtime,createtime];
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

//根据id值删除工作计划
-(void)deleteById:(NSInteger *)workId{
    @try{
        [self connDataBase];
        {
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"delete from t_work_log where work_id=%d",workId];
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

//查询出所有工作计划
-(NSMutableArray *)findAll{
    sqlite3_stmt *stmt;
    @try {
        
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [self connDataBase];
        {     
            
            NSString *sql=[NSString stringWithFormat:@"select * from t_work_log order by work_id desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    int *workId=(int *)sqlite3_column_int(stmt, 0);
                    char *type=(char *)sqlite3_column_text(stmt, 1);
                    char *content=(char *)sqlite3_column_text(stmt, 2);
                    char *startTime=(char *)sqlite3_column_text(stmt, 3);
                    char *endTime=(char *)sqlite3_column_text(stmt, 4);
                    char *createTime=(char *)sqlite3_column_text(stmt, 5);
                    
                    WorkLog *workLog=[[WorkLog alloc]init];
                    workLog.workId=workId;
                    if(type!=nil){
                        workLog.type=[NSString stringWithUTF8String:(const char *)type];
                    }
                    if(content!=nil){
                        workLog.content=[NSString stringWithUTF8String:(const char *)content];
                    }
                    if(startTime!=nil){
                        workLog.startTime=[NSString stringWithUTF8String:(const char *)startTime];
                    }
                    if(endTime!=nil){
                        workLog.endTime=[NSString stringWithUTF8String:(const char *)endTime];
                    }
                    if(createTime!=nil){
                        workLog.createTime=[NSString stringWithUTF8String:(const char *)createTime];
                    }
                    [array addObject:workLog];
                }
                sqlite3_finalize(stmt);
            }else
            {
                const char* error=sqlite3_errmsg(dataBase);
                NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                                   [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                        userInfo:nil];
                @throw e;
            }
        }
        
        return array;
        
    }
    @catch (NSException *exception) {
        @throw  exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}
@end
