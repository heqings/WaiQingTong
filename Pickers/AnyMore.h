//
//  AnyMore.h
//  Pickers
//
//  Created by air macbook on 12-2-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface AnyMore : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSDictionary *myData;
    UITableView *myTableView;
    NSString *url;
}
@property(nonatomic,strong) NSDictionary *myData;
@property(nonatomic,strong)IBOutlet UITableView *myTableView;
@end
