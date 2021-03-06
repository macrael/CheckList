//
//  RootViewController.h
//  CheckList
//
//  Created by MacRae Linton on 8/28/10.
//  Copyright Apple Inc. 2010. All rights reserved.
//

// The root view controller is the collection of all the checklists.

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NNCheckListViewController.h"

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;


// private I think.
- (NNCheckListViewController *)createAndPushViewControllerForManagedList:(NSManagedObject *)managedList;

@end
