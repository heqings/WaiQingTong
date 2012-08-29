//
//  PeopleServices.h
//  Pickers
//
//  Created by 张飞 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "People.h"

@interface PeopleServices : ConnectionDataBase

+(PeopleServices *)getConnection;
-(void)insertPeople:(People*)p;
-(void)deleteById:(NSInteger)pId;
-(void)clearPeople;
-(NSMutableArray *)findAll;

-(People *)findByMobile:(NSString *)mobile;

-(NSInteger)findCount;

-(People *)findBySpId:(NSInteger)pId;

-(NSMutableArray *)findByName:(NSString *)name;
@end
