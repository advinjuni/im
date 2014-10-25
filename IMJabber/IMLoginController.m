//
//  IMLoginController.m
//  IMJabber
//
//  Created by wangjian on 10/21/14.
//  Copyright (c) 2014 Advin. All rights reserved.
//

#import "IMLoginController.h"
#import "IMAppDelegate.h"

@interface IMLoginController ()

@property (weak,nonatomic) IBOutlet UITableView *LoginVew;
@property (weak,nonatomic) IBOutlet UITextField *userfield;
@property (weak,nonatomic) IBOutlet UITextField *pwfield;

-(void) Goback;
-(IBAction) loginOn:(id)sender;

@end

@implementation IMLoginController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _userfield.delegate=self;
    _pwfield.delegate=self;


    
#pragma LOGIN INTERFACE
    UINavigationBar *navbar =[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, 320, 40)];
  //  [navbar setTintColor: [UIColor redColor]];
    UINavigationItem *navtitle =[[UINavigationItem alloc] initWithTitle:@"login"];
    [navbar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Courier" size:16.0], NSFontAttributeName,nil]];
  //  navtitle.leftBarButtonItem=barleft;
    [navbar pushNavigationItem:navtitle animated:YES];
    
    
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 100)];
    [headerview addSubview:navbar];
  //  [headerview addSubview:imageviewLeft];
    _LoginVew.tableHeaderView=headerview;
 //   [self.view addSubview:leftbutton];
    
    
}
#pragma textfiel delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



-(IBAction) loginOn:(id)sender
{
    if ([self validatewithUser:(NSString *)_userfield.text andPass:(NSString *)_pwfield.text] ) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *user=[NSString stringWithFormat:@"%@@advin",_userfield.text ];
        [userdefault setObject:user forKey:@"user"];
        [userdefault setObject:_pwfield.text forKey:@"password"];
        [userdefault setObject:@"localhost" forKey:@"server"];
        [userdefault synchronize];
        NSString *RESULT =[userdefault objectForKey:@"RESULT"];
     //   NSLog(@"%@",RESULT);

        if ([[self appdelegate] connect]) {
            if ([RESULT isEqualToString:@"NO"]) {
                
            }
            else
            {
                [self performSegueWithIdentifier:@"contactlist" sender:self];
            }
            //           NSLog(@"show buddy list");
            
        }
        
    }
    /*
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有设置账号" delegate:self cancelButtonTitle:@"设置" otherButtonTitles:nil, nil];
        [alert show];
    }
     */
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"login input" message:@"pls input login message" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
  //  if (![[self xmppStream] isAuthenticated]) {

        //        NSLog(@"lll");
 //   }
}
-(IMAppDelegate *) appdelegate
{
    return (IMAppDelegate *) [[UIApplication sharedApplication] delegate];
}

-(XMPPStream *) xmppStream
{
    return [[self appdelegate] xmppStream];
}
-(BOOL)validatewithUser:(NSString *)User andPass:(NSString *)Pw
    {
    if (User.length>0 && Pw.length>0 ) {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma receive memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
