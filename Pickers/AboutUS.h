//
//  AboutUS.h
//  Pickers
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUS : UIViewController{
    UILabel *versionLab;
}
@property(nonatomic,retain)IBOutlet UILabel *versionLab;
-(IBAction)callTel:(id)sender;
@end
