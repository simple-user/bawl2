//
//  NewItemViewController.m
//  bawl2
//
//  Created by Admin on 10.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "NewItemViewController.h"
#import "Constants.h"
#import "TakePhotoViewController.h"
#import "NewItemViewControllerPhotoInfoDelegate.h"
#import "MyAlert.h"
#import "NetworkDataSorce.h"

@interface NewItemViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
//name section
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//category section
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (nonatomic) BOOL isCategoryPickerCellEnable;
@property (strong, nonatomic) IssueCategory *selectedCategory;
//sdescription secrion
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
//photo section
@property(strong, nonatomic) NewItemViewControllerPhotoInfoDelegate *photoDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end

@implementation NewItemViewController


#pragma mark - Lasy Instantiation
-(NewItemViewControllerPhotoInfoDelegate*)photoDelegate
{
    if(_photoDelegate == nil)
        _photoDelegate = [[NewItemViewControllerPhotoInfoDelegate alloc] init];
    return _photoDelegate;
}


#pragma mark - Load / Appear

-(void)viewDidLoad
{
    self.categoryImage.hidden = YES;
    self.categoryImage.alpha = 0;
    self.categoryName.hidden = YES;
    self.categoryName.alpha = 0;
    self.isCategoryPickerCellEnable = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MyNotificationIssueCategoriesDidLoad
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self.categoryPicker reloadAllComponents];
                                                  }];
}

-(void)viewWillAppear:(BOOL)animated
{
    //even if it's nil!
    self.photoView.image = self.photoDelegate.image;
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameTextField resignFirstResponder];
    return YES;
}


#pragma mark - TableView Delegate / Sorce

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath ];
    if(cell == nil)
        NSLog(@"custom cell wasn't inited!");
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1 && indexPath.row==1)
    {
        if(self.isCategoryPickerCellEnable == NO)
            return 0;
        else
            return 150;
    }
    else return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(indexPath.section==1 && indexPath.row==0) // category
    {
        self.isCategoryPickerCellEnable = !self.isCategoryPickerCellEnable;
        // next two rows - are just some f*king miracle
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        if(self.categoryName.hidden == YES)
        {
            IssueCategory *cat = [[[IssueCategories standartCategories] categories] firstObject];
            if(cat!=nil)
            {
                self.selectedCategory = cat;
                self.categoryImage.image = cat.image;
                self.categoryName.text = cat.name;
                self.categoryImage.hidden = NO;
                self.categoryName.hidden = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    self.categoryImage.alpha = 1.0;
                    self.categoryName.alpha = 1.0;
                }];
            }
        }
    }
    else if (indexPath.section==3)
    {
        [self performSegueWithIdentifier:MySegueFromNewIssueToGetPhoto sender:indexPath];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // we just need to hide keyboard ;)
    [self.descriptionTextView resignFirstResponder];
}


#pragma mark - Picker View data sorce

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    IssueCategories *cats = [IssueCategories standartCategories];
    if(cats == nil)
        return 0;
    else
        return [[cats categories] count];
}

#pragma mark - Picker View delegate

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[[[IssueCategories standartCategories] categories] objectAtIndex:row] name];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    IssueCategory *cat = [[[IssueCategories standartCategories] categories] objectAtIndex:row];
    if(cat!=nil)
    {
        self.selectedCategory = cat;
        self.categoryImage.image = cat.image;
        self.categoryName.text = cat.name;
        if (self.categoryImage.hidden==YES)
        {
            self.categoryImage.hidden = NO;
            self.categoryName.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.categoryImage.alpha = 1.0;
                self.categoryName.alpha = 1.0;
            }];
        }
    }
    else
    {
        self.selectedCategory = nil;
        self.categoryImage.hidden = YES;
        self.categoryImage.alpha = 0;
        self.categoryName.hidden = YES;
        self.categoryName.alpha = 0;
        NSLog(@"Troubles with displaying category image in new item view controller");
        
        
    }
}

#pragma mark - Actions


- (IBAction)cancelController:(UIBarButtonItem *)sender {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)doneWithController:(UIBarButtonItem *)sender {
    if (!(self.nameTextField.text.length!=0
        && self.selectedCategory!=nil
        && self.descriptionTextView.text.length!=0
        && self.photoView.image!=nil))
        {
            [MyAlert alertWithTitle:@"Check" andMessage:@"Fill all fields :)"];
            return;
        }
    
    NetworkDataSorce *dataSorce = [[NetworkDataSorce alloc] init];
    Issue *issueForSend = [[Issue alloc] init];
    issueForSend.name = self.nameTextField.text;
    issueForSend.issueDescription = self.descriptionTextView.text;
    issueForSend.categoryId = [self.selectedCategory.categoryId stringValue];
    issueForSend.attachments = self.photoDelegate.filenameOfLoadedToServerPhoto;
    // LatLng(50.66181, 26.16304)
    issueForSend.mapPointer = [NSString stringWithFormat:@"LatLng(%f, %f)", self.mapLoaction.latitude, self.mapLoaction.longitude];
    
    [dataSorce requestAddNewIssue:issueForSend withHandler:^(Issue *returnedIssue, NSError *error) {
       // if it's OK unwind to map
        if(returnedIssue!=nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.createdIssue = returnedIssue;
                [self.createdIssue addCoordinateInfo];
                [self performSegueWithIdentifier:MySegueUnwindSegueFromNewItemToMap sender:self];
            });
        }
            
    }];

    
}


#pragma mark - Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[NSIndexPath class]] && [segue.identifier isEqualToString:MySegueFromNewIssueToGetPhoto])
    {
        TakePhotoViewController *tfvc = (TakePhotoViewController*)segue.destinationViewController;
        tfvc.nameOfIssue = self.nameTextField.text;
        tfvc.photoDelegate = self.photoDelegate;
    }
    else if([segue.identifier isEqualToString:MySegueUnwindSegueFromNewItemToMap])
    {
        // sending of request will be on map
    }
    
}




@end
