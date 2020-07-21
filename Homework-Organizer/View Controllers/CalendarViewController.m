//
//  CalendarViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "CalendarViewController.h"
#import "FSCalendar/FSCalendar.h"
@import Parse;
#import "Assignment.h"

@interface CalendarViewController () <FSCalendarDataSource,FSCalendarDelegate, FSCalendarDelegateAppearance>

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) NSArray<NSString *> *datesWithEvent;
@property (strong, nonatomic) NSMutableArray *assignments;
@property (strong, nonatomic) NSDateFormatter *myFormat;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    self.myFormat = [[NSDateFormatter alloc] init];
    self.myFormat.dateFormat = @"yyyy-MM-dd";
    NSLog(@"Getting due dates...");

//    [self getDueDates];
    [self.calendar reloadData];
    
}
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    // Do other updates here
    [self.view layoutIfNeeded];
}

-(void)fetchAssignments {
    NSLog(@"fetching assignments");
    PFQuery *assignmentQuery = [PFQuery queryWithClassName:@"Assignment"];
    [assignmentQuery orderByAscending:@"dueDate"];
    [assignmentQuery whereKey:@"creationComplete" equalTo: @YES];
    [assignmentQuery whereKey:@"completed" equalTo: @NO];
    [assignmentQuery whereKey:@"author" equalTo: [PFUser currentUser]];
    assignmentQuery.limit = 20;
    
    [assignmentQuery findObjectsInBackgroundWithBlock:^(NSArray<Assignment *>* _Nullable assignments, NSError * _Nullable error) {
        if (assignments) {
            self.assignments = (NSMutableArray *) assignments;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)getDueDates {
    [self fetchAssignments];
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSLog(@"setting @%lu due dates", [self.assignments count]);
    for (Assignment *assignment in self.assignments) {
        [dates addObject:[self.myFormat stringFromDate: assignment.dueDate]];
        
        NSLog(@"%@", [self.myFormat stringFromDate:assignment.dueDate]);
    }
    self.datesWithEvent = dates;
}

-(NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    [self getDueDates];
    if ([self.datesWithEvent containsObject:[self.myFormat stringFromDate: date]]) {
        return 1;
    }
    return 0;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.myFormat stringFromDate:date]);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date
{
//    if ([self calendar:calendar subtitleForDate:date]) {
//        return CGPointZero;
//    }
    if ([_datesWithEvent containsObject:[self.myFormat stringFromDate:date]]) {
        return CGPointMake(0, -2);
    }
    return CGPointZero;
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date
{
//    if ([self calendar:calendar subtitleForDate:date]) {
//        return CGPointZero;
//    }
    if ([_datesWithEvent containsObject:[self.myFormat stringFromDate:date]]) {
        return CGPointMake(0, -10);
    }
    return CGPointZero;
}

//- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(nonnull NSDate *)date
//{
////    if ([self calendar:calendar subtitleForDate:date]) {
////        return @[appearance.eventDefaultColor];
////    }
//    if ([_datesWithEvent containsObject:[self.myFormat stringFromDate:date]]) {
//        return @[[UIColor whiteColor]];
//    }
//    return nil;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
