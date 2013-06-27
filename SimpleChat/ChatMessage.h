//
//  ChatMessage.h
//  SimpleChat
//
//  Created by iris on 13-6-25.
//  Copyright (c) 2013年 iris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessage : NSObject
@property NSString *content;
@property NSString *from;
@property NSDate *datetime;
@end
