//
//  VisitListViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VisitListViewController.h"


@implementation VisitListViewController
@synthesize table,cellsDataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"我的拜访";
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"新增" 
                                                                  style:UITabBarSystemItemContacts target:self action:@selector(newBtnClick:)]; 
    self.navigationItem.rightBarButtonItem= newButton;
    cellsDataArray=[[NSMutableArray alloc]init];
    NotifyPlanServices *conn=[NotifyPlanServices getConnection];
    cellsDataArray=[conn findAll];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

//新增按钮事件
-(void)newBtnClick:(id)sender{
    isHidden=YES;
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;  
    
    VisitFromViewController *from=[[VisitFromViewController alloc]init];
    from.workUtilsDelegate=self;
    [self.navigationController pushViewController:from animated:YES];
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
    NotifyPlanE *plan=(NotifyPlanE *)[cellsDataArray objectAtIndex:indexPath.row];

	[cell.textLabel setText:plan.npContent];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
    
//    ApplyViewDetailViewController* alp =  [[ApplyViewDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
//    alp.apply = (Apply *)[cellsDataArray objectAtIndex:indexPath.row];;
//    [self.navigationController pushViewController:alp animated:true];
    
}

//刷新表格
-(void)reloadTableView{
    NotifyPlanServices *conn=[NotifyPlanServices getConnection];
    cellsDataArray=[conn findAll];
    [table reloadData];
}

//视图显示前调用
-(void)viewWillAppear:(BOOL)animated{
    isHidden=NO;
    [self hideTabBar:NO];
}

//视图跳转不显示时调用
-(void)viewWillDisappear:(BOOL)animated{
    if(isHidden==YES){
        [self hideTabBar:YES];
    }
}

//隐藏底部菜单栏
-(void)hideTabBar:(BOOL)hide{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    for(UIView *view in self.tabBarController.view.subviews){
        if([view isKindOfClass:[UITabBar class]]){
            if (hide) {
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 480-49, view.frame.size.width, view.frame.size.height)];
            }
        } else {
            if (hide) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480-49)];
            }
        }
    }
    [UIView commitAnimations];
}
@end
