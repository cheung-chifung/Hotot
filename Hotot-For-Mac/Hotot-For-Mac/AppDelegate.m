//
//  Hotot_For_MacAppDelegate.m
//  Hotot-For-Mac
//
//  Created by 張 志鋒 on 11/09/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if (hototWindowController == NULL) {
        hototWindowController = [[HototWindowController alloc] initWithWindowNibName:@"HototWindow"];
        [hototWindowController showWindow:self];
    }
    if (tweetWindowController == NULL) {
        tweetWindowController = [[TweetWindowController alloc] initWithWindowNibName:@"TweetWindow"];
    }
}

- (void)showTweetBox
{
    [[tweetWindowController window] setFrame:CGRectMake(0,0,380,200) display:YES animate:YES];
    [NSApp beginSheet:[tweetWindowController window] modalForWindow:[hototWindowController window] modalDelegate:tweetWindowController didEndSelector:@selector(didEndTweetSheet:returnCode:contextInfo:) contextInfo:nil];
}

- (void)closeTweetBox
{
    [NSApp endSheet:[tweetWindowController window]];
}

@end
