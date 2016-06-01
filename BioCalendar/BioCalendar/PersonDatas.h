//
//  PersonDatas.h
//  UITest
//
//  Created by Sangwook Nam on 13. 5. 13..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PersonDatas : NSObject

+ (PersonDatas *)getInstance;

- (void)savePersonData;
- (void)addPersonData:(NSString *)name birthday:(NSDate *)birthday;
- (NSInteger)getPersonCount;
- (NSString *)getPersonName:(NSInteger)index;
- (NSString *)getPersonBirthday:(NSInteger)index;
- (void)deletePerson:(NSInteger)index;


- (id)getPersonData:(NSInteger)index;
- (void)insertObject:(id)personData atIndex:(NSInteger)index;
- (NSDateComponents *)getPersonBirthdayDateComp;
- (NSString *)getSelectedPersonInfo;

- (NSInteger)getSelectedIndex;
- (void)setSelectedIndex:(NSInteger)selectedIndex;

@end
