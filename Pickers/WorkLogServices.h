//
//  WorkLogServices.h
//  Pickers
//
//  Created by air macbook on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "WorkLog.h"

@interface WorkLogServices : ConnectionDataBase{
    
}
+(WorkLogServices *)getConnection;

-(void)insertWorkLog:(NSString *)type content:(NSString *)content startTime:(NSString *)starttime endTime:(NSString *)endtime createTime:(NSString *)createtime;

-(void)deleteById:(NSInteger *)workId;

-(NSMutableArray *)findAll;
@end
