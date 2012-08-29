//
//  PeopleServices.m
//  Pickers
//
//  Created by 张飞 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PeopleServices.h"

@implementation PeopleServices
@dynamic dataBase;
static PeopleServices *conn;

+(PeopleServices *)getConnection{
    if(conn==nil){
        conn=[[PeopleServices alloc]init];
    }
    return conn;
}
-(void)clearPeople
{
    @try {
        [self connDataBase];
        { 
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"delete from t_people"];
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
//联系人保存
-(void)insertPeople:(People*)p
{
    @try {
        [self connDataBase];
        { 
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"insert into t_people(sp_id,imei,name_pinyin,name,nicke,nick_pinyin,topimg,type,email,mobile,group_py,group_dp)values(%i,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",p.spId,p.imei,p.namePinyin,p.name,p.nicke,p.nickPinyin,p.topimg,p.type,p.email,p.mobile,p.groupPy,p.groupDp];
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

-(void)deleteById:(NSInteger)pId{
    @try{
        [self connDataBase];
        {
            char *error=nil;
            NSString *sql=[NSString stringWithFormat:@"delete from notification_table where p_id=%d",pId];
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
            NSString *sql=[NSString stringWithFormat:@"select * from t_people order by group_py asc"];
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

                    People *people=[[People alloc]init];
                    people.pId=pId;
                    people.spId=spId;

                    if(imei!=nil){
                        people.imei=[NSString stringWithUTF8String:(const char *)imei];
                    }
                    if(namePinyin!=nil){
                        people.namePinyin=[NSString stringWithUTF8String:(const char *)namePinyin];
                    }
                    if(topimg!=nil){
                        people.topimg=[NSString stringWithUTF8String:(const char *)topimg];
                    }
                    if(type!=nil){
                        people.type=[NSString stringWithUTF8String:(const char *)type];
                    }
                    if(email!=nil){
                        people.email=[NSString stringWithUTF8String:(const char *)email];
                    }
                    if(nicke!=nil){
                        people.nicke=[NSString stringWithUTF8String:(const char *)nicke];
                    }
                    if(name!=nil){
                        people.name=[NSString stringWithUTF8String:(const char *)name];
                    }
                    if(nickPinyin!=nil){
                        people.nickPinyin=[NSString stringWithUTF8String:(const char *)nickPinyin];
                    }
                    if(mobile!=nil){
                        people.mobile=[NSString stringWithUTF8String:(const char *)mobile];
                    }
                    if(groupPy!=nil){
                        people.groupPy=[NSString stringWithUTF8String:(const char *)groupPy];
                    }
                    if(groupDp!=nil){
                        people.groupDp=[NSString stringWithUTF8String:(const char *)groupDp];
                    }
                    [array addObject:people];
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

-(People *)findByMobile:(NSString *)mobile{
    @try {
        People *people=[[People alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from t_people where mobile='%@'",mobile];
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
                    
                    people.pId=pId;
                    people.spId=spId;
                    
                    if(imei!=nil){
                        people.imei=[NSString stringWithUTF8String:(const char *)imei];
                    }
                    if(namePinyin!=nil){
                        people.namePinyin=[NSString stringWithUTF8String:(const char *)namePinyin];
                    }
                    if(topimg!=nil){
                        people.topimg=[NSString stringWithUTF8String:(const char *)topimg];
                    }
                    if(type!=nil){
                        people.type=[NSString stringWithUTF8String:(const char *)type];
                    }
                    if(email!=nil){
                        people.email=[NSString stringWithUTF8String:(const char *)email];
                    }
                    if(nicke!=nil){
                        people.nicke=[NSString stringWithUTF8String:(const char *)nicke];
                    }
                    if(name!=nil){
                        people.name=[NSString stringWithUTF8String:(const char *)name];
                    }
                    if(nickPinyin!=nil){
                        people.nickPinyin=[NSString stringWithUTF8String:(const char *)nickPinyin];
                    }
                    if(mobile!=nil){
                        people.mobile=[NSString stringWithUTF8String:(const char *)mobile];
                    }
                    if(groupPy!=nil){
                        people.groupPy=[NSString stringWithUTF8String:(const char *)groupPy];
                    }
                    if(groupDp!=nil){
                        people.groupDp=[NSString stringWithUTF8String:(const char *)groupDp];
                    }
                }
                sqlite3_finalize(stmt);
            }
        }
        
        return people;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(NSInteger)findCount{
    @try {
        int count=0;
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select count(*) from t_people"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {                    
                    count=(int)sqlite3_column_int(stmt, 0);
                }
                sqlite3_finalize(stmt);
            }
        }
        return count;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(People *)findBySpId:(NSInteger)pId{
    @try {
        People *people = [[People alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from t_people where sp_id=%i",pId];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                     people=[[People alloc]init];
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
                    
                    people.pId=pId;
                    people.spId=spId;
                    
                    if(imei!=nil){
                        people.imei=[NSString stringWithUTF8String:(const char *)imei];
                    }
                    if(namePinyin!=nil){
                        people.namePinyin=[NSString stringWithUTF8String:(const char *)namePinyin];
                    }
                    if(topimg!=nil){
                        people.topimg=[NSString stringWithUTF8String:(const char *)topimg];
                    }
                    if(type!=nil){
                        people.type=[NSString stringWithUTF8String:(const char *)type];
                    }
                    if(email!=nil){
                        people.email=[NSString stringWithUTF8String:(const char *)email];
                    }
                    if(nicke!=nil){
                        people.nicke=[NSString stringWithUTF8String:(const char *)nicke];
                    }
                    if(name!=nil){
                        people.name=[NSString stringWithUTF8String:(const char *)name];
                    }
                    if(nickPinyin!=nil){
                        people.nickPinyin=[NSString stringWithUTF8String:(const char *)nickPinyin];
                    }
                    if(mobile!=nil){
                        people.mobile=[NSString stringWithUTF8String:(const char *)mobile];
                    }
                    if(groupPy!=nil){
                        people.groupPy=[NSString stringWithUTF8String:(const char *)groupPy];
                    }
                    if(groupDp!=nil){
                        people.groupDp=[NSString stringWithUTF8String:(const char *)groupDp];
                    }
                }
                sqlite3_finalize(stmt);
            }
        }
        return people;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(NSMutableArray *)findByName:(NSString *)name;{
    @try {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from t_people where name='%@' or name like '%@%@' or name like '%@%@' or name like '%@%@%@' limit 5",name,@"%",name,name,@"%",@"%",name,@"%"];
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
                    
                    People *people=[[People alloc]init];
                    people.pId=pId;
                    people.spId=spId;
                    
                    if(imei!=nil){
                        people.imei=[NSString stringWithUTF8String:(const char *)imei];
                    }
                    if(namePinyin!=nil){
                        people.namePinyin=[NSString stringWithUTF8String:(const char *)namePinyin];
                    }
                    if(topimg!=nil){
                        people.topimg=[NSString stringWithUTF8String:(const char *)topimg];
                    }
                    if(type!=nil){
                        people.type=[NSString stringWithUTF8String:(const char *)type];
                    }
                    if(email!=nil){
                        people.email=[NSString stringWithUTF8String:(const char *)email];
                    }
                    if(nicke!=nil){
                        people.nicke=[NSString stringWithUTF8String:(const char *)nicke];
                    }
                    if(name!=nil){
                        people.name=[NSString stringWithUTF8String:(const char *)name];
                    }
                    if(nickPinyin!=nil){
                        people.nickPinyin=[NSString stringWithUTF8String:(const char *)nickPinyin];
                    }
                    if(mobile!=nil){
                        people.mobile=[NSString stringWithUTF8String:(const char *)mobile];
                    }
                    if(groupPy!=nil){
                        people.groupPy=[NSString stringWithUTF8String:(const char *)groupPy];
                    }
                    if(groupDp!=nil){
                        people.groupDp=[NSString stringWithUTF8String:(const char *)groupDp];
                    }
                    [array addObject:people];
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
