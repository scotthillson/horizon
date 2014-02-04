//
//  AppDelegate.h
//  horizon Drive
//
//  Created by Scott Hillson on 2/14/12.
//  Copyright (c) 2012 Dr Bott LLC. All rights reserved.

#import <UIKit/UIKit.h>
#import "HorizonBrain.h"
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
