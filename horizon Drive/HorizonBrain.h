//
//  HorizonBrain.h
//  horizon Drive
//
//  Created by Scott Hillson on 6/6/12.
//  Copyright (c) 2012 Dr Bott LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface HorizonBrain : NSObject  {
	
}

@property ( strong , nonatomic ) NSNumber *totalDistance ;

@property ( strong , nonatomic ) NSManagedObjectContext *managedObjectContext;

- ( BOOL ) storeTime ;

- ( double ) retrieveDistance ;

- ( id ) storeDistance : ( NSNumber * ) inputNumber ;

@end