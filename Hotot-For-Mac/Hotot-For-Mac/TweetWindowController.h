//
//  TweetWindowController.h
//  Hotot-For-Mac
//
//  Created by 張 志鋒 on 11/09/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TweetSheetWindow : NSWindow

- (BOOL)canBecomeKeyWindow;

@end


@interface TweetWindowController : NSWindowController
{
    IBOutlet TweetSheetWindow *tweetWindow;
}
- (IBAction)onClose:(id)sender;
- (IBAction)onEdit:(id)sender;

@end
