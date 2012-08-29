//
//  ClientServices.m
//  Pickers
//
//  Created by 张飞 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientServices.h"

@implementation ClientServices
@dynamic dataBase;
static ClientServices *conn;

+(ClientServices *)getConnection{
    if(conn==nil){
        conn=[[ClientServices alloc]init];
    }
    return conn;
}

-(void)insertClient:(Client*)client{
    @try {
        [self connDataBase];
        { 
            char *error=nil;
            
            NSString *sql=[NSString stringWithFormat:@"insert into client_table(custom_id,faxphone,c_email,c_address,c_name,name_pinyin,uri,telphone,create_time,group_py)values(%i,'%@','%@','%@','%@','%@','%@','%@','%@','%@')",client.customId,client.faxphone,client.email,client.address,client.name,client.namePinyin,client.uri,client.telphone,client.createtime,client.groupPy];
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
            NSString *sql=[NSString stringWithFormat:@"select * from client_table order by group_py asc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int cId=(int)sqlite3_column_int(stmt, 0);
                    int customId=(int)sqlite3_column_int(stmt, 1);
                    char *faxphone=(char *)sqlite3_column_text(stmt, 2);
                    char *email=(char *)sqlite3_column_text(stmt, 3);
                    char *address=(char *)sqlite3_column_text(stmt, 4);
                    char *name=(char *)sqlite3_column_text(stmt, 5);
                    char *namePinyin=(char *)sqlite3_column_text(stmt, 6);
                    char *uri=(char *)sqlite3_column_text(stmt, 7);
                    char *telphone=(char *)sqlite3_column_text(stmt, 8);
                    char *createtime=(char *)sqlite3_column_text(stmt, 9);
                    char *groupPy=(char *)sqlite3_column_text(stmt, 10);
                    
                    Client *client=[[Client alloc]init];
                    client.cId=cId;
                    client.customId=customId;
                    
                    if(faxphone!=nil){
                        client.faxphone=[NSString stringWithUTF8String:(const char *)faxphone];
                    }
                    if(namePinyin!=nil){
                        client.namePinyin=[NSString stringWithUTF8String:(const char *)namePinyin];
                    }
                    if(email!=nil){
                        client.email=[NSString stringWithUTF8String:(const char *)email];
                    }
                    if(address!=nil){
                        client.address=[NSString stringWithUTF8String:(const char *)address];
                    }
                    if(name!=nil){
                        client.name=[NSString stringWithUTF8String:(const char *)name];
                    }
                    if(namePinyin!=nil){
                        client.namePinyin=[NSString stringWithUTF8String:(const char *)namePinyin];
                    }
                    if(uri!=nil){
                        client.uri=[NSString stringWithUTF8String:(const char *)uri];
                    }
                    if(telphone!=nil){
                        client.telphone=[NSString stringWithUTF8String:(const char *)telphone];
                    }
                    if(createtime!=nil){
                        client.createtime=[NSString stringWithUTF8String:(const char *)createtime];
                    }
                    if(groupPy!=nil){
                        client.groupPy=[NSString stringWithUTF8String:(const char *)groupPy];
                    }
                 
                    [array addObject:client];
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

-(Client *)findByCustomId:(NSInteger)customId{
    @try {
        Client *client=[[Client alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from client_table where custom_id=%i",customId];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int cId=(int)sqlite3_column_int(stmt, 0);
                    int customId=(int)sqlite3_column_int(stmt, 1);
                    char *faxphone=(char *)sqlite3_column_text(stmt, 2);
                    char *email=(char *)sqlite3_column_text(stmt, 3);
                    char *address=(char *)sqlite3_column_text(stmt, 4);
                    char *name=(char *)sqlite3_column_text(stmt, 5);
                    char *namePinyin=(char *)sqlite3_column_text(stmt, 6);
                    char *uri=(char *)sqlite3_column_text(stmt, 7);
                    char *telphone=(char *)sqlite3_column_text(stmt, 8);
                    char *createtime=(char *)sqlite3_column_text(stmt, 9);
                    char *groupPy=(char *)sqlite3_column_text(stmt, 10);
                    
                    
                    client.cId=cId;
                    client.customId=customId;
                    
                    if(faxphone!=nil){
                        client.faxphone=[NSString stringWithUTF8String:(const char *)faxphone];
                    }
                    if(namePinyin!=nil){
                        client.namePinyin=[NSString stringWithUTF8String:(const char *)namePinyin];
                    }
                    if(email!=nil){
                        client.email=[NSString stringWithUTF8String:(const char *)email];
                    }
                    if(address!=nil){
                        client.address=[NSString stringWithUTF8String:(const char *)address];
                    }
                    if(name!=nil){
                        client.name=[NSString stringWithUTF8String:(const char *)name];
                    }
                    if(namePinyin!=nil){
                        client.namePinyin=[NSString stringWithUTF8String:(const char *)namePinyin];
                    }
                    if(uri!=nil){
                        client.uri=[NSString stringWithUTF8String:(const char *)uri];
                    }
                    if(telphone!=nil){
                        client.telphone=[NSString stringWithUTF8String:(const char *)telphone];
                    }
                    if(createtime!=nil){
                        client.createtime=[NSString stringWithUTF8String:(const char *)createtime];
                    }
                    if(groupPy!=nil){
                        client.groupPy=[NSString stringWithUTF8String:(const char *)groupPy];
                    }
           
                }
                sqlite3_finalize(stmt);
            }
        }
        
        return client;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(void)clearClient{
    @try {
        [self connDataBase];
        { 
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"delete from client_table"];
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
