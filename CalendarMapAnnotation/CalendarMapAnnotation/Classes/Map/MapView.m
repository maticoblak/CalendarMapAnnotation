//
//  MapView.m
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "MapView.h"
#import "ExtensionUIViewControllerViewExtension.h"
///////////////////////////////////////////////////////
///
///          -MapView-
#pragma mark -MapView
///
///////////////////////////////////////////////////////
@implementation MapView
@synthesize map = _mapView;
///////////////////////////////////////////////////////
///          Initializers
#pragma mark Initializers
///////////////////////////////////////////////////////
- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(.0f, .0f, self.width, self.height)];
        _mapView.delegate = self;
        [self addSubview:_mapView];
    }
    return self;
}
///////////////////////////////////////////////////////
///          Handles
#pragma mark Handles
///////////////////////////////////////////////////////
- (void)reloadData {
    [_mapView removeAnnotations:_annotationCache];
    _annotationCache = [self.delegate mapViewAnotations:self];
    [_mapView addAnnotations:_annotationCache];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[EventAnnotation class]]) {
        EventAnnotation *item = (EventAnnotation *)annotation;
        return item.basicAnnotationView;
    }
    return nil;
}
- (void)beginRegionSelectionMode {
    [_regionSelectionView removeFromSuperview]; //just in case
    _regionSelectionView = nil;
    
    _regionSelectionView = [[UIView alloc] initWithFrame:CGRectMake(60.0f, 60.0f, self.width-120.0f, self.height-120.0f)];
    _regionSelectionView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.4f];
    _regionSelectionView.layer.borderColor = [[UIColor blueColor] CGColor];
    _regionSelectionView.layer.borderWidth = 2.0f;
    [self addSubview:_regionSelectionView];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    _panGesture.delegate = self;
    [self addGestureRecognizer:_panGesture];
}
- (void)endRegionSelectionMode {
    [self removeGestureRecognizer:_panGesture];
    [_regionSelectionView removeFromSuperview];
    _regionSelectionView = nil;
}
///////////////////////////////////////////////////////
///          Region selection
#pragma mark Region selection
///////////////////////////////////////////////////////
- (void)panGestureRecognized:(UIGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint newLocation = [sender locationInView:self];
            switch (corrnerIndex) {
                case 0: {
                    //grabbed upper left corner
                    CGPoint bottomRight = CGPointMake(_regionSelectionView.right, _regionSelectionView.bottom);
                    if(newLocation.x > bottomRight.x) newLocation.x = bottomRight.x;
                    if(newLocation.y > bottomRight.y) newLocation.y = bottomRight.y;
                    _regionSelectionView.frame = CGRectMake(newLocation.x,
                                                            newLocation.y,
                                                            bottomRight.x-newLocation.x,
                                                            bottomRight.y-newLocation.y);
                    break;
                }
                case 1: {
                    //grabbed upper right corner
                    CGPoint bottomLeft = CGPointMake(_regionSelectionView.left, _regionSelectionView.bottom);
                    if(newLocation.x < bottomLeft.x) newLocation.x = bottomLeft.x;
                    if(newLocation.y > bottomLeft.y) newLocation.y = bottomLeft.y;
                    _regionSelectionView.frame = CGRectMake(bottomLeft.x,
                                                            newLocation.y,
                                                            newLocation.x-bottomLeft.x,
                                                            bottomLeft.y-newLocation.y);
                    break;
                }
                case 2: {
                    //grabbed bottom left corner
                    CGPoint topRight = CGPointMake(_regionSelectionView.right, _regionSelectionView.top);
                    if(newLocation.x > topRight.x) newLocation.x = topRight.x;
                    if(newLocation.y < topRight.y) newLocation.y = topRight.y;
                    _regionSelectionView.frame = CGRectMake(newLocation.x,
                                                            topRight.y,
                                                            topRight.x-newLocation.x,
                                                            newLocation.y-topRight.y);
                    break;
                }
                case 3: {
                    //grabbed bottom right corner
                    CGPoint topLeft = CGPointMake(_regionSelectionView.left, _regionSelectionView.top);
                    if(newLocation.x < topLeft.x) newLocation.x = topLeft.x;
                    if(newLocation.y < topLeft.y) newLocation.y = topLeft.y;
                    _regionSelectionView.frame = CGRectMake(topLeft.x,
                                                            topLeft.y,
                                                            newLocation.x-topLeft.x,
                                                            newLocation.y-topLeft.y);
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            break;
        }
        default:
            break;
    }
    if([self.delegate respondsToSelector:@selector(mapView:didSelectRegion:)]) {
        CLLocationCoordinate2D center = [_mapView convertPoint:CGPointMake((_regionSelectionView.left+_regionSelectionView.right)*.5f, (_regionSelectionView.bottom+_regionSelectionView.top)*.5f) toCoordinateFromView:self];
        CLLocationCoordinate2D topLeft = [_mapView convertPoint:CGPointMake(_regionSelectionView.left, _regionSelectionView.top) toCoordinateFromView:self];
        CLLocationCoordinate2D bottomRight = [_mapView convertPoint:CGPointMake(_regionSelectionView.right, _regionSelectionView.bottom) toCoordinateFromView:self];
        
        
        [self.delegate mapView:self didSelectRegion:
         MKCoordinateRegionMake(center,
                                MKCoordinateSpanMake((bottomRight.latitude-topLeft.latitude)*.5f,
                                                     (bottomRight.longitude-topLeft.longitude)*.5f))];
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //check if gesture began in one of the corners of the region selection view
    static const CGFloat POIRadius = 60.0f;
    CGPoint location = [gestureRecognizer locationInView:self];
    //upper left
    if(fabsf(location.x-_regionSelectionView.left) < POIRadius && fabsf(location.y-_regionSelectionView.top) < POIRadius) {
        corrnerIndex = 0;
        return YES;
    }
    //upper right
    if(fabsf(location.x-_regionSelectionView.right) < POIRadius && fabsf(location.y-_regionSelectionView.top) < POIRadius) {
        corrnerIndex = 1;
        return YES;
    }
    //bottom left
    if(fabsf(location.x-_regionSelectionView.left) < POIRadius && fabsf(location.y-_regionSelectionView.bottom) < POIRadius) {
        corrnerIndex = 2;
        return YES;
    }
    //bottom right
    if(fabsf(location.x-_regionSelectionView.right) < POIRadius && fabsf(location.y-_regionSelectionView.bottom) < POIRadius) {
        corrnerIndex = 3;
        return YES;
    }
    return NO;
}
@end
