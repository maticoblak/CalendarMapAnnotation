//
//  CalendarTools.m
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "CalendarTools.h"
#import <EventKit/EventKit.h>

///////////////////////////////////////////////////////
///
///          -CalendarTools-
#pragma mark -CalendarTools
///
///////////////////////////////////////////////////////
@implementation CalendarTools
///////////////////////////////////////////////////////
///          Initialization
#pragma mark Initialization
///////////////////////////////////////////////////////
+ (NSArray *)fetchEvents {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if(granted == NO) {
            [[[UIAlertView alloc] initWithTitle:@"This application requires access to calendar" message:@"Pleas enable access in settings!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else {
            
        }
    }];
    return [self _entityArrayWithEvents:[self _getEvents]];//can be empty
}
///////////////////////////////////////////////////////
///          Handles
#pragma mark Handles
///////////////////////////////////////////////////////
+ (void)insertNewEvent:(NSString *)title withLocation:(NSString *)location atDate:(NSDate *)timeDate {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.title = title;
        
        event.startDate = timeDate;
        event.endDate = timeDate;
        event.location = location;
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        
        NSError *err;
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        if(err != nil) {
            NSLog(@"Failed saving event! (%@)", err);
        }
    }];
}
///////////////////////////////////////////////////////
///          Internal
#pragma mark Internal
///////////////////////////////////////////////////////
+ (NSArray *)_getEvents {
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    EKEventStore *store = [[EKEventStore alloc] init];
    // Create the start date components
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end date components
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneYearFromNow
                                                          calendars:nil];
    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];
    
    return events;
}
+ (NSArray *)_entityArrayWithEvents:(NSArray *)events {
    NSMutableArray *toReturn = [[NSMutableArray alloc] init];
    for(EKEvent *event in events) {
        CalendarEntity *entity = [CalendarEntity withEventIdentifier:event.eventIdentifier];
        entity.dispayString = event.title;
        [entity findCoordinatesForAddress:event.location];
        entity.eventDate = event.startDate;
        [toReturn addObject:entity];
    }
    return toReturn;
}
@end
///////////////////////////////////////////////////////
///
///          -CalendarEntity-
#pragma mark -CalendarEntity
///
///////////////////////////////////////////////////////

static NSMutableArray *__calendarEntityCache = nil;

@implementation CalendarEntity
+ (CalendarEntity *)withEventIdentifier:(NSString *)identifier {
    CalendarEntity *toReturn = nil;
    if(identifier.length > 0) {
        //get from cache
        for(CalendarEntity *entity in __calendarEntityCache) {
            if([entity.eventIdentifier compare:identifier] == NSOrderedSame) {
                toReturn = entity;
                break;
            }
        }
    }
    if(toReturn == nil) {
        //item not in cache
        toReturn = [[CalendarEntity alloc] init];
        toReturn.eventIdentifier = identifier;
        if(identifier.length > 0) {
            //can insert into a cache
            if(__calendarEntityCache == nil) __calendarEntityCache = [[NSMutableArray alloc] init];
            [__calendarEntityCache addObject:toReturn];
        }
    }
    return toReturn;
}
- (void)findCoordinatesForAddress:(NSString *)address {
    if(self.dispayString.length > 0) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error) {
            if(placemarks.count > 0) {
                CLPlacemark* placemark = placemarks[0];
                self.coordinate = placemark.location.coordinate;
            }
        }];
    }
}
@end