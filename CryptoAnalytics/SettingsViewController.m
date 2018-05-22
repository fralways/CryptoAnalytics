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
    OPTIONS_END,
    OPTIONS_SELECT_STRATEGY,
}SERVER_OPTIONS;

@interface SettingsViewController ()

@property NSDictionary *networkConfig;
@property Config *config;
@property BOOL settingsChanged;
@property BOOL optionsExpanded;
@property NSMutableArray *options;
@property BOOL useTestData;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Settings";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(reset)];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    
    [self initOptions];
    [self getConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)initOptions{
    self.options = [NSMutableArray new];
    
    for (int i=0; i<OPTIONS_END; i++){
        [self.options addObject:[self sectionToTitle:i]];
    }
    
}

#pragma mark - Network

- (void)getConfig{
    
    if (![Context sharedContext].testing){
        [[NetworkManager sharedManager] getConfigWithCompletionHandler:^(bool successful, NSDictionary *config, NSError *httpError) {
            if (successful){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.networkConfig = config;
                    self.config = [[Config alloc]initWithNetworkData:config];
                    
                    [self refreshTableView];
                });
            }
        }];
    }else{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"config" ofType:@"json"];
        NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]];
        NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"config: %@", config);
        self.networkConfig = config;
        self.config = [[Config alloc]initWithNetworkData:config];
        
        [self refreshTableView];
    }
}

- (void)patchConfig{
    [[NetworkManager sharedManager]patchConfig:[self.config toDictionary] withCompletionHandler:^(bool successful, NSDictionary *config, NSError *httpError) {
        if (successful){
            NSLog(@"Config: Patched successfully");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.networkConfig = config;
                self.config = [[Config alloc]initWithNetworkData:config];
                
                [self refreshTableView];
            });
        }
    }];
}

#pragma mark - Table view

- (void)refreshTableView{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else{
        if (self.config != NULL){
            return self.options.count;
        }else{
            return 0;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_SETTINGSSUBTITLE];
        
        cell.lblTitle.text = @"Use test data";
        if (self.useTestData){
            cell.lblSubtitle.text = @"YES";
        }else{
            cell.lblSubtitle.text = @"NO";
        }
        
        return cell;
    }else{
        NSString *option = self.options[indexPath.row];
        
        SettingsTableViewCell *cell;
        
        if ([option isEqualToString:[self sectionToTitle:OPTIONS_SELECTED_STRATEGY]]){
            cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_SETTINGSSUBTITLE];
        }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SELECT_STRATEGY]]){
            cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_SETTINGSPICKER];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_SETTINGSSLIDER];
        }
        
        if ([option isEqualToString:[self sectionToTitle:OPTIONS_EMA_LONG]]){
            cell.slider.maximumValue = 100;
            cell.slider.minimumValue = 20;
            cell.slider.value = self.config.emaLongCount;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
        }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SMA_LONG]]){
            cell.slider.maximumValue = 100;
            cell.slider.minimumValue = 20;
            cell.slider.value = self.config.smaLongCount;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
        }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_EMA_SHORT]]){
            cell.slider.maximumValue = 20;
            cell.slider.minimumValue = 5;
            cell.slider.value = self.config.emaShortCount;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
        }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SMA_SHORT]]){
            cell.slider.maximumValue = 20;
            cell.slider.minimumValue = 5;
            cell.slider.value = self.config.smaShortCount;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
        }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_EMA_INTERVAL]]){
            cell.slider.minimumValue = 5;
            cell.slider.maximumValue = 60 * 5;
            cell.slider.value = self.config.emaStrategyInterval;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
        }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SMA_INTERVAL]]){
            cell.slider.minimumValue = 5;
            cell.slider.maximumValue = 60 * 5;
            cell.slider.value = self.config.smaStrategyInterval;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
        }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SPEED_INTERVAL]]){
            cell.slider.minimumValue = 5;
            cell.slider.maximumValue = 60 * 5;
            cell.slider.value = self.config.speedStrategyInterval;
            cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
        }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SPEED_NEEDPERC]]){
            cell.slider.minimumValue = 0.01;
            cell.slider.maximumValue = 0.5;
            cell.slider.value = self.config.speedStrategyPercentChangeNeeded;
            cell.lblValue.text = [NSString stringWithFormat:@"%d%%", (int)(cell.slider.value * 100)];
        }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SELECTED_STRATEGY]]){
            cell.lblSubtitle.text = [[Context sharedContext] strategyToString:self.config.selectedStrategy];
        }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SELECT_STRATEGY]]){
            cell.pickerView.dataSource = self;
            cell.pickerView.delegate = self;
            [cell.pickerView selectRow:self.config.selectedStrategy inComponent:0 animated:NO];
        }else{
            NSLog(@"Settings: Cell type not found at row: %ld", (long)indexPath.row);
        }
        
        if ([option isEqualToString:[self sectionToTitle:OPTIONS_SELECTED_STRATEGY]]){
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.lblTitle.text = option;
        
        cell.delegate = self;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        self.useTestData = !self.useTestData;
        [Context sharedContext].testing = self.useTestData;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        NSString *option = self.options[indexPath.row];

        if ([option isEqualToString:[self sectionToTitle:OPTIONS_SELECTED_STRATEGY]]){
            self.optionsExpanded = !self.optionsExpanded;
            if (self.optionsExpanded){
                [self.options insertObject:[self sectionToTitle:OPTIONS_SELECT_STRATEGY] atIndex:1];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [self.options removeObjectAtIndex:1];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"TESTING";
    }else{
        return @"SERVER CONFIGURATION";
    }
}

#pragma mark - Delegates

- (void)sliderValueChanged:(double)value withCellTitle:(NSString *)title{
    
    NSInteger index = [self findIndexForTitle:title];
    NSString *option = self.options[index];
    SettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1]];
    
    if ([option isEqualToString:[self sectionToTitle:OPTIONS_EMA_LONG]]){
        self.config.emaLongCount = value;
        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
    }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SMA_LONG]]){
        self.config.smaLongCount = value;
        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
    }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_EMA_SHORT]]){
        self.config.emaShortCount = value;
        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
    }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SMA_SHORT]]){
        self.config.smaShortCount = value;
        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
    }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_EMA_INTERVAL]]){
        self.config.emaStrategyInterval = value;
        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
    }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SMA_INTERVAL]]){
        self.config.smaStrategyInterval = value;
        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
    }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SPEED_INTERVAL]]){
        self.config.speedStrategyInterval = value;
        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
    }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SPEED_NEEDPERC]]){
        self.config.speedStrategyPercentChangeNeeded = value;
        cell.lblValue.text = [NSString stringWithFormat:@"%d%%", (int)(cell.slider.value * 100)];
    }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SELECTED_STRATEGY]]){
        cell.lblSubtitle.text = [[Context sharedContext] strategyToString:self.config.selectedStrategy];
    }else if ([option isEqualToString:[self sectionToTitle:OPTIONS_SELECT_STRATEGY]]){
        cell.pickerView.dataSource = self;
        cell.pickerView.delegate = self;
    }else{
        NSLog(@"Settings: Slider changed but row not found with title: %@", title);
    }
    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
}

#pragma mark - Buttons

- (void)save{
    [self patchConfig];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

- (void)reset{
    self.config = [[Config alloc]initWithNetworkData:self.networkConfig];
    [self refreshTableView];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

#pragma mark - Helper

- (NSInteger)findIndexForTitle:(NSString *)title{
    for (int i=0; i<self.options.count; i++){
        NSString *option = self.options[i];
        if ([title isEqualToString:option]){
            return i;
        }
    }
    return -1;
}

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

#pragma mark - Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    STRATEGIES strategy = row;
    return [[Context sharedContext] strategyToString:strategy];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    STRATEGIES strategy = row;
    self.config.selectedStrategy = strategy;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
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
