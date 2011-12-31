//
//  NNCheckList.m
//  CheckList
//
//  Created by local on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NNCheckList.h"


@implementation NNCheckList

@dynamic title;
@dynamic lastAccessed;
@dynamic createdAt;
@dynamic listItems;

- (NSString *)sectionName
{
    NSLog(@"QUERYING MY SECTION TITLE BABY: %@", [self title]);
    if (fabs([[self lastAccessed] timeIntervalSinceNow]) < 60.0 * 1.0 ){
        NSLog(@"recent");
        return @"Recent";
    }else {
        NSLog(@"old");
        return @"Old";
    }
}


@end
