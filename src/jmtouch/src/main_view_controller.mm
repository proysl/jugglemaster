/*
 * JMTouch - JuggleMaster for iPhone / iPod Touch
 * Version 1.00
 * (C) Per Johan Groland 2009
 *
 * Using JMLib 2.1 (C) Per Johan Groland 2000-2009
 * Based on JuggleMaster Version 1.60
 * Copyright (C) 1995-1996 Ken Matsuoka
 *
 * JuggleSaver support based on Juggler3D
 * Copyright (c) 2005-2008 Brian Apps <brian@jugglesaver.co.uk>
 *
 * JMTouch is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation; either version 2 of the License,
 * or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 */

#import "main_view_controller.h"
#import "main_view.h"
#import "app_delegate.h"

@implementation MainViewController

@synthesize jm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
   tableItems = [[NSArray alloc] initWithObjects:@"Enter Siteswap",@"Settings",@"Random Pattern",@"3D Mode",@"2D Mode",nil];

   categories = [[NSArray alloc] initWithObjects:@"Category 1", @"Category 2",@"Category 3",@"Category 4",@"Category 5",nil];
   fakeItems = [[NSArray alloc] initWithObjects:@"Item 1",@"Item 2",@"Item 3",@"Item 4",@"Item 5",@"Item 6",@"Item 7",@"Item 8",@"Item 9",nil];
   
   [super viewDidLoad];
 }


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
  //[appDelegate showJuggler];
}

- (void)enterSiteViewControllerDidFinish:(EnterSiteViewController *)controller {
	[self dismissModalViewControllerAnimated:NO];
  [appDelegate showJuggler];
}


/*
- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}
 */

- (IBAction)done {
  [appDelegate showJuggler];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)setAppDelegate:(jmtouchAppDelegate*)appDelegate_ {
  appDelegate = appDelegate_;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [categories count] + 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) 
    return [tableItems count];
  else
    return [fakeItems count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
  }
  
  if (indexPath.section == 0) {
    if (indexPath.row <= 1)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else if (indexPath.row == 3 && jm->getRenderingMode() == RENDERING_OPENGL_3D)
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if (indexPath.row == 4 && jm->getRenderingMode() == RENDERING_OPENGL_2D)
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
      cell.accessoryType = UITableViewCellAccessoryNone;
  }
  else
    cell.accessoryType = UITableViewCellAccessoryNone;
  
  if (indexPath.section == 0)
    cell.textLabel.text = [tableItems objectAtIndex:indexPath.row];
  else
    cell.textLabel.text = [fakeItems objectAtIndex:indexPath.row];
  
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  if(section == 0)
    return nil;
  else
    return [categories objectAtIndex:section - 1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString* str = [tableItems objectAtIndex:indexPath.row];
  
  if (indexPath.section == 0) { 
    if ([str isEqualToString:@"Enter Siteswap"]) {
      EnterSiteViewController *controller = [[EnterSiteViewController alloc] initWithNibName:@"EnterSiteView" bundle:nil];
      controller.delegate = self;
      
      controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
      [self presentModalViewController:controller animated:YES];
      
      [controller release];
      
    }
    else if ([str isEqualToString:@"Random Pattern"]) {
      jm->setPattern("3B@(1,-0.4)>(2,4.2)/(-2,1)3B@(-1.8,4.4)>(-2.1,0)");    
      [appDelegate showJuggler];
    }
    else if ([str isEqualToString:@"3D Mode"]) {
      jm->setRenderingMode(RENDERING_OPENGL_3D);
      [appDelegate showJuggler];
    }
    else if ([str isEqualToString:@"2D Mode"]) {
      jm->setRenderingMode(RENDERING_OPENGL_2D);    
      [appDelegate showJuggler];
    }
    else if ([str isEqualToString:@"Settings"]) {
      FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
      controller.delegate = self;
    
      controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
      [self presentModalViewController:controller animated:YES];
    
      [controller release];
    }
    else {
      
    }
  }
  else {
    
  }
}

@end