//
//  TweetWindowController.m
//  Hotot-For-Mac
//
//  Created by 張 志鋒 on 11/09/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TweetWindowController.h"

@implementation TweetSheetWindow

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

@end


@implementation TweetWindowController



- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)didEndTweetSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [sheet orderOut:self];
}

- (IBAction)onClose:(id)sender {
    NSLog(@"close");
    [[NSApp delegate] closeTweetBox];
}

- (IBAction)onEdit:(id)sender {
    NSLog(@"Edit");
}
@end
