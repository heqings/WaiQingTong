//
//  UserServices.m
//  Pickers
//
//  Created by 张飞 on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserServices.h"

#import "User.h"
@implementation UserServices
@dynamic dataBase;
static UserServices *conn;

+(UserServices *)getConnection{
    if(conn==nil){
        conn=[[UserServices alloc]init];
    }
    return conn;
}

-(void)updateUser:(User*)user
{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"update t_user set nicke='%@',email='%@',sex='%@',area='%@',topimg='%@',autograph='%@',modified=%d",
                           user.nicke,user.email,user.sex,user.area,user.topimage,user.autograph,user.modified];             
        sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error);    
        if(error !=nil)
        {
                NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                                   [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                        userInfo:nil];
                @throw e;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        sqlite3_close(dataBase);
    }
}
//用户信息插入
-(void)insertUser:(User*)user {
    @try {
        [self connDataBase];
        char *error=nil;
        if([user.sex isEqualToString:@""])
            user.sex=@"0";
        if([user.area isEqualToString:@""])
            user.area=@"0";
        
        NSString *sql=[NSString stringWithFormat:@"insert into t_user(user_id,mobile,nicke,name,email,pwd,companyid,imei,sex,area,topimg,autograph,token,modified)values(%d,'%@','%@','%@','%@','%@',%d,'%@','%@','%@','%@','%@','%@',%d)",user.userId,user.mobile,user.nicke,user.name,user.email,user.pwd,user.qyId,user.imei,user.sex,user.area,user.topimage,user.autograph,user.token,user.modified];
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
//

//从本地表查找已经登录用户
-(User*)getLoginUser
{
    sqlite3_stmt *stmt;
    @try {
        User* dic=nil;
        [self connDataBase]; 
        NSString *sql=[NSString stringWithFormat:@"select * from t_user "];
        int errorCode;
        if((errorCode=sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil))==SQLITE_OK){
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                dic= [[User alloc]init];
                
                int  userId = sqlite3_column_int(stmt,0);
                char *mobile=(char *)sqlite3_column_text(stmt, 2);
                char *nicke=(char *)sqlite3_column_text(stmt, 3);
                
                char *email=(char *)sqlite3_column_text(stmt, 4);
                char *name =(char*)sqlite3_column_text(stmt,5);
              
                char *imei=(char *)sqlite3_column_text(stmt, 7); 
                char *sex=(char *)sqlite3_column_text(stmt, 8);
                char *region=(char *)sqlite3_column_text(stmt, 9);
                char *image=(char *)sqlite3_column_text(stmt, 10);
                char *sign=(char *)sqlite3_column_text(stmt, 11);
                char *token=(char *)sqlite3_column_text(stmt, 12);
                int  modified = sqlite3_column_int(stmt,13);
                dic.userId = userId;
                dic.mobile = [NSString stringWithUTF8String:mobile];
                
                dic.nicke =   [NSString stringWithUTF8String:nicke];;
                dic.name=    [NSString stringWithUTF8String:name];
                dic.email = [NSString stringWithUTF8String:email];
              
                dic.imei =  [NSString stringWithUTF8String:imei];
                dic.sex = [NSString stringWithUTF8String:sex];
                dic.area = [NSString stringWithUTF8String:region];
                dic.topimage = [NSString stringWithUTF8String:image];
                dic.autograph =[NSString stringWithUTF8String:sign];
                dic.token = [NSString stringWithUTF8String:token];
                dic.modified = modified;
                
            }
            sqlite3_finalize(stmt);
        }else{
            const char* error=sqlite3_errmsg(dataBase);
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        return dic;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

@end
