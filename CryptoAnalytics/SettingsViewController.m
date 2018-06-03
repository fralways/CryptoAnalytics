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

@interface SettingsViewController ()

@property NSDictionary *networkConfig;
@property Config *config;
@property BOOL settingsChanged;
@property BOOL optionsExpanded;
@property BOOL useTestData;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Settings";
    
    self.useTestData = [Context sharedContext].testing;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = AppStyle.primaryLightColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(reset)];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    
    [self getConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

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

- (void)setupCellGraphics:(SettingsTableViewCell *)cell{
    cell.lblTitle.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];
    cell.lblValue.font = [UIFont systemFontOfSize:AppStyle.cellDetailsFontSize];
    cell.lblSubtitle.font = [UIFont systemFontOfSize:AppStyle.cellDetailsFontSize];
    
    cell.lblTitle.textColor = AppStyle.primaryTextColor;
    cell.lblValue.textColor = AppStyle.primaryTextColor;
    cell.lblSubtitle.textColor = AppStyle.primaryTextColor;
    cell.backgroundColor = AppStyle.primaryLightColor;
    UIView *selection = [[UIView alloc]init];
    selection.backgroundColor = AppStyle.primaryColor;
    cell.selectedBackgroundView = selection;
}

- (void)refreshTableView{
    [self.tableView reloadData];
}

- (void)refreshTableViewWithAnimation{
    NSRange range = NSMakeRange(0, self.tableView.numberOfSections);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else{
        if (self.config != NULL){
            NSInteger preCells = self.optionsExpanded ? 2:1;
            switch (self.config.selectedStrategy) {
                case MACD:
                    return 1 + preCells;
                    break;
                case EMA: case SMA:
                    return 3 + preCells;
                case SPEED:
                    return 2 + preCells;
                default:
                    NSLog(@"Settings: Error - selected strategy %ld not handled", (long)self.config.selectedStrategy);
                    return 0;
            }
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self setupCellGraphics:cell];
        
        return cell;
    }else{
        
        SettingsTableViewCell *cell;
        NSString *option;

        if (indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_SETTINGSSUBTITLE];
            option = @"Selected strategy";
            cell.lblSubtitle.text = [[Context sharedContext] strategyToString:self.config.selectedStrategy];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else if (indexPath.row == 1 && self.optionsExpanded){
            cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_SETTINGSPICKER];
            cell.pickerView.dataSource = self;
            cell.pickerView.delegate = self;
            [cell.pickerView selectRow:self.config.selectedStrategy inComponent:0 animated:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_SETTINGSSLIDER];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSInteger index = indexPath.row;
        if (self.optionsExpanded){
            index --;
        }
        
        switch (self.config.selectedStrategy) {
            case SPEED:
                switch (index) {
                    case 1:
                        option = @"Percent needed";
                        cell.slider.minimumValue = 0.01;
                        cell.slider.maximumValue = 0.5;
                        cell.slider.value = self.config.speedStrategyPercentChangeNeeded;
                        cell.lblValue.text = [NSString stringWithFormat:@"%d%%", (int)(cell.slider.value * 100)];
                        break;
                    case 2:
                        option = @"Tick interval";
                        cell.slider.minimumValue = 5;
                        cell.slider.maximumValue = 60 * 5;
                        cell.slider.value = self.config.speedStrategyInterval;
                        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                        break;
                    default:
                        break;
                }
                break;
            case SMA:
                switch (index) {
                    case 1:
                        option = @"Short count";
                        cell.slider.maximumValue = 20;
                        cell.slider.minimumValue = 5;
                        cell.slider.value = self.config.smaShortCount;
                        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                        break;
                    case 2:
                        option = @"Long count";
                        cell.slider.maximumValue = 100;
                        cell.slider.minimumValue = 20;
                        cell.slider.value = self.config.smaLongCount;
                        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                        break;
                    case 3:
                        option = @"Tick interval";
                        cell.slider.minimumValue = 5;
                        cell.slider.maximumValue = 60 * 5;
                        cell.slider.value = self.config.smaStrategyInterval;
                        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                        break;
                    default:
                        break;
                }
                break;
            case EMA:
                switch (index) {
                    case 1:
                        option = @"Short count";
                        cell.slider.maximumValue = 20;
                        cell.slider.minimumValue = 5;
                        cell.slider.value = self.config.emaShortCount;
                        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                        break;
                    case 2:
                        option = @"Long count";
                        cell.slider.maximumValue = 100;
                        cell.slider.minimumValue = 20;
                        cell.slider.value = self.config.emaLongCount;
                        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                        break;
                    case 3:
                        option = @"Tick interval";
                        cell.slider.minimumValue = 5;
                        cell.slider.maximumValue = 60 * 5;
                        cell.slider.value = self.config.emaStrategyInterval;
                        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                        break;
                    default:
                        break;
                }
                break;
            case MACD:
                switch (index) {
                    case 1:
                        option = @"Tick interval";
                        cell.slider.minimumValue = 5;
                        cell.slider.maximumValue = 60 * 5;
                        cell.slider.value = self.config.macdStrategyInterval;
                        cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        
        [self setupCellGraphics:cell];
        
        cell.lblTitle.text = option;
        cell.delegate = self;
        cell.tag = indexPath.row;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        self.useTestData = !self.useTestData;
        [Context sharedContext].testing = self.useTestData;
        
//        (self.useTestData) ? [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationFade] : [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        [self getConfig];
        
    }else{
        if (indexPath.row == 0){
            self.optionsExpanded = !self.optionsExpanded;
            
            for (int i=0; i<[self getHowManyCellsHasStrategy:self.config.selectedStrategy]; i++) {
                NSInteger startIndex = (self.optionsExpanded) ? 1:2;
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:startIndex+i inSection:1]];
                cell.tag = (self.optionsExpanded) ? 2+i : 1+i;
            }
            
            if (self.optionsExpanded){
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 0){
//        return @"TESTING";
//    }else{
//        return @"SERVER CONFIGURATION";
//    }
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = [UILabel new];
    header.text = (section == 0) ? @"TESTING":@"SERVER CONFIGURATION";
    header.backgroundColor = AppStyle.primaryColor;
    header.textColor = AppStyle.primaryTextColor;
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont systemFontOfSize:18];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark - Delegates

- (void)sliderValueChanged:(double)value withCell:(SettingsTableViewCell *)cell{
    if (cell.tag == 0){
        cell.lblSubtitle.text = [[Context sharedContext] strategyToString:self.config.selectedStrategy];
    }else if (cell.tag == 1 && self.optionsExpanded){
        cell.pickerView.dataSource = self;
        cell.pickerView.delegate = self;
    }else{
        NSInteger row = cell.tag;
        if (self.optionsExpanded){
            row --;
        }
        switch (self.config.selectedStrategy) {
            case SPEED:
                if (row == 1){
                    self.config.speedStrategyPercentChangeNeeded = value;
                    cell.lblValue.text = [NSString stringWithFormat:@"%d%%", (int)(cell.slider.value * 100)];
                }else if (row == 2){
                    self.config.speedStrategyInterval = value;
                    cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                }
                break;
            case SMA:
                if (row == 1){
                    self.config.smaShortCount = value;
                    cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                }else if (row == 2){
                    self.config.smaLongCount = value;
                    cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                }else if (row == 3){
                    self.config.smaStrategyInterval = value;
                    cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                }
                break;
            case EMA:
                if (row == 1){
                    self.config.emaShortCount = value;
                    cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                }else if (row == 2){
                    self.config.emaLongCount = value;
                    cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                }else if (row == 3){
                    self.config.emaStrategyInterval = value;
                    cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                }
                break;
            case MACD:
                if (row == 1){
                    self.config.macdStrategyInterval = value;
                    cell.lblValue.text = [NSString stringWithFormat:@"%d", (int)cell.slider.value];
                }
                break;
            default:
                break;
        }
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
    [self refreshTableViewWithAnimation];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

#pragma mark - Helper

- (NSInteger)getHowManyCellsHasStrategy:(STRATEGIES)strategy{
    NSInteger count = 0;
    switch (strategy) {
        case MACD:
            count = 1;
            break;
        case SPEED:
            count = 2;
            break;
        case SMA: case EMA:
            count = 3;
            break;
        default:
            break;
    }
    return count;
}

#pragma mark - Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.textColor = AppStyle.primaryTextColor;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    STRATEGIES strategy = row;
    label.text = [[Context sharedContext] strategyToString:strategy];
    return label;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    STRATEGIES strategy = row;
//    return [[Context sharedContext] strategyToString:strategy];
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    STRATEGIES strategy = row;
    self.config.selectedStrategy = strategy;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
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
