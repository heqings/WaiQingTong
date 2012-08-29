//
//  PoiInfoServices.m
//  Pickers
//
//  Created by 张飞 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PoiInfoServices.h"

@implementation PoiInfoServices
@dynamic dataBase;
static PoiInfoServices *conn;

+(PoiInfoServices *)getConnection{
    if(conn==nil){
        conn=[[PoiInfoServices alloc]init];
    }
    return conn;
}

-(void)insertPoiInfo:(PoiInfo *)info{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"insert into poi_info(sp_id,poi_name,poi_type,poi_address,poi_imgUrl,sl_id,o_lat,o_lng,create_time,end_time)values(%i,'%@','%@','%@','%@',%i,'%f','%f','%@','%@')",info.spId,info.poiName,info.poiType,info.poiAddress,info.poiImgUrl,info.slId,info.OLat,info.OLng,info.createTime,info.endTime];
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

-(PoiInfo*)findBySpId:(NSInteger)spId{
    @try {
        PoiInfo *poiInfo=[[PoiInfo alloc]init];
        [self connDataBase];
        
        sqlite3_stmt *stmt;
        NSString *sql=[NSString stringWithFormat:@"select * from poi_info where sp_id=%i",spId];
        if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                int piId=(int)sqlite3_column_int(stmt, 0);
                int spId=(int)sqlite3_column_int(stmt, 1);
                char *poiName=(char *)sqlite3_column_text(stmt, 2);
                char *poiType=(char *)sqlite3_column_text(stmt, 3);
                char *poiAddress=(char *)sqlite3_column_text(stmt, 4);
                char *poiImgUrl=(char *)sqlite3_column_text(stmt, 5);
                int slId=(int)sqlite3_column_int(stmt, 6);
                double OLat=(float)sqlite3_column_double(stmt, 7);
                double OLng=(float)sqlite3_column_double(stmt, 8);    
                
                poiInfo.piId=piId;
                poiInfo.spId=spId; 
                poiInfo.slId=slId;
                poiInfo.OLat=OLat;
                poiInfo.OLng=OLng;
                if(poiName!=nil){
                    poiInfo.poiName=[NSString stringWithUTF8String:(const char *)poiName];
                }
                if(poiType!=nil){
                    poiInfo.poiType=[NSString stringWithUTF8String:(const char *)poiType];
                }
                if(poiAddress!=nil){
                    poiInfo.poiAddress=[NSString stringWithUTF8String:(const char *)poiAddress];
                }
                if(poiImgUrl!=nil){
                    poiInfo.poiImgUrl=[NSString stringWithUTF8String:(const char *)poiImgUrl];
                }
                
            }
            sqlite3_finalize(stmt);
        }
        return poiInfo;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(PoiInfo*)findById:(NSInteger)poiId{
    @try {
        PoiInfo *poiInfo=[[PoiInfo alloc]init];
        [self connDataBase];
        
        sqlite3_stmt *stmt;
        NSString *sql=[NSString stringWithFormat:@"select * from poi_info where pi_id=%i",poiId];
        if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                int piId=(int)sqlite3_column_int(stmt, 0);
                int spId=(int)sqlite3_column_int(stmt, 1);
                char *poiName=(char *)sqlite3_column_text(stmt, 2);
                char *poiType=(char *)sqlite3_column_text(stmt, 3);
                char *poiAddress=(char *)sqlite3_column_text(stmt, 4);
                char *poiImgUrl=(char *)sqlite3_column_text(stmt, 5);
                int slId=(int)sqlite3_column_int(stmt, 6);
                double OLat=(float)sqlite3_column_double(stmt, 7);
                double OLng=(float)sqlite3_column_double(stmt, 8);    
                
                poiInfo.piId=piId;
                poiInfo.spId=spId; 
                poiInfo.slId=slId;
                poiInfo.OLat=OLat;
                poiInfo.OLng=OLng;
                if(poiName!=nil){
                    poiInfo.poiName=[NSString stringWithUTF8String:(const char *)poiName];
                }
                if(poiType!=nil){
                    poiInfo.poiType=[NSString stringWithUTF8String:(const char *)poiType];
                }
                if(poiAddress!=nil){
                    poiInfo.poiAddress=[NSString stringWithUTF8String:(const char *)poiAddress];
                }
                if(poiImgUrl!=nil){
                    poiInfo.poiImgUrl=[NSString stringWithUTF8String:(const char *)poiImgUrl];
                }
                
            }
            sqlite3_finalize(stmt);
        }
        return poiInfo;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        sqlite3_close(dataBase);
    }
}

-(void)deleteBySpId:(NSInteger)spId{
    @try {
        [self connDataBase];
        {
            char *error =nil;
            NSString *sql=[NSString stringWithFormat:@"delete from poi_info where sp_id=%i",spId];
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
            NSString *sql=[NSString stringWithFormat:@"select * from poi_info order by create_time desc"];
            if(sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
                while (sqlite3_step(stmt)==SQLITE_ROW) {
            
                    int piId=(int)sqlite3_column_int(stmt, 0);
                    int spId=(int)sqlite3_column_int(stmt, 1);
                    char *poiName=(char *)sqlite3_column_text(stmt, 2);
                    char *poiType=(char *)sqlite3_column_text(stmt, 3);
                    char *poiAddress=(char *)sqlite3_column_text(stmt, 4);
                    char *poiImgUrl=(char *)sqlite3_column_text(stmt, 5);
                    int slId=(int)sqlite3_column_int(stmt, 6);
                    double OLat=(float)sqlite3_column_double(stmt, 7);
                    double OLng=(float)sqlite3_column_double(stmt, 8);  
                    char *createTime=(char *)sqlite3_column_text(stmt, 9);
                    char *endTime=(char *)sqlite3_column_text(stmt, 10);
                    
                    PoiInfo *poiInfo=[[PoiInfo alloc]init];
                    
                    poiInfo.piId=piId;
                    poiInfo.spId=spId; 
                    poiInfo.slId=slId;
                    poiInfo.OLat=OLat;
                    poiInfo.OLng=OLng;
                    if(poiName!=nil){
                        poiInfo.poiName=[NSString stringWithUTF8String:(const char *)poiName];
                    }
                    if(poiType!=nil){
                        poiInfo.poiType=[NSString stringWithUTF8String:(const char *)poiType];
                    }
                    if(poiAddress!=nil){
                        poiInfo.poiAddress=[NSString stringWithUTF8String:(const char *)poiAddress];
                    }
                    if(poiImgUrl!=nil){
                        poiInfo.poiImgUrl=[NSString stringWithUTF8String:(const char *)poiImgUrl];
                    }
                    if(createTime!=nil){
                        poiInfo.createTime=[NSString stringWithUTF8String:(const char *)createTime];
                    }
                    if(endTime!=nil){
                        poiInfo.endTime=[NSString stringWithUTF8String:(const char *)endTime];
                    }
                    [array addObject:poiInfo];
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
