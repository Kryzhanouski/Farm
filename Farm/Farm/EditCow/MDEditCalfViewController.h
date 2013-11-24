//
//  MDEditCalfViewController.h
//  Farm
//
//  Created by Mark on 11/24/13.
//  Copyright (c) 2013 Mark Kryzhanouski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDEditCalfViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectID *objectID;

@end
