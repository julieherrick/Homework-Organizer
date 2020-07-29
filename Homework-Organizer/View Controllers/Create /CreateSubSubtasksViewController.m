//
//  CreateSubSubtasksViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/29/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "CreateSubSubtasksViewController.h"
#import "CreateSubtaskCell.h"

@interface CreateSubSubtasksViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *taskField;
@property (strong, nonatomic) NSMutableArray *subtasks;
@property (weak, nonatomic) IBOutlet UILabel *parentTaskLabel;



@end

@implementation CreateSubSubtasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.parentTaskLabel.text = self.subtask.description;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     CreateSubtaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateSubtaskCell"];
     Subtask *subtask = self.subtasks[indexPath.row];
     
     cell.subtask = subtask;
     
     return cell;
 }

 - (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.subtasks.count;
 }
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row number: %ld", (long)indexPath.row);
    [self performSegueWithIdentifier:@"subSubtaskSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView reloadData];
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
