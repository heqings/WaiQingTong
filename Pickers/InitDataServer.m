//
//  InitDataServer.m
//  Pickers
//
//  Created by air macbook on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitDataServer.h"
@implementation InitDataServer
@dynamic dataBase;
static InitDataServer *conn;

+(InitDataServer *)getConnection{
    if(conn==nil){
        conn=[[InitDataServer alloc]init];
    }
    return conn;
}
-(void)clearAllData
{
    @try 
    {
        [self connDataBase];
        
        char *error=nil;
        //考勤
        NSString *sql=[NSString stringWithFormat:@"delete from t_attendance"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //联系人
        NSString *sql9=[NSString stringWithFormat:@"delete from t_people"];
        if(sqlite3_exec(dataBase, [sql9 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //工作日志
        NSString *sql1=[NSString stringWithFormat:@"delete from t_work_log"];
        if(sqlite3_exec(dataBase, [sql1 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //申请
        NSString *sql2=[NSString stringWithFormat:@"delete from t_apply"];
        if(sqlite3_exec(dataBase, [sql2 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //消息组详情
        NSString *sql3=[NSString stringWithFormat:@"delete from notifycation_info"];
        if(sqlite3_exec(dataBase, [sql3 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //消息组
        NSString *sql4=[NSString stringWithFormat:@"delete from notifycation_table"];
        if(sqlite3_exec(dataBase, [sql4 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;

        }
        
        //用户设置
        NSString *sql5=[NSString stringWithFormat:@"delete from t_user_setting"];
        if(sqlite3_exec(dataBase, [sql5 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;

        }
        
        //用户
        NSString *sql6=[NSString stringWithFormat:@"delete from t_user"];
        if(sqlite3_exec(dataBase, [sql6 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
         
        }
        
        //签到
        NSString *sql7=[NSString stringWithFormat:@"delete from signIn_table"];
        if(sqlite3_exec(dataBase, [sql7 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;

        }
        
        //poi详情
        NSString *sql8=[NSString stringWithFormat:@"delete from poi_info"];
        if(sqlite3_exec(dataBase, [sql8 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;

        }
        
        //scoket－拜访poi
        NSString *sql10=[NSString stringWithFormat:@"delete from notify_poi"];
        if(sqlite3_exec(dataBase, [sql10 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //scoket－拜访
        NSString *sql11=[NSString stringWithFormat:@"delete from notify_plan"];
        if(sqlite3_exec(dataBase, [sql11 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
           
        }
       
        //scoket－工作任务
        NSString *sql12=[NSString stringWithFormat:@"delete from notify_gzrw"];
        if(sqlite3_exec(dataBase, [sql12 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //scoket－申请
        NSString *sql13=[NSString stringWithFormat:@"delete from notify_sq"];
        if(sqlite3_exec(dataBase, [sql13 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //scoket－通知
        NSString *sql14=[NSString stringWithFormat:@"delete from notify_tz"];
        if(sqlite3_exec(dataBase, [sql14 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //scoket－工作日志
        NSString *sql15=[NSString stringWithFormat:@"delete from notify_gzrz"];
        if(sqlite3_exec(dataBase, [sql15 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //客户
        NSString *sql16=[NSString stringWithFormat:@"delete from client_table"];
        if(sqlite3_exec(dataBase, [sql16 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        //客户详情
        NSString *sql17=[NSString stringWithFormat:@"delete from client_info"];
        if(sqlite3_exec(dataBase, [sql17 UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
    }@catch (NSException* e) {
        @throw  e;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}
//创建签到表
-(void)initAttendance{
    @try 
    {
        [self connDataBase];
        
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists t_attendance(att_id INTEGER PRIMARY KEY autoincrement,create_time TEXT,address TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
            
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;
        }
        
        
    }@catch (NSException* e) {
        @throw  e;
    }
    @finally {
        sqlite3_close(dataBase);
    }
    
}

//创建工作日志表
-(void)initWorklog{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists t_work_log(work_id INTEGER PRIMARY KEY autoincrement,work_type TEXT,work_content TEXT,start_time TEXT,end_time TEXT,create_time TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//创建费用申请表
-(void)initApply{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists t_apply(apply_id INTEGER PRIMARY KEY autoincrement,apply_type TEXT,apply_content TEXT,handler TEXT,apply_time TEXT,handler_time TEXT,remark TEXT,status TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//创建通知表
-(void)initNotify{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists notifycation_table(nt_id INTEGER PRIMARY KEY autoincrement,nt_title TEXT,is_read TEXT,read_count INTEGER,nt_date TEXT,to_user TEXT,group_id TEXT,nt_type TEXT,detail_text TEXT)"];
        
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//创建通知表详情
-(void)initNotifyInfo{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists notifycation_info(ni_id INTEGER PRIMARY KEY autoincrement,nt_id INTEGER,peopel_id INTEGER,ni_type TEXT,ni_name TEXT,ni_path TEXT,ni_status TEXT,ni_date TEXT,is_read TEXT,is_myspeaking TEXT,ni_content TEXT,record_time TEXT)"];
        
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//初始化设置
-(void)initGeneralSetting
{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists t_user_setting(t_image_quality TEXT,t_notify_system TEXT,t_notify_workplan TEXT,t_notify_visit TEXT,t_notify_apply TEXT,t_area_people TEXT,app_num INTEGER,notify_num INTEGER)"];
        
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;

        } 
        
        NSString *sql1=[NSString stringWithFormat:@"select count(*) from t_user_setting"];
        int count=0;
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(dataBase, [sql1 UTF8String], -1, &stmt, nil)==SQLITE_OK){
            if (sqlite3_step(stmt)==SQLITE_ROW) 
                count=(int)sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
 
        if(count == 0)
        {
            NSString *sql2=[NSString stringWithFormat:@"insert into t_user_setting(t_image_quality ,t_notify_system ,t_notify_workplan ,t_notify_visit ,t_notify_apply ,t_area_people,app_num,notify_num ) values('0','Y','Y','Y','Y','',0,0)"];
            if(sqlite3_exec(dataBase, [sql2 UTF8String], nil, nil, &error)!=SQLITE_OK){
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
//创建用户表
-(void)initUser{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists t_user(user_id int,companyid TEXT,mobile TEXT,nicke TEXT,email TEXT,name TEXT,pwd TEXT,imei TEXT,sex TEXT,area TEXT,topimg TEXT,autograph TEXT,token TEXT,modified int)"];
        
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//创建联系人
-(void)initPeople{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists t_people(p_id INTEGER PRIMARY KEY autoincrement,sp_id INTEGER,imei TEXT,name_pinyin TEXT,name TEXT,nicke TEXT,nick_pinyin TEXT,topimg TEXT,type TEXT,email TEXT,mobile TEXT,group_py TEXT,group_dp TEXT)"];
        
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//系统公用表
-(void)initAppGlobal{
    @try {
        [self connDataBase];
        char *error=nil;
        
        NSString *sql=[NSString stringWithFormat:@"create table if not exists app_global(ag_id INTEGER PRIMARY KEY autoincrement,u_url TEXT,t_urlimg TEXT,t_downloadtopimgurl TEXT,t_downloadpoiimgurl TEXT)"];
        
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                               [NSString stringWithCString:error encoding:NSUTF8StringEncoding] 
                                                    userInfo:nil];
            @throw e;

        }  
        NSString *sql1=[NSString stringWithFormat:@"select count(*) from app_global"];
        int count=0;
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(dataBase, [sql1 UTF8String], -1, &stmt, nil)==SQLITE_OK){
            if (sqlite3_step(stmt)==SQLITE_ROW) 
                count=(int)sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
        if(count == 0)
        {
            NSString *sql2=[NSString stringWithFormat:@"insert into app_global(u_url, t_urlimg,t_downloadtopimgurl,t_downloadpoiimgurl) values('http://new.ydwqt.com/stom/service/','http://new.ydwqt.com/stom','http://file.ydwqt.com/wqt_fserver/topimg/','http://file.ydwqt.com/wqt_fserver/label/')"];
            if(sqlite3_exec(dataBase, [sql2 UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//推送工作日志
-(void)initNotifyGzrz{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists notify_gzrz(ng_id INTEGER PRIMARY KEY autoincrement,nt_id INTEGER,people_id INTEGER,sp_id INTEGER,ng_content TEXT,ng_createdate TEXT,ng_remarkpeople TEXT,ng_remarkcontent TEXT,status TEXT,ng_type TEXT,ng_remarkTime TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//推送通知
-(void)initNotifyTz{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists notify_tz(nte_id INTEGER PRIMARY KEY autoincrement,nt_id INTEGER,people_id INTEGER,sp_id INTEGER,nte_content TEXT,nte_createDate TEXT,nte_createUser TEXT,nt_title TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//推送申请
-(void)initNotifySq{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists notify_sq(ns_id INTEGER PRIMARY KEY autoincrement,nt_id INTEGER,people_id INTEGER,sp_id INTEGER,ns_content TEXT,ns_createDate TEXT,ns_remarkPeople TEXT,ns_remarkContent TEXT,status TEXT,ns_type TEXT,ns_remarkTime TEXT,ns_remarkType TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//推送工作任务
-(void)initNotifyGzrw{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists notify_gzrw(ng_id INTEGER PRIMARY KEY autoincrement,nt_id INTEGER,people_id INTEGER,sp_id INTEGER,ng_title TEXT,ng_content TEXT,ng_createDate TEXT,finish_time TEXT,ng_level TEXT,status TEXT,create_user TEXT,remark_user TEXT,remark_content TEXT,rl_time TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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
//拜访信息
-(void)initNotifyPlan{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists notify_plan(np_id INTEGER PRIMARY KEY autoincrement,nt_id INTEGER,sp_id INTEGER,np_content TEXT,create_date TEXT,create_user INTEGER,end_time TEXT,start_time TEXT,handler_name TEXT,handler_id INTEGER)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//拜访POI信息
-(void)initNotifyPoi{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists notify_poi(poi_id INTEGER PRIMARY KEY autoincrement,np_id INTEGER,sp_id INTEGER,poi_name TEXT,poi_address TEXT,poi_imgUrl TEXT,start_time TEXT,end_time TEXT,is_finish TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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
//签到信息表
-(void)initPoiInfo{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists poi_info(pi_id INTEGER PRIMARY KEY autoincrement,sp_id INTEGER,poi_name TEXT,poi_type TEXT,poi_address TEXT,poi_imgUrl TEXT,sl_id INTEGER,o_lat REAL,o_lng REAL,create_time TEXT,end_time TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//签到历史信息表
-(void)initPoiHistory{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists poi_history(pi_id INTEGER PRIMARY KEY autoincrement,sp_id INTEGER,poi_name TEXT,poi_type TEXT,poi_address TEXT,poi_imgUrl TEXT,sl_id INTEGER,o_lat REAL,o_lng REAL,create_time TEXT,end_time TEXT,is_finish TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//初始化标注表
-(void)initSignIn{
    @try {
        [self connDataBase];
        char *error=nil;
        
        NSString *sql=[NSString stringWithFormat:@"create table if not exists signIn_table(si_id INTEGER PRIMARY KEY autoincrement,si_name TEXT,si_type TEXT,si_remark TEXT,si_address TEXT,si_imgUrl TEXT,o_lat REAL,o_lng REAL,create_time TEXT)"];

        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//位置查询
-(void)initPlace{
    @try {
        [self connDataBase];
        char *error=nil;
        NSString *sql=[NSString stringWithFormat:@"create table if not exists place_search(p_id INTEGER PRIMARY KEY autoincrement,sp_id INTEGER,imei TEXT,name_pinyin TEXT,name TEXT,nicke TEXT,nick_pinyin TEXT,topimg TEXT,type TEXT,email TEXT,mobile TEXT,group_py TEXT,group_dp TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//客户资料
-(void)initClient{
    @try {
        [self connDataBase];
        char *error=nil;

        NSString *sql=[NSString stringWithFormat:@"create table if not exists client_table(c_id INTEGER PRIMARY KEY autoincrement,custom_id INTEGER,faxphone TEXT,c_email TEXT,c_address TEXT,c_name TEXT,name_pinyin TEXT,uri TEXT,telphone TEXT,create_time TEXT,group_py TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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

//客户资料详情
-(void)initClientInfo{
    @try {
        [self connDataBase];
        char *error=nil;
        
        NSString *sql=[NSString stringWithFormat:@"create table if not exists client_info(ci_id INTEGER PRIMARY KEY autoincrement,c_id INTEGER,sp_id INTEGER,linkmobile TEXT,linkname TEXT,officetel TEXT,c_remark TEXT,c_email TEXT)"];
        if(sqlite3_exec(dataBase, [sql UTF8String], nil, nil, &error)!=SQLITE_OK){
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
