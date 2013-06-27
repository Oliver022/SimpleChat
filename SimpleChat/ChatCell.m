//
//  ChatCell.m
//  SimpleChat
//
//  Created by iris on 13-6-25.
//  Copyright (c) 2013年 iris. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

@synthesize message;
@synthesize date;
@synthesize backgroundImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        date = [[UILabel alloc] init];
        [self.date setFrame:CGRectMake(10, 5, 300, 20)];
        [self.date setFont:[UIFont systemFontOfSize:11.0]];
        [self.date setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.date];
        
        backgroundImageView = [[UIImageView alloc] init];
        [self.backgroundImageView setFrame:CGRectZero];
		[self.contentView addSubview:self.backgroundImageView];
        
		message = [[UITextView alloc] init];
        [self.message setBackgroundColor:[UIColor clearColor]];
        [self.message setEditable:NO];
        [self.message setScrollEnabled:NO];
		[self.message sizeToFit];
		[self.contentView addSubview:self.message];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
