//
//  MDEditCowViewController.m
//  Farm
//
//  Created by Mark Kryzhanouski on 7/1/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDEditCowViewController.h"
#import "MDSelectGroupViewController.h"
#import "MDDatePickerViewController.h"
#import "MDEditTreatmentViewController.h"
#import "MDTreatmentListViewController.h"

#define kPickerAnimationDuration 0.40


@interface MDEditCowViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSManagedObjectContext* childContext;
@property (weak, nonatomic) IBOutlet UITextField *collarTextField;
@property (weak, nonatomic) IBOutlet UILabel *collarLabel;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UIButton *illButton;

@property (weak, nonatomic) IBOutlet UITableViewCell *illCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *groupCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateOfBirdthCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *tagCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *collarCell;
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

@property (nonatomic, strong) NSManagedObject* object;
@end

@implementation MDEditCowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_childContext reset];
    self.collarTextField.delegate = nil;
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
        self.object = [[self childContext] objectWithID:self.objectID];
    } else {
        self.object = [NSEntityDescription insertNewObjectForEntityForName:@"Animal" inManagedObjectContext:[self childContext]];
    }
    
    [self refreshData];
}

- (void)refreshData {
    NSUInteger animalType = [[self.object valueForKey:@"type"] unsignedIntegerValue];
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    for (int i = 0; i < rows; i++) {
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    }
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:animalType inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];

    self.dateOfBirdthCell.selectionStyle = animalType == 0 ?UITableViewCellSelectionStyleNone:UITableViewCellSelectionStyleGray;
    self.dateOfBirdthCell.textLabel.enabled = animalType != 0;
    self.dateOfBirdthCell.detailTextLabel.enabled = animalType != 0;
    
    self.collarCell.selectionStyle = animalType == 1 ?UITableViewCellSelectionStyleNone:UITableViewCellSelectionStyleGray;
    self.collarLabel.enabled = animalType == 0;
    self.collarTextField.enabled = animalType == 0;
    
    NSUInteger group = [[self.object valueForKey:@"group"] unsignedIntegerValue];
    NSString* groupName = nil;
    switch (group) {
        case 0:
            groupName = @"Сухостой";
            break;
        case 1:
            groupName = @"Низко продуктивная";
            break;
        case 2:
            groupName = @"Средне продуктивная";
            break;
        case 3:
            groupName = @"Высоко продуктивная";
            break;
        default:
            break;
    }
    self.groupCell.detailTextLabel.text = groupName;
    self.groupCell.selectionStyle = animalType == 1 ?UITableViewCellSelectionStyleNone:UITableViewCellSelectionStyleGray;
    self.groupCell.textLabel.enabled = animalType == 0;
    self.groupCell.detailTextLabel.enabled = animalType == 0;
    
    self.tagTextField.text = [NSString stringWithFormat:@"%d",[[self.object valueForKey:@"tag"] unsignedIntegerValue]];
    self.collarTextField.text = [self.object valueForKey:@"collar"];
    
    NSString* dateOfBirdthString = @"";
    NSDate* dateOfBirdthDate = [self.object valueForKey:@"dateOfBirdth"];
    if (dateOfBirdthDate) {
        dateOfBirdthString = [dateOfBirdthString stringByAppendingFormat:@" %@",[self.dateFormatter stringFromDate:dateOfBirdthDate]];
    }
    self.dateOfBirdthCell.detailTextLabel.text = dateOfBirdthString;
    
    self.illButton.selected = [[self.object valueForKey:@"isIll"] boolValue];
    
    NSSet* treatments = [self.object valueForKey:@"treatments"];
    NSArray* orderedTreatments = [treatments sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    if ([orderedTreatments count] > 0) {
        self.treatment1Date.text = [self.dateFormatter stringFromDate:[orderedTreatments[0] valueForKeyPath:@"date"]];
        self.treatment1Ill.text = [orderedTreatments[0] valueForKeyPath:@"illness.name"];
        self.treatment1Drug.text = [orderedTreatments[0] valueForKeyPath:@"drug.name"];
        self.treatment1Result.text = [orderedTreatments[0] valueForKeyPath:@"result"];
    }
    if ([orderedTreatments count] > 1) {
        self.treatment2Date.text = [self.dateFormatter stringFromDate:[orderedTreatments[1] valueForKeyPath:@"date"]];
        self.treatment2Ill.text = [orderedTreatments[1] valueForKeyPath:@"illness.name"];
        self.treatment2Drug.text = [orderedTreatments[1] valueForKeyPath:@"drug.name"];
        self.treatment2Result.text = [orderedTreatments[1] valueForKeyPath:@"result"];
    }
    if ([orderedTreatments count] > 2) {
        self.treatment3Date.text = [self.dateFormatter stringFromDate:[orderedTreatments[2] valueForKeyPath:@"date"]];
        self.treatment3Ill.text = [orderedTreatments[2] valueForKeyPath:@"illness.name"];
        self.treatment3Drug.text = [orderedTreatments[2] valueForKeyPath:@"drug.name"];
        self.treatment3Result.text = [orderedTreatments[2] valueForKeyPath:@"result"];
    }

    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    __weak MDEditCowViewController* weakSelf = self;
    NSManagedObject* object = self.object;
    if ([segue.destinationViewController isKindOfClass:[MDSelectGroupViewController class]]) {
        NSUInteger group = [[self.object valueForKey:@"group"] unsignedIntegerValue];
        [(MDSelectGroupViewController*)segue.destinationViewController setSelectedIndex:group];
        [(MDSelectGroupViewController*)segue.destinationViewController setDidSelectGroupAction:^(NSUInteger groupIndex) {
            [object setValue:@(groupIndex) forKey:@"group"];
            [weakSelf refreshData];
        }];
    }
    if ([segue.destinationViewController isKindOfClass:[MDDatePickerViewController class]]) {
        NSDate* dateOfBirdthDate = [self.object valueForKey:@"dateOfBirdth"];
        [(MDDatePickerViewController*)segue.destinationViewController setCurrentDate:dateOfBirdthDate];
        [(MDDatePickerViewController*)segue.destinationViewController setDidSelectDateAction:^(NSDate * date) {
            [object setValue:date forKey:@"dateOfBirdth"];
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
    NSString* collar = self.collarTextField.text;
    NSString* tagString = self.tagTextField.text;
    float tag = [tagString floatValue];
    NSUInteger type = [[self.object valueForKey:@"type"] unsignedIntegerValue];
    BOOL isIll = self.illButton.selected;
    
    if ((collar == nil || [collar isEqualToString:@""]) && type == 0) {
        isValid = NO;
        errorMessage = @"Введите номер ошейника";
    } else if (type == 0) {
        NSDictionary* commitedValues = [self.object committedValuesForKeys:@[@"collar"]];
        NSString* oldValue = [commitedValues valueForKey:@"collar"];
        if (oldValue == nil || ![oldValue isEqualToString:collar]) {
            NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Animal"];
            [request setPredicate:[NSPredicate predicateWithFormat:@"collar == %@",collar]];
            NSUInteger count = [[self childContext] countForFetchRequest:request error:nil];
            if (count > 0) {
                isValid = NO;
                errorMessage = @"Корова с таким ошейником уже существует";
            }
        }
    }
    
    if ([tagString length] > 0 && tag == 0) {
        isValid = NO;
        errorMessage = @"Номер бирки не может быть нулевым";
    }
    
    if (errorMessage) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    
    if (isValid) {
        [self.object setValue:collar forKey:@"collar"];
        [self.object setValue:@(tag) forKey:@"tag"];
        [self.object setValue:@(type) forKey:@"type"];
        [self.object setValue:@(isIll) forKey:@"isIll"];
        
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
    [self setCollarTextField:nil];
    [self setTagTextField:nil];
    [self setCollarLabel:nil];
    [self setIllButton:nil];
    [self setIllCell:nil];
    [self setGroupCell:nil];
    [self setDateOfBirdthCell:nil];
    [self setTagCell:nil];
    [self setCollarCell:nil];
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
    if (textField == self.collarTextField) {
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.collarCell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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
        [self.object setValue:@(tag) forKey:@"tag"];
    }
    if (textField == self.collarTextField) {
        NSString* collar = self.collarTextField.text;
        [self.object setValue:collar forKey:@"collar"];
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
        [self.collarTextField becomeFirstResponder];
    }
    if (textField == self.collarTextField) {
        [self.tagTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger animalType = [[self.object valueForKey:@"type"] unsignedIntegerValue];
    if ([tableView cellForRowAtIndexPath:indexPath] == self.dateOfBirdthCell && animalType == 0) {
        return nil;
    }
    if ([tableView cellForRowAtIndexPath:indexPath] == self.groupCell && animalType == 1) {
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
        [self.object setValue:@(indexPath.row) forKey:@"type"];
        [self refreshData];
    }
    if ([tableView cellForRowAtIndexPath:indexPath] == self.illCell) {
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
