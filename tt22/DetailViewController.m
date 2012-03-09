//
//  DetailViewController.m
//  tt2
//
//  Created by 泰三 佐藤 on 12/02/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

- (void)dealloc
{
    [_detailItem release];
    [_detailDescriptionLabel release];
    [_masterPopoverController release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release]; 
        _detailItem = [newDetailItem retain]; 

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle






- (void)viewDidLoad
{
    //前回起動時入力文字をラベルに読み出し
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *imputed_Text = [ud stringForKey:@"IMPUT_TXT"];
    output_lbl.text = imputed_Text;
    
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

//テーブルココから
/*
- (NSInteger)numberOfSections {
    return 2; // セクションは2個とします
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: // 1個目のセクションの場合
            return @"セクションその1";
            break;
        case 1: // 2個目のセクションの場合
            return @"セクションその2";
            break;
    }
    return nil; //ビルド警告回避用
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 3; // 1個目のセクションのセルは3個とします
    }
    return 4; // 2個目のセクションのセルは4個とします
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
    }
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"セクション0 行0";
        } else if(indexPath.row == 1){
            cell.textLabel.text = @"セクション0 行1";
        } else {
            cell.textLabel.text = @"セクション0 行2";
        }
    } else {
        NSString *str = [[NSString alloc] initWithFormat:@"セクション%d 行%d",indexPath.section,indexPath.row];
        cell.textLabel.text = str;
        [str release];
    }
    return cell;
}
 */

//テーブルココまで

//メモリ情報の表示
-(void)memCheck{
    struct task_basic_info t_info;
	mach_msg_type_number_t t_info_count = TASK_BASIC_INFO_COUNT;
    
	if (task_info(current_task(), TASK_BASIC_INFO,
				  (task_info_t)&t_info, &t_info_count)!= KERN_SUCCESS) {
		NSLog(@"%s(): Error in task_info(): %s",
			  __FUNCTION__, strerror(errno));
	}
    
	u_int rss = t_info.resident_size;
	NSLog(@"RSS: %0.1f MB", rss/1024.0/1024.0);
}

//フォーカスがとれたらキーボードが隠れる。（複数レイヤーにわたってUIオブジェクトがある時チェイン（レスポンダーが感知しない）に注意）
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//UITouch* touch = [touches anyObject];
	//CGPoint pt = [touch locationInView:self];
    [memo_inputField resignFirstResponder];
    NSLog(@"タッチ");
}

- (IBAction) memo_post_btn_down:(id)sender{
    
     //ボタン押下＆入投稿
     if(![memo_inputField.text isEqualToString:@""]){
     output_lbl.text = memo_inputField.text;
     
     //入力文字を保存
     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults]; 
     [ud setObject:memo_inputField.text forKey:@"IMPUT_TXT"];
     [ud synchronize];
     
     memo_inputField.text = @"";
     NSLog(@"投稿実施");
     }
     NSLog(@"投稿");
    [memo_inputField resignFirstResponder];
    [self memCheck]; //メモリ状況チェック
    
}


@end
