//
//  AddNewEventView.h
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AddNewEventView;

@protocol AddNewEventViewProtocol <NSObject>
- (void)addNewEventViewFinishedSettingEvent:(AddNewEventView *)sender;
@end


///////////////////////////////////////////////////////
///
///          -AddNewEventView-
#pragma mark -AddNewEventView
///
///////////////////////////////////////////////////////
@interface AddNewEventView : UIView {
    UITextField *_titleField;
    UITextField *_addressField;
    UIButton *_dateButton;
    NSDate *_eventDate;
    
    UIButton *_overlay;
}
@property (weak) id<AddNewEventViewProtocol> delegate;
@end
