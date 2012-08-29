//
//  Attendance.h
//  Pickers
//
//  Created by air macbook on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//签到实体类
@interface Attendance : NSObject{
    NSInteger *attId;//签到id
    NSString *createtime;//创建时间
    NSString *address;//签到地址
}
@property(nonatomic,nonatomic) NSInteger *attId;
@property(nonatomic,strong) NSString *createtime;
@property(nonatomic,strong) NSString *address;
@end
