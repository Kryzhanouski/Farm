//
//  RecipeList.h
//  foody
//
//  Created by Tope on 01/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myJson.h"

@interface RecipeList : UITableViewController <myJsonDelegate>

@property (nonatomic, retain) NSMutableArray *recipes;

-(void)loadRecipes;
@end