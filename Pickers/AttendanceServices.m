//
//  AttendanceServices.m
//  Pickers
//
//  Created by air macbook on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AttendanceServices.h"
@implementation AttendanceServices

@dynamic dataBase;
static AttendanceServices *conn;

+(AttendanceServices *)getConnection{
    if(conn==nil){
        conn=[[AttendanceServices alloc]init];
    }
    return conn;
}
-(void)insertAttendance:(NSString *)createtime address:(NSString *)address
{
    @try {
        [self connDataBase];
        char *error=nil;
       
        NSString *sql=[NSString stringWithFormat:@"insert into t_attendance(create_time,address)values('%@','%@')",createtime,address];
        int count=sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error);
        if(error!=nil)
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

-(void)deleteById:(NSInteger *)attId
{
    @try {
        [self connDataBase];
        char *error = nil;
        NSString *sql=[NSString stringWithFormat:@"delete from t_attendance where att_id=%d",attId];
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

//查询出所有签到信息
-(NSMutableArray *)findAll{
  
    @try {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [self connDataBase];
        
        sqlite3_stmt *stmt;
        NSString *sql=[NSString stringWithFormat:@"select * from t_attendance order by att_id desc"];
        if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                
                int *attId=(int *)sqlite3_column_int(stmt, 0);
                char *name=(char *)sqlite3_column_text(stmt, 1);
                char *address=(char *)sqlite3_column_text(stmt, 2);
                
                Attendance *attendance=[[Attendance alloc]init];
                attendance.attId=attId;
                if(name!=nil){
                    attendance.createtime=[NSString stringWithUTF8String:(const char *)name];
                }
                if(address!=nil){
                    attendance.address=[NSString stringWithUTF8String:(const char *)address];
                }
                [array addObject:attendance];
            }
            sqlite3_finalize(stmt);
        }else{
            const char* error=sqlite3_errmsg(dataBase);
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
            
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
