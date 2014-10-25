//
//  IMAppDelegate.h
//  IMJabber
//
//  Created by wangjian on 10/21/14.
//  Copyright (c) 2014 Advin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"

@interface IMAppDelegate : UIResponder <UIApplicationDelegate>
{
 //   XMPPStream *xmppStream;
    NSString *passWord;
    BOOL isOpen;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong,readonly) XMPPStream *xmppStream;

@property (nonatomic,retain) id chatDelegate;

@property (nonatomic,retain) id messageDelegate;

-(BOOL) connect;

-(void) disconnect;

-(void) setupStream;

-(void) goOnline;

-(void) goOffline;

@end
