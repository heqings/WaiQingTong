//
//  DivertViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DivertViewController.h"
#define VIEW   100
#define TEXTFIELD   200

@implementation DivertViewController
@synthesize workUtilsDelegate,table,cellsDataArray,myData;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    cellsDataArray=[[PeopleServices getConnection] findAll];
    self.navigationItem.title=@"申请转移";
    myData = [[NSMutableDictionary alloc] init]; 
    for(People *p in cellsDataArray){
        if([myData objectForKey:p.groupPy]){
            NSMutableArray *getArry = [myData objectForKey:p.groupPy];
            [getArry addObject:p.name];
            
        }else{
            NSMutableArray *newArry = [[NSMutableArray alloc] init];
            [newArry addObject:p.name];
            [myData setObject:newArry forKey:p.groupPy];
        }
    }
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    table=nil;
    cellsDataArray=nil;
    myData=nil;
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

	NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    cell.textLabel.text = [[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
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
    NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    currentName=[[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
													message:[NSString stringWithFormat:@"您确定要转移申请给%@?",currentName]
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确定", nil];

	[alert show];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
} 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES];
    for(People *p in cellsDataArray){
        if([p.name isEqualToString:currentName]){
            NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
            User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
            NSDictionary *dic=[
                               [NSDictionary alloc] 
                               initWithObjects:
                               [NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"sqSpId"],[NSString stringWithFormat:@"%i",p.spId],[Global getKey],user.imei,nil]
                               forKeys:[NSArray arrayWithObjects:@"server_id",@"handler_id",@"key",@"imei",nil]
                               ];
            
            NSString *json=[dic JSONRepresentation];
            NSMutableData *postBody = [NSMutableData data];
            NSString *param =[NSString stringWithFormat:@"param=%@",json];
            [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
            
            
            [[NetUtils shareNetworkHelper] requestDataFromURL:@"apply/applytransfer" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
            break;
        }
    }
    
}

- (void)requestSuccess:(NSObject*)result{
    [[NSUserDefaults standardUserDefaults]setObject:@"true" forKey:@"divert"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [workUtilsDelegate reloadTableView];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)requestFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

-(IBAction)backBtnClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

@end
