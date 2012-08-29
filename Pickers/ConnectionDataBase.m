//
//  ConnectionDataBase.m
//  SqlDemo
//
//  Created by air macbook on 12-1-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ConnectionDataBase.h"
@implementation ConnectionDataBase

@synthesize dataBase;

//sqlite3里的数据类型
//  NULL，值是NULL
//  INTEGER，值是有符号整形，根据值的大小以1,2,3,4,6或8字节存放
//  REAL，值是浮点型值，以8字节IEEE浮点数存放
//  TEXT，值是文本字符串，使用数据库编码（UTF-8，UTF-16BE或者UTF-16LE）存放
//  BLOB，只是一个数据块，完全按照输入存放（即没有准换）

//创建sqlite3数据库文件
-(NSString *)dataBataPath{
    return [[Global getDocumentPath] stringByAppendingPathComponent:dataBaseName];
}

//打开数据库
-(void)connDataBase{
    
    @try {
        int errorCode=0;
        if ((errorCode=sqlite3_open([[self dataBataPath] UTF8String], &dataBase))!=SQLITE_OK) {
           const char* err_msg = sqlite3_errmsg(dataBase);
            NSException* e  = [NSException exceptionWithName:@"SqlException" reason:
                              [NSString stringWithCString:err_msg encoding:NSUTF8StringEncoding] 
                            userInfo:nil];
            @throw e;
        }
        
    }
    @catch (NSException *exception) {
        sqlite3_close(dataBase);
        @throw exception;
         
    }
    @finally {
        
    }
}
@end
