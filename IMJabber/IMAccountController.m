//
//  IMAccountController.m
//  IMJabber
//
//  Created by wangjian on 10/21/14.
//  Copyright (c) 2014 Advin. All rights reserved.
//

#import "IMAccountController.h"
#import "IMChatController.h"
#import "IMAppDelegate.h"

@interface IMAccountController ()
{
    NSMutableArray *onlineusers;
    NSString *chatuser;
}

@property (weak,nonatomic) IBOutlet UITableView *tableview;

@end

@implementation IMAccountController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    IMAppDelegate *delegate =[self appdelegate];
    delegate.messageDelegate=self;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    onlineusers=[NSMutableArray array];
    UINavigationBar *navbar =[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, 320, 40)];
    //  [navbar setTintColor: [UIColor redColor]];
    UINavigationItem *navtitle =[[UINavigationItem alloc] initWithTitle:@"list"];
    [navbar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Courier" size:16.0], NSFontAttributeName,nil]];

    [navbar pushNavigationItem:navtitle animated:YES];
#pragma mark button
    UIButton *back=[[UIButton alloc] init];
    back=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    back.bounds=CGRectMake(0, 0, 40, 30);
    back.titleLabel.font=[UIFont fontWithName:@"Courier" size:11];
    [back setTitle:@"count" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    back.backgroundColor=[UIColor clearColor];
    [back addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barleft =[[ UIBarButtonItem alloc] initWithCustomView:back];
  //  UIBarButtonItem *barright =[[ UIBarButtonItem alloc] initWithCustomView:logout];
    
    navtitle.leftBarButtonItem=barleft;
  //  navtitle.rightBarButtonItem=barright;
    [self.view addSubview:navbar];

    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    if (login) {
        
      
        
    }
}
-(void) Goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark implement account delegate

-(IMAppDelegate *) appdelegate
{
    return (IMAppDelegate *) [[UIApplication sharedApplication] delegate];
}

-(XMPPStream *) xmppStream
{
    return [[self appdelegate] xmppStream];
}

-(void) NewBuddyOnline:(NSString *)buddyname
{
    if (![onlineusers containsObject:buddyname]) {
     //   NSLog(@"don't contains object %@",buddyname);
        [onlineusers addObject:buddyname];
        [self.tableview reloadData];
    }
//    NSLog(@"%@",onlineusers);

    
}

-(void) BuddyWentOffline:(NSString *)buddyname
{
    [onlineusers removeObject:buddyname];
    [self.tableview reloadData];
}


#pragma TABLEVIEW datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //  NSLog(@"onlineusers array object %d",[onlineusers count]);
    return [onlineusers count];
   // return 2;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId= @"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSString *tmp= [onlineusers objectAtIndex:[indexPath row]];
    NSRange range =[tmp rangeOfString:@"@"];
    NSRange range1;
    range1.location=0;
    range1.length=range.location++;
    NSString *final =[ tmp substringWithRange:range1];
    cell.textLabel.font=[UIFont fontWithName:@"Courier" size:11];
    cell.textLabel.text =final;
    NSLog(@"%@",[onlineusers objectAtIndex:[indexPath row]]);
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatuser = (NSString*)[onlineusers objectAtIndex:[indexPath row]];
    NSLog(@"object at index path %@",chatuser);
   // [self performSegueWithIdentifier:@"messagelist" sender:self];
    return indexPath;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    IMChatController *destination = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"messagelist"] ) {
        destination.chatusername=chatuser;
        NSLog(@"pass value%@",chatuser);

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
