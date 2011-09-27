//
//  HototWindowController.h
//  Hotot-For-Mac
//
//  Created by 張 志鋒 on 11/09/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HototViewController.h"

@interface HototWindowController : NSWindowController
{
    HototViewController *hototViewController;
    IBOutlet NSView *hototView;
}

@end
