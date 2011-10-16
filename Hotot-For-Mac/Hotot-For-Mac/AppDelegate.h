//
//  Hotot_For_MacAppDelegate.h
//  Hotot-For-Mac
//
//  Created by @Kee_Kun on 11/09/24.
//  Hotot For Mac is licensed under LGPL version 3.
//

#import <Cocoa/Cocoa.h>
#import "HototWindowController.h"
#import "TweetWindowController.h"
#import "HUDImageController.h"

#import "hotot.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    HototWindowController *hototWindowController;
    TweetWindowController *tweetWindowController;
    HUDImageController *hudImageController;
    HototStatus hototStatus;
}

@end
