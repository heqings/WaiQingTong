//
//  PoiHistoryServices.h
//  Pickers
//
//  Created by 张飞 on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "PoiHistory.h"

@interface PoiHistoryServices : ConnectionDataBase{
    
}
+(PoiHistoryServices *)getConnection;

-(void)insertPoiInfo:(PoiHistory *)info;
-(void)updatePoiInfo:(NSInteger)spId endTime:(NSString *)endTime isFinish:(NSString*)isFinish;
-(NSMutableArray *)findAll;
@end
