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
- **Scope:** Store assignment progress and give notfications close to the due date

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can log in/out using facebook [would this use facebook SDK?]
* User can create a new account
* User can add a new assignment
* User can add due date
* User can view a list of all assignments
* Users can view assignment due dates on calendar
* User can switch between tabs of a list of assignments and a calendar
* User can swipe to delete assignments
* [something using the camera]
* ...

**Optional Nice-to-have Stories**

* User can input the progress they have made in their homework (eg. 75% completed)
* User can view their profile
* User can input their classes on their profile
* User can group assignments by class 
* User can get notifications
* User can customize notification time/frequency 
* Assignment will automatically disappear after due date has passed
* ...

### 2. Screen Archetypes

* Login
   * User can log in/out using facebook 
   * User can create a new account
* Assignments List
   * User can view a list of assignments
   * User can add a new assignment
   * User can swipe to delete an assignment

* Add Assignment
   * User can add new assignment
   * User can add due date

* Calendar
    * User can view assignment due dates on calendar

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Assignment List
* Calendar View

**Flow Navigation** (Screen to Screen)

* Login Screen
    => Assignment List
* Assignment List
    => Add Assignment
* Add Assignment
    => Assignment List
* Calendar View
    => none

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
