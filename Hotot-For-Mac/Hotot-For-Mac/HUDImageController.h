//
//  HUDImageController.h
//  Hotot-For-Mac
//
//  Created by @Kee_Kun on 11/10/09.
//  Hotot For Mac is licensed under LGPL version 3.
//

#import <Cocoa/Cocoa.h>

@interface HUDImageController : NSWindowController
{
    IBOutlet NSImageView *imageView;
    IBOutlet NSPanel *imageWindow;
    IBOutlet NSScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet NSImageView *imageView;
@property (nonatomic, retain) IBOutlet NSPanel *imageWindow;
@property (nonatomic, retain) IBOutlet NSScrollView *scrollView;

@end
