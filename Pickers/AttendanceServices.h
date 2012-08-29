//
//  AttendanceServices.h
//  Pickers
//
//  Created by air macbook on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "Attendance.h"

@interface AttendanceServices : ConnectionDataBase{
    
}

+(AttendanceServices *)getConnection;

-(void)insertAttendance:(NSString *)createtime address:(NSString *)address;

-(void)deleteById:(NSInteger *)attId;

-(NSMutableArray *)findAll;
@end
