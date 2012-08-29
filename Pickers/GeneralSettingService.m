//
//  GeneralSettingService.m
//  Pickers
//
//  Created by  on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GeneralSettingService.h"

@implementation GeneralSettingService
@dynamic dataBase;
static GeneralSettingService *conn;

+(GeneralSettingService *)getConnection{
    if(conn==nil){
        conn=[[GeneralSettingService alloc]init];
    }
    return conn;
}

-(void)clearGeneralSetting
{
    @try{
        char* error=nil;
        [self connDataBase];
        
        NSString *sql1=[NSString stringWithFormat:@"delete from t_user_setting"];
        if(sqlite3_exec(dataBase, [sql1 UTF8String], nil, nil, &error)!=SQLITE_OK)
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
-(void)insertGeneralSetting:(NSDictionary*)dic
{
    @try{
        char* error=nil;
        [self connDataBase];
        {
            NSString* str =  [dic valueForKey:@"t_area_people"];
            NSString *sql1=[NSString stringWithFormat:@"insert into t_user_setting(t_image_quality ,t_notify_system ,t_notify_workplan ,t_notify_visit ,t_notify_apply ,t_area_people) values('0','Y','Y','Y','Y','%@')",str];
            if(sqlite3_exec(dataBase, [sql1 UTF8String], nil, nil, &error)!=SQLITE_OK){
                NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                                   [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                        userInfo:nil];
                @throw e;
                
            }
        }
    }@catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
    
}

-(void)updateGeneralSetting:(NSDictionary*)dict
{
    @try {
        [self connDataBase];
        {

            for(NSString* k in dict.allKeys)
            {
                NSString* v= [dict valueForKey:k];
                char *error =nil;
                NSString *sql=[NSString stringWithFormat:@"update t_user_setting set %@=\"%@\"",k,v];

                sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error);    
                
                if(error !=nil)
                {
                    NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                                       [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                            userInfo:nil];
                    @throw e;
                    
                }
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


-(NSMutableDictionary*)getGeneralSetting
{
    sqlite3_stmt *stmt;
    @try {
        
        [self connDataBase]; 
        NSMutableDictionary* dict =[NSMutableDictionary dictionary];
        NSString *sql=[NSString stringWithFormat:@"select * from t_user_setting"];
        int errorCode;
        if((errorCode=sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil))==SQLITE_OK){
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                char *t_image_quality=(char *)sqlite3_column_text(stmt, 0);
                char *t_notify_workplan=(char *)sqlite3_column_text(stmt, 2);
                char *t_notify_system=(char *)sqlite3_column_text(stmt, 1);
                char *t_notify_apply=(char *)sqlite3_column_text(stmt, 4);
                char *t_notify_visit=(char *)sqlite3_column_text(stmt, 3);
                 char *t_area_people =(char*)sqlite3_column_text(stmt,5);
                 
                [dict setValue:  [NSString stringWithCString:t_image_quality encoding:NSUTF8StringEncoding] forKey:@"t_image_quality"];
                [dict setValue:[NSString stringWithCString:t_notify_workplan encoding:NSUTF8StringEncoding] forKey:@"t_notify_workplan"];
                [dict setValue:[NSString stringWithCString:t_notify_visit encoding:NSUTF8StringEncoding] forKey:@"t_notify_visit"];
                [dict setValue:[NSString stringWithCString:t_notify_apply encoding:NSUTF8StringEncoding] forKey:@"t_notify_apply"];
                [dict setValue:[NSString stringWithCString:t_notify_system encoding:NSUTF8StringEncoding] forKey:@"t_notify_system"];
                [dict setValue:[NSString stringWithCString:t_area_people encoding:NSUTF8StringEncoding] forKey:@"t_area_people"];
             
                //
            }
            sqlite3_finalize(stmt);
            return dict;
            
        }
        else
        {
            const char* error=sqlite3_errmsg(dataBase);
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
