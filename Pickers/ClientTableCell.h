//
//  ClientTableCell.h
//  Pickers
//
//  Created by 张飞 on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientTableCell : UITableViewCell{
    
    IBOutlet UILabel *linkname;
    IBOutlet UILabel *linkmobile;
    IBOutlet UILabel *officetel;
    IBOutlet UILabel *email;
    IBOutlet UILabel *remark;
    IBOutlet UIImageView *img;
    IBOutlet UIImageView *bottom;
}

@property(nonatomic,strong)IBOutlet UILabel *linkname;
@property(nonatomic,strong)IBOutlet UILabel *linkmobile;
@property(nonatomic,strong)IBOutlet UILabel *officetel;
@property(nonatomic,strong)IBOutlet UILabel *email;
@property(nonatomic,strong)IBOutlet UILabel *remark;
@property(nonatomic,strong)IBOutlet UIImageView *img;;
@property(nonatomic,strong)IBOutlet UIImageView *bottom;
@end
