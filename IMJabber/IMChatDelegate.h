//
//  IMChatDelegate.h
//  IMJabber
//
//  Created by wangjian on 10/22/14.
//  Copyright (c) 2014 Advin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMChatDelegate <NSObject>

-(void) NewMessageReceived:(NSDictionary *)messagecontent;

@end
