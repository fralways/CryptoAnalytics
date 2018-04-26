//
//  HistoryViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 4/22/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"History";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init & UI

- (void)setupUI{
    self.btnFilter.layer.borderColor = [[UIColor darkTextColor] CGColor];
    self.btnFilter.layer.borderWidth = 1;
    self.btnFilter.layer.cornerRadius = 8;
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_HISTORY];
    
    cell.lblText.text = @"some text in two lines some text in two linessome text in two lines some text in two lines some text in two linessome text in two lines";
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)filter:(id)sender {
}
@end
