//
//  AppGlobalServices.m
//  Pickers
//
//  Created by 张飞 on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppGlobalServices.h"

@implementation AppGlobalServices
@dynamic dataBase;
static AppGlobalServices *conn;

+(AppGlobalServices *)getConnection{
    if(conn==nil){
        conn=[[AppGlobalServices alloc]init];
    }
    return conn;
}

//初始化公用表
-(void)insertAppGlobal{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"insert into app_global(app_num,notify_num)values(0,0)"];
            
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
//查询公用表
-(NSDictionary *)findAll{
    @try {
        NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithCapacity:10];
        
        [self connDataBase];
        {     
            sqlite3_stmt *stmt;
            NSString *sql=[NSString stringWithFormat:@"select * from app_global"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    int agId=(int)sqlite3_column_int(stmt, 0);
                    char *t_url =(char*)sqlite3_column_text(stmt,1);
                    char* t_urlimg = (char*)sqlite3_column_text(stmt,2);
                    char* t_downloadtopimgurl = (char*)sqlite3_column_text(stmt,3);
                    char* t_downloadpoiimgurl = (char*)sqlite3_column_text(stmt,4);
                    [dict setValue:[NSString stringWithCString:t_url encoding:NSUTF8StringEncoding] forKey:@"t_url"];
                    [dict setValue:[NSString stringWithCString:t_urlimg encoding:NSUTF8StringEncoding] forKey:@"t_urlimg"];
                    [dict setValue:[NSString stringWithCString:t_downloadtopimgurl encoding:NSUTF8StringEncoding] forKey:@"t_downloadtopimgurl"];
                    [dict setValue:[NSString stringWithCString:t_downloadpoiimgurl encoding:NSUTF8StringEncoding] forKey:@"t_downloadpoiimgurl"];
                }
                sqlite3_finalize(stmt);
            }
        }
        return dict;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}
@end
