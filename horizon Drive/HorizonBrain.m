//
//  HorizonBrain.m
//  horizon Drive
//
//  Created by Scott Hillson on 6/6/12.
//  Copyright (c) 2012 Dr Bott LLC. All rights reserved.
//

#import "HorizonBrain.h"

@interface HorizonBrain ( )

@property ( strong , nonatomic ) MainViewController *mainViewController ;

@end

@implementation HorizonBrain

@synthesize totalDistance ;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize mainViewController = _mainViewController ;

- ( BOOL ) stealDistance {
	//steal our total distance from the controller and store it permanently
	NSNumber *result = [ [ NSNumber alloc ] initWithDouble: [ self.mainViewController returnTotalDistance ] ] ;
	
	if ( !result ) result = FALSE ;
	
	if ( _managedObjectContext == nil ) {
		_managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}
	NSError *error = nil ;
	NSFetchRequest *request = [ [ NSFetchRequest alloc ] init ] ;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:_managedObjectContext];
	
	[request setEntity:entity];
	
	NSManagedObject *object = [ NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext: _managedObjectContext ] ;
	[ object setValue:result forKey:@"distance" ] ;
	
    // save the data
    [ _managedObjectContext save:&error ] ;
	
	if ( !error ) return TRUE ;
	else return FALSE ;
	
}

- ( BOOL ) storeTime {
	
	if ( _managedObjectContext == nil ) {
		_managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}
	
	double time = [ self.mainViewController returnTime ] ;
	
	NSLog(@"how is mainViewController doing? %@" , self.mainViewController ) ;
	
	NSLog(@"how is time doing? %f" , time ) ;
	
	double returnedTime = [ self.mainViewController returnTime ] ;

	NSLog(@"time i'm receiving %f" , returnedTime ) ;
	/*
	NSNumber *timeNumber = [[ NSNumber alloc ] initWithDouble : returnedTime ] ;
	
	NSError *error = nil ;
	NSFetchRequest *request = [ [ NSFetchRequest alloc ] init ] ;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Timer" inManagedObjectContext:_managedObjectContext];
	
	[ request setEntity : entity ] ;
	
	NSManagedObject *object = [ NSEntityDescription insertNewObjectForEntityForName:@"Timer" inManagedObjectContext: _managedObjectContext ] ;
	[ object setValue : timeNumber forKey : @"time" ] ;
	
	[ _managedObjectContext save:&error ] ;
	
	NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
	NSArray *times = [ array valueForKey:@"time" ] ;
	NSLog ( @"array %@" , times ) ;

	*/
	return TRUE ;
}

- ( double ) retrieveTime {
	
	if ( _managedObjectContext == nil ) {
		_managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}
	
	return 0.1 ;
	
}

- ( double ) retrieveDistance {
	
	if ( _managedObjectContext == nil ) {
		_managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}
	
	NSError *error = nil ;
	NSFetchRequest *request = [ [ NSFetchRequest alloc ] init ] ;
	NSEntityDescription *entity = [ NSEntityDescription entityForName:@"Location" inManagedObjectContext:_managedObjectContext ] ;
	[ request setEntity:entity ] ;
	NSArray *objects = [ _managedObjectContext executeFetchRequest : request error:&error ] ;
	 
	 if ( objects.count ) {
		 NSArray *array = [ objects objectAtIndex:[ objects count ] - 1 ] ;
		 totalDistance = [ array valueForKey:@"distance" ] ;
		 
	 }
	if ( totalDistance ) { double result = [ totalDistance doubleValue ] ; return result ; }
	else { double result = 0 ; return result ; }
}

- ( id ) storeDistance : ( NSNumber * ) inputNumber {
	
	if ( _managedObjectContext == nil ) {
		_managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}
	
	NSError *error = nil ;
	NSFetchRequest *request = [ [ NSFetchRequest alloc ] init ] ;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:_managedObjectContext];
	
	[request setEntity:entity];
	
	NSManagedObject *object = [ NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext: _managedObjectContext ] ;
	[ object setValue:inputNumber forKey:@"distance" ] ;
	
    // save the data
    [ _managedObjectContext save:&error ] ;
	
	NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
	NSArray *distances = [ array valueForKey:@"distance" ] ;
	
	// TODO: FOR SOME REASON THIS CAN RETURN NULL WHEN OUR GPS ACCURACY IS LOW
	
	if ( distances != nil ) {
		id distance = distances.lastObject ;
		NSLog(@"distance %@" , distance ) ;
		return distance ;
	}
	else return 0 ;
}

@end