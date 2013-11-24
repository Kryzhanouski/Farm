//
//  MDEditCalfViewController.m
//  Farm
//
//  Created by Mark on 11/24/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDEditCalfViewController.h"
#import "MDSelectGroupViewController.h"
#import "MDDatePickerViewController.h"
#import "MDEditTreatmentViewController.h"
#import "MDTreatmentListViewController.h"

#define kPickerAnimationDuration 0.40


@interface MDEditCalfViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSManagedObjectContext* childContext;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UIButton *illButton;

@property (weak, nonatomic) IBOutlet UITableViewCell *illCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateOfBirdthCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *tagCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *treatmentCell1;
@property (weak, nonatomic) IBOutlet UITableViewCell *treatmentCell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *treatmentCell3;
@property (weak, nonatomic) IBOutlet UILabel *treatment1Date;
@property (weak, nonatomic) IBOutlet UILabel *treatment1Ill;
@property (weak, nonatomic) IBOutlet UILabel *treatment1Drug;
@property (weak, nonatomic) IBOutlet UILabel *treatment1Result;
@property (weak, nonatomic) IBOutlet UILabel *treatment2Date;
@property (weak, nonatomic) IBOutlet UILabel *treatment2Ill;
@property (weak, nonatomic) IBOutlet UILabel *treatment2Drug;
@property (weak, nonatomic) IBOutlet UILabel *treatment2Result;
@property (weak, nonatomic) IBOutlet UILabel *treatment3Date;
@property (weak, nonatomic) IBOutlet UILabel *treatment3Ill;
@property (weak, nonatomic) IBOutlet UILabel *treatment3Drug;
@property (weak, nonatomic) IBOutlet UILabel *treatment3Result;


@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) Animal* object;
@end

@implementation MDEditCalfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_childContext reset];
    self.tagTextField.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [self.illButton setBackgroundImage:[[UIImage imageNamed:@"ipad-button-red.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)] forState:UIControlStateSelected];
    [self.illButton setBackgroundImage:[[UIImage imageNamed:@"ipad-button-green.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)] forState:UIControlStateNormal];
    
    if (self.objectID != nil) {
        self.object = (Animal*)[[self childContext] objectWithID:self.objectID];
    } else {
        self.object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Animal class]) inManagedObjectContext:[self childContext]];
        self.object.type = @(AnimalTypeCalf);
    }
    
    [self refreshData];
}

- (void)refreshData {
    AnimalType animalType = self.object.animalType;
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    for (int i = 0; i < rows; i++) {
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    }
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:animalType inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    self.dateOfBirdthCell.selectionStyle = animalType == AnimalTypeCow ?UITableViewCellSelectionStyleNone:UITableViewCellSelectionStyleGray;
    self.dateOfBirdthCell.textLabel.enabled = animalType != AnimalTypeCow;
    self.dateOfBirdthCell.detailTextLabel.enabled = animalType != AnimalTypeCow;
    
    self.tagTextField.text = [NSString stringWithFormat:@"%d", [self.object.tag unsignedIntegerValue]];
    
    NSString* dateOfBirdthString = @"";
    NSDate* dateOfBirdthDate = self.object.dateOfBirdth;
    if (dateOfBirdthDate) {
        dateOfBirdthString = [dateOfBirdthString stringByAppendingFormat:@" %@",[self.dateFormatter stringFromDate:dateOfBirdthDate]];
    }
    self.dateOfBirdthCell.detailTextLabel.text = dateOfBirdthString;
    
    self.illButton.selected = [self.object.isIll boolValue];
    
    NSSet* treatments = self.object.treatments;
    NSString* dateKeypath = @keypath(Treatment.new, startDate);
    NSArray* orderedTreatments = [treatments sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:dateKeypath ascending:NO]]];
    if ([orderedTreatments count] > 0) {
        self.treatment1Date.text = [self.dateFormatter stringFromDate:[orderedTreatments[0] valueForKeyPath:dateKeypath]];
        self.treatment1Ill.text = [orderedTreatments[0] valueForKeyPath:@keypath(Treatment.new, illness.name)];
        self.treatment1Drug.text = [orderedTreatments[0] valueForKeyPath:@keypath(Treatment.new, drug.name)];
        self.treatment1Result.text = [orderedTreatments[0] valueForKeyPath:@keypath(Treatment.new, result)];
    }
    if ([orderedTreatments count] > 1) {
        self.treatment2Date.text = [self.dateFormatter stringFromDate:[orderedTreatments[1] valueForKeyPath:dateKeypath]];
        self.treatment2Ill.text = [orderedTreatments[1] valueForKeyPath:@keypath(Treatment.new, illness.name)];
        self.treatment2Drug.text = [orderedTreatments[1] valueForKeyPath:@keypath(Treatment.new, drug.name)];
        self.treatment2Result.text = [orderedTreatments[1] valueForKeyPath:@keypath(Treatment.new, result)];
    }
    if ([orderedTreatments count] > 2) {
        self.treatment3Date.text = [self.dateFormatter stringFromDate:[orderedTreatments[2] valueForKeyPath:dateKeypath]];
        self.treatment3Ill.text = [orderedTreatments[2] valueForKeyPath:@keypath(Treatment.new, illness.name)];
        self.treatment3Drug.text = [orderedTreatments[2] valueForKeyPath:@keypath(Treatment.new, drug.name)];
        self.treatment3Result.text = [orderedTreatments[2] valueForKeyPath:@keypath(Treatment.new, result)];
    }
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    __weak MDEditCalfViewController* weakSelf = self;
    Animal* object = self.object;
    if ([segue.destinationViewController isKindOfClass:[MDSelectGroupViewController class]]) {
        GroupType group = self.object.groupType;
        [(MDSelectGroupViewController*)segue.destinationViewController setSelectedIndex:group];
        [(MDSelectGroupViewController*)segue.destinationViewController setDidSelectGroupAction:^(NSUInteger groupIndex) {
            object.group = @(groupIndex);
            [weakSelf refreshData];
        }];
    }
    if ([segue.destinationViewController isKindOfClass:[MDDatePickerViewController class]]) {
        NSDate* dateOfBirdthDate = self.object.dateOfBirdth;
        [(MDDatePickerViewController*)segue.destinationViewController setCurrentDate:dateOfBirdthDate];
        [(MDDatePickerViewController*)segue.destinationViewController setDidSelectDateAction:^(NSDate * date) {
            object.dateOfBirdth = date;
            [weakSelf refreshData];
        }];
    }
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController*)segue.destinationViewController topViewController] isKindOfClass:[MDEditTreatmentViewController class]]) {
        MDEditTreatmentViewController* treatmentController = (MDEditTreatmentViewController*)[(UINavigationController*)segue.destinationViewController topViewController];
        [treatmentController setCowID:[object objectID]];
        [treatmentController setManagedObjectContext:self.childContext];
        [treatmentController setDidAddTreatment:^{
            [weakSelf refreshData];
            [self dismissModalViewControllerAnimated:YES];
        }];
        [treatmentController setDidCancelAddTreatment:^{
            [self dismissModalViewControllerAnimated:YES];
        }];
    }
    if ([segue.destinationViewController isKindOfClass:[MDTreatmentListViewController class]]) {
        MDTreatmentListViewController* treatmentController = (MDTreatmentListViewController*)segue.destinationViewController;
        [treatmentController setCowID:[object objectID]];
        [treatmentController setManagedObjectContext:self.childContext];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (NSManagedObjectContext*)childContext {
    if (_childContext == nil) {
        _childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_childContext setParentContext:self.managedObjectContext];
    }
    return _childContext;
}

- (IBAction)makeIllAction:(UIButton*)sender {
    BOOL isIll = !self.illButton.selected;
    self.illButton.selected = isIll;
}

- (IBAction)addTreatmentAction:(id)sender {
}

- (void)cancelAction {
    [_childContext reset];
    _childContext = nil;
    self.object = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneAction {
    BOOL isValid = YES;
    NSString* errorMessage = nil;
    NSString* tagString = self.tagTextField.text;
    float tag = [tagString floatValue];
    AnimalType type = AnimalTypeCalf;
    BOOL isIll = self.illButton.selected;
    
    if ([tagString length] > 0 && tag == 0) {
        isValid = NO;
        errorMessage = @"Номер бирки не может быть нулевым";
    }
    
    if (errorMessage) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    
    if (isValid) {
        self.object.tag = @(tag);
        self.object.type = @(type);
        self.object.isIll = @(isIll);
        
        [[self childContext] save:nil];
        [[self managedObjectContext] save:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTagTextField:nil];
    [self setIllButton:nil];
    [self setIllCell:nil];
    [self setDateOfBirdthCell:nil];
    [self setTagCell:nil];
    [self setTreatmentCell1:nil];
    [self setTreatmentCell2:nil];
    [self setTreatmentCell3:nil];
    [self setTreatment1Date:nil];
    [self setTreatment1Ill:nil];
    [self setTreatment1Drug:nil];
    [self setTreatment1Result:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.tagTextField) {
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.tagCell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.tagTextField && [self.tagTextField.text floatValue] == 0) {
        self.tagTextField.text = nil;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.tagTextField && [self.tagTextField.text floatValue] == 0) {
        self.tagTextField.text = @"0.0";
    }
    if (textField == self.tagTextField) {
        float tag = [self.tagTextField.text floatValue];
        self.object.tag = @(tag);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.tagTextField) {
    }
    return YES;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimalType animalType = self.object.animalType;
    if ([tableView cellForRowAtIndexPath:indexPath] == self.dateOfBirdthCell && animalType == AnimalTypeCow) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSInteger rows = [tableView numberOfRowsInSection:indexPath.section];
        for (int i = 0; i < rows; i++) {
            [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]] setAccessoryType:UITableViewCellAccessoryNone];
        }
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        self.object.type = @(indexPath.row);
        [self refreshData];
    }
    if ([tableView cellForRowAtIndexPath:indexPath] == self.illCell) {
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
