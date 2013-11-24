//
//  MDMasterViewController.m
//  Farm
//
//  Created by Mark Kryzhanouski on 6/30/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDMasterViewController.h"
#import "MDCowListViewController.h"
#import "MDDrugListViewController.h"
#import "MDIllnessListViewController.h"
#import "MDIllnessListBihavior.h"
#import "MDDrugListBihavior.h"


@interface MDMasterViewController ()
@property (nonatomic, strong) UINavigationController* cowListStack;
@property (nonatomic, strong) UINavigationController* calfListStack;
@property (nonatomic, strong) UINavigationController* sickCowListStack;
@property (nonatomic, strong) UINavigationController* sickCalfListStack;
@property (nonatomic, strong) UINavigationController* drugListStack;
@property (nonatomic, strong) UINavigationController* treatmentListStack;
@property (nonatomic, strong) UINavigationController* currentStack;
@end

@implementation MDMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Действие";
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentStack = [self cowListStack];
    self.splitViewController.viewControllers = @[self.parentViewController,self.currentStack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger  number = 0;
    switch (section) {
        case 0:
            number = 2;
            break;
        case 1:
            number = 2;
            break;
        case 2:
            number = 2;
            break;
        default:
            break;
    }
    return number;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* title = 0;
    switch (section) {
        case 0:
            title = @"Все Поголовье";
            break;
        case 1:
            title = @"Больное Поголовье";
            break;
        case 2:
            title = @"Другое";
            break;
        default:
            break;
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:212.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Стадо";
                cell.imageView.image = [UIImage imageNamed:@"Cow_head2"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Телята";
                cell.imageView.image = [UIImage imageNamed:@"calf.png"];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Стадо";
                cell.imageView.image = [UIImage imageNamed:@"Cow_head2"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Телята";
                cell.imageView.image = [UIImage imageNamed:@"calf.png"];
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Лекарства";
                cell.imageView.image = [UIImage imageNamed:@"Drug"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Болезни";
                cell.imageView.image = [UIImage imageNamed:@"Pharmacy"];
            }
            break;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController* nextStack = nil;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                nextStack = [self cowListStack];
            } else if (indexPath.row == 1) {
                nextStack = [self calfListStack];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                nextStack = [self sickCowListStack];
            } else if (indexPath.row == 1) {
                nextStack = [self sickCalfListStack];
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                nextStack = [self drugListStack];
            } else if (indexPath.row == 1) {
                nextStack = [self treatmentListStack];
            }
            break;
        default:
            break;
    }
    self.currentStack = nextStack;
    self.splitViewController.viewControllers = @[self.parentViewController, nextStack];
}

- (UINavigationController*)cowListStack {
    if (_cowListStack == nil) {
        MDCowListViewController* ctr = (MDCowListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MDCowListViewController class])];
        ctr.managedObjectContext = self.managedObjectContext;
        ctr.filterPredicale = [NSPredicate predicateWithFormat:@"%K == %d",@keypath(Animal.new,type),AnimalTypeCow];
        UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:ctr];
        _cowListStack = nc;
    }
    return _cowListStack;
}

- (UINavigationController*)sickCowListStack {
    if (_sickCowListStack == nil) {
        MDCowListViewController* ctr = (MDCowListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MDCowListViewController class])];
        ctr.managedObjectContext = self.managedObjectContext;
        ctr.filterPredicale = [NSPredicate predicateWithFormat:@"%K == %d && %K == YES",@keypath(Animal.new,type),AnimalTypeCow,@keypath(Animal.new,isIll)];
        UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:ctr];
        _sickCowListStack = nc;
    }
    return _sickCowListStack;
}

- (UINavigationController*)calfListStack {
    if (_calfListStack == nil) {
        MDCowListViewController* ctr = (MDCowListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MDCowListViewController class])];
        ctr.managedObjectContext = self.managedObjectContext;
        ctr.animalType = AnimalTypeCalf;
        ctr.filterPredicale = [NSPredicate predicateWithFormat:@"%K == %d",@keypath(Animal.new,type),AnimalTypeCalf];
        UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:ctr];
        _calfListStack = nc;
    }
    return _calfListStack;
}

- (UINavigationController*)sickCalfListStack {
    if (_sickCalfListStack == nil) {
        MDCowListViewController* ctr = (MDCowListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MDCowListViewController class])];
        ctr.managedObjectContext = self.managedObjectContext;
        ctr.animalType = AnimalTypeCalf;
        ctr.filterPredicale = [NSPredicate predicateWithFormat:@"%K == %d && %K == YES",@keypath(Animal.new,type),AnimalTypeCalf,@keypath(Animal.new,isIll)];
        UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:ctr];
        _sickCalfListStack = nc;
    }
    return _sickCalfListStack;
}

- (UINavigationController*)drugListStack {
    if (_drugListStack == nil) {
        MDDrugListViewController* ctr = (MDDrugListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MDDrugListViewController class])];
        MDDrugListBihavior* listBehavior = [[MDDrugListBihavior alloc] init];
        listBehavior.attachedViewController = ctr;
        ctr.managedObjectContext = self.managedObjectContext;
        UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:ctr];
        _drugListStack = nc;
    }
    return _drugListStack;
}

- (UINavigationController*)treatmentListStack {
    if (_treatmentListStack == nil) {
        MDIllnessListViewController* ctr = (MDIllnessListViewController*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MDIllnessListViewController class])];
        MDIllnessListBihavior* listBehavior = [[MDIllnessListBihavior alloc] init];
        listBehavior.attachedViewController = ctr;
        ctr.managedObjectContext = self.managedObjectContext;
        UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:ctr];
        _treatmentListStack = nc;
    }
    return _treatmentListStack;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = @"Действие";
    NSArray* buttons = @[barButtonItem];
    if (self.currentStack.visibleViewController.navigationItem.leftBarButtonItem) {
        buttons = [buttons arrayByAddingObject:self.currentStack.visibleViewController.navigationItem.leftBarButtonItem];
    }
    [self.currentStack.visibleViewController.navigationItem setLeftBarButtonItems:buttons animated:YES];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    NSArray* buttons = @[];
    if ([self.currentStack.visibleViewController.navigationItem.leftBarButtonItems count] > 1) {
        buttons = [buttons arrayByAddingObject:[self.currentStack.visibleViewController.navigationItem.leftBarButtonItems objectAtIndex:1]];
    }
    [self.currentStack.visibleViewController.navigationItem setLeftBarButtonItems:buttons animated:YES];
}


@end
