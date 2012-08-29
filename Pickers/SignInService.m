//
//  SignInService.m
//  Pickers
//
//  Created by  on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SignInService.h"
#import "SignIn.h"
@implementation SignInService
@dynamic dataBase;
static SignInService *conn;

+(SignInService *)getConnection{
    if(conn==nil){
        conn=[[SignInService alloc]init];
    }
    return conn;
}
-(void)insertSignIn:(SignIn*)si
{
    @try {
        [self connDataBase];
        {
            char *error =nil;

            NSString *sql=[NSString stringWithFormat:@"insert into signIn_table(si_name,si_type,si_remark,si_address,si_imgUrl,o_lat,o_lng,create_time)values('%@','%@','%@','%@','%@','%@','%@','%@')",si.signInName,si.signInType,si.signInRemark,si.signInAddress,si.signInImgUrl,si.OLat,si.OLng,si.createTime];

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
            NSString *sql=[NSString stringWithFormat:@"select * from signIn_table order by create_time desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
                    
                    int signInId=(int)sqlite3_column_int(stmt, 0);
                    char *signInName=(char *)sqlite3_column_text(stmt, 1);
                    char *signInType=(char *)sqlite3_column_text(stmt, 2);
                    char *signInRemark=(char *)sqlite3_column_text(stmt, 3);
                    char *signInAddress=(char *)sqlite3_column_text(stmt, 4);
                    char *signInImgUrl=(char *)sqlite3_column_text(stmt, 5);
                    double oLat=(double)sqlite3_column_double(stmt, 6);
                    double oLng =(double)sqlite3_column_double(stmt,7);
                    char *createTime=(char *)sqlite3_column_text(stmt, 8);
                    
                    SignIn *si=[[SignIn alloc]init];
                   
                    si.signInId=signInId;
                    si.OLat=[NSString stringWithFormat:@"%f",oLat];
                    si.OLng=[NSString stringWithFormat:@"%f",oLng];
                    
                    if(signInName!=nil){
                         si.signInName=[NSString stringWithUTF8String:(const char *)signInName];
                    }
                    if(signInType!=nil){
                        si.signInType=[NSString stringWithUTF8String:(const char *)signInType];
                    }
                    if(signInAddress!=nil){
                        si.signInAddress=[NSString stringWithUTF8String:(const char *)signInAddress];
                    }
                    if(signInImgUrl!=nil){
                        si.signInImgUrl=[NSString stringWithUTF8String:(const char *)signInImgUrl];
                    }
                    if(signInRemark!=nil){
                        si.signInRemark=[NSString stringWithUTF8String:(const char *)signInRemark];
                    }
                    if(createTime!=nil){
                        si.createTime=[NSString stringWithUTF8String:(const char *)createTime];
                    }
                     [array addObject:si];
                  
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
