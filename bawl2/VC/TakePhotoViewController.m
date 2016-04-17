//
//  TakePhotoViewController.m
//  bawl2
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "NetworkDataSorce.h"
#import "MyAlert.h"
#import "Constants.h"

@interface TakePhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

// prepare for out
// it will be setted only by tapping OK
@property(strong, nonatomic) NSString *outFileName;
@property(strong, nonatomic) UIImage *outImage;

@end

@implementation TakePhotoViewController


#pragma mark - Lasy instantiations
-(void)setProgress:(UIProgressView *)progress
{
    _progress = progress;
    _progress.hidden = YES;
}


#pragma mark - Init / appear
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserverForName:MyNotificationUploadIssueImageInfo
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      self.progress.progress = [note.userInfo[CustomDictionaryKeyUploadIssueImageInfoForProgress] floatValue];
                                                  }];
}

#pragma mark - Actions

- (IBAction)tekePhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0: imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 1: imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 2: imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
    }
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    self.photoDelegate.filenameOfLoadedToServerPhoto = self.outFileName;
    self.photoDelegate.image = self.outImage;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Imasge Picker Controller Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.progress.progress = 0;
    self.progress.hidden = NO;
    self.photoView.image = nil;

    // UIImagePickerControllerEditedImage - uiimage
    // UIImagePickerControllerMediaURL - NSURL
    // UIImagePickerControllerReferenceURL - NSURL
    
    // [info[UIImagePickerControllerReferenceURL] absoluteString]
    // assets-library://asset/asset.JPG?id=106E99A1-4F6A-45A2-B320-B0AD4A8E8473&ext=JPG
    NSString *lastComp = [info[UIImagePickerControllerReferenceURL] lastPathComponent];
    NSString *stringType = [lastComp substringFromIndex:lastComp.length-3];
    UIImage *imageForSend = info[UIImagePickerControllerEditedImage];
    
    NetworkDataSorce *datasorce = [[NetworkDataSorce alloc] init];
    [datasorce requestSendImage:imageForSend
                         ofType:stringType
                    withHandler:^(NSString *fileName, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(fileName != nil && error == nil)
                            {
                                self.progress.hidden = YES;
                                self.photoView.alpha = 0.0;
                                self.photoView.image = imageForSend;
                                [UIView animateWithDuration:0.4
                                                 animations:^{
                                                     self.photoView.alpha = 1.0;
                                                 }];
                                self.outFileName = fileName;
                                self.outImage = imageForSend;
                            }
                            else
                            {
                                [MyAlert alertWithTitle:@"Image upload" andMessage:@"Image upload faild"];
                            }
                        });
                    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
