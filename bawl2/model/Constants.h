//
//  NotificationsNames.h
//  net
//
//  Created by Admin on 27.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#pragma mark - my notificstions

#define MyNotificationManagedObjectDidInit @"ManagedObjectDdidInitNotification"
#define MyNotificationIssueCategoriesDidLoad @"IssueCategoriesDidLoadNotification" 
// user check on start
#define MyNotificationUserCheckedAndLogIned @"UserCheckedAndLogIned"
#define MyNotificationUserCheckAndLogInFaild @"UserCheckdAndLogInFaild"

//curren user avatar download
#define MyNotificationUserAvatarDownloadSuccess @"User avatar download success"
#define MyNotificationUserAvatarDownloadFailed @"User avatar download failed"

// notifications during upload issue image (with info)
#define MyNotificationUploadIssueImageInfo @"UploadIssueImageInfo"
#define MyNotificationUploadAvatarImageInfo @"UploadAvatarImageInfo"

#pragma mark - names of keys in custom dictionaries
// this key is in nsnotification userinfo
#define CustomDictionaryKeyUploadIssueImageInfoForProgress @"UploadIssueImageInfoForProgress"
#define CustomDictionaryKeyUploadAvatarImageInfoForProgress @"UploadAvatarImageInfoForProgress"


#pragma mark - Segue identificators

#define MySegueFromMapToLogIn @"FromMapToLogIn"
#define MySegueFromMapToDescription @"FromMapToDescription"
#define MySegueFromMapToProfile @"FromMapToProfile"
#define MySegueFromDescriptionToHistory @"FromDescriptionToHistory"
#define MySegueFromDescriptionToProfile @"FromDescriptionToProfile"
#define MySegueFromMapToNewItemModal @"fromMapToNewItem"
#define MySegueFromNewIssueToGetPhoto @"FromNewIssueToGetPhoto"
#define MySegueUnwindSegueFromNewItemToMap @"UnwindSegueFromNewItemToMap"
#define MySegueFromProfileToEditProfile @"FromProfileToEditProfile"
#define MySegueFromDescriptionToHistory @"FromDescriptionToHistory"
#define MySegueFromHistoryToProfile @"FromHistoryToProfile"

#pragma mark - default names for blank images (user, issue)
//names wich chenge [NSNull null]
#define ImageNameForBLankUser @"defaultUser"
#define ImageNameForBLankIssue @"defaultIssue"

//local names of images for no_issue and no_user
#define ImageNameNoUser @"no_avatar"
#define ImageNameNoIssue @"no_attach"

#pragma mark - Kinds of image for upload request
// to edintify it in delegate method (for progress bar)
#define ImageKindIssue @"ImageKindIssue"
#define ImageKindAvatar @"ImageKindAvatar"

#pragma mark - names of requests (for active requests)

#define ActiveRequestLogInUser @"log in user"    // starts early, when app starts
#define ActiveRequestGetCurrentUserImage @"get current user image"  //loadig user image after user logined
#define ActiveRequestGetCurrentIssueImage @"get current issue image"  //loadig selected issue image


#pragma mark - CustomSell

#define CustomCellName @"name"
#define CustomCellCategory @"category"
#define CustomCellForEditProfile @"EditProfileCell"
#define CustomCellHistoryCellXib @"historyCellXib"
#define CustomCellHistoryCell @"historyCell"

#pragma mark - String constants for image download type
// description: we have a single method to download image from server.
// we need to hook urlSessionDataTask object for downloading current issue and current user
// to have posibility stop dowloading proccess, if user changed his choise (before downloadin of previous image complited)
// controller doesn't know anything about session data tasks, but network data sorce knows.
// so when (for example) current user avatar downloadin starts controller sends special constant to network data sorce, so it can hook info about downloading
#define ImageNameSimpleUserImage @"simple user image" //avatar
#define ImageNameCurrentUserImage @"current user image" //avatar
#define ImageNameSimpleIssueImage @"simple issue image"
#define ImageNameCurrentIssueImage @"curent issue image"


#endif /* NotificationsNames_h */
