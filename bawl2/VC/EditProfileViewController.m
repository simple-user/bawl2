//
//  EditProfileViewController.m
//  bawl2
//
//  Created by Admin on 27.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Constants.h"
#import "UIColor+Bawl.h"
#import "CurrentItems.h"
#import "NetworkDataSorce.h"
#import "MyAlert.h"
#import "TextFieldValidation.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *avatarView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameText;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailText;

@property (strong, nonatomic) IBOutlet UIView *background;

@property(strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property(strong, nonatomic) UITextField *currentTextField;
@property(strong, nonatomic) TextFieldValidation *textFieldValidator;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomScrollViewConstraint;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

// out properties
@property(strong, nonatomic)NSString *outAvatarFileName;
@property(strong, nonatomic)UIImage *outAvatarImage;
@property(strong, nonatomic)NSString *outName;
@property(strong, nonatomic)NSString *outEmail;


@end

@implementation EditProfileViewController


#pragma mark - Init / appear / load view
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserverForName:MyNotificationUploadAvatarImageInfo
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      self.progress.progress = [note.userInfo[CustomDictionaryKeyUploadAvatarImageInfoForProgress] floatValue];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Lasy Instantiation

-(TextFieldValidation*)textFieldValidator
{
    if(_textFieldValidator==nil)
        _textFieldValidator = [[TextFieldValidation alloc] init];
    return _textFieldValidator;
}


-(void)setProgress:(UIProgressView *)progress
{
    _progress = progress;
    _progress.hidden = YES;
}

-(void)setNameLabel:(UILabel *)nameLabel
{
    _nameLabel = nameLabel;
    _nameLabel.attributedText = [[NSAttributedString alloc] initWithString:@"NAME"
                                                                attributes:@{NSForegroundColorAttributeName : [UIColor bawlRedColor]}];
}

-(void)setEmailLabel:(UILabel *)emailLabel
{
    _emailLabel = emailLabel;
    _emailLabel.attributedText = [[NSAttributedString alloc] initWithString:@"EMAIL"
                                                                attributes:@{NSForegroundColorAttributeName : [UIColor bawlRedColor]}];
}

-(void)setNameText:(UITextField *)nameText
{
    _nameText = nameText;
    _nameText.text = self.user.name;
}

-(void)setEmailText:(UITextField *)emailText
{
    _emailText = emailText;
    _emailText.text = self.user.email;
}


-(void)setAvatarView:(UIImageView *)avatarView
{
    _avatarView = avatarView;
    _avatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _avatarView.layer.borderWidth = 3.0;
    _avatarView.image = [CurrentItems sharedItems].userImage;
}

-(void)setBackground:(UIView *)background
{
    _background = background;
    _background.backgroundColor = [UIColor bawlRedColor];
}

-(User*)user
{
    if(!_user)
    {
        _user = [CurrentItems sharedItems].user;
    }
    return _user;
}


#pragma mark - Profile image box delegata

-(void)profileImageBoxUpdatedImage:(UIImage *)image
{
    self.avatarView.image = image;
}

#pragma mark - Actions

- (IBAction)takePhotoButton {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:NULL];

}

- (IBAction)doneWithThisControler
{
    self.textFieldValidator.fields = @[self.nameText, self.emailText];
    
    if (![self.textFieldValidator isFilled])
        return;
    
    if(![self.textFieldValidator isValidFields])
        return;

}


#pragma mark - Imasge Picker Controller Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.progress.progress = 0;
    self.progress.hidden = NO;
    self.avatarView.image = nil;
    
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
                           kind:ImageKindAvatar
                    withHandler:^(NSString *fileName, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(fileName != nil && error == nil)
                            {
                                [self.profileImageBox.subscribersImageLoad removeAllObjects];
                                self.progress.hidden = YES;
                                self.avatarView.alpha = 0.0;
                                self.avatarView.image = imageForSend;
                                [UIView animateWithDuration:0.4
                                                 animations:^{
                                                     self.avatarView.alpha = 1.0;
                                                 }];
                                self.outAvatarFileName = fileName;
                                self.outAvatarImage = imageForSend;
                            }
                            else
                            {
                                [MyAlert alertWithTitle:@"Image upload" andMessage:@"Image upload faild"];
                            }
                        });
                    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextFild delegate + keyboard

#define TEXTFIELD_OFFSET 10

-(void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary *dic = notification.userInfo;
    NSValue *keyboardFrame = dic[UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [keyboardFrame CGRectValue];
    CGRect viewFrame = [self.view convertRect:frame fromView:nil];
    CGFloat keyboardHeight = viewFrame.size.height;
    
    self.bottomScrollViewConstraint.constant = keyboardHeight;
    [self.view layoutIfNeeded];
    
    if (self.currentTextField == nil)
        return;
    
    CGPoint scrollOffset = self.scrollView.contentOffset;
    
    CGFloat bottomCurrentFieldByScrollView = self.currentTextField.frame.origin.y - scrollOffset.y + self.currentTextField.bounds.size.height + TEXTFIELD_OFFSET;
    CGFloat bottomScrollView = self.scrollView.bounds.size.height;
    
    if(bottomCurrentFieldByScrollView != bottomScrollView)
    {
        CGFloat yMove = bottomCurrentFieldByScrollView - bottomScrollView;
        CGFloat newY = (scrollOffset.y + yMove < 0) ? 0 : scrollOffset.y + yMove;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(scrollOffset.x, newY);
        }];
        
    }
    
}

-(void)keyboardWillHide
{
    self.bottomScrollViewConstraint.constant = 0;
    [self.view layoutIfNeeded];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    textField.backgroundColor = [UIColor whiteColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.placeholder = textField.restorationIdentifier;
    self.currentTextField = nil;
    [self.textFieldValidator isValidField:textField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.currentTextField resignFirstResponder];
    self.currentTextField = nil;
    return YES;
}




@end
