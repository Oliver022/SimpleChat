//
//  ChatCell.h
//  SimpleChat
//
//  Created by iris on 13-6-25.
//  Copyright (c) 2013年 iris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
@property (nonatomic, retain) UITextView  *message;
@property (nonatomic, retain) UILabel     *date;
@property (nonatomic, retain) UIImageView *backgroundImageView;
@end
