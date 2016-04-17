//
//  TakePhotoViewController.h
//  bawl2
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewItemViewController.h"
#import "NewItemViewControllerPhotoInfoDelegate.h"

@interface TakePhotoViewController : UIViewController

@property(strong, nonatomic) NSString *nameOfIssue;
@property(strong, nonatomic) NewItemViewControllerPhotoInfoDelegate *photoDelegate;

@end
