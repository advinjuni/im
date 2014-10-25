//
//  IMAccountDelegate.h
//  IMJabber
//
//  Created by wangjian on 10/22/14.
//  Copyright (c) 2014 Advin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMAccountDelegate <NSObject>

-(void) NewBuddyOnline:(NSString *)buddyname;
-(void) BuddyWentOffline:(NSString *)buddyname;

@end
