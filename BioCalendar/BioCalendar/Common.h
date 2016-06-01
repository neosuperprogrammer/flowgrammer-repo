//
//  Common.h
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 3. 27..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#ifndef Calendar_Test_Common_h
#define Calendar_Test_Common_h

#import "NEODateUtil.h"
#import "NEOBiorhythmUtil.h"

#if DEBUG
    #define NEOLog(fmt, ...)				NSLog((@"%s(%d) * " fmt " *"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else 
    #define NEOLog(fmt, ...)
#endif

#endif
