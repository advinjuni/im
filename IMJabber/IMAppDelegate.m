//
//  IMAppDelegate.m
//  IMJabber
//
//  Created by wangjian on 10/21/14.
//  Copyright (c) 2014 Advin. All rights reserved.
//

#import "IMAppDelegate.h"
#import "IMChatController.h"
#import "IMAccountController.h"

@implementation IMAppDelegate

@synthesize xmppStream;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self disconnect];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self connect];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma xmppstream
-(void) setupStream
{
    xmppStream=[[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_current_queue()];
    
}
-(void)goOnline
{
    XMPPPresence *presence =[XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}
-(void)goOffline
{
    XMPPPresence *presence =[XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];

}
-(BOOL) connect
{
    [self setupStream];
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    NSString *userid    =[ defaults stringForKey:@"user"];
    NSString *password  =[ defaults stringForKey:@"password"];
    NSString *server    =[ defaults stringForKey:@"server"];
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    if (userid==nil || password ==nil) {
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:userid]];
    
    [xmppStream setHostName:server];
    
    passWord =password;
    
   NSError *error=nil;
 
//   if (![ xmppStream connect:&error])
    NSTimeInterval time =5;
    if(![xmppStream connectWithTimeout:time error:&error])
    {
    
        NSLog(@"can't connect %@",server);
        return NO;
    }
  
    return YES;
}
-(void) disconnect
{
    [self goOffline];
    [xmppStream disconnect];
}

#pragma mark xmpp delegate
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    isOpen=YES;
    NSError *error=nil;
  // NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    //NSString *tmp=  [userdefault objectForKey:@"password"];
   NSLog(@"password %@", passWord);
  //
    [[self xmppStream] authenticateWithPassword:passWord error:&error];
  //  NSLog(@"authenicate %@",authenicate?@"YES":@"NO");

}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSUserDefaults *pass =[NSUserDefaults standardUserDefaults];
    [pass setObject:@"NO" forKey:@"RESULT"];
    [pass synchronize];
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"incorrect" message:@"password incorrect" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alert show];
}
-(void) xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSUserDefaults *pass =[NSUserDefaults standardUserDefaults];
    [pass setObject:@"YES" forKey:@"RESULT"];
    [pass synchronize];
    [self goOnline];
}

-(void) xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    if ([message isChatMessageWithBody])
    {
        NSString *msg=[[message elementForName:@"body"] stringValue];
        NSString *from=[[message attributeForName:@"from"] stringValue];
        
        
        NSMutableDictionary *m= [[NSMutableDictionary alloc] init];
        [m setObject:msg forKey:@"msg"];
        [m setObject:from forKey:@"sender"];
        [_chatDelegate NewMessageReceived:m];
//        return;
    }

  
}

-(void) xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSString *presenceType=[presence type];
    NSString *userid= [[sender myJID]user];
    NSString *presencefromuser=[[presence from]user];
 //  NSLog(@"presencerfromuser %@",presencefromuser);
 //      NSLog(@"userid %@",userid);
    
    if (![presencefromuser isEqualToString:userid]) {
        if ([presenceType isEqualToString:@"available"])
        {
   //         NSLog(@"add buddy name %@",presencefromuser);
            [_messageDelegate NewBuddyOnline:[NSString stringWithFormat:@"%@@%@",presencefromuser,@"advin"]];
        }
        else if ([presenceType isEqualToString:@"unavailable"])
        {
            [_messageDelegate BuddyWentOffline:[NSString stringWithFormat:@"%@@%@",presencefromuser,@"advin"]];

        }
    }
    
}

@end
