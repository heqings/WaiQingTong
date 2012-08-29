//
//  User.m
//  Pickers
//
//  Created by 张飞 on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize userId,qyId,mobile,nicke,email,pwd,imei,name,sex,area,topimage,autograph,token,modified;
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:self.userId forKey:@"userId"];
    [encoder encodeInt:self.qyId forKey:@"qyId"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.nicke forKey:@"nicke"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.pwd forKey:@"pwd"];
    [encoder encodeObject:self.imei   forKey:@"imei"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.area forKey:@"area"];
    [encoder encodeObject:self.topimage  forKey:@"topimage"];
    [encoder encodeObject:self.autograph  forKey:@"autograph"];
    [encoder encodeObject:self.token  forKey:@"token"];
    [encoder encodeInt:self.modified  forKey:@"modified"];
    
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
    self.userId= [decoder decodeIntForKey:@"userId"];
      self.qyId= [decoder decodeIntForKey:@"qyId"];
      self.mobile= [decoder decodeObjectForKey:@"mobile"];
      self.nicke= [decoder decodeObjectForKey:@"nicke"];
      self.email= [decoder decodeObjectForKey:@"email"];
      self.pwd= [decoder decodeObjectForKey:@"pwd"];
      self.imei= [decoder decodeObjectForKey:@"imei"];
      self.name= [decoder decodeObjectForKey:@"name"];
      self.sex= [decoder decodeObjectForKey:@"sex"];
      self.area= [decoder decodeObjectForKey:@"area"];
      self.topimage= [decoder decodeObjectForKey:@"topimage"];
    self.autograph= [decoder decodeObjectForKey:@"autograph"];
    self.token= [decoder decodeObjectForKey:@"token"];
    self.modified= [decoder decodeIntForKey:@"modified"];
    }
    return self;
}
@end
