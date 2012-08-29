//
//  DoubleComponentPickerViewController.m
//  Pickers
//
//  Created by HeQing on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DoubleComponentPickerViewController.h"

#import "JsonServer.h"
#import "MBProgressHUD.h"
@interface DoubleComponentPickerViewController(private)
-(void)hideTabBar:(BOOL)hide;
-(void)searchTableSource:(NSString*)str;
@end

@implementation DoubleComponentPickerViewController

@synthesize table;


#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle{
    self = [super initWithNibName:nibName bundle:nibBundle];
    return self;
}
-(void)loadData
{
    //
    NSMutableArray*     allPeople = [[PeopleServices getConnection] findAll];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init]; 
    
  
    for(People *p in allPeople){
        if([dic objectForKey:p.groupPy]){
            NSMutableArray *getArry = [dic objectForKey:p.groupPy];
            [getArry addObject:p];
            
        }else{
            NSMutableArray *newArry = [[NSMutableArray alloc] init];
            [newArry addObject:p];
            [dic setObject:newArry forKey:p.groupPy];
        }
    }
   
    myData = dic;
    [table reloadData];
}
-(void)downloadCompanygates:(id)temp
{
    //
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    PeopleServices *conn=[PeopleServices getConnection];
    [conn clearPeople];
    NSArray* result = [JsonServer getCompanGates:user];
    for (People* p in result)
    {
        [conn insertPeople:p];
        if(![p.topimg isEqualToString:@""])
        {
            [JsonServer downloadUserTopImage:p.topimg];
        }
        //每次加入一个联系人都重新刷新界面
        
    }   
}
-(void)btnFlushPeople
{
    //
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"刷新联系人..." animated:TRUE];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
        
        dispatch_async(dispatch_get_main_queue(), ^{ 
            @try{
                 
                [self downloadCompanygates:nil];
                //[self downloadAreaPeople:nil];暂时不要目录树
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //更新界面
              
                [self viewWillAppear:true];
                
            }@catch (NSException* e) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([e.name isEqualToString:@"NetError"])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
                                                                    message:e.reason
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"参数错误"
                                                                    message:e.reason
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                
            }
        });  
    }); 
    //
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                             target:self
                                             action:@selector(btnFlushPeople)];
    //
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40)];  
    searchBar.placeholder = @"搜索";
    searchBar.delegate=self;
    table.tableHeaderView = searchBar;
    
    disableViewOverlay = [[UIView alloc]  
                          initWithFrame:CGRectMake(0.0f,40.0f,320.0f,416.0f)];  
    disableViewOverlay.backgroundColor=[UIColor blackColor];  
    disableViewOverlay.alpha = 0;
    //
    
    self.navigationItem.rightBarButtonItem.title=@"拼音";
    self.navigationItem.leftBarButtonItem.title=@"刷新";
    //
    searchBar.text=@"";
    isSearching=false;
   }
-(void)btnChangeGroupMode
{
    //
    
    //
}
-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    [self searchTableSource:searchBar.text];
    isHidden=NO;
    [self hideTabBar:NO];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    //
    isSearching=false;
    searchBar.text=@"";
    
    //
}
- (void)viewDidUnload{
    table=nil;
    myData=nil; 
    pyArray=nil;
    searchBar=nil;
    disableViewOverlay=nil; 
 
    [super viewDidUnload];
    
}

//切换分组

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return [[myData allKeys] count];  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return [[myData valueForKey:[arr objectAtIndex:section]] count];
}
-(UIImage*)getPeopleTopImage:(People*)p
{

    if(![p.topimg isEqualToString:@""])
    {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //
    NSString* fileName= [p.topimg lastPathComponent];
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    UIImage* image = [UIImage imageWithContentsOfFile:strPath];
    //
    CGSize size;
    size.width =  36;
    size.height = 36;
    UIGraphicsBeginImageContext(size);  
    // 绘制改变大小的图片  
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];  
    
    // 从当前context中创建一个改变大小后的图片  
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
    
    // 使当前的context出堆栈  
    UIGraphicsEndImageContext(); 
        return scaledImage;

    }else
    {
        UIImage* image = [UIImage imageNamed:@"header36"];
        return image;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:CellIdentifier];
    }
    //
    NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    //
    People* p= [[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    //
    cell.imageView.image = [self getPeopleTopImage:p];
    cell.textLabel.text  =p.name;  
	//特定section里面找到对应的array，
	//然后在array中找到indexPath.row所在的内容
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}
//分组标头
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     //return [[myData allKeys] objectAtIndex:section];
	//这里设置对应section的名字
	//用objectAtIndex: 来找出究竟是哪一个就可以了！
    if(isSearching)//如果正在搜索，不显示分组索引
        return @"";
    if([myData count]==0){
        return @"";
    }
    NSArray *sortedKeys = [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
       
    return [sortedKeys objectAtIndex:section];
}

//索引筛选
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
      if(isSearching)//如果正在搜索，不显示分组索引
         return 0;
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
    if(isSearching)//如果正在搜索，不显示分组索引
        return nil;
    return [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    isHidden=YES;
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    //self.navigationController.delegate = self;    
   
    NSArray* arr=[[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
   
    People* p = [[myData valueForKey:[arr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setInteger:p.spId forKey:@"choosePeople"];
            [[NSUserDefaults standardUserDefaults]synchronize];
    //
    MessageInfoViewController *info = [[MessageInfoViewController alloc]init];
    [self.navigationController pushViewController:info animated:YES]; 
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
    //
} 

//删除行
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        People *people=(People *)[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
//        [[PeopleServices getConnection] deleteById:people.pId];
//        [[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
//    }
//}

//将delete键显示成删除
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{  
//    return @"删除";  
//}


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
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hide) {
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 480-49, view.frame.size.width, view.frame.size.height)];
            }
        } 
        else 
        {
            if (hide) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480-49)];
            }
        }
    }
    [UIView commitAnimations];
}


#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)bar activate:(BOOL) active{
 
    self.table.allowsSelection = !active;  
    self.table.scrollEnabled = !active;  
    if (!active) {  
        isSearching=false;
        
        [disableViewOverlay removeFromSuperview];  
        [bar resignFirstResponder];  
    } else {
      
        isSearching=true;
        disableViewOverlay.alpha = 0;  
        [self.view addSubview:disableViewOverlay];  
        
        [UIView beginAnimations:@"FadeIn" context:nil];  
        [UIView setAnimationDuration:0.5];  
        disableViewOverlay.alpha = 0.8;  
        [UIView commitAnimations];  
        
        NSIndexPath *selected = [self.table   
                                 indexPathForSelectedRow];  
        if (selected) {  
            [table deselectRowAtIndexPath:selected   
                                 animated:NO];  
        }  
    }  
    [searchBar setShowsCancelButton:active animated:YES];  
    [table reloadData];
}  
- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText
{
    [self searchBar:searchBar activate:NO];  
    
    [self searchTableSource:bar.text];
    [self.table reloadData]; 
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)bar {  
    
    [self searchBar:bar activate:YES];  
}  

- (void)searchBarCancelButtonClicked:(UISearchBar *)bar
{
    bar.text=@"";
    [self searchBar:searchBar activate:NO];  
    
    [self loadData ];
}

-(void)searchTableSource:(NSString*)str{
    
    if([str isEqualToString:@""])
    {
        [self loadData];
    
    }else
    {
    for (NSString*  cs in [myData allKeys])
    {
        NSMutableArray* arr = [myData valueForKey:cs];
        NSArray* b = [NSArray arrayWithArray:arr];
        for(People* p in b)
        {
            NSRange r = [p.name rangeOfString:str];
            if(r.location ==NSNotFound && ![str isEqualToString:@""])
            {
                [arr removeObject:p];
            }
        }
        if(arr.count == 0)
        {
            [myData removeObjectForKey:cs];
        }
    }
    }
    //
    
}


@end
