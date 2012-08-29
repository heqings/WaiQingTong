//
//  AnyMore.m
//  Pickers
//
//  Created by air macbook on 12-2-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnyMore.h"
#import "PersonInfoController.h"
#import "PersonSignController.h"
#import "GeneralSettingController.h"
#import "AccountManageController.h"
#import "SuggestionBackController.h"
#import "AboutUS.h"
#import "SectionViewController.h"
#import "OtherViewController.h"
#import "DoubleComponentPickerViewController.h"
@implementation NSString(compare)

-(NSComparisonResult)floatCompare:(NSString*)other
{
    
    float myValue = [self floatValue];
    float otherValue= [other floatValue];
    if(myValue == otherValue) return NSOrderedSame;
    return (myValue < otherValue ? NSOrderedAscending : NSOrderedDescending);
}

@end
@implementation AnyMore

@synthesize myTableView,myData;
#pragma mark view methods

-(void)viewDidLoad{
    NSString *jsonString =@"{\"1\":[\"个人名片\",\"个性签名\"],\"2\":[\"通用设置\",\"帐号管理\"],\"3\":[\"意见反馈\",\"检测版本\",\"关于我们\"]}";

    myData = [jsonString JSONValue]; 
     
    /*
	for (int section = 0; section < [myTableView numberOfSections]; section++) {
		for (int row = 0; row < [myTableView numberOfRowsInSection:section]; row++) {
			[[myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]] setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
	}*/
    [super viewDidLoad];
}

-(void)viewDidUnload{
    myTableView=nil;
	myData=nil;
    url=nil;
    [super viewDidUnload];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [myData count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      NSArray* temp=   [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return [[myData valueForKey:[temp objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger count=[indexPath row];
    NSArray* temp=   [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *text=[[myData valueForKey:[temp objectAtIndex:indexPath.section]] objectAtIndex:count];
    
    if([text isEqualToString:@"个人名片"]){
        cell.imageView.image = [UIImage imageNamed:@"setting_1"];
    }else if([text isEqualToString:@"个性签名"]){
         cell.imageView.image = [UIImage imageNamed:@"setting_2"];
    }else if([text isEqualToString:@"通用设置"]){
         cell.imageView.image = [UIImage imageNamed:@"setting_3"];
    }else if([text isEqualToString:@"帐号管理"]){
         cell.imageView.image = [UIImage imageNamed:@"setting_4"];
    }else if([text isEqualToString:@"意见反馈"]){
         cell.imageView.image = [UIImage imageNamed:@"setting_5"];
    }else if([text isEqualToString:@"检测版本"]){
         cell.imageView.image = [UIImage imageNamed:@"setting_6"];
    }else if([text isEqualToString:@"关于我们"]){
         cell.imageView.image = [UIImage imageNamed:@"setting_7"];
    }
    
	[cell.textLabel setText:text];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
      NSArray* temp=   [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *text=[[myData valueForKey:[temp objectAtIndex:indexPath.section]] objectAtIndex:[indexPath row]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
       if([text isEqualToString:@"个人名片"])
    {
                PersonInfoController *controller = [[PersonInfoController alloc] initWithNibName:@"PersonInfoController" bundle:nil] ;  
        controller.title=text;

        [self.navigationController pushViewController:controller animated:YES];
        
        
    }else if([text isEqualToString:@"个性签名"]){

        PersonSignController* controller = [[PersonSignController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if([text isEqualToString:@"通用设置"]){

        GeneralSettingController* controller = [[GeneralSettingController alloc]initWithStyle:UITableViewStyleGrouped];
        controller.title=text;

        [self.navigationController pushViewController:controller animated:YES];
    }else if([text isEqualToString:@"帐号管理"]){
        AccountManageController* controller = [[AccountManageController alloc]initWithStyle:UITableViewStyleGrouped];
        controller.title=text;

        [self.navigationController pushViewController:controller animated:YES];
    }else if([text isEqualToString:@"意见反馈"]){
       
        SuggestionBackController* controller =[[SuggestionBackController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if([text isEqualToString:@"关于我们"]){
        AboutUS* ab = [[AboutUS alloc]init];
        [self.navigationController pushViewController:ab animated:YES];
    }else{
        @try {
            NSString *retrunVal=[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=536500293"] encoding:NSUTF8StringEncoding error:nil];
            if(retrunVal!=nil){
                NSDictionary *resultDict= [retrunVal JSONValue];
                if(resultDict!=nil){
                    NSArray *array=[resultDict objectForKey:@"results"];
                    double currentVersion=[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] doubleValue];
                    double newVersion=[[[array objectAtIndex:0] objectForKey:@"version"] doubleValue];
                    
                    if(newVersion >currentVersion){
                        url=[[NSString alloc]init];
                        url=[[array objectAtIndex:0] objectForKey:@"trackViewUrl"];
                        
                        NSString *title=[NSString stringWithFormat:@"升级到%@版",[[[array objectAtIndex:0] objectForKey:@"version"] substringToIndex:3]];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                        message:[[array objectAtIndex:0] objectForKey:@"releaseNotes"]
                                                                       delegate:self
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"升级", nil];
                        [alert show];
                    }else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                        message:@"已经是最新版本"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            @throw exception;
        }
    }  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
} 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex!=alertView.cancelButtonIndex){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
} 
@end
