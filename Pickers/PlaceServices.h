//
//  PlaceServices.h
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "place.h"

@interface PlaceServices : ConnectionDataBase

+(PlaceServices *)getConnection;

-(void)insertPlace:(Place*)p;

-(NSMutableArray *)findAll;

-(void)clearPlace;

@end
