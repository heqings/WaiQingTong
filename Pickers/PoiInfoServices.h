//
//  PoiInfoServices.h
//  Pickers
//
//  Created by 张飞 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "PoiInfo.h"

@interface PoiInfoServices : ConnectionDataBase{
    
}
+(PoiInfoServices *)getConnection;

-(void)insertPoiInfo:(PoiInfo *)info;
-(PoiInfo*)findBySpId:(NSInteger)spId;
-(PoiInfo*)findById:(NSInteger)poiId;
-(void)deleteBySpId:(NSInteger)spId;
-(NSMutableArray *)findAll;
@end
