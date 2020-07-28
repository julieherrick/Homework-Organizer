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
#import "AssignmentListCell.h"

@interface CalendarViewController () <UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource,FSCalendarDelegate, FSCalendarDelegateAppearance>

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) NSArray<NSString *> *datesWithEvent;
@property (strong, nonatomic) NSMutableArray *allAssignments;
@property (strong, nonatomic) NSMutableArray *assignments;
@property (strong, nonatomic) NSDateFormatter *myFormat;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    self.myFormat = [[NSDateFormatter alloc] init];
    self.myFormat.dateFormat = @"yyyy-MM-dd";
    NSLog(@"Getting due dates...");
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self fetchAllAssignments];
    [self.calendar reloadData];
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    // Do other updates here
    [self.view layoutIfNeeded];
}

-(void)fetchAllAssignments {
    NSLog(@"fetching assignments");
    PFQuery *assignmentQuery = [PFQuery queryWithClassName:@"Assignment"];
    [assignmentQuery orderByAscending:@"dueDate"];
    [assignmentQuery whereKey:@"creationComplete" equalTo: @YES];
    [assignmentQuery whereKey:@"completed" equalTo: @NO];
    [assignmentQuery whereKey:@"author" equalTo: [PFUser currentUser]];
//    assignmentQuery.limit = 20;
    
    [assignmentQuery findObjectsInBackgroundWithBlock:^(NSArray<Assignment *>* _Nullable assignments, NSError * _Nullable error) {
        if (assignments) {
            self.allAssignments = (NSMutableArray *) assignments;
            [self getDueDates];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)getDueDates {
    NSMutableArray *dates = [[NSMutableArray alloc] init];
//    NSLog(@"setting @%lu due dates", [self.allAssignments count]);
    for (Assignment *assignment in self.allAssignments) {
        [dates addObject:[self.myFormat stringFromDate: assignment.dueDate]];
        
//        NSLog(@"%@", [self.myFormat stringFromDate:assignment.dueDate]);
    }
    self.datesWithEvent = dates;
    [self.calendar reloadData];
}

-(NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    if ([self.datesWithEvent containsObject:[self.myFormat stringFromDate: date]]) {
        return 1;
    }
    return 0;
}

-(void)assignmentsForDate:(NSDate *)date {
    PFQuery *assignmentQuery = [PFQuery queryWithClassName:@"Assignment"];
    [assignmentQuery orderByAscending:@"dueDate"];
    [assignmentQuery whereKey:@"creationComplete" equalTo: @YES];
    [assignmentQuery whereKey:@"completed" equalTo: @NO];
    [assignmentQuery whereKey:@"author" equalTo: [PFUser currentUser]];
    [assignmentQuery whereKey:@"dueDate" greaterThanOrEqualTo:date];
    NSTimeInterval oneDay = (double) 24 * 60 * 60;
    [assignmentQuery whereKey:@"dueDate" lessThan:[date dateByAddingTimeInterval:oneDay]];
//    assignmentQuery.limit = 20;
    
    [assignmentQuery findObjectsInBackgroundWithBlock:^(NSArray<Assignment *>* _Nullable assignments, NSError * _Nullable error) {
        if (assignments) {
            self.assignments = (NSMutableArray *) assignments;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.tableView reloadData];
}

// date selection action
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSLog(@"did select date %@",[self.myFormat stringFromDate:date]);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    [self assignmentsForDate:date];
    
}

// format of event dot
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date {
    if ([_datesWithEvent containsObject:[self.myFormat stringFromDate:date]]) {
        return CGPointMake(0, -2);
    }
    return CGPointZero;
}

// format of event dot
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date {
    if ([_datesWithEvent containsObject:[self.myFormat stringFromDate:date]]) {
        return CGPointMake(0, -10);
    }
    return CGPointZero;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     AssignmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssignmentListCell"];
     Assignment *assignment = self.assignments[indexPath.row];
     
     cell.assignment = assignment;
     
     return cell;
 }

 - (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.assignments.count;
 }
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row number: %ld", (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
