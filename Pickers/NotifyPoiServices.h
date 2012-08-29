//
//  NotifyPoiServices.h
//  Pickers
//
//  Created by 张飞 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "NotifyPoi.h"

@interface NotifyPoiServices : ConnectionDataBase{
    
}

+(NotifyPoiServices *)getConnection;
-(void)insertNotify:(NotifyPoi*)poi;
-(NSMutableArray *)findAll;
-(NSMutableArray *)findByFinish:(NSString *)isFinish npId:(NSInteger)npId;
-(void)updatePoiByStartTime:(NSInteger)spId isFinish:(NSString *)isFinish startTime:(NSString*)startTime;
-(void)updatePoiByEndTime:(NSInteger)spId isFinish:(NSString *)isFinish endTime:(NSString*)endTime;
-(void)cleanAll;
@end
