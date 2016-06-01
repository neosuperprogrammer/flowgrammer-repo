//
//  NEODateUtil.h
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 3. 27..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEODateUtil : NSObject 

+ (NSDateComponents *)dateComponentFromDate:(NSDate *)date;
+ (NSDateComponents*)componentsByAddingDay:(NSInteger)addingDay toComp:(NSDateComponents *)prevDateComp;
+ (NSDateComponents*)componentsByAddingMonth:(NSInteger)addingMonth toComp:(NSDateComponents *)prevDateComp;
+ (void)printDayComp:(NSDateComponents *)aDateComp withTag:(NSString *)tag;

@end
