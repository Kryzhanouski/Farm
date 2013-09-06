//
//  RecipeDetail.m
//  foody
//
//  Created by Tope on 01/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RecipeDetail.h"

@implementation RecipeDetail
@synthesize dishTitle;
@synthesize dishImage;
@synthesize scrollView;
@synthesize recipe;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    scrollView.contentSize = CGSizeMake(320, 520);
    
    UIImage *backgroundImage = [UIImage imageNamed:@"leather-background.png"];
    
    UIColor *backgroundPattern= [UIColor colorWithPatternImage:backgroundImage];
    
    [self.view setBackgroundColor:backgroundPattern];
    
    dishImage.image = [UIImage imageWithData:recipe.imageData];
    dishTitle.text = recipe.name;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setScrollView:nil];
    [self setDishImage:nil];
    [self setDishTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
