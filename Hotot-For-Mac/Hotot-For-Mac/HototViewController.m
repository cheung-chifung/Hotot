//
//  HototViewController.m
//  Hotot-For-Mac
//
//  Created by 張 志鋒 on 11/09/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HototViewController.h"

@implementation HototViewController


- (NSString *)_url_decode:(NSString *)string
{
    NSString *data = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    data = [data stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return data;
}

- (NSDictionary *) registrationDictionaryForGrowl
{
    NSArray *array = [NSArray arrayWithObjects:@"notify", nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:1],
                          @"TicketVersion",
                          array, 
                          @"AllNotifications",
                          array,
                          @"DefaultNotifications",
                          nil];
    return dict;
}

- (void) growlMessage:(NSString *)message title:(NSString *)title avatar:(NSURL *)avatar type:(NSString *)type clickContext:(NSString *)clickContext
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void){
        NSData *image = [[[NSData alloc] initWithContentsOfURL:avatar] autorelease];
        dispatch_async( dispatch_get_main_queue(), ^(void){
            [GrowlApplicationBridge notifyWithTitle:title
                                        description:message
                                   notificationName:type
                                           iconData:image ? image : nil
                                           priority:0
                                           isSticky:NO
                                       clickContext:clickContext];
        });
    });
    
}


- (void) showHUDImage:(NSURL *)imageURL
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void){
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:imageURL];
        dispatch_async( dispatch_get_main_queue(), ^(void){
            if (image) {
                NSInteger width;
                NSInteger height;
                if ( (image.size.width/image.size.height) <= (600/500) ) {
                    width  = image.size.width <= 600 ? image.size.width : 600;
                    height = width * (image.size.height/image.size.width);
                } else {
                    height = image.size.height <= 500 ? image.size.height : 500;
                    width  = height * (image.size.width/image.size.height); 
                }
                
                NSPanel *hudWindow = [[NSPanel alloc]
                                      initWithContentRect:NSMakeRect(0, 0, width+20, height+20) 
                                      styleMask:NSUtilityWindowMask|NSTitledWindowMask|NSHUDWindowMask|NSClosableWindowMask 
                                      backing:NSBackingStoreRetained
                                      defer:NO];
                
                
                NSImageView *imageView = [[NSImageView alloc] initWithFrame:CGRectMake(10, 10, width, height)];
                [imageView setImage:image];
                [imageView setAutoresizesSubviews:YES];
                [[hudWindow contentView] addSubview:imageView];
                [hudWindow center];
                
                [hudWindow makeKeyAndOrderFront:nil];
                
                [image release];
                [imageView release];
            }
        });
    });
    
    
    
}


- (Boolean)on_hotot_action:(NSString *)message
{
    if([message length]>6){
        NSString *command = [message substringFromIndex:6];
        DLog("hotot_command:%@",command);
        
        NSArray *params = [command componentsSeparatedByString:@"/"];
        if([params count]>1){
            NSString *type = [NSString stringWithString: [params objectAtIndex:0]];
            if([type isEqualToString:@"action"]){                              //   /action
                NSString *action = [NSString stringWithString: [params objectAtIndex:1]];
                if ([action isEqualToString:@"search"]) {                      //   /action/search
                    // TODO: search
                }else if([action isEqualToString:@"choose_file"]){             //   /action/choose_file
                    NSString *callback = [NSString stringWithString: [params objectAtIndex:2]];
                    
                    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
                    [openDlg setAllowedFileTypes: [NSArray arrayWithObjects:@"jpg",@"jpeg",@"gif",@"png",nil]];
                    [openDlg setCanChooseFiles:YES];
                    [openDlg setAllowsMultipleSelection:NO];
                    [openDlg setCanChooseDirectories:NO];
                    
                    if ( [openDlg runModal] == NSOKButton )
                    {
                        NSArray *filenames = [openDlg URLs];
                        if ([filenames count]>0) {
                            // FIXME
                            NSString *filename = [NSString stringWithString:[[filenames objectAtIndex:0] path]];
                            //filename = [self _url_decode:filename];
                            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@');",callback, filename]];
                            DLog(@"%@('%@');",callback, filename);
                        }
                    }
                    
                    //}else if([action isEqualToString:@"save_avatar"]){             //   /action/save_avatar
                    // TODO: save avatar
                }else if([action isEqualToString:@"log"]){                     //   /action/log
                    NSString *method = [NSString stringWithString: [params objectAtIndex:2]];
                    NSString *data   = [NSString stringWithString: [params objectAtIndex:3]];
                    method = [self _url_decode:method];
                    data   = [self _url_decode:data];
                    //DLog(@"HOTOT_ACTION_LOG: %@ | %@", method, data);
                }else if([action isEqualToString:@"paste_clipboard_text"]){    //   /action/paste_clipboard_text
                    // paste clipboard_text
                    [webView doCommandBySelector:@selector(pasteAsPlainText:)];
                }else if([action isEqualToString:@"set_clipboard_text"]){      //   /action/set_clipborad_text
                    // set clipboard_text
                    NSString *copied = [command substringFromIndex:[@"action/set_clipboard_text/" length]];
                    NSPasteboard *clipboard = [NSPasteboard generalPasteboard];
                    [clipboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
                    [clipboard setString:copied forType:NSStringPboardType];
                    [clipboard release];
                }
            }else if ([type isEqualToString:@"system"]) {                      //   /system
                NSString *method = [NSString stringWithString: [params objectAtIndex:1]];
                if ([method isEqualToString:@"quit"]) {                        //   /system/quit
                    [NSApp terminate:self];
                }else if ([method isEqualToString:@"notify"]){
                    NSString *notifyType = [self _url_decode:[NSString stringWithString: [params objectAtIndex:2]]];
                    NSString *body       = [self _url_decode:[NSString stringWithString: [params objectAtIndex:3]]];
                    NSString *summary    = [self _url_decode:[NSString stringWithString: [params objectAtIndex:4]]];
                    NSURL *avatar        = [NSURL URLWithString:[self _url_decode:[NSString stringWithString: [params objectAtIndex:5]]]];
                    if ([notifyType isEqualToString:@"content"]) {
                        [self growlMessage:summary title:body avatar:avatar type:@"notify" clickContext:nil];
                    }else if([notifyType isEqualToString:@"count"]){
                        // TODO: count it
                    }
                    
                }
            }
        }
    }
    return TRUE;
}

/*
 *   Handle all request
 */
- (Boolean)handle_uri:(NSURLRequest *)request
{
    NSString *scheme = [[request URL] scheme];
    NSString *url    = [[request URL] absoluteString];
    NSString *ext    = [[url pathExtension] lowercaseString];

    if ([scheme isEqualToString:@"file"]) {
        return FALSE;
    } else if ([scheme isEqualToString:@"hotot"]){
        [self on_hotot_action:url];
        return TRUE;
    } else if ([scheme isEqualToString:@"about"]){
        return TRUE;
    } else if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]){
        
        if ([[[request URL] host] isEqualToString:@"stat.hotot.org"]) {
            return FALSE;
        } else if ( [ext isEqualToString:@"jpg"]  ||
                    [ext isEqualToString:@"jpeg"] ||
                    [ext isEqualToString:@"gif"]  ||
                    [ext isEqualToString:@"png"]  ){
            
            // show HUD window
            [self showHUDImage:[request URL]];
        } else {
            [[NSWorkspace sharedWorkspace] openURL:[request URL]];
            return TRUE;
        }
    }
    return TRUE;
}

/*
 * On Navigation Requested
 */
- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    if([self handle_uri:request]){
        [listener ignore];
    }else{
        [listener use];
    }
}


/*
 * On New Window
 */
- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener
{
    if([self handle_uri:request]){
        [listener ignore];
    }else{
        [listener use];
    }
}

/*
 * On Alert
 */
- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    [self on_hotot_action:message];
}

/*
 * On Confirm
 */
- (BOOL)webView:(WebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSInteger result = NSRunInformationalAlertPanel(
                                                    NSLocalizedString(@"Please Confirm", @""), 
                                                    message, 
                                                    NSLocalizedString(@"OK", @""), 
                                                    NSLocalizedString(@"Cancel", @""),
                                                    nil
                                                    );
    return NSAlertDefaultReturn == result;
}

/*
 * On Load Finished
 */
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    NSString *_trigger_js = @"overlay_variables({platform:'Mac',"
                                                 "conf_dir:'%@',"
                                                "cache_dir:'%@',"
                                         "avatar_cache_dir:'%@',"
                                              "extra_fonts:'%@',"
                                               "extra_exts:'%@',"
                                             "extra_themes:'%@',"
                                                 "locale:'%@'});"
                                          "globals.load_flags=1;";

    _trigger_js = [NSString stringWithFormat:_trigger_js,@"",@"",@"",@"",@"",@"",@"en_US"];
    [sender stringByEvaluatingJavaScriptFromString:_trigger_js];
    DLog(@"Inject startup javascript code");
    
    //[[NSApp delegate] showTweetBox];    
    
}

#ifdef DEBUG
- (void)webView:(WebView *)webView addMessageToConsole:(NSDictionary  
                                                        *)dictionary;
{
    NSString *message = [dictionary objectForKey:@"message"];
    NSString *source  = [dictionary objectForKey:@"sourceURL"];
    NSNumber *line    = [dictionary objectForKey:@"lineNumber"];
    
    DLog(@"HOTOTLOG:%d @ %@ @ %@",[line intValue],message,source);
}
#endif



- (void)awakeFromNib
{
    NSString* datadir = @"~/Library/Safari/Databases/";
 	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
 	[defaults setObject:datadir forKey:@"WebDatabaseDirectory"];
 	[defaults setObject:datadir forKey:@"WebKitLocalStorageDatabasePathPreferenceKey"];
 	[defaults setObject:datadir forKey:@"WebKitLocalCache"];
 	[defaults synchronize];
    
    // Setup all Delegates
    [webView setPolicyDelegate:self];
    [webView setFrameLoadDelegate:self];
    [webView setUIDelegate:self];
    [webView setResourceLoadDelegate:self];  
    
    // Setup Web Preferences
    WebPreferences* prefs = [webView preferences];
    [prefs setUsesPageCache:YES];
    [prefs setJavaScriptCanAccessClipboard:YES];     // private method
    
    // Enable cross-domain XMLHttpRequest
    [prefs setAllowUniversalAccessFromFileURLs:YES]; // private method
    [prefs setAllowFileAccessFromFileURLs:YES];      // private method
    
    // Enable local database & storage
    [prefs setDatabasesEnabled:YES];                 // private method
    [prefs setLocalStorageEnabled:YES];              // private method
    
    [prefs setLocalFileContentSniffingEnabled:YES];
    [prefs setDeveloperExtrasEnabled:YES];

    // Load the page
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"data"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    [webView.mainFrame loadRequest:[NSURLRequest requestWithURL:fileURL]];
    
    // Register Growl
    [GrowlApplicationBridge setGrowlDelegate:self];
    
    [self setView:webView];
}



@end
