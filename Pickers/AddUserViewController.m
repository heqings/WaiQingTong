//
//  AddUserViewController.m
//  Pickers
//
//  Created by 张飞 on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddUserViewController.h"

@implementation AddUserViewController
@synthesize myData,table,bootView,delBtn,submitBtn,from;

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    chatArray = [[NSMutableArray alloc] init];
    checked = [UIImage imageNamed:@"checked"];
    checkno = [UIImage imageNamed:@"check_no"];
    mArray=[[PeopleServices getConnection] findAll];
    
    myData = [[NSMutableDictionary alloc] init]; 
    for(People *p in mArray){
        if([myData objectForKey:p.groupPy]){
            NSMutableArray *getArry = [myData objectForKey:p.groupPy];
            [getArry addObject:p];
            
        }else{
            NSMutableArray *newArry = [[NSMutableArray alloc] init];
            [newArry addObject:p];
            [myData setObject:newArry forKey:p.groupPy];
        }
    }

    bootView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tools_bar"]];
    bootView.opaque = NO;
}

- (void)viewDidUnload{
    from=nil;
    myData=nil;
    mArray=nil;
    chatArray=nil;
    [super viewDidUnload];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[myData allKeys] count];  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return [[myData valueForKey:[arr objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:CellIdentifier];
    }
    UIImage *image = [UIImage imageNamed:@"check_no"];  
    cell.imageView.image = image;
    
	NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    People *p=(People *)[[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.text =p.name;

	//特定section里面找到对应的array，
	//然后在array中找到indexPath.row所在的内容
    return cell;
}

//分组标头
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if([myData count]==0){
        return @"";
    }
    NSArray *sortedKeys = [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return [sortedKeys objectAtIndex:section];
}

//索引筛选
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]){
        
        if([character isEqualToString:title]){            
            return count;
        }        
        count ++;        
    }
    return 0;
}

//右边索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isExist=YES;
    for(int i=0;i<[chatArray count];i++){
        if([indexPath isEqual:[chatArray objectAtIndex:i]]){
            [chatArray removeObjectAtIndex:i];
            isExist=NO;
        }
    }
    if(isExist){
        [chatArray addObject:indexPath];
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];  
    if([cell.imageView.image isEqual:checkno]){
        cell.imageView.image = checked;
    }else{
         cell.imageView.image = checkno;
    } 
    [submitBtn setTitle:[NSString stringWithFormat:@"发起会话(%i)",[chatArray count]] forState:UIControlStateNormal];
    [delBtn setTitle:[NSString stringWithFormat:@"删除(%i)",[chatArray count]] forState:UIControlStateNormal];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
} 

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

//当滚动条滚动时，从新绘制图片
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView=(UITableView *)scrollView;
        for(int i=0;i<[chatArray count];i++){
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:[chatArray objectAtIndex:i]]; 
            cell.imageView.image = checked;
        }
    }
}


//返回按钮事件
-(IBAction)backBtnClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

//发起会话
-(IBAction)addUser:(id)sender{ 
    if([chatArray count]>0){
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        NotifyServices *nConn=[NotifyServices getConnection];
        
        if([from isEqualToString:@"A"]){
            
        NSString *identityString;
        
        if([chatArray count]==1){//选择单个用户进行语音
            NSString *toUserName;
            NSInteger toUserId;
            for(int i=0;i<[chatArray count];i++){
                NSIndexPath *indexPath=[chatArray objectAtIndex:i]; 
                People *people =(People *)[[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]; 
                toUserId=people.spId;
                toUserName=people.name;
            }
            
            identityString=[Global getSortIdentity:[NSString stringWithFormat:@"%i",user.userId] toUser:[NSString stringWithFormat:@"%i",toUserId]];
            
            Notify *notify=[nConn findByGroup:identityString];
            if(notify.toUser==nil){
                [nConn insertNotify:toUserName isRead:@"Y" readCount:0 ntDate:[Global getCurrentTime] toUser:[NSString stringWithFormat:@"%i",toUserId] groupId:identityString ntType:[Global getNOTIFY_YY] detailText:@""];    
            }
        }else{//选择多个用户进行语音
            NSMutableString *names=[[NSMutableString alloc]init];
            NSMutableArray *serverIds=[[NSMutableArray alloc]init];
            [serverIds addObject:[NSNumber numberWithInteger:user.userId]];
            for(int i=0;i<[chatArray count];i++){
                NSIndexPath *indexPath=[chatArray objectAtIndex:i]; 
                People *people =(People *)[[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]; 
                [serverIds addObject:[NSNumber numberWithInteger:people.spId]];
                [names appendString:[NSString stringWithFormat:@"%@ ",people.name]];
            }
            NSString *tempName=nil;
            if([names length]>10){
                NSRange nameRange = NSMakeRange(0,10);
                tempName = [names substringWithRange:nameRange];
                tempName=[NSString stringWithFormat:@"%@...(%i)",tempName,[chatArray count]+1];
            }else{
                tempName=[NSString stringWithFormat:@"%@...(%i)",names,[chatArray count]+1];
            }
            NSArray* arrayIds = [serverIds sortedArrayUsingSelector:@selector(compare:)];
            NSMutableString *idsString=[[NSMutableString alloc]init];//toUser
            NSMutableString *idsIdentity=[[NSMutableString alloc]init];//groupId
            
            for(int i=0;i<[arrayIds count];i++){
                if([[arrayIds objectAtIndex:i]intValue]!=user.userId){
                    [idsString appendString:[NSString stringWithFormat:@"%@|",[arrayIds objectAtIndex:i]]];
                }
                [idsIdentity appendString:[NSString stringWithFormat:@"%@",[arrayIds objectAtIndex:i]]];
            }        
            
            identityString = [NSString stringWithFormat:@"%@",idsIdentity]; 
            
            Notify *notify=[nConn findByGroup:identityString];
            if(notify.toUser==nil){
                [nConn insertNotify:tempName isRead:@"Y" readCount:0 ntDate:[Global getCurrentTime] toUser:[Global getString:idsString] groupId:identityString ntType:[Global getNOTIFY_YY] detailText:@""];    
            }
            }
        
            [[NSUserDefaults standardUserDefaults] setInteger:[nConn findByGroup:identityString].ntId forKey:@"notifyId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        
            [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"forwardSounds"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        
            [self dismissModalViewControllerAnimated:YES];
        }else{
            Notify *n=[nConn findById:[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"]];
            if(n.toUser!=nil){
                NSArray *users=[n.toUser componentsSeparatedByString:@"|"];  
                NSMutableArray *array=[[NSMutableArray alloc]init];
                for(int i=0;i<[users count];i++){         
                    [array addObject:[NSNumber numberWithInteger:[[users objectAtIndex:i]intValue]]];
                }
                BOOL isExist=NO;
                for(int i=0;i<[chatArray count];i++){
                    NSIndexPath *indexPath=[chatArray objectAtIndex:i]; 
                    People *people =(People *)[[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]; 
                    for(int j=0;j<[users count];j++){
                        if(people.spId!=[[users objectAtIndex:j] intValue]){
                            isExist=YES;
                        } 
                    }
                    if(isExist){
                        [array addObject:[NSNumber numberWithInteger:people.spId]];
                        isExist=NO;
                    }
                }
                
                NSArray* arrayIds = [array sortedArrayUsingSelector:@selector(compare:)];
                
                NSMutableString *toUser=[[NSMutableString alloc]init];//toUser
                
                for(int i=0;i<[arrayIds count];i++){
                    [toUser appendString:[NSString stringWithFormat:@"%@|",[arrayIds objectAtIndex:i]]];
                } 

                [nConn updateToUser:[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"] toUser:[Global getString:toUser]];
                
                
            }
        }   
    }
}

-(IBAction)deleteUser:(id)sender{
    NSMutableArray *serverIds=[[NSMutableArray alloc]init];
    NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    if([chatArray count]>0){
        for(int i=0;i<[chatArray count];i++){
            NSIndexPath *indexPath=[chatArray objectAtIndex:i]; 
            People *people =(People *)[[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]; 
            
            for(int j=0;j<[mArray count];j++){
                People *p=[mArray objectAtIndex:j];
                if(p.spId==people.spId){   
                    [serverIds addObject:[NSNumber numberWithInteger:p.spId]];
                    continue;
                }
            }
        }
    }     
}

@end
