//
//  AppGlobalServices.h
//  Pickers
//
//  Created by 张飞 on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"

@interface AppGlobalServices : ConnectionDataBase{
    
}
+(AppGlobalServices *)getConnection;
-(NSDictionary *)findAll;
@end
