//
//  debug.h
//  Hotot-For-Mac
//
//  Created by 張 志鋒 on 11/09/24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef Hotot_For_Mac_debug_h
#define Hotot_For_Mac_debug_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s %s [Line %d] " fmt), __FILE__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...) ;
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s %s [Line %d] " fmt), __FILE__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#endif
