//
//  WorkUtilsDelegate.h
//  Pickers
//
//  Created by air macbook on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WorkUtilsDelegate <NSObject>

//刷新表格
-(void)reloadTableView;

//选择申请类型
-(void)chooseTypeName:(NSString *)name;

@end
