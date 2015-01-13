//
//  VimeoBaseTableViewController.h
//  VimeoStaffPicks
//
//  Created by Lin on 12/4/14.
//  Copyright (c) 2014 Chenglin. All rights reserved.
//

/*This is a generic super class, the fetching process should be implemented on subclass */

#import <UIKit/UIKit.h>

@interface VimeoBaseTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *videos;

@end
