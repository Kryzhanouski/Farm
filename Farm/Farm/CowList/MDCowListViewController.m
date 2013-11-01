//
//  MDDetailViewController.m
//  Farm
//
//  Created by Mark Kryzhanouski on 6/30/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDCowListViewController.h"
#import "MDEditCowViewController.h"


@interface MDCowListViewController () <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSPredicate* searchPredicate;
@end

@implementation MDCowListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Список Животных";
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCowAction)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)addCowAction {
    [self editCow:nil];
}

//- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender NS_AVAILABLE_IOS(5_0);
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MDEditCowViewController* ctr = (MDEditCowViewController*)segue.destinationViewController;
    [ctr setManagedObjectContext:self.managedObjectContext];
    [ctr setObjectID:[sender objectID]];
}

- (void)editCow:(NSManagedObject*)object {
    [self performSegueWithIdentifier:@"MDEditCowViewController" sender:object];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Animal *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    AnimalType animalType = object.animalType;

    NSString* identifier = animalType == AnimalTypeCow ? @"CowCell": @"CalfCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self editCow:object];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Animal class]) inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@keypath(Animal.new, collar) ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate* predicate = self.searchPredicate;
    if (predicate && self.filterPredicale) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate,self.filterPredicale]];
    } else if (self.filterPredicale){
        predicate = self.filterPredicale;
    }

    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Animal *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    AnimalType animalType = object.animalType;
    
    ((UILabel*)[cell viewWithTag:1]).text = [NSString stringWithFormat:@"%d",[object.tag unsignedIntegerValue]];
    if (animalType == 0) {
        ((UILabel*)[cell viewWithTag:2]).text = object.collar;
    } else {
        NSDate* dateOfBirdthDate = object.dateOfBirdth;
        NSMutableString* ageString = [NSMutableString stringWithString:@"-"];
        if (dateOfBirdthDate) {
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                       fromDate:dateOfBirdthDate
                                                         toDate:[NSDate date]
                                                        options:0];
            [ageString setString:@""];
            if (components.year > 0) {
                int lastDigit = components.year % 10;
                if ((components.year < 5 || components.year > 20) && lastDigit < 5) {
                    [ageString appendFormat:@"%i год",components.year];
                    if (lastDigit != 1) {
                        [ageString appendString:@"а"];
                    }
                } else {
                    [ageString appendFormat:@"%i лет",components.year];
                }
            }
            if (components.month > 0) {
                if ([ageString length] > 0) {
                    [ageString appendString:@", "];
                }
                int lastDigit = components.month % 10;
                [ageString appendFormat:@"%i месяц",components.month];
                if ((components.month < 5 || components.month > 20) && lastDigit < 5 && lastDigit != 1) {
                    [ageString appendString:@"а"];
                } else if (lastDigit >= 5) {
                    [ageString appendString:@"ев"];
                }
            }
            if (components.day > 0 && components.year == 0) {
                if ([ageString length] > 0) {
                    [ageString appendString:@", "];
                }
                int lastDigit = components.day % 10;
                if ((components.day < 5 || components.day > 20) && lastDigit < 5) {
                    if (lastDigit == 1) {
                        [ageString appendFormat:@"%i день",components.day];
                    } else {
                        [ageString appendFormat:@"%i дня",components.day];
                    }
                } else {
                    [ageString appendFormat:@"%i дней",components.day];
                }
            }
        }
        ((UILabel*)[cell viewWithTag:2]).text = ageString;
    }
    
    if (animalType == AnimalTypeCow) {
        NSString* groupName = object.groupName;
        ((UILabel*)[cell viewWithTag:3]).text = groupName;
    }
    
    
    BOOL isIll = [object.isIll boolValue];
    ((UILabel*)[cell viewWithTag:4]).text = isIll ? @"Больная": @"Не Больная";
    UIView* bkgView = [[UIView alloc] init];
    bkgView.backgroundColor = isIll ? [UIColor redColor]: [UIColor whiteColor];
    cell.backgroundView = bkgView;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Implement UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSPredicate* predicate = nil;
    if ([searchText length] > 0) {
        switch (searchBar.selectedScopeButtonIndex) {
            case 0:
                predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@keypath(Animal.new, collar),searchText];
                break;
            case 1:
                predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@keypath(Animal.new, tag),searchText];
                break;
            case 2:
                predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@keypath(Animal.new, tag),searchText];
                break;
            default:
                break;
        }
    }
    self.searchPredicate = predicate;
    _fetchedResultsController = nil;
    [self.tableView reloadData];
}

//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0); // called before text changes
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
//- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar;                   // called when bookmark button pressed
//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar;                    // called when cancel button pressed
//- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2); // called when search results button pressed
//

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
}

@end










