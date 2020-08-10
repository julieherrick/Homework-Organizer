//
//  CreateViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/13/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "CreateViewController.h"
#import "Assignment.h"
#import "Subtask.h"
#import <Parse/Parse.h>

// design
#import <MaterialComponents/MaterialButtons+ColorThemer.h>
#import <MaterialComponents/MaterialButtons+TypographyThemer.h>

#import <MaterialComponents/MaterialTextFields+ColorThemer.h>
#import <MaterialComponents/MaterialTextFields.h>

#import "MaterialTextFields+Theming.h"
#import "MaterialContainerScheme.h"
#import "MaterialTypographyScheme.h"
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialButtons+Theming.h>

#import "ApplicationScheme.h"

@interface CreateViewController ()

@property(nonatomic) MDCTextInputControllerOutlined *titleController;
@property(nonatomic) MDCTextInputControllerOutlined *classController;
@property(nonatomic) MDCTextInputControllerOutlined *dueDateController;

@property (weak, nonatomic) IBOutlet MDCTextField *titleField;
@property (weak, nonatomic) IBOutlet MDCTextField *classField;
@property (weak, nonatomic) IBOutlet MDCTextField *dueDateField;
@property (weak, nonatomic) IBOutlet UIImageView *attachedImage;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;


//@property (nonatomic, strong) MDCContainerScheme *containerScheme;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO: Instantiate Controllers
    MDCContainerScheme *containerScheme = [[MDCContainerScheme alloc] init];
    containerScheme.colorScheme = [ApplicationScheme sharedInstance].colorScheme;
//    containerScheme.typographyScheme = [ApplicationScheme sharedInstance].typographyScheme;


    self.titleController = [[MDCTextInputControllerOutlined alloc] initWithTextInput:self.titleField];
    self.titleField.placeholder = @"Title";
    self.titleField.translatesAutoresizingMaskIntoConstraints = NO;
//    [self styleTextInputController:self.titleController];
    [self.titleController applyThemeWithScheme:containerScheme];
    
    self.classController = [[MDCTextInputControllerOutlined alloc] initWithTextInput:self.classField];
    self.classField.placeholder = @"Class";
    self.classField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.classController applyThemeWithScheme:containerScheme];
    
    
    self.dueDateController = [[MDCTextInputControllerOutlined alloc] initWithTextInput:self.dueDateField];
    self.dueDateField.placeholder = @"Due Date";
    self.dueDateField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dueDateController applyThemeWithScheme:containerScheme];
    
    self.cameraButton.layer.cornerRadius = 30;
    self.cameraButton.accessibilityLabel = @"add photo";
    self.backgroundView.layer.cornerRadius = 10;
    // Do any additional setup after loading the view.
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.dueDateField setInputView:self.datePicker];
//    [self showSelectedDate];

}

//- (void)styleTextInputController:(id<MDCTextInputController>)controller {
//  if ([controller isKindOfClass:[MDCTextInputControllerOutlined class]]) {
//    MDCTextInputControllerOutlined *outlinedController =
//        (MDCTextInputControllerOutlined *)controller;
//    [outlinedController applyThemeWithScheme:self.containerScheme];
//  }
//}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onDateChange:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    self.dueDateField.text = [NSString stringWithFormat: @"%@", [formatter stringFromDate:self.datePicker.date]];
    [self.dueDateField resignFirstResponder];
}


// creates assignment
- (IBAction)onNext:(id)sender {
    // test to see if assignment is created
    if ([self.titleField.text isEqual:@""] || [self.dueDateField.text  isEqual: @""]) {
        if ([self.titleField.text isEqual:@""]) {
//            [self alertError:@"Title is required"];
            [self.titleController setErrorColor:[UIColor colorWithRed:0.87 green:0.29 blue:0.16 alpha:1.0]];
            [self.titleController setErrorText:@"Must have a title" errorAccessibilityValue:nil];
        } else {
//            [self alertError:@"Due Date required"];
            [self.dueDateController setErrorColor:[UIColor colorWithRed:0.87 green:0.29 blue:0.16 alpha:1.0]];
            [self.dueDateController setErrorText:@"Must have a due date" errorAccessibilityValue:nil];
        }
    } else {
    [Assignment  createNewAssignment:self.titleField.text withClassName:self.classField.text withDueDate:self.datePicker.date withImage:self.attachedImage.image withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"The assignment was saved!");
            [self performSegueWithIdentifier:@"next" sender:nil];
            
        } else {
            NSLog(@"Problem saving assignment: %@", error.localizedDescription);
//            [self alertError:error.localizedDescription];
        }
    }];}
}

- (IBAction)onPhotoSelect:(id)sender {
    NSLog(@"tapped");
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped do nothing.
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // take photo button tapped.
        [self takePhoto];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // choose photo button tapped.
        [self choosePhoto];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)takePhoto {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

-(void)choosePhoto {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
//    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    [self.attachedImage setImage:[self resizeImage:editedImage withSize:CGSizeMake(500, 500)]];
    
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)alertError:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // closes to let the user fill the fields
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
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
