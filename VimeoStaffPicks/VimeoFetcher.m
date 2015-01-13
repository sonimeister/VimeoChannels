//
//  VimeoFetcher.m
//  VimeoStaffPicks
//
//  Created by Lin on 12/4/14.
//  Copyright (c) 2014 Chenglin. All rights reserved.
//

#import "VimeoFetcher.h"
#import "VimeoUserToken.h"

@implementation VimeoFetcher

/*specify which channel, how many videos you want to get*/
+ (NSDictionary *)executeVimeoFetchForChannel:(NSString *)channel forVideos:(NSUInteger)videos
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.vimeo.com/channels/%@/videos?page=1&per_page=%lu",channel,(unsigned long)videos]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request addValue:[NSString stringWithFormat:@"bearer %@", USER_TOKEN] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: &error];
    NSDictionary *results = returnData ? [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);  //Log the error out.
    return results;
}
@end
