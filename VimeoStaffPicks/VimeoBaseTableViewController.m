//
//  VimeoBaseTableViewController.m
//  VimeoStaffPicks
//
//  Created by Lin on 12/4/14.
//  Copyright (c) 2014 Chenglin. All rights reserved.
//

#import "VimeoBaseTableViewController.h"
#import "VimeoFetcher.h"

@implementation VimeoBaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefreshControl];
    [self fetchData];
}

-(void)fetchData{
    //Channel can be adjust here
    //NSString *channel=@"StaffPicks";
    NSString *channel=@"DocumentaryFilm";
    //NSString *channel=@"EverythingAnimated";
    //NSString *channel=@"NiceType";
    
    //Ajust number of videos fetched
    NSUInteger videoAmount=35;
    
    /**async fetching**/
    
    dispatch_queue_t loaderQ = dispatch_queue_create("vimeo loader", NULL);
    dispatch_async(loaderQ, ^{
        NSDictionary *latestvideos = [VimeoFetcher executeVimeoFetchForChannel:channel forVideos:videoAmount];
        // when we have the results, use main queue to display them
        dispatch_async(dispatch_get_main_queue(), ^{
            self.videos = latestvideos;
            if (!self.videos)
                self.navigationItem.title = @"No Internet Connection"; //Indicate network error on navigation bar
            else
                self.navigationItem.title =channel;
            
        });
    });
    //self.videos=[VimeoFetcher executeVimeoFetchForChannel:channel forVideos:videoAmount];
}

/*pull to refresh*/
-(void)addRefreshControl{
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}
-(void)refreshView:(UIRefreshControl *)refresh {
    [self fetchData];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (void)setVideos:(NSDictionary *)videos
{
    _videos = videos;
    [self.tableView reloadData]; //When model changes, update table view
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.videos valueForKeyPath:VIDEOS] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Video Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //video title
    UILabel *titleLable = (UILabel *)[cell viewWithTag:1];
    titleLable.text = [self titleForRow:indexPath.row];
    
    //video author
    UILabel *authorLable = (UILabel *)[cell viewWithTag:2];
    authorLable.text=[self authorForRow:indexPath.row];
    
    //thumbnail image
    UIImageView *ImageView = (UIImageView *)[cell viewWithTag:3];
    ImageView.image=[self imageForRow:indexPath.row];
    return cell;
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [[self.videos valueForKeyPath:VIDEO_TITLE]objectAtIndex:row];
}
- (NSString *)authorForRow:(NSUInteger)row
{
    return [[self.videos valueForKeyPath:VIDEO_AUTHOR]objectAtIndex:row];
}
-(UIImage *)imageForRow:(NSUInteger)row
{
    NSArray* images=[self.videos valueForKeyPath: VIDEO_IMAGE_ARRAY];
    NSString* imageUrlString=[[[images objectAtIndex:row]objectAtIndex:1] valueForKeyPath:@"link"];
    NSURL *imageURL=[NSURL URLWithString:imageUrlString];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    return image;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 75; //This method is here only because dynamic cell height set in Storyboard get overwrite by system
}

@end
