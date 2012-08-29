//
//  ApplyServices.m
//  Pickers
//
//  Created by air macbook on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ApplyServices.h"
@implementation ApplyServices
@dynamic dataBase;
static ApplyServices *conn;

+(ApplyServices *)getConnection{
    if(conn==nil){
        conn=[[ApplyServices alloc]init];
    }
    return conn;
}

//我的申请插入
-(void)insertApply:(NSString *)type content:(NSString *)content applyTime:(NSString *)applytime status:(NSString *)status{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"insert into t_apply(apply_type,apply_content,apply_time,status)values('%@','%@','%@','%@')",type,content,applytime,status];
            
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

//根据id值删除申请
-(void)deleteById:(NSInteger)appId{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"delete from t_apply where apply_id=%i",appId];
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
        @throw  exception;
    }
    @finally {
         sqlite3_close(dataBase);
    }
   
}

//查询出所有的申请
-(NSMutableArray *)findAll{
    @try {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from t_apply order by apply_id desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int appId=(int )sqlite3_column_int(stmt, 0);
                    char *appType=(char *)sqlite3_column_text(stmt, 1);
                    char *content=(char *)sqlite3_column_text(stmt, 2);
                    char *handler=(char *)sqlite3_column_text(stmt, 3);
                    char *applyTime=(char *)sqlite3_column_text(stmt, 4);
                    char *handlerTime=(char *)sqlite3_column_text(stmt, 5);
                    char *remark=(char *)sqlite3_column_text(stmt, 6);
                    char *status=(char *)sqlite3_column_text(stmt, 7);
                    
                    
                    Apply *qpply=[[Apply alloc]init];
                    qpply.appId=appId;
                    if(appType!=nil){
                        qpply.appType=[NSString stringWithUTF8String:(const char *)appType];
                    }
                    if(content!=nil){
                        qpply.content=[NSString stringWithUTF8String:(const char *)content];
                    }
                    if(handler!=nil){
                        qpply.handler=[NSString stringWithUTF8String:(const char *)handler];
                    }
                    if(applyTime!=nil){
                        qpply.applyTime=[NSString stringWithUTF8String:(const char *)applyTime];
                    }
                    if(handlerTime!=nil){
                        qpply.handlerTime=[NSString stringWithUTF8String:(const char *)handlerTime];
                    }
                    if(remark!=nil){
                        qpply.remark=[NSString stringWithUTF8String:(const char *)remark];
                    }
                    if(status!=nil){
                        qpply.status=[NSString stringWithUTF8String:(const char *)status];
                    }
                    
                    [array addObject:qpply];
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
