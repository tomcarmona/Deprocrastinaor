//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Tom Carmona on 5/18/15.
//  Copyright (c) 2015 Tom Carmona. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property NSMutableArray *cellArray;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UITableViewCell *cell, *swipedRightCell;
@property NSIndexPath *cellToDelete;
@property BOOL delete;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRightGesture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cellArray = [[NSMutableArray alloc] init];
    self.delete = 0;
}

- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {

    if ([sender.title  isEqual: @"Edit"]) {
        sender.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
        self.editing = YES;
    } else {
        sender.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
    }
}

- (IBAction)swipedRight:(id)sender {
    NSLog(@"Swipe returns object: %@", sender);

    CGPoint swipeLocation = [self.swipeRightGesture locationInView:self.tableView];
    NSIndexPath *cellIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];

    if (cellIndexPath) {
        UITableViewCell *cell = (UITableViewCell *)[self.tableView                                            cellForRowAtIndexPath:cellIndexPath];
        if ([cell.textLabel.textColor isEqual:[UIColor blackColor]]) {
            cell.textLabel.textColor = [UIColor greenColor];
        } else if ([cell.textLabel.textColor isEqual:[UIColor greenColor]]){
            cell.textLabel.textColor = [UIColor yellowColor];
        } else if ([cell.textLabel.textColor isEqual: [UIColor yellowColor]]){
            cell.textLabel.textColor = [UIColor redColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *stringMove = self.cellArray[sourceIndexPath.row];
    [self.cellArray removeObjectAtIndex:sourceIndexPath.row];
    [self.cellArray insertObject:stringMove atIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are you sure you want to delet this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, delete", nil];
        [alert show];

        //Save index path to retrieve when deleting from UIALert cancel button
        self.cellToDelete = indexPath;

    } else {
        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //pressed cancel, do nothing
    } else if (buttonIndex == 1) {
        //Remove object at index, reload data, the table view will no longer display the deleted array object
        [self.cellArray removeObjectAtIndex:self.cellToDelete.row];
        [self.tableView reloadData];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (IBAction)onAddButtonPressed:(id)sender {

    if (![self.textField.text  isEqual:@""]) {
        [self.cellArray addObject:self.textField.text];
        [self.tableView reloadData];
    }

    [self.textField resignFirstResponder];
    self.textField.text = @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![self.textField.text  isEqual:@""]) {
        [self.cellArray addObject:self.textField.text];
        self.textField.text = @"";
        [self.tableView reloadData];
    }
//    [self.textField resignFirstResponder];
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"THIS WILL TEL LUS THE CELL");

    self.cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    self.cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.cellArray objectAtIndex:indexPath.row]];
    return self.cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor greenColor];
    self.swipedRightCell = [tableView cellForRowAtIndexPath:indexPath];
}


@end
