//
//  IMChatController.h
//  IMJabber
//
//  Created by wangjian on 10/21/14.
//  Copyright (c) 2014 Advin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMChatDelegate.h"
#import  <sqlite3.h>

@interface IMChatController : UIViewController< UITableViewDataSource,UITableViewDelegate,IMChatDelegate>


@property (retain,nonatomic) NSString *chatusername;
//@property (weak,nonatomic) NSString *labeltext;
//@property (weak ,nonatomic) IBOutlet UILabel *label;
@property (weak,nonatomic) IBOutlet UITextField *textfield;

//-(IBAction)Sender:(id)sender;
-(void) Goback;
//-(IBAction)Goback:(id)sender;

@end
