//
//  SimpleChatDetailViewController.h
//  SimpleChat
//
//  Created by iris on 13-6-24.
//  Copyright (c) 2013年 iris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleChatDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
