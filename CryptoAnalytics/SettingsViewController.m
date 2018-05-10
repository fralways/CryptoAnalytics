//
//  SettingsViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/27/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "SettingsViewController.h"
#import "NetworkManager.h"
#import "Config.h"

typedef enum: NSInteger{
    OPTIONS_SELECTED_STRATEGY   = 0,
    OPTIONS_EMA_SHORT,
    OPTIONS_EMA_LONG,
    OPTIONS_EMA_INTERVAL,
    OPTIONS_SMA_SHORT,
    OPTIONS_SMA_LONG,
    OPTIONS_SMA_INTERVAL,
    OPTIONS_SPEED_NEEDPERC,
    OPTIONS_SPEED_INTERVAL,
    OPTIONS_END
}SERVER_OPTIONS;

@interface SettingsViewController ()

@property NSDictionary *networkConfig;
@property Config *config;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Settings";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
    [self getConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network

- (void)getConfig{
    [[NetworkManager sharedManager] getConfigWithCompletionHandler:^(bool successful, NSDictionary *config, NSError *httpError) {
        if (successful){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.networkConfig = config;
                self.config = [[Config alloc]initWithNetworkData:config];
                
                [self refreshTableView];
            });
        }
    }];
}

- (void)save{
    
}

#pragma mark - Table view

- (void)refreshTableView{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.config != NULL){
        return OPTIONS_END;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingsTableViewCell *cell = (indexPath.row == OPTIONS_SELECTED_STRATEGY) ? [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_SETTINGSSUBTITLE] : [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_SETTINGSSLIDER];
    
    switch (indexPath.row) {
        case OPTIONS_EMA_LONG: case OPTIONS_SMA_LONG:

            cell.slider.maximumValue = 100;
            cell.slider.minimumValue = 20;
            
            if (indexPath.row == OPTIONS_EMA_LONG){
                cell.slider.value = self.config.emaLongCount;
            }else{
                cell.slider.value = self.config.smaLongCount;
            }
            
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
            
            break;
            
        case OPTIONS_EMA_SHORT: case OPTIONS_SMA_SHORT:
            
            cell.slider.maximumValue = 20;
            cell.slider.minimumValue = 5;
            
            if (indexPath.row == OPTIONS_EMA_SHORT){
                cell.slider.value = self.config.emaShortCount;
            }else{
                cell.slider.value = self.config.smaShortCount;
            }
            
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];

            break;
            
        case OPTIONS_EMA_INTERVAL: case OPTIONS_SMA_INTERVAL: case OPTIONS_SPEED_INTERVAL:
            
            cell.slider.minimumValue = 5;
            cell.slider.maximumValue = 60 * 5;
            
            if (indexPath.row == OPTIONS_EMA_INTERVAL){
                cell.slider.value = self.config.emaStrategyInterval;
            }else if (indexPath.row == OPTIONS_SMA_INTERVAL){
                cell.slider.value = self.config.smaStrategyInterval;
            }else{
                cell.slider.value = self.config.speedStrategyInterval;
            }
            
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
            
            break;
            
        case OPTIONS_SPEED_NEEDPERC:
            cell.slider.minimumValue = 0.01;
            cell.slider.maximumValue = 0.5;
            
            cell.slider.value = self.config.speedStrategyPercentChangeNeeded;
            
            cell.lblValue.text = [NSString stringWithFormat:@"%d%%", (int)(cell.slider.value * 100)];

            break;
            
        case OPTIONS_SELECTED_STRATEGY:
            
            cell.lblSubtitle.text = [self strategyToString:self.config.selectedStrategy];

            break;
        default:
            NSLog(@"Settings: Cell type not found at row: %ld", (long)indexPath.row);
            break;
    }
    
    cell.lblTitle.text = [self sectionToTitle:indexPath.row];
    cell.tag = indexPath.row;
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Delegates

- (void)sliderValueChanged:(double)value withTag:(NSInteger)tag{
    
    SettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    
    switch (tag) {
        case OPTIONS_EMA_LONG:
            self.config.emaLongCount = value;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
            break;
        case OPTIONS_EMA_SHORT:
            self.config.emaShortCount = value;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
            break;
        case OPTIONS_EMA_INTERVAL:
            self.config.emaStrategyInterval = value;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
            break;
        case OPTIONS_SMA_LONG:
            self.config.smaLongCount = value;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
            break;
        case OPTIONS_SMA_SHORT:
            self.config.smaShortCount = value;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
            break;
        case OPTIONS_SMA_INTERVAL:
            self.config.smaStrategyInterval = value;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
            break;
        case OPTIONS_SPEED_NEEDPERC:
            self.config.speedStrategyPercentChangeNeeded = value;
            cell.lblValue.text = [NSString stringWithFormat:@"%d%%", (int)(cell.slider.value * 100)];
            break;
        case OPTIONS_SPEED_INTERVAL:
            self.config.speedStrategyInterval = value;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
            break;
        default:
            NSLog(@"Settings: Slider changed but row not found with tag: %ld", (long)tag);
            break;
    }
}

#pragma mark - Helper

- (NSString *)sectionToTitle:(SERVER_OPTIONS)option{
    NSString *title = @"";
    switch (option) {
        case OPTIONS_EMA_SHORT:
            title = @"EMA short count";
            break;
        case OPTIONS_EMA_LONG:
            title = @"EMA long count";
            break;
        case OPTIONS_EMA_INTERVAL:
            title = @"EMA tick interval";
            break;
        case OPTIONS_SMA_SHORT:
            title = @"SMA short count";
            break;
        case OPTIONS_SMA_LONG:
            title = @"SMA long count";
            break;
        case OPTIONS_SMA_INTERVAL:
            title = @"SMA tick interval";
            break;
        case OPTIONS_SPEED_NEEDPERC:
            title = @"SPEED percent for change";
            break;
        case OPTIONS_SPEED_INTERVAL:
            title = @"SPEED tick interval";
            break;
        case OPTIONS_SELECTED_STRATEGY:
            title = @"Selected strategy";
            break;
        default:
            break;
    }
    return title;
}

- (NSString *)strategyToString:(STRATEGIES)strategy{
    NSString *title = @"";
    switch(strategy){
        case SMA:
            title = @"SMA";
            break;
        case EMA:
            title = @"EMA";
            break;
        case SPEED:
            title = @"SPEED";
            break;
        case MACD:
            title = @"MACD";
            break;
            
    }
    return title;
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
