//
//  ApplyViewController.m
//  Pickers
//
//  Created by air macbook on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ApplyViewController.h"
#import "ApplyViewDetailViewController.h"
@implementation ApplyViewController
@synthesize myTable,cellsDataArray;



#pragma mark - View lifecycle
//创建返回按钮，页面跳转动画
-(void)pageForward{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    //self.navigationController.delegate = self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"新增" 
                                                                    style:UITabBarSystemItemContacts target:self action:@selector(newBtnClick:)]; 
    
    self.navigationItem.rightBarButtonItem= applyButton;
    self.navigationItem.title=@"我的申请";
    
    ApplyServices *conn=[ApplyServices getConnection];
    cellsDataArray=[conn findAll];
    
}

//新增按钮事件
-(void)newBtnClick:(id)sender{
    [self pageForward];
    NewApplyViewController *apply=[[NewApplyViewController alloc]init];
    apply.workUtilsDelegate=self;
    [self.navigationController pushViewController:apply animated:YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
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
    Apply *apply=(Apply *)[cellsDataArray objectAtIndex:indexPath.row];
    
    UIImage *image; 
    if([apply.appType isEqualToString:@"H"]){
        image = [UIImage imageNamed:@"shenqing_icon_hd"];
       
    }else if([apply.appType isEqualToString:@"F"]){
        image = [UIImage imageNamed:@"shenqing_icon_fy"];

    }else if([apply.appType isEqualToString:@"C"]){
        image = [UIImage imageNamed:@"shenqing_icon_cc"];

    }else if([apply.appType isEqualToString:@"Q"]){
        image = [UIImage imageNamed:@"shenqing_icon_qt"];

    }
    cell.imageView.image = image;
    
    UIFont *font = [UIFont systemFontOfSize:18];
    UIFont *font1 = [UIFont systemFontOfSize:16];
    
    [cell.textLabel setFont:font];
	[cell.textLabel setText:apply.content];
    [cell.detailTextLabel setFont:font1];
    [cell.detailTextLabel setText:apply.applyTime];
    
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
    
    ApplyViewDetailViewController* alp =  [[ApplyViewDetailViewController alloc]init];
    alp.apply = (Apply *)[cellsDataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:alp animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
}

//删除行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Apply *apply=(Apply *)[cellsDataArray objectAtIndex:indexPath.row];
        [[ApplyServices getConnection] deleteById:apply.appId];
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
    ApplyServices *conn=[ApplyServices getConnection];
    cellsDataArray=[conn findAll];
    [myTable reloadData];
}

@end
