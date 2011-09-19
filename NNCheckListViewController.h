//
//  NNCheckListViewController.h
//  CheckList
//
//  Created by MacRae Linton on 7/9/11.
//  Copyright 2011 Apple Inc. All rights reserved.
//

// This is the view associated with as specicic instance of a checklist.

#import <UIKit/UIKit.h>


@interface NNCheckListViewController : UITableViewController <UITextFieldDelegate> {
	NSManagedObject *managedList;
}

@property (nonatomic, retain) NSManagedObject *managedList;


//private
- (NSManagedObject *)listItemAtIndex:(NSInteger)index;
- (void)clearAllCheckboxes;
@end
