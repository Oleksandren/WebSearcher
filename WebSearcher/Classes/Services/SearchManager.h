//
//  SearchManager.h
//  WebSearcher
//
//  Created by  Nechet Oleksandr on 16.08.15.
//  Copyright (c) 2015  Nechet Oleksandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchManagerDelegate <NSObject>
@optional
- (void)didUpdateData;
@end

@interface SearchManager : NSObject

/**
 * used as start point for searching
 */
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *searchString;

/**
 * The number of URL which be used before stopping searching. Min 1.
 * By default 100
 */
@property (nonatomic, assign) NSUInteger maximumAllowedUrls;

/**
 * By defaault 3
 */
@property (nonatomic, assign) NSUInteger maxConcurrentDownloads;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, weak) id <SearchManagerDelegate> delegate;


+ (instancetype)shareManager;
- (void)startSearching;
- (void)stop;
@end
