//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Tom Carmona on 5/18/15.
//  Copyright (c) 2015 Tom Carmona. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property NSMutableArray *cellArray;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UITableViewCell *cell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cellArray = [[NSMutableArray alloc] init];
}


- (IBAction)onAddButtonPressed:(id)sender {
    [self.cellArray addObject:self.textField.text];
    [self.tableView reloadData];
    [self.textField resignFirstResponder];
    self.textField.text = @""; //make sure to prevent empty cells!!!

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
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

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell.tintColor = [UIColor greenColor];
}



@end
