//
//  IMChatController.m
//  IMJabber
//
//  Created by wangjian on 10/21/14.
//  Copyright (c) 2014 Advin. All rights reserved.
//

#import "IMChatController.h"
#import "IMAppDelegate.h"
#import "IMTableViewCell.h"
#import  <sqlite3.h>

@interface IMChatController ()
{
    NSMutableArray *messages;
    sqlite3 *database;
    int count;
//    NSString *chatusername;
}
-(NSString *) databasepath;

//{
  //  NSString *label;
//}
@property (strong,nonatomic) IBOutlet UITableView *tableview;

//@property (strong,nonatomic) IBOutlet UIBarButtonItem *barleft;


@end

@implementation IMChatController

//@synthesize labeltext=_labeltext;

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
    IMAppDelegate *delegate = [self appdelegate];
    delegate.chatDelegate=self;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    
    if (sqlite3_open([[self databasepath] UTF8String], &database)!=SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"failed to open database");
    }
 //   NSLog(@"data path %@",[self databasepath]);
    NSString *createsql=@"CREATE TABLE IF NOT EXISTS MESSAGES" "(ROW INTEGER PRIMARY KEY,MESSAGE TEXT,SENDER TEXT);";
    char *error ;
    if (sqlite3_exec(database, [createsql UTF8String], NULL, NULL, &error) !=SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"error message create table:%s",error);
    }
    
    
    messages=[NSMutableArray array];
    UINavigationBar *navbar =[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, 320, 40)];
  //  [navbar setTintColor: [UIColor redColor]];
    UINavigationItem *navtitle =[[UINavigationItem alloc] initWithTitle:@"chat"];
    [navbar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Courier" size:16.0], NSFontAttributeName,nil]];
    //[setTitleTextAttributes];
#pragma image resource

    UIButton *leftbutton =[[UIButton alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
    leftbutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftbutton.bounds=CGRectMake(0, 0, 40, 30);
    leftbutton.titleLabel.font=[UIFont fontWithName:@"Courier" size:11];
    [leftbutton setTitle:@"list" forState:UIControlStateNormal];
    [leftbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    leftbutton.backgroundColor=[UIColor clearColor];

 //   [leftbutton setImage:imageLeftNormal forState:UIControlStateNormal];
//    [leftbutton setImage:imageLeftHilight forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barleft=[[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    navtitle.leftBarButtonItem=barleft;
    [navbar pushNavigationItem:navtitle animated:YES];
    [self.view addSubview:navbar];

    UIButton *send=[[UIButton alloc] init];
    send=[UIButton buttonWithType:UIButtonTypeRoundedRect];
   // send.frame =CGRectMake(200, 5, 50, 25);
    send.bounds=CGRectMake(0, 0, 40, 30);
   //send.titleLabel.text=@"Send";
    send.titleLabel.font=[UIFont fontWithName:@"Courier" size:11];
    //send.titleLabel.textColor=[UIColor blueColor];
    [send setTitle:@"send" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    send.backgroundColor=[UIColor clearColor];
    [send addTarget:self action:@selector(Sender:) forControlEvents:UIControlEventTouchUpInside];
    
    _textfield.rightView=send;
    _textfield.rightViewMode=UITextFieldViewModeWhileEditing;
    
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
 //   _navbartitile.leftBarButtonItem =barleft;
}

-(void) viewWillAppear:(BOOL)animated
{
    if (sqlite3_open([[self databasepath] UTF8String], &database)!=SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"failed to open database");
    }
    NSString *query=@"SELECT ROW,MESSAGE,SENDER FROM MESSAGES ORDER BY ROW";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, nil) ==SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int row = sqlite3_column_int(stmt, 0);
            char *msgdata = (char *) sqlite3_column_text(stmt, 1);
            char *senderdata = (char *) sqlite3_column_text(stmt, 2);
            NSString *msg =[[NSString alloc] initWithUTF8String:msgdata];
            NSString *sender =[[NSString alloc] initWithUTF8String:senderdata];
            NSLog(@"row %d content %@ sender %@",row,msg, sender);
            NSMutableDictionary *dict =[NSMutableDictionary dictionary];
            [dict setValue:msg forKey:@"msg"];
            [dict setValue:sender forKey:@"sender"];
            [messages addObject:dict];
        }
        sqlite3_finalize(stmt);
    }
    
    sqlite3_close(database);
    count =[messages count];
    NSLog(@"initial row %d",count);
}

-(void) viewWillDisappear:(BOOL)animated
{
    
    int row=(int) [messages count];
 //   NSUserDefaults *
    NSLog(@"final row %d",row);
    if (sqlite3_open([[self databasepath] UTF8String], &database)!=SQLITE_OK)
    {
        sqlite3_close(database);
        NSAssert(0, @"failed to open database");
    }
    for (int i=(int) count; i<row; i++)
    {
        
        NSDictionary *dict =[ messages objectAtIndex:i];
        NSString *msg= [dict objectForKey:@"msg"];
        NSString *sender=[dict objectForKey:@"sender"];
        char *update="INSERT OR REPLACE INTO MESSAGES (ROW, MESSAGE,SENDER)" "VALUES(?,?,?);";
        char *error;
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) ==SQLITE_OK)
        {
            sqlite3_bind_int(stmt, 1, i);
             sqlite3_bind_text(stmt, 2, [msg UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3, [sender UTF8String], -1, NULL);
        }
        
        if(sqlite3_step(stmt) != SQLITE_DONE )
        {
            NSAssert(0, @"error update table: %s",error);
        }
        
        sqlite3_finalize(stmt);
    }
    sqlite3_close(database);


}

-(NSString *) databasepath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentdir= [paths objectAtIndex:0];
    return [documentdir stringByAppendingPathExtension:@"data.sqlite"];
}

#pragma button action
-(void) Goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tableview datasource and delegate
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
   static NSString *From =@"ChatCell";
  //  static NSString *TO =@"TO";
    NSString *FROMORUSER=nil;

   NSMutableDictionary *dict = [messages objectAtIndex:indexPath.row];
    NSString *msg=[ dict objectForKey:@"msg"];
    FROMORUSER=[dict objectForKey:@"sender"];
 //   NSLog(@"%@",FROMORUSER);
   IMTableViewCell *cell=[[IMTableViewCell alloc] init];
    if ([FROMORUSER isEqualToString:@"you"]) {
        cell =[tableView dequeueReusableCellWithIdentifier:From];
        cell.from =[[UILabel alloc] initWithFrame:CGRectMake(10,10,10,20)];
        cell.from.text =msg;
        cell.from.font= [UIFont fontWithName:@"Courier" size:11];
        cell.from.frame= CGRectMake(10,10,[self passlable:cell.from].width , 20);
//        NSLog(@"%f",[self passlable:cell.from].width);

 //       CGSize size = [frommsg sizeWithFont:cell.from.font ];
//       [ cell.from setFrame:CGRectMake(10, 0, size.width, 20)];
      cell.to =[[UILabel alloc] initWithFrame:CGRectMake(230,10,40 , 20)];
        cell.to.text =@"advin";
        cell.to.font= [UIFont fontWithName:@"Courier" size:9];
        [cell.contentView addSubview:cell.from];
        [cell.contentView addSubview:cell.to];

    } else {
        cell =[tableView dequeueReusableCellWithIdentifier:From];
       // NSString *tomsg=[ dict objectForKey:@"msg"];
        cell.to =[[UILabel alloc] init];
        cell.to.text =msg;
        cell.to.font= [UIFont fontWithName:@"Courier" size:11];
        cell.to.frame= CGRectMake(310-[self passlable:cell.to].width,10 ,[self passlable:cell.to].width , 20);
        cell.from =[[UILabel alloc] initWithFrame:CGRectMake(10,10,40 , 20)];
        cell.from.text =@"honey";
        cell.from.font= [UIFont fontWithName:@"Courier" size:9];
        [cell.contentView addSubview:cell.from];
        [cell.contentView addSubview:cell.to];
    }

    cell.accessoryType=UITableViewCellAccessoryNone;
  return cell;
}

-(CGSize) passlable:(UILabel*) label
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSDictionary * attributes = @{NSFontAttributeName : label.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT,label.frame.size.height)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // NSLog(@"message accout %d",[messages count]);
 return [messages count];
   // return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark app delegate
-(IMAppDelegate *) appdelegate
{
    return (IMAppDelegate *) [[UIApplication sharedApplication] delegate];
}

-(XMPPStream *) xmppStream
{
    return [[self appdelegate] xmppStream];
}

#pragma mark receive and send message
-(void) NewMessageReceived:(NSDictionary *)messagecontent
{
    [messages addObject:messagecontent];
  //  NSLog(@"%@",messagecontent);
    [self.tableview reloadData];
}

-(void)Sender:(id)sender
{
    NSString *message = self.textfield.text;
    if (message.length >0) {
        NSXMLElement *body =[NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        
        NSXMLElement *mes=[NSXMLElement elementWithName:@"message"];
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        [mes addAttributeWithName:@"to" stringValue:_chatusername];
     //   NSLog(@"to who %@",_chatusername);
        [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"user"]];
        [mes addChild:body];
        [[self xmppStream] sendElement:mes];
         
        self.textfield.text=@"";
        [self.textfield resignFirstResponder];
         
         NSMutableDictionary *dict =[NSMutableDictionary dictionary];
         [dict setObject:message forKey:@"msg"];
        [dict setObject:@"you" forKey:@"sender"];
         [messages addObject:dict];
        

        }
       // NSLog(@"message %@",messages );
         [self.tableview reloadData];
         
         
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/*
 NSString *imagenormal = [[NSBundle mainBundle] pathForResource:@"nav_arrow_d" ofType:@"png"];
 NSString *imagehilight = [[NSBundle mainBundle] pathForResource:@"nav_arrow_d-1" ofType:@"png"];
 
 // NSLog(@"Image Path %@",imagehilight);
 
 UIImage *imageLeftNormal =[ UIImage imageWithContentsOfFile:imagenormal];
 UIImage *imageLeftHilight =[ UIImage imageWithContentsOfFile:imagehilight];
 //  UIImageView *imageviewLeft =[[ UIImageView alloc] initWithImage:imageLeftNormal];
 // imageviewLeft.frame = CGRectMake(10, 20, 60, 40);
 if ([[NSFileManager defaultManager] fileExistsAtPath:imagenormal ]== NO)
 {
 NSLog(@"Image not exists here");
 }
 */


@end
