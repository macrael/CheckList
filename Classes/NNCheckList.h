//
//  NNCheckList.h
//  CheckList
//
//  Created by local on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NNCheckList : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * lastAccessed;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSSet *listItems;
@end

@interface NNCheckList (CoreDataGeneratedAccessors)

- (void)addListItemsObject:(NSManagedObject *)value;
- (void)removeListItemsObject:(NSManagedObject *)value;
- (void)addListItems:(NSSet *)values;
- (void)removeListItems:(NSSet *)values;

- (NSString *)sectionName;

@end
