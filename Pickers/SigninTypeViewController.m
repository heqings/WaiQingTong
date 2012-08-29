//
//  SigninTypeViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SigninTypeViewController.h"

@implementation SigninTypeViewController
@synthesize myData,myTable,workUtilsDelegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"标注类型";
    NSString *jsonString =@"{\"一\":[\"门店\",\"渠道\",\"其他\"]}";
    
    myData = [jsonString JSONValue];
}

- (void)viewDidUnload
{
    myData=nil;
    myTable=nil;
    [super viewDidUnload];
    
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[myData valueForKey:[[myData allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:CellIdentifier];
    }
	cell.textAlignment=UITextAlignmentCenter;
	cell.textLabel.text = [[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    return cell;
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [workUtilsDelegate chooseTypeName:[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
    [self.navigationController popViewControllerAnimated:YES];
} 


@end
