//
//  MDMasterViewController.h
//  Farm
//
//  Created by Mark Kryzhanouski on 6/30/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDCowListViewController;

#import <CoreData/CoreData.h>

@interface MDMasterViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) MDCowListViewController *detailViewController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
