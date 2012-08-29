//
//  ClientInfoServices.m
//  Pickers
//
//  Created by 张飞 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientInfoServices.h"

@implementation ClientInfoServices
@dynamic dataBase;
static ClientInfoServices *conn;

+(ClientInfoServices *)getConnection{
    if(conn==nil){
        conn=[[ClientInfoServices alloc]init];
    }
    return conn;
}

-(void)insertClientInfo:(ClientInfo *)info{
    @try {
        [self connDataBase];
        { 
            char *error=nil;
           
            NSString *sql=[NSString stringWithFormat:@"insert into client_info(c_id,sp_id,linkmobile,linkname,officetel,c_remark,c_email)values(%i,%i,'%@','%@','%@','%@','%@')",info.cId,info.spId,info.linkmobile,info.linkname,info.officetel,info.remark,info.email];
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
            NSString *sql=[NSString stringWithFormat:@"select * from client_info order by ci_id asc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int ciId=(int)sqlite3_column_int(stmt, 0);
                    int cId=(int)sqlite3_column_int(stmt, 1);
                    int spId=(int)sqlite3_column_int(stmt, 2);
                    char *linkmobile=(char *)sqlite3_column_text(stmt, 3);
                    char *linkname=(char *)sqlite3_column_text(stmt, 4);
                    char *officetel=(char *)sqlite3_column_text(stmt, 5);
                    char *remark=(char *)sqlite3_column_text(stmt, 6);
                    char *email=(char *)sqlite3_column_text(stmt, 7);
                                       
                    ClientInfo *info=[[ClientInfo alloc]init];
                    info.ciId=ciId;
                    info.cId=cId;
                    info.spId=spId;
                    
                    if(linkmobile!=nil){
                        info.linkmobile=[NSString stringWithUTF8String:(const char *)linkmobile];
                    }
                    if(linkname!=nil){
                        info.linkname=[NSString stringWithUTF8String:(const char *)linkname];
                    }
                    if(officetel!=nil){
                        info.officetel=[NSString stringWithUTF8String:(const char *)officetel];
                    }
                    if(remark!=nil){
                        info.remark=[NSString stringWithUTF8String:(const char *)remark];
                    }
                    if(email!=nil){
                        info.email=[NSString stringWithUTF8String:(const char *)email];
                    }
                    
                    [array addObject:info];
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

-(void)clearClientInfo{
    @try {
        [self connDataBase];
        { 
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"delete from client_info"];
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

-(NSMutableArray *)findByCId:(NSInteger)cId{
    @try {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from client_info where c_id=%i order by ci_id asc",cId];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int ciId=(int)sqlite3_column_int(stmt, 0);
                    int cId=(int)sqlite3_column_int(stmt, 1);
                    int spId=(int)sqlite3_column_int(stmt, 2);
                    char *linkmobile=(char *)sqlite3_column_text(stmt, 3);
                    char *linkname=(char *)sqlite3_column_text(stmt, 4);
                    char *officetel=(char *)sqlite3_column_text(stmt, 5);
                    char *remark=(char *)sqlite3_column_text(stmt, 6);
                    char *email=(char *)sqlite3_column_text(stmt, 7);
                    
                    ClientInfo *info=[[ClientInfo alloc]init];
                    info.ciId=ciId;
                    info.cId=cId;
                    info.spId=spId;
                    
                    if(linkmobile!=nil){
                        info.linkmobile=[NSString stringWithUTF8String:(const char *)linkmobile];
                    }
                    if(linkname!=nil){
                        info.linkname=[NSString stringWithUTF8String:(const char *)linkname];
                    }
                    if(officetel!=nil){
                        info.officetel=[NSString stringWithUTF8String:(const char *)officetel];
                    }
                    if(remark!=nil){
                        info.remark=[NSString stringWithUTF8String:(const char *)remark];
                    }
                    if(email!=nil){
                        info.email=[NSString stringWithUTF8String:(const char *)email];
                    }
                    
                    [array addObject:info];
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
