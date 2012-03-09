//
//  MasterViewController.m
//  tt2
//
//  Created by 泰三 佐藤 on 12/02/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//b

#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
		
- (void)dealloc
{
    [_detailViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    //メモリチェック
    [self memCheck];
    
    //位置情報関連
    _longitude = 0.0;
	_latitude = 0.0;
    
	// ロケーションマネージャーを作成
	BOOL locationServicesEnabled;
	locationManager = [[CLLocationManager alloc] init];
        NSLog(@"通った１");
	if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]) {
                NSLog(@"通った１２");
		// iOS4.0以降はクラスメソッドを使用
		locationServicesEnabled = [CLLocationManager locationServicesEnabled];
	} else {
                NSLog(@"通った１３");
		// iOS4.0以前はプロパティを使用
		locationServicesEnabled = locationManager.locationServicesEnabled;
	}
    
    
	if (locationServicesEnabled) {
                NSLog(@"通った２");
		locationManager.delegate = self;
        
		// 位置情報取得開始
		[locationManager startUpdatingLocation];
        
    static NSString *CellIdentifier = @"Cell";
    /*
        UITableViewCell *cell =
    [UITableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.textColor = [UIColor blueColor];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        cell.textLabel.text = @"ほげ";
     */
	}  

}

- (void)viewDidUnload
{
    //[super viewDidUnload];
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

// 位置情報が取得成功した場合にコールされる
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	// 位置情報更新
	_longitude = newLocation.coordinate.longitude;
	_latitude = newLocation.coordinate.latitude;
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    geoCoder.delegate = self;
    [geoCoder start];
}

// 位置情報が取得失敗した場合にコールされる。
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if (error) {
            NSLog(@"通った４");
		NSString* message = nil;
		switch ([error code]) {
                // アプリでの位置情報サービスが許可されていない場合
			case kCLErrorDenied:	
				// 位置情報取得停止
				[locationManager stopUpdatingLocation];
				message = [NSString stringWithFormat:@"このアプリは位置情報サービスが許可されていません。"];
				break;
			default:
				message = [NSString stringWithFormat:@"位置情報の取得に失敗しました。"];
				break;
		}
		if (message) {
			// アラートを表示
			UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil 
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
            [alert release];
		}
	}
}


//地図情報を取得する
/*
 - (void)locationManager:(CLLocationManager *)manager 
 didUpdateToLocation:(CLLocation *)newLocation 
 fromLocation:(CLLocation *)oldLocation {
 NSTimeInterval howRecent = [newLocation.timestamp timeIntervalSinceNow];
 if (abs(howRecent) < 15.0) {
 // stop locationManager  
 [locationManager stopUpdatingLocation];
 // start Geocoder
 MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
 geoCoder.delegate = self;
 [geoCoder start];
 } else {
 NSLog(@"skip");
 }
 }
 */


//位置情報を取得する
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSMutableString *str = [[NSMutableString alloc] init];
    //    [str appendFormat:@"longitude : %f \n", placemark.coordinate.longitude];
    //    [str appendFormat:@"latitude : %f \n", placemark.coordinate.latitude];
    //    [str appendFormat:@"%@\n", placemark.country];
    [str appendFormat:@"現在地:%@\n", placemark.administrativeArea];
    //    [str appendFormat:@"%@\n", placemark.subAdministrativeArea];
    [str appendFormat:@"%@\n", placemark.locality];
    [str appendFormat:@"%@\n", placemark.subLocality];
    [str appendFormat:@"%@\n", placemark.thoroughfare];
    [str appendFormat:@"%@\n", placemark.subThoroughfare];
    //    [str appendFormat:@"%@\n", placemark.postalCode];
    now_Poslbl.text = str;
    
}

//エラーハンドリング
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"MKReverseGeocoder has failed. %@, %@", error, [error userInfo]);
}


//Enter押したらキーボードが隠れる。
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [memo_inputField resignFirstResponder];
    return NO;
}

//フォーカスがとれたらキーボードが隠れる。（複数レイヤーにわたってUIオブジェクトがある時チェインに注意）
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//UITouch* touch = [touches anyObject];
	//CGPoint pt = [touch locationInView:self];
    [memo_inputField resignFirstResponder];
    NSLog(@"タッチ");
}

//メモ投稿用画面遷移ボタン
-(IBAction)post_btn_down
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (!self.detailViewController) {
            self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil] autorelease];
        }
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}


-(IBAction)search_convini_btn_down:(id)sender{
    //コンビニ
    //ここで日本語テキストを入れ、文字コード変換をするとうまくURLに入るようなのだが…うまく動かない。ので、この謎文字を入れる。
    NSString* addString = @"%E3%82%B3%E3%83%B3%E3%83%93%E3%83%8B";
    [self searchOpenGooglemap:addString];
    [self memCheck]; //メモリ状況チェック
}


- (IBAction) search_gasolineStand_btn_down:(id)sender
{
    //ガソリンスタンド
    NSString* addString = @"%E3%82%AC%E3%82%BD%E3%83%AA%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%83%89";
    [self searchOpenGooglemap:addString];
}

- (IBAction) search_onsen_btn_down:(id)sender{
    //温泉
    NSString* addString = @"%E6%B8%A9%E6%B3%89";
    [self searchOpenGooglemap:addString];
}

- (IBAction) search_hotel_btn_down:(id)sender{
    //ホテル
    NSString* addString = @"%E3%83%9B%E3%83%86%E3%83%AB";
    [self searchOpenGooglemap:addString];    
}

- (IBAction) search_ridersHouse_btn_down:(id)sender{
    //ライダースハウス
    NSString* addString = @"%E3%83%A9%E3%82%A4%E3%83%80%E3%83%BC%E3%82%B9%E3%83%8F%E3%82%A6%E3%82%B9";
    [self searchOpenGooglemap:addString];
}

- (IBAction) search_campsite_btn_down:(id)sender{
    //キャンプ場
    NSString* addString = @"%E3%82%AD%E3%83%A3%E3%83%B3%E3%83%97%E5%A0%B4";
    [self searchOpenGooglemap:addString];
}

//各検索ボタン押下時にgoogleMAPを呼び出すメソッド
- (void)searchOpenGooglemap:(NSString*)btnWord{    
    
    NSString* searchUrl;
    searchUrl = [NSString stringWithFormat:@"http://maps.google.com/maps?z=15&q=%@&sll=%f,%f",btnWord,_latitude, _longitude];
    NSLog(@"searchUrl=%@" ,searchUrl);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:searchUrl]];
    [self memCheck]; //メモリ状況チェック
}

    //回転殺し
    - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
    {
        // Return YES for supported orientations
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
        } else {
            return YES;
        }
    }    
    
@end
