//
//  main.m
//  SimpleChat
//
//  Created by iris on 13-6-24.
//  Copyright (c) 2013年 iris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "SimpleChatAppDelegate.h"
#import "SRWebSocket.h"


#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

FMDatabase *mydb ;
SRWebSocket *_webSocket;
NSString *me;

int main(int argc, char *argv[])
{
    @autoreleasepool {
        //FMDBReportABugFunction();
        
        NSString *dbPath = @"/tmp/tmp.db";
        
        // delete the old db.
        //NSFileManager *fileManager = [NSFileManager defaultManager];
        //[fileManager removeItemAtPath:dbPath error:nil];
        
        mydb = [FMDatabase databaseWithPath:dbPath];
        me = @"Oliver";
        
        if (![mydb open]) {
            NSLog(@"Could not open db.");
            
        }
        else
            NSLog(@"open db.");
        
        [mydb executeUpdate:@"create table contacts (userID integer, nickName text)"];
        [mydb executeUpdate:@"create table messages (sfrom text, sto text, content text, time date)"];
        
        
        /*
        int i = 1;
        while (i++ < 20) {
            
            [mydb executeUpdate:@"insert into messages ( sfrom, sto ,content, time) values (?, ?,?, ?)" ,
             me     , // look!  I put in a ', and I'm not escaping it!
             [NSString stringWithFormat:@"number %d", i],
             [NSString stringWithFormat:@"Hello, Mr. %d", i],
             [NSDate date]
             ];
            
            
            [mydb executeUpdate:@"insert into contacts (userID, nickName) values (?, ?)" ,
             [NSNumber numberWithInt:i]     , // look!  I put in a ', and I'm not escaping it!
             [NSString stringWithFormat:@"number %d", i]
             ];

        }
        */
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([SimpleChatAppDelegate class]));
    }
}
