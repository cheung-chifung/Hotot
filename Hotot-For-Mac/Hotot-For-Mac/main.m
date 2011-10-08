//
//  main.m
//  Hotot-For-Mac
//
//  Created by @Kee_Kun on 11/09/24.
//  Hotot For Mac is licensed under LGPL version 3.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
 /*   
    id pool = [NSAutoreleasePool new];
    
	NSString *logPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Logs/HototForMac.log"];
	freopen([logPath fileSystemRepresentation], "a", stderr);
    
	[pool release];
   */ 
    
    return NSApplicationMain(argc, (const char **)argv);
}
