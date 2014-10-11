//
//  XbICalendarCalendarTests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/13/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarCalendarTests : XbICalendarIcsTest
@end

@implementation XbICalendarCalendarTests

- (NSString *)icsFileNameUnderTest
{
    return @"calendar";
}

- (void)test_initialization
{
    XCTAssertNotNil(self.rootComponent, @"Initialization");
    XCTAssertTrue([self.calendars count] == 3, @"Expected 3 calendars");
}

- (void)test_calendar_method
{
    XbICVCalendar * vCalendar = self.calendars[0];
    XCTAssertEqualObjects([vCalendar method], @"CREATE", @"Unexpected method");
}

- (void)test_event_with_organizer
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([[vEvent organizer] emailAddress], @"Mailto:B@example.com", @"Unexpected event organizer");
}

- (void)test_event_with_start_date
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970701T190000Z"
                isEqualToDate:[vEvent dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
}

- (void)test_event_with_end_date
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970701T193000Z"
                isEqualToDate:[vEvent dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
}

- (void)test_event_with_timestamp
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970611T190000Z"
                isEqualToDate:[vEvent dateStamp]
           withFailureMessage:@"event dateStamp is incorrect"];
}

- (void)test_event_with_summary
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    
    XCTAssertEqualObjects([vEvent summary], @"Phone Conference", @"event summary is incorrect");
}

- (void)test_event_with_uid
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([vEvent UID], @"calsrv.example.com-873970198738777@example.com", @"Unexpected event UID");
}

- (void)test_event_with_sequence
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    
    XCTAssertEqualObjects([vEvent sequences], @[@2], @"Unexpected sequence");
}

- (void)test_event_with_status
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([vEvent status], @"CONFIRMED", @"Unexpected status");
}

- (void)test_event_with_attendees
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    NSArray * attendees = [vEvent attendees];
    XCTAssertEqual([attendees count], 6, @"Expected 6 attendees");
    
    // Test a few attendees which cover the different parameters:
    
    // Second attendee:
    XbICProperty *attendee2 = attendees[1];
    XCTAssertTrue([attendee2 isKindOfClass:[XbICProperty class]], @"Second attendee object is not property class.");
    NSDictionary *parameters2 = attendee2.parameters;
    
    XCTAssertEqualObjects(parameters2[@"RSVP"], @"TRUE", @"Unexpected attendee rsvp");
    XCTAssertEqualObjects(parameters2[@"CUTYPE"], @"INDIVIDUAL", @"Unexpected attendee calendar user type");
    XCTAssertEqualObjects(attendee2.value, @"Mailto:B@example.com", @"Unexpected attendee value");
    
    // Fifth attendee:
    XbICProperty *attendee5 = attendees[4];
    XCTAssertTrue([attendee5 isKindOfClass:[XbICProperty class]], @"Second attendee object is not property class.");
    NSDictionary *parameters5 = attendee5.parameters;
    
    XCTAssertEqualObjects(parameters5[@"RSVP"], @"FALSE", @"Unexpected attendee rsvp");
    XCTAssertEqualObjects(parameters5[@"CUTYPE"], @"ROOM", @"Unexpected attendee calendar user type");
    XCTAssertEqualObjects(attendee5.value, @"conf_Big@example.com", @"Unexpected attendee value");
}

@end