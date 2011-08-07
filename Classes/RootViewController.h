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

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
