Original App Design Project
===

# Homework Organizer

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Upload your assignments, the estimated time you think it will take to complete them, and the due date. Use the app to track your progress with your homework to makesure you don't miss a deadline

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Productivity
- **Mobile:** Yes
- **Story:** Allows users to keep track of their homework assignments to help them finish on time
- **Market:** Students
- **Habit:** Homework is very frequent so I think it would be habit forming to check when your assignments are due
- **Scope:** User can store an organized list of their assignments to have a single location to keep track of their school work
<img src="https://i.postimg.cc/J0tVG27m/IMG-3684.jpg" width=600>

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can log in/out using facebook [use facebook SDK]
- [x] User can add a new assignment
- [x] User can attach a photo to an assignent
- [x] User can view a list of all assignments
- [x] Users can view assignment due dates on calendar
- [x] User can switch between tabs of a list of assignments and a calendar
- [x] User can swipe to delete assignments
- [x] User can add subtasks to their assignments
- [x] User can check off subtasks and progress bar will reflect completion status
- [x] User can attatch photograph to assignments

**Optional Nice-to-have Stories**

- [x] User can view what assignments are due when they click the day on the calendar
- [ ] User can get notifications
- [ ] User can customize notification time/frequency 
- [x] User can view past assignment on setting page
- [x] User can un-complete an assignment
* ...

### 2. Screen Archetypes

* Login
   * User can log in/out using facebook 
   <img src="https://i.postimg.cc/MKDPhDzm/IMG-3685.png" width=300>
* Assignments List
   * User can view a list of assignments
   * User can add a new assignment
   * User can swipe to delete an assignment
  <img src="https://i.postimg.cc/SK8WpSW-b/IMG-3687.png" width=300>
* Add Assignment
   * User can add new assignment with class and due date
   * User can add tasks to the assignment
   * User can add subtasks to the task
   <img src="https://i.postimg.cc/6QsvckFj/IMG-3690.png" width=300>
   <img src="https://i.postimg.cc/ryvRqXw8/IMG-3692.png" width=300>
   <img src="https://i.postimg.cc/L8SqZtPw/IMG-3694.png" width=300>
* Assignment Detail
   * user can view the details of the assignment
   <img src="https://i.postimg.cc/rmMtXSV5/IMG-3688.png" width=300>
* Calendar
    * User can view assignment due dates on calendar
    <img src="https://i.postimg.cc/1tBV9fX2/IMG-3689.png" width=300>
* Settings
    * User can logout
    * User can view completed assignments
    * User can double tap an assignment to make it uncompleted
    <img src="https://i.postimg.cc/vHtYkp12/IMG-3695.png" width=300>

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Assignment List
* Calendar View

**Flow Navigation** (Screen to Screen)

* Login Screen
    => Assignment List
* Assignment List
    => Add Assignment
    => Assignment details
    => Settings
* Assignment Details
    => Assignment List
* Create Assignment
    => Assignment List
* Calendar View
    => none

## Wireframes
<img src="https://i.postimg.cc/vB67Rfvt/IMG-3435.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups
<img src="https://i.postimg.cc/fLp8w4xK/Screen-Shot-2020-07-10-at-1-19-39-AM.png" width=1000>

### [BONUS] Interactive Prototype

## Schema 
### Models
#### Assignment
 | Property      | Type     | Description |
 | ------------- | -------- | ------------|
 | objectId      | NSString   | Unique id for the user assignment (default field) |
 | userID        | NSString | unique ID for user |
 | author        | Pointer to User | Author of assignment |
 | title         | NSString   | Name of the assignment |
 | classKey      | NSString   | The name of the class the assignment is for |
 | due_date      | NSDate | The date the assignment is due |
 | Progress      | NSNumber   | Based on the number of subtasks stores the proportion completed |
 | completed     | BOOL  | Stores if the task is completed |
 | image         | File     | User can attach image |
 | creationComplete | BOOL     | checks if assignment was fully created with subtasks |
 | totalSubtasks | NSNumber  | Number of subtasks associated with the assignment |
  | totalCompletedSubtasks | NSNumber  | Number of subtasks associated with the assignment that are complete |
 
 #### Subtask
  | Property      | Type     | Description |
  | ------------- | -------- | ------------|
  | objectId      | NSString   | Unique id for the user subtask (default field) |
  | description   | NSString   | Description of subtask |
  | completed     | BOOL  | Stores if the task has been completed |
  | isChildTask   | BOOL  | Stores if it is a child subtask |
  | isParentTask  | BOOL  | Stores if it is a parent subtask |
  | totalChildTasks | NSNumber   | The total number of child tasks a parent subtask has |
  | totalCompletedChildTasks | NSNumber   | The total number of child tasks a parent subtask has that are completed |
  | parentTask    | Pointer to Subtask | The parent task of a child subtask |
  | assignment    | Pointer to Assignment | The Assignment a parent subtask is related to |
  
   
 #### User
  | Property      | Type     | Description |
  | ------------- | -------- | ------------|
  | objectId      | String   | Unique id for the user assignment (default field) |
  | username      | String   | unique username for the user's account |


### Networking
#### List of network requests by screen
- Assignment List Screen
  - (Read/GET) Query all assignments where user is author
    ```objective c
    PFQuery *query = [PFQuery queryWithClassName:@"Assignment"];
    [query whereKey:@"author" equalTo: currentuser];
    query.order(byDescending: "createdAt");
 
    [query findObjectsInBackgroundWithBlock:^(NSArray *assignments, NSError *error) {
      if (assignments != nil) {
          NSLog(@"Succesfully retrieved assignments");
          // TODO: Something with assignments
      } else {
          NSLog(@"%@", error.localizedDescription);
      }
    }];
    ```
  - (Update/PUT) Mark assignment as completed
  - (Delete) Delete assignment
- Create Assignment Screen
  - (Create/ADD) Create new Assignment
- Assignment Detials Screen
  - (Update/PUT) Edit assignment details
  
  #### Network Request Actions
     CRUD    | HTTP Verb | Example
   ----------|-----------|------------
    Create   | `ADD`     | Creating a new assignment
    Read     | `GET`     | Fetch assignments from user
    Update   | `PUT`     | Update assignment information
    Delete   | `DELETE`  | Delete an assignment

- [OPTIONAL: List endpoints if using existing API such as Yelp]
