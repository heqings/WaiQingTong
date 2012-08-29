//
//  WorkplanViewController.m
//  Pickers
//
//  Created by air macbook on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WorkplanViewController.h"
#import "WorkplanDetailViewController.h"
@implementation WorkplanViewController
@synthesize myTable,cellsDataArray;

//创建返回按钮，页面跳转动画
-(void)pageForward{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
   // self.navigationController.delegate = self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *planButton = [[UIBarButtonItem alloc] initWithTitle:@"新增" 
                                                                   style:UITabBarSystemItemContacts target:self action:@selector(newBtnClick:)]; 
    
    self.navigationItem.rightBarButtonItem= planButton;
    self.navigationItem.title=@"我的工作";
   // self.navigationController.delegate = self;

    WorkLogServices *conn=[WorkLogServices getConnection];
    cellsDataArray=[conn findAll];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

//新增按钮事件
-(void)newBtnClick:(id)sender{
    [self pageForward];
    NewPlanViewController *plan = [[NewPlanViewController alloc]init];  
    plan.workUtilsDelegate=self; 
    [self.navigationController pushViewController:plan animated:YES];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellsDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    WorkLog *workLog=(WorkLog *)[cellsDataArray objectAtIndex:indexPath.row];
    UIImage *image;
    if([workLog.type isEqualToString:@"P"]){
       image = [UIImage imageNamed:@"workicon_2"];
    }else{
        image = [UIImage imageNamed:@"workicon_1"];
    }

    cell.imageView.image = image;
    
    UIFont *font = [UIFont systemFontOfSize:18];
    UIFont *font1 = [UIFont systemFontOfSize:16];
    
    [cell.textLabel setFont:font];
	[cell.textLabel setText:workLog.content];
    [cell.detailTextLabel setFont:font1];
    [cell.detailTextLabel setText:workLog.createTime];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;

    WorkplanDetailViewController* wl = [[WorkplanDetailViewController alloc] init];
   
    wl.workLog = (WorkLog *)[cellsDataArray objectAtIndex:indexPath.row];
  
    [self.navigationController pushViewController:wl animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
} 

//删除行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WorkLog *work=(WorkLog *)[cellsDataArray objectAtIndex:indexPath.row];
        [[WorkLogServices getConnection] deleteById:work.workId];
        [cellsDataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

//将delete键显示成删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{  
    return @"删除";  
}

//刷新表格
-(void)reloadTableView{
    WorkLogServices *conn=[WorkLogServices getConnection];
    cellsDataArray=[conn findAll];
    [myTable reloadData];
}

@end
