//
//  SearchManager.m
//  WebSearcher
//
//  Created by  Nechet Oleksandr on 16.08.15.
//  Copyright (c) 2015  Nechet Oleksandr. All rights reserved.
//

#import "SearchManager.h"
#import "Result.h"

@interface SearchManager ()
{
    NSUInteger numberConcurrentDownloads;
    BOOL cancelled;
}
@property (nonatomic, assign) NSUInteger requestedCount;
@end

@implementation SearchManager

+ (instancetype)shareManager
{
    static SearchManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [SearchManager new];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        _maximumAllowedUrls = 100;
        _maxConcurrentDownloads = 3;
        _searchResult = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

#pragma mark - Searching

- (void)startSearching
{
    [_searchResult removeAllObjects];
    [_searchResult addObject:[Result resultWithUrlString:_urlString]];
    _requestedCount = 0;
    numberConcurrentDownloads = 0;
    cancelled = NO;
    [self startPrefetchingAtIndex:0];
}

- (void)startPrefetchingAtIndex:(NSUInteger)index
{
    if (index >= self.searchResult.count) return;
    self.requestedCount++;
    numberConcurrentDownloads ++;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (cancelled) {
            return ;
        }
        typeof(weakSelf) self = weakSelf;
        Result *r = _searchResult[index];
        r.state = WSStateLoading;
        if ([_delegate respondsToSelector:@selector(didUpdateData)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate didUpdateData];
            });
        }
        NSError *error;
        NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:r.urlString] encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            r.state = WSStateErrorOccured;
            r.errorDescription = error.localizedDescription;
        }else{
            if (str) {
                r.state = (WSState)[str containsString:self.searchString];
                if (_searchResult.count < _maximumAllowedUrls) {
                    [self addUrlsFromString:str];
                }
            }else{
                r.state = WSStateNoMatches;
            }
        }
        if ([self.delegate respondsToSelector:@selector(didUpdateData)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didUpdateData];
            });
        }
        -- numberConcurrentDownloads;
        if (!cancelled && (self.searchResult.count > self.requestedCount)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (NSUInteger i = self.requestedCount; numberConcurrentDownloads < (self.maxConcurrentDownloads + 1) && self.requestedCount < self.searchResult.count; i++) {
                    [self startPrefetchingAtIndex:i];
                }
            });
        }
    });
}

- (void)addUrlsFromString:(NSString *)str
{
    @synchronized(self.searchResult){
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http?://([-\\w\\.]+)+(:\\d+)?(/([\\w/_\\.]*(\\?\\S+)?)?)?"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:NULL];
        NSArray *arrayOfAllMatches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
        for (NSTextCheckingResult *match in arrayOfAllMatches) {
            if (!cancelled && (self.searchResult.count < self.maximumAllowedUrls)) {
                [self.searchResult addObject:[Result resultWithUrlString:[str substringWithRange:match.range]]];
            }else{
                break;
            }
        }
    }
}

- (void)stop
{
    cancelled = YES;
}

@end
