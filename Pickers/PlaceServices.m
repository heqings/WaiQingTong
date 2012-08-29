//
//  PlaceServices.m
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceServices.h"

@implementation PlaceServices
@dynamic dataBase;
static PlaceServices *conn;

+(PlaceServices *)getConnection{
    if(conn==nil){
        conn=[[PlaceServices alloc]init];
    }
    return conn;
}

//查询位置联系人保存
-(void)insertPlace:(Place*)p
{
    @try {
        [self connDataBase];
        { 
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"insert into place_search(sp_id,imei,name_pinyin,name,nicke,nick_pinyin,topimg,type,email,mobile,group_py,group_dp)values(%i,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",p.spId,p.imei,p.namePinyin,p.name,p.nicke,p.nickPinyin,p.topimg,p.type,p.email,p.mobile,p.groupPy,p.groupDp];
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
            NSString *sql=[NSString stringWithFormat:@"select * from place_search order by group_py asc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int pId=(int)sqlite3_column_int(stmt, 0);
                    int spId=(int)sqlite3_column_int(stmt, 1);
                    char *imei=(char *)sqlite3_column_text(stmt, 2);
                    char *namePinyin=(char *)sqlite3_column_text(stmt, 3);
                    char *name=(char *)sqlite3_column_text(stmt, 4);
                    char *nicke=(char *)sqlite3_column_text(stmt, 5);
                    char *nickPinyin=(char *)sqlite3_column_text(stmt, 6);
                    char *topimg=(char *)sqlite3_column_text(stmt, 7);
                    char *type=(char *)sqlite3_column_text(stmt, 8);
                    char *email=(char *)sqlite3_column_text(stmt, 9);
                    char *mobile=(char *)sqlite3_column_text(stmt, 10);
                    char *groupPy=(char *)sqlite3_column_text(stmt, 11);
                    char *groupDp=(char *)sqlite3_column_text(stmt, 12);
                    
                    Place *place=[[Place alloc]init];
                    place.pId=pId;
                    place.spId=spId;
                    
                    if(imei!=nil){
                        place.imei=[NSString stringWithUTF8String:(const char *)imei];
                    }
                    if(namePinyin!=nil){
                        place.namePinyin=[NSString stringWithUTF8String:(const char *)namePinyin];
                    }
                    if(topimg!=nil){
                        place.topimg=[NSString stringWithUTF8String:(const char *)topimg];
                    }
                    if(type!=nil){
                        place.type=[NSString stringWithUTF8String:(const char *)type];
                    }
                    if(email!=nil){
                        place.email=[NSString stringWithUTF8String:(const char *)email];
                    }
                    if(nicke!=nil){
                        place.nicke=[NSString stringWithUTF8String:(const char *)nicke];
                    }
                    if(name!=nil){
                        place.name=[NSString stringWithUTF8String:(const char *)name];
                    }
                    if(nickPinyin!=nil){
                        place.nickPinyin=[NSString stringWithUTF8String:(const char *)nickPinyin];
                    }
                    if(mobile!=nil){
                        place.mobile=[NSString stringWithUTF8String:(const char *)mobile];
                    }
                    if(groupPy!=nil){
                        place.groupPy=[NSString stringWithUTF8String:(const char *)groupPy];
                    }
                    if(groupDp!=nil){
                        place.groupDp=[NSString stringWithUTF8String:(const char *)groupDp];
                    }
                    [array addObject:place];
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

//"删除位置查询联系人
-(void)clearPlace{
    @try {
        [self connDataBase];
        { 
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"delete from place_search"];
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
