//
//  MDEditTreatmentViewController.m
//  Farm
//
//  Created by Mark Kryzhanouski on 7/8/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDEditTreatmentViewController.h"
#import "MDIllnessListViewController.h"
#import "MDDrugListViewController.h"
#import "MDDatePickerViewController.h"

@interface MDEditTreatmentViewController ()
@property (nonatomic, strong) NSManagedObjectContext* childContext;
@property (nonatomic, strong) Treatment* object;

@property (weak, nonatomic) IBOutlet UITableViewCell *treatmentDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *treatmentEndDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *illnessCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *drugCell;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MDEditTreatmentViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSManagedObjectContext*)childContext {
    if (_childContext == nil) {
        _childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_childContext setParentContext:self.managedObjectContext];
    }
    return _childContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    if (self.treatmentID != nil) {
        self.object = (Treatment*)[[self childContext] objectWithID:self.treatmentID];
    } else {
        self.object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Treatment class]) inManagedObjectContext:[self childContext]];
    }

    if (self.object.startDate == nil) {
        self.object.startDate = [NSDate date];
    }
    if (self.object.endDate == nil) {
        self.object.endDate = [NSDate date];
    }
    
    [self refreshData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    NSString* dateString = @"";
    NSDate* date = self.object.startDate;
    if (date) {
        dateString = [dateString stringByAppendingFormat:@" %@",[self.dateFormatter stringFromDate:date]];
    }
    NSString* endDateString = @"";
    NSDate* endDate = self.object.endDate;
    if (endDate) {
        endDateString = [endDateString stringByAppendingFormat:@" %@",[self.dateFormatter stringFromDate:endDate]];
    }
    self.treatmentDateCell.detailTextLabel.text = dateString;
    self.treatmentEndDateCell.detailTextLabel.text = endDateString;
    self.illnessCell.detailTextLabel.text = self.object.illness.name;
    self.drugCell.detailTextLabel.text = self.object.drug.name;
    self.descriptionTextView.text = self.object.result;
    
    [self.tableView reloadData];
}

- (IBAction)doneAction:(id)sender {
    BOOL isValid = YES;
    NSString* errorMessage = nil;
    Illness* ill = self.object.illness;
    
    if (ill == nil) {
        isValid = NO;
        errorMessage = @"Введите Болезнь";
    }
    
    if (errorMessage) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    
    if (isValid) {
        self.object.result = self.descriptionTextView.text;
        Animal* cow = (Animal*)[[self childContext] objectWithID:self.cowID];
        NSMutableSet* treatments = [cow mutableSetValueForKey:@keypath(Animal.new, treatments)];
        [treatments addObject:self.object];
        [self scheduleNotificationWithItem:self.object interval:1];
        [[self childContext] save:nil];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.didAddTreatment) {
            self.didAddTreatment();
        }
    }
    
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.didCancelAddTreatment) {
        self.didCancelAddTreatment();
    }
}

- (void)scheduleNotificationWithItem:(Treatment *)item interval:(int)minutesBefore {
    NSDate* startDate = item.startDate;
//    NSDate* endDate = item.endDate;
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
fromDate:startDate];
    [dateComps setHour:6];
    [dateComps setMinute:0];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.repeatInterval = NSCalendarUnitDay;

    localNotif.alertBody = [NSString stringWithFormat:@"Ошейник: %@, болезнь: %@.", item.animal.collar,item.illness.name];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[[[item objectID] URIRepresentation] absoluteString] forKey:@"URIRepresentation"];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];


    [dateComps setHour:17];
    [dateComps setMinute:0];
    itemDate = [calendar dateFromComponents:dateComps];
    localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.repeatInterval = NSCalendarUnitDay;

    localNotif.alertBody = [NSString stringWithFormat:@"Ошейник: %@, болезнь: %@.", item.animal.collar,item.illness.name];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MDEditTreatmentViewController* __weak weakSelf = self;
    Treatment* object = self.object;
    if ([segue.destinationViewController isKindOfClass:[MDIllnessListViewController class]]) {
        [(MDIllnessListViewController*)segue.destinationViewController setManagedObjectContext:[self childContext]];
        [(MDIllnessListViewController*)segue.destinationViewController setDidSelectIllAction:^(Illness * ill) {
            object.illness = ill;
            [weakSelf refreshData];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    if ([segue.destinationViewController isKindOfClass:[MDDrugListViewController class]]) {
        [(MDDrugListViewController*)segue.destinationViewController setManagedObjectContext:[self childContext]];
        [(MDDrugListViewController*)segue.destinationViewController setDidSelectDrugAction:^(Drug * drug) {
            object.drug = drug;
            [weakSelf refreshData];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    if ([segue.destinationViewController isKindOfClass:[MDDatePickerViewController class]]) {
        UITableViewCell* selectedCell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        NSString* keyPath = nil;
        if (selectedCell == self.treatmentDateCell) {
            keyPath = @keypath(self.object,startDate);
        } else {
            keyPath = @keypath(self.object,endDate);
        }
        NSDate* date = [self.object valueForKey:keyPath];
        [(MDDatePickerViewController*)segue.destinationViewController setCurrentDate:date];
        [(MDDatePickerViewController*)segue.destinationViewController setDidSelectDateAction:^(NSDate * date) {
            [object setValue:date forKey:keyPath];
            [weakSelf refreshData];
        }];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setTreatmentDateCell:nil];
    [self setIllnessCell:nil];
    [self setDrugCell:nil];
    [self setDescriptionTextView:nil];
    [super viewDidUnload];
}
@end
