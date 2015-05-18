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
@property BOOL delete;

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
    if ([self.cell.textLabel.textColor isEqual:[UIColor blackColor]]) {
        self.cell.textLabel.textColor = [UIColor greenColor];
    } else if ([self.cell.textLabel.textColor isEqual:[UIColor greenColor]]){
        self.cell.textLabel.textColor = [UIColor yellowColor];
    } else if ([self.cell.textLabel.textColor isEqual: [UIColor yellowColor]]){
        self.cell.textLabel.textColor = [UIColor redColor];
    } else {
        self.cell.textLabel.textColor = [UIColor blackColor];
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

        if (self.delete == 1) {
        [self.cellArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.delete = 0;
        }


        [self.tableView reloadData];
    } else {
        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //pressed cancel, do nothing
    } else if (buttonIndex == 1) {
         self.delete = 1;
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
    self.textField.text = @""; //make sure to prevent empty cells!!!

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![self.textField.text  isEqual:@""]) {
        [self.cellArray addObject:self.textField.text];
        self.textField.text = @"";
        [self.tableView reloadData];
    }
    [self.textField resignFirstResponder];
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    self.cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.cellArray objectAtIndex:indexPath.row]];
    return self.cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor greenColor];
}

@end
