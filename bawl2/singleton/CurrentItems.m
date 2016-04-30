//
//  CurrentItems.m
//  net
//
//  Created by Admin on 14.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "CurrentItems.h"
#import "NetworkDataSorce.h"
#import "Constants.h"
#import "MyAlert.h"



@interface CurrentItems()

@property(strong, nonatomic) id<DataSorceProtocol> dataSorce;
@property(strong, nonatomic) NSURL* fullURLforUIManagedDocument;

@property(nonatomic) BOOL isInitManagedObjectcontextStarted;

@end

@implementation CurrentItems

// повний шлях у нас використовується при створенні document
// а також при перевірці чи існує такий файл
// тому повний шлях у нас: self.fullURLforUIManagedDocument

// оскільки віддкривання чи стчворення файлу у нас відбувається в блоці
// тому ми не можемо відвразу повернути context
// тому у нас void метод startInitManagedObjextContext
// у випадку коли він вже проініціалізований - він же й вповертається
// якщо ні - поівертається nil, но при цьому запускається відповідний метод (стратування ініціалізації)
// і вже там десь він буде сетатись

-(NSURL*)fullURLforUIManagedDocument
{
    if (_fullURLforUIManagedDocument==nil)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDir = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *documentName = @"BawlDoc";
        _fullURLforUIManagedDocument = [documentsDir URLByAppendingPathComponent:documentName];
    }
    return _fullURLforUIManagedDocument;
}

-(UIManagedDocument*)managedDocument
{
    if(_managedDocument == nil)
    {
        _managedDocument = [[UIManagedDocument alloc] initWithFileURL:self.fullURLforUIManagedDocument];
    }
    return _managedDocument;
}

-(NSManagedObjectContext*)managedObjectContext
{
    if (_managedObjectContext==nil && !self.isInitManagedObjectcontextStarted)
        [self startInitManagedObjectcontext];
    return _managedObjectContext;
}

-(void)startInitManagedObjectcontext
{
    self.isInitManagedObjectcontextStarted = YES;
    
    // if it already inited - we do nothing
    if (self.managedObjectContext!=nil)
        return;
    
    __weak CurrentItems *weakSelf = self;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.fullURLforUIManagedDocument path]])
    {
        // якщо файл існує
        [self.managedDocument openWithCompletionHandler:^(BOOL success) {
            [weakSelf afterOpenManagedDocument:success];
        }];
    }
    else
    {
        // файл не існує - створюємо
        [self.managedDocument saveToURL:self.fullURLforUIManagedDocument
                       forSaveOperation:UIDocumentSaveForCreating
                      completionHandler:^(BOOL success) {
            [weakSelf afterOpenManagedDocument:success];
        }];
    }
}


-(void)afterOpenManagedDocument:(BOOL)success
{
    BOOL someFail = NO;
    if(success==YES)
    {
        if (self.managedDocument.documentState == UIDocumentStateNormal)
        {

            self.managedObjectContext = self.managedDocument.managedObjectContext;
            [[NSNotificationCenter defaultCenter] postNotificationName:MyNotificationManagedObjectDidInit object:self];
        }
        else
        {
            someFail = YES;
        }
    }
    else
    {
        someFail = YES;
    }
    
    // check for fail
    if (someFail == YES)
    {
        [MyAlert alertWithTitle:@"Getting cache info" andMessage:@"Fail while loading cache"];
    }
}

-(NSMutableDictionary <NSString*, ActiveRequest*> *)activeRequests
{
    if(_activeRequests==nil)
    {
        _activeRequests = [[NSMutableDictionary alloc] init];
    }
    return _activeRequests;
}

-(id<DataSorceProtocol>)dataSorce
{
    if(_dataSorce==nil)
        _dataSorce = [[NetworkDataSorce alloc] init];
    return _dataSorce;
}


+(instancetype)sharedItems
{
    static CurrentItems *sharedItems_ = nil;
    static dispatch_once_t token =0;
    dispatch_once(&token, ^{
        sharedItems_ = [[super alloc] initSinleObject];
    });
    
    return sharedItems_;
}

-(instancetype)initSinleObject
{
    if(self = [super init])
    {
        _userImageDelegates = [[NSMutableArray alloc] init];
        _issueImageDelegates = [[NSMutableArray alloc] init];
        _isInitManagedObjectcontextStarted = NO;
    }
    return self;
}


-(void)setUser:(User *)user
{
    _user = user;
    // NSString *unchangedName = _user.avatar;
    // we don't even need to check name after download image, because when we start
    // download new one - prewious will be canceled
    if(user!=nil)
    {
        [self.dataSorce requestImageWithName:_user.avatar andImageType:ImageNameCurrentUserImage
        andHandler:^(UIImage *image, NSError *error) {
            NSLog(@"_setUser_: We've got response from server about current user avatar.");
            if(image!=nil)
            {
                self.userImage = image;
                [self.userImageDelegates makeObjectsPerformSelector:@selector(userImageDidLoad)];
            }
            else
            {
                //fail load user avatar
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MyAlert alertWithTitle:@"We have a problem cap!" andMessage:[NSString stringWithFormat:@"Avatar download for user %@ failed.", self.user.name]];
                    self.userImage = [UIImage imageNamed:ImageNameNoUser];
                    [self.userImageDelegates makeObjectsPerformSelector:@selector(userImageDidFailedLoad)];
                });
            }
        }];
    }
}
//
//-(void)setUser:(User *)user withChangingImageViewBloc:(void(^)()) changinImageView
//{
//    self.user = user;
//    
//    NSString *unchangedName = self.user.avatar;
//    [self.dataSorce requestImageWithName:self.user.avatar andHandler:^(UIImage *image, NSError *error) {
//        if ([unchangedName isEqualToString:self.user.avatar])
//        {
//            self.userImage = image;
//            changinImageView();
//        }
//    }];
//    
//}

-(void)setIssue:(Issue *)issue
{
    _issue = issue;
    self.issueImage = nil;
    // NSString *unchangedName = self.issue.attachments;
    //temp
    NSString *tempAttach = _issue.attachments;
    [self.dataSorce requestImageWithName:_issue.attachments andImageType:ImageNameCurrentIssueImage
    andHandler:^(UIImage *image, NSError *error) {
        if(image != nil)
        {
            NSLog(@"_setIssue_: current issue image is DOWNLOADED. (filename:%@)", tempAttach);
            self.issueImage = image;
            [self.issueImageDelegates makeObjectsPerformSelector:@selector(issueImageDidLoad)];
        }
        else
        {
            NSLog(@"_setIssue_: current issue image download is FAILED . (filename:%@)", tempAttach);
            self.issueImage = [UIImage imageNamed:ImageNameNoIssue];
            [self.issueImageDelegates makeObjectsPerformSelector:@selector(issueImageDidFailedLoad)];
        }
        
        
    }];
    
    
//    [self.dataSorce requestImageWithName:self.issue.attachments andHandler:^(UIImage *image, NSError *error) {
//        if ([unchangedName isEqualToString:self.issue.attachments])
//        {
//            self.issueImage = image;
//            [self.issueImageDelegates makeObjectsPerformSelector:@selector(issueImageDidLoad)];
//        }
//    }];
}
//
//-(void)setIssue:(Issue *)issue withChangingImageViewBloc:(void(^)()) changinImageView
//{
//    self.issue = issue;
//    
//    NSString *unchangedName = self.issue.attachments;
//    [self.dataSorce requestImageWithName:self.issue.attachments andHandler:^(UIImage *image, NSError *error) {
//        if ([unchangedName isEqualToString:self.issue.attachments])
//        {
//            self.issueImage = image;
//            changinImageView();
//            
//        }
//    }];
//    
//}





@end
