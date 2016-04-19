//
//  NewItemViewController.h
//  bawl2
//
//  Created by Admin on 10.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDIssue.h"
#import "IssueCategories.h"
#import <MapKit/MapKit.h>

@interface NewItemViewController : UITableViewController


// in
@property(nonatomic) CLLocationCoordinate2D mapLoaction;

//out
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;  // --->out
@property (strong, nonatomic) IssueCategory *selectedCategory;   // ---> out
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;  // --->out



@end

