//
//  SimpleChatDetailViewController.m
//  SimpleChat
//
//  Created by iris on 13-6-24.
//  Copyright (c) 2013年 iris. All rights reserved.
//

#import "SimpleChatDetailViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "ChatCell.h"
#import "ChatMessage.h"
#import "SRWebSocket.h"

extern NSString *me;
extern FMDatabase *mydb;
extern SRWebSocket *_webSocket;

@interface SimpleChatDetailViewController () <SRWebSocketDelegate, UITextViewDelegate> 
{
    //NSMutableArray *dialogs;
    NSString *chater;
    NSMutableArray *messages;
}
- (IBAction)sending:(UIButton *)sender;

- (IBAction)tapView:(UITapGestureRecognizer *)sender;

@property (retain, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UINavigationItem *nameTag;
@property (weak, nonatomic) IBOutlet UIButton *sendingButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)configureView;
@end

@implementation SimpleChatDetailViewController

@synthesize nameTag;






- (void)_reconnect;
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:9000/chat"]]];
    _webSocket.delegate = self;
    
    self.title = @"Opening Connection...";
    [_webSocket open];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _reconnect];
}



- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    [self.tableView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    self.title = @"Connected!";
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    //NSLog(@"Received \"%@\"", message);
    //[_messages addObject:[[TCMessage alloc] initWithMessage:message fromMe:NO]];
    //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView scrollRectToVisible:self.tableView.tableFooterView.frame animated:YES];
    
    ChatMessage *newMessage =[[ChatMessage alloc] init];
    newMessage.content = [(ChatMessage *)message content];
    newMessage.from = @"";
    newMessage.datetime = [NSDate date];
    [messages addObject:newMessage];
    
    [mydb executeUpdate:@"insert into messages (sfrom, sto, content, time) values (?, ?, ?, ?)",
     chater,
     me,
     message,
     [NSDate date]
     ];
    
    // reload table
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed! (see logs)";
    _webSocket = nil;
}






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
        self.nameTag.title = newDetailItem;
        chater = newDetailItem;
        // Update the view.
        [self configureView];
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{   //NSLog(@"%@",chater);
    messages = [[NSMutableArray alloc] init];
    FMResultSet *rs = [mydb executeQuery:@"select * from messages c where c.sfrom = ? OR c.sto = ?",chater, chater];
    
    while ([rs next]) {

        ChatMessage *newMessage =[[ChatMessage alloc] init];        
        newMessage.content = [rs stringForColumn:@"content"];
        if([[rs stringForColumn:@"sfrom"] isEqual:me])
            newMessage.from = me;
        else
            newMessage.from = chater;
        newMessage.datetime = [rs dateForColumn:@"time"];
        [messages addObject:newMessage];
        
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.textField) {
        [theTextField resignFirstResponder];
        
    }
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self keyboardShow];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self keyboardHide];
}

-(void)keyboardShow{
    CGRect rectFild = self.textField.frame;
    rectFild.origin.y -= 215;
    
    CGRect rectButton = self.sendingButton.frame;
    rectButton.origin.y -= 215;
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self.textField setFrame:rectFild];
                         [self.sendingButton setFrame:rectButton];
                     }
     ];
}

-(void)keyboardHide{
    CGRect rectFild = self.textField.frame;
    rectFild.origin.y += 215;
    CGRect rectButton = self.sendingButton.frame;
    rectButton.origin.y += 215;
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self.textField setFrame:rectFild];
                         [self.sendingButton setFrame:rectButton];
                     }
     ];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}


static CGFloat padding = 20.0;
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"ChatCellIdentifier";
	
    // Create cell
	ChatCell *cell = (ChatCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:CellIdentifier];
	}
    cell.accessoryType = UITableViewCellAccessoryNone;
	cell.userInteractionEnabled = NO;
    
    
    
    
    // Message
    ChatMessage *messageBody = [messages objectAtIndex:[indexPath row]];
    
    // set message's text
	NSString *message = [messageBody content];
    cell.message.text = [messageBody content];
    
    // message's datetime
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"yyyy-mm-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    NSString *time = [formatter stringFromDate:messageBody.datetime];
    
	
	CGSize textSize = { 260.0, 10000.0 };
	CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
					  constrainedToSize:textSize
						  lineBreakMode:UILineBreakModeWordWrap];
	size.width += (padding/2);
	
    
    // Left/Right bubble
    UIImage *bgImage = nil;
    if ([messageBody.from isEqualToString:chater]) {
        
        bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
        
        [cell.message setFrame:CGRectMake(padding, padding*2, size.width+padding, size.height+padding)];
        
        [cell.backgroundImageView setFrame:CGRectMake( cell.message.frame.origin.x - padding/2,
                                                      cell.message.frame.origin.y - padding/2,
                                                      size.width+padding,
                                                      size.height+padding)];
        
        cell.date.textAlignment = UITextAlignmentLeft;
        cell.backgroundImageView.image = bgImage;
        
      
            cell.date.text = [NSString stringWithFormat:@"%@ %@", chater, time];

        
    } else {
        NSLog(@"USE aqua");
        bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
        
        [cell.message setFrame:CGRectMake(320 - size.width - padding,
                                          padding*2,
                                          size.width+padding,
                                          size.height+padding)];
        
        [cell.backgroundImageView setFrame:CGRectMake(cell.message.frame.origin.x - padding/2,
                                                      cell.message.frame.origin.y - padding/2,
                                                      size.width+padding,
                                                      size.height+padding)];
        
        cell.date.textAlignment = UITextAlignmentRight;
        cell.backgroundImageView.image = bgImage;
        cell.date.text = [NSString stringWithFormat:@"%@ %@",@"me", time];
    }
    
	return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatMessage *chatMessage = (ChatMessage *)[messages objectAtIndex:indexPath.row];
	NSString *text = chatMessage.content;
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:13]
                   constrainedToSize:textSize
                       lineBreakMode:UILineBreakModeWordWrap];
	
	size.height += padding;
	return size.height+padding+5;
}

- (IBAction)sending:(UIButton *)sender {
    
    ChatMessage *newMessage =[[ChatMessage alloc] init];
    newMessage.content = self.textField.text;
    newMessage.from = me;
    newMessage.datetime = [NSDate date];
    [messages addObject:newMessage];
    NSLog(@" %@ %@",newMessage.content, newMessage.datetime);
    
    [mydb executeUpdate:@"insert into messages (sfrom, sto, content, time) values (?, ?, ?, ?)",
     me,
     chater,
     self.textField.text,
     [NSDate date]
    ];
    
    [_webSocket send:self.textField.text];
    
    // reload table
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self.textField resignFirstResponder];
    self.textField.text = @"";
    
    
    
}

- (IBAction)tapView:(UITapGestureRecognizer *)sender {
    //[self keyboardHide];
    [self.textField resignFirstResponder];
}


@end
