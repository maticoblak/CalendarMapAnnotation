//
//  EventAnnotation.h
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

///////////////////////////////////////////////////////
///
///          -EventAnnotation-
#pragma mark -EventAnnotation
///
///////////////////////////////////////////////////////
@interface EventAnnotation : UIView<MKAnnotation> {
    CLLocationCoordinate2D _location;
}
@property NSDictionary *additionalInfo;
@property CLLocationCoordinate2D location;
+ (NSArray *)calendarAnnotations;
@end
