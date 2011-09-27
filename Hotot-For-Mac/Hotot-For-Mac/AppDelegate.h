//
//  Hotot_For_MacAppDelegate.h
//  Hotot-For-Mac
//
//  Created by 張 志鋒 on 11/09/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HototWindowController.h"
#import "TweetWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    HototWindowController *hototWindowController;
    TweetWindowController *tweetWindowController;
}

@end
