//
//  TakePhotoViewController.m
//  bawl2
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "TakePhotoViewController.h"

@interface TakePhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end

@implementation TakePhotoViewController




- (IBAction)tekePhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    switch (self.segmentedControl.selectedSegmentIndex == 0)
    {
        case 0: imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 1: imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 2: imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
    }
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
