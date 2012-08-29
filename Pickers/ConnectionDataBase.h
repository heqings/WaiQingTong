//
//  ConnectionDataBase.h
//  SqlDemo
//
//  Created by air macbook on 12-1-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Global.h"

#define dataBaseName    @"wqt_web.sqlite3"
@interface ConnectionDataBase : NSObject{
    
    sqlite3 *dataBase;
}

@property (nonatomic) sqlite3 *dataBase;

-(NSString *)dataBataPath;

-(void)connDataBase;
@end
