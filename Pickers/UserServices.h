//
//  UserServices.h
//  Pickers
//
//  Created by 张飞 on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDataBase.h"
#import "User.h"

@interface UserServices : ConnectionDataBase{
    
}

+(UserServices *)getConnection;
-(void)insertUser:(User*)user;
-(User*)getLoginUser;
-(void)updateUser:(User*)userSetting;
@end
