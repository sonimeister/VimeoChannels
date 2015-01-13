//
//  VimeoFetcher.h
//  VimeoStaffPicks
//
//  Created by Lin on 12/4/14.
//  Copyright (c) 2014 Chenglin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VIDEOS @"data"
#define VIDEO_TITLE @"data.name"
#define VIDEO_AUTHOR @"data.user.name"
#define VIDEO_IMAGE_ARRAY @"data.pictures.sizes"

@interface VimeoFetcher : NSObject

/*Specify which channel, how many videos you want to get*/
+ (NSDictionary *)executeVimeoFetchForChannel:(NSString *)channel forVideos:(NSUInteger)videos;

@end
