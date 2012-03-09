//
//  DetailViewController.h
//  tt2
//
//  Created by 泰三 佐藤 on 12/02/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <mach/mach.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>{
    IBOutlet UILabel *output_lbl;
    IBOutlet UITextField *memo_inputField;

}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

//    - (IBAction)mem_post_btn_down;

- (void)memCheck;//メモリチェック
//    - (IBAction)inputField;

@end
