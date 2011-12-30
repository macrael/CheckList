//
//  NNCheckListViewController.m
//  CheckList
//
//  Created by MacRae Linton on 7/9/11.
//  Copyright 2011 Apple Inc. All rights reserved.
//

#import "NNCheckListViewController.h"


@implementation NNCheckListViewController

@synthesize managedList;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
	
	[self setTitle:[[self managedList] valueForKey:@"title"] ];
}



- (void)viewWillAppear:(BOOL)animated {
	// could be the place to uncheck stuff when that is the right time
	NSLog(@"VIEW WILL BE APPEARING NOW");
	
	double secondsForRefresh = 60.0; //60.0 * 24.0 * 2.0;
	
	NSDate *lastAccessed = [[self managedList] valueForKey:@"lastAccessed"];
	NSLog(@"%f",[lastAccessed timeIntervalSinceNow]);
	if (fabs([lastAccessed timeIntervalSinceNow]) > secondsForRefresh){
		NSLog(@"It's been a while. Resetting list");
		[self clearAllCheckboxes];
	}
	
	[[self managedList] setValue:[NSDate date] forKey:@"lastAccessed"];
	
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	
	// Just in case you leave it open for a long time, this way it won't disappear unexpectedly.
	[[self managedList] setValue:[NSDate date] forKey:@"lastAccessed"];
	
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

//Configure cell feels like it might not be the right place to setup the text field. 

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
	int topIndex = [indexPath indexAtPosition:[indexPath length] - 1 ];
	id listItem = [self listItemAtIndex:topIndex];
	
	//NNCheckBox *checkBox = [[NNCheckBox alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
	//[cell.contentView addSubview:checkBox];
	
	if ([[listItem valueForKey:@"isChecked"] isEqualToNumber:[NSNumber numberWithBool:NO]]){
		cell.imageView.image = [UIImage imageNamed:@"checkbox_unticked.png"];
		cell.textLabel.textColor = [UIColor blackColor];
	}else {
		cell.imageView.image = [UIImage imageNamed:@"checkbox_ticked.png"];
		cell.textLabel.textColor = [UIColor grayColor];
	}
	
	UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCheckBox:)];
	[cell.contentView addGestureRecognizer:singleFingerTap];
	
	//this is a hack to make the textlabel work when you are transitiong from editing. 
	cell.textLabel.text = @" ";
	if ([[listItem valueForKey:@"isEditing"] isEqualToNumber:[NSNumber numberWithBool:NO]]){
		//Normal case:
		NSLog(@"AA: %@",[listItem valueForKey:@"title"]);
		cell.textLabel.text = [[listItem valueForKey:@"title"] description];
		NSLog(@"BB: %@",cell.textLabel);
		return;
	}
	NSLog(@"BIG TIME EDITING");
    //We are editing.
	
	// Get a hold of the textview if it exists
	// create it if it doesn't
	// Do I actually want to have this at the higher level? 
		// have a different reusable cell for editing/not

}

#pragma mark -
#pragma mark tapstuff

- (void) tapCheckBox:(UIGestureRecognizer *)gestureRecognizer
{
	NSLog(@"Check BOX TQPPP:");
	UITableViewCell *cell = (UITableViewCell *)[[gestureRecognizer view] superview];
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	int topIndex = [indexPath indexAtPosition:[indexPath length] - 1];
	id listItem = [self listItemAtIndex:topIndex];
	
	if ([[listItem valueForKey:@"isChecked"] isEqual:[NSNumber numberWithBool:YES]]){
		[listItem setValue:[NSNumber numberWithBool:NO] forKey:@"isChecked"];
	}else{
		[listItem setValue:[NSNumber numberWithBool:YES] forKey:@"isChecked"];
	}
	
	NSError *error = nil;
	if (![[listItem managedObjectContext] save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	[self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
	//[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark UITextFieldDelegate

//Scroll it into view when text field starts editing. 


- (void)textFieldDidEndEditing:(UITextField *)textField{
	
	NSLog(@"ENDING EDIINT");
	
	UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	for (int i = 0; i < [indexPath length]; i++){
		NSLog(@"FINISH EDIT PATH: %d",[indexPath indexAtPosition:i]);
	}
	
	int topIndex = [indexPath indexAtPosition:[indexPath length] - 1];
	id listItem = [self listItemAtIndex:topIndex];
	
	[listItem setValue:[NSNumber numberWithBool:NO] forKey:@"isEditing"];
	[listItem setValue:[textField text] forKey:@"title"];
	//[listItem setValue:[NSNumber numberWithBool:YES] forKey:@"isChecked"];
	
	NSManagedObjectContext *context = [listItem managedObjectContext];
	// Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, 
		 although it may be useful during development. If it is not possible to recover from the error, 
		 display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

	[textField removeFromSuperview];
	//[textField release];
	NSLog(@"LAB: %@",[cell textLabel]);
	
	//[self.tableView reloadData];
	[self configureCell:cell atIndexPath:indexPath];
	//[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
	
}

//Are we leaking the textfield? esp when go back to root view
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	NSLog(@"SHOULD RETURN");
	
	[textField resignFirstResponder];
	//[self.tableView setEditing:NO animated:YES];
	
	return NO;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if ([self managedList] == nil){
		NSLog(@"TRYING TO GET NUMBER FROM LIST THAT DOESN'T EXIST");
		return 0;
	}
	
    return [[[self managedList] valueForKey:@"listItems"] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	
	[self configureCell:cell atIndexPath:indexPath];
	
	if (indexPath){
		NSLog(@"WE HAVE INDEX");
		for (int i = 0; i < [indexPath length]; i ++){
			NSLog(@"%d",[indexPath indexAtPosition:i]);
		}
	}
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSLog(@"EDIT: %d",editingStyle);
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSLog(@"DELETEING OPBET FROM VIEW");
        // Delete the row from the data source
		int topIndex = [indexPath indexAtPosition:[indexPath length] - 1];
		NSManagedObject *listItem = [self listItemAtIndex:topIndex];
		NSManagedObjectContext *context = [listItem managedObjectContext];
		[context deleteObject:listItem];
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
		NSLog(@"SAVED");
		NSLog(@"%d",[[[self managedList] valueForKey:@"listItems"] count]);
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject {
	NSLog(@"CREAST NEW LIST TIEME");
	
	// Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [[self managedList] managedObjectContext];
    NSManagedObject *newListItem = [NSEntityDescription insertNewObjectForEntityForName:@"NNCheckListItem" inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
	NSString *name = [NSString stringWithFormat:@"Item: %d",[[[self managedList] valueForKey:@"listItems"] count]];
	
	[newListItem setValue:name forKey:@"title"];
	[newListItem setValue:[NSNumber numberWithBool:YES]  forKey:@"isEditing"];
	[newListItem setValue:[NSNumber numberWithInt:[[[self managedList] valueForKey:@"listItems"] count]] forKey:@"index"];
	//[[[self managedList] valueForKey:@"listItems"] addObject:newList];
	[newListItem setValue:[self managedList] forKey:@"checkList"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	
	NSLog(@"LISTSICE: %d",[[[self managedList] valueForKey:@"listItems"] count]);
	
	// This should be replaced by proper use of a fetched results controller
	NSUInteger indexes[2];
	indexes[0] = 0;  // This might still be ok, could be sections not over all controllers?
	indexes[1] = [[[self managedList] valueForKey:@"listItems"] count] - 1;
	NSIndexPath *newIndexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	
	// This sets the first responder correctly. 
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:newIndexPath];
	
	CGRect fieldFrame = CGRectMake(53, 10, [cell frame].size.width - 53, [cell frame].size.height - 10);
	UITextField *textField = [[UITextField alloc] initWithFrame:fieldFrame];
	[textField setText:[newListItem valueForKey:@"title"]];
	[textField setFont:[UIFont boldSystemFontOfSize:20.0]];
	[textField setDelegate:self];
	
	[cell.contentView addSubview:textField];
	
	[textField becomeFirstResponder];
	
}

#pragma mark -
#pragma mark Helper Methods

- (NSManagedObject *)listItemAtIndex:(NSInteger)index
{
	NSArray *all = [[[self managedList] valueForKey:@"listItems"] allObjects];
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
	NSArray *sorted = [all sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	return [sorted objectAtIndex:index];
}

- (void)clearAllCheckboxes
{
	for (NSManagedObject *listItem in [[[self managedList] valueForKey:@"listItems"] allObjects]){
		NSLog(@"Resetting %@",listItem);
		[listItem setValue:[NSNumber numberWithBool:NO] forKey:@"isChecked"];
	}
	NSManagedObjectContext *context = [[self managedList] managedObjectContext];
	NSError *error = nil;
	if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end

