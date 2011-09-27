//
//  HototViewController.h
//  Hotot-For-Mac
//
//  Created by 張 志鋒 on 11/09/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <WebKit/WebKit.h>

#import <WebKit/WebPolicyDelegate.h>
#import <WebKit/WebFrameLoadDelegate.h>
#import <WebKit/WebUIDelegate.h>
#import <WebKit/WebResourceLoadDelegate.h>

#import <WebKit/WebPreferences.h>

#import <Growl/Growl.h>

#import "debug.h"

@protocol WebPolicyDelegate
@end

@protocol WebFrameLoadDelegate
@end

@protocol WebUIDelegate
@end

@protocol WebResourceLoadDelegate
@end

@interface HototViewController : NSViewController <WebPolicyDelegate, WebFrameLoadDelegate, WebUIDelegate, WebResourceLoadDelegate,GrowlApplicationBridgeDelegate>
{
    IBOutlet WebView *webView;
}

@end
