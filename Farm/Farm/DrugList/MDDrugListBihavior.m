//
//  MDDrugListBihavior.m
//  Farm
//
//  Created by Mark Kryzhanouski on 7/8/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import "MDDrugListBihavior.h"
#import "MDEditDrugViewController.h"
#import "MDDrugListViewController.h"


@implementation MDDrugListBihavior

- (MDDrugListViewController*)drugController {
    return (MDDrugListViewController*)_viewController;
}

- (void)setAttachedViewController:(UIViewController *)attachedViewController {
    [super setAttachedViewController:attachedViewController];
    attachedViewController.title = @"Список Лекарств";
    attachedViewController.navigationItem.rightBarButtonItems = @[attachedViewController.editButtonItem,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDrugAction)]];
    MDDrugListBihavior* __weak weakSelf = self;
    [[self drugController] setDidSelectDrugAction:^(NSManagedObject * drug) {
        [weakSelf editDrug:drug];
    }];
}

- (void)addDrugAction {
    [self editDrug:nil];
}

- (void)editDrug:(NSManagedObject*)object {
    MDEditDrugViewController* ctr = [[self drugController].storyboard instantiateViewControllerWithIdentifier:@"MDEditDrugViewController"];
    [ctr setManagedObjectContext:[self drugController].managedObjectContext];
    [ctr setObjectID:[object objectID]];
    [[self drugController].navigationController pushViewController:ctr animated:YES];
}

@end
