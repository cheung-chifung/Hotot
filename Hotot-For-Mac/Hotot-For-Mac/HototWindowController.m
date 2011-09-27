//
//  HototWindowController.m
//  Hotot-For-Mac
//
//  Created by 張 志鋒 on 11/09/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HototWindowController.h"

@implementation HototWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    hototViewController = [[HototViewController alloc] initWithNibName:@"HototView" bundle:nil];
    [hototView addSubview:hototViewController.view];
    
}

@end
