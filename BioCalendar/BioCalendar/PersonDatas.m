//
//  PersonDatas.m
//  UITest
//
//  Created by Sangwook Nam on 13. 5. 13..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import "PersonDatas.h"
#import "NEODateUtil.h"

#define STORAGE_FILE        (@"person_data.plist")

#define kNameKey        (@"name")
#define kBirthdayKey    (@"birthday")

#define kSelectedPersonKey  (@"selectedPersonIndex")

static  PersonDatas *mySelf;

@interface PersonDatas ()

@property (strong, nonatomic) NSMutableArray *personDatas;
@property (nonatomic) NSInteger selectedIndex;

@end

@implementation PersonDatas

+ (PersonDatas *)getInstance
{
    if(mySelf == nil) {
        mySelf = [[PersonDatas alloc] init];
    }
    return mySelf;
}

- (id)init
{
    self = [super init];
    if(self) {
        _personDatas = [NSMutableArray array];
        [self loadPersonData];
        NSString *selectedIndex = [[NSUserDefaults standardUserDefaults] objectForKey:kSelectedPersonKey];
        if(selectedIndex == nil) {
            _selectedIndex = -1;
        }
        else {
            _selectedIndex = [selectedIndex integerValue];
        }
    }
    return self;
    
}

- (void)loadPersonData
{
    NSString *filePath = [self filePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        _personDatas = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
}

- (void)savePersonData
{
    NSString *filePath = [self filePath];
    [_personDatas writeToFile:filePath atomically:YES];
}

- (NSString *)filePath
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [documents[0] stringByAppendingPathComponent:STORAGE_FILE];
    return filePath;
}

- (void)addPersonData:(NSString *)name birthday:(NSDate *)birthday
{
    [_personDatas addObject:@{kNameKey : name, kBirthdayKey : birthday}];
}

- (NSInteger)getPersonCount
{
    return _personDatas.count;
}

- (NSString *)getPersonName:(NSInteger)index
{
    return _personDatas[index][kNameKey];
}

- (NSString *)getPersonBirthday:(NSInteger)index
{
    NSDate *date = _personDatas[index][kBirthdayKey];
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyy-MM-dd"];
    return [dateFormmater stringFromDate:date];
}

- (NSString *)getSelectedPersonInfo
{
    if(_selectedIndex < 0 || _personDatas.count <= 0) {
        return NSLocalizedString(@"SelectPersonPlease", @"");
    }
    else {
        return [NSString stringWithFormat:@"%@ (%@)", [self getPersonName:_selectedIndex], [self getPersonBirthday:_selectedIndex]];
    }
}

- (NSDateComponents *)getPersonBirthdayDateComp
{
    if(_selectedIndex < 0 || _personDatas.count <= 0) {
        return nil;
    }
    else {
        NSDate *date = _personDatas[_selectedIndex][kBirthdayKey];
        return [NEODateUtil dateComponentFromDate:date];
    }
}

- (NSInteger)getSelectedIndex
{
    return _selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    NSString *selectedIndexString = [NSString stringWithFormat:@"%d", selectedIndex];
    [[NSUserDefaults standardUserDefaults] setObject:selectedIndexString forKey:kSelectedPersonKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _selectedIndex = selectedIndex;
}

- (void)deletePerson:(NSInteger)index
{
    [_personDatas removeObjectAtIndex:index];
}

- (id)getPersonData:(NSInteger)index
{
    return _personDatas[index];
}

- (void)insertObject:(id)personData atIndex:(NSInteger)index
{
    [_personDatas insertObject:personData atIndex:index];
}

@end
