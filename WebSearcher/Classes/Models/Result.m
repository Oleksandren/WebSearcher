//
//  Result.m
//  WebSearcher
//
//  Created by  Nechet Oleksandr on 18.08.15.
//  Copyright (c) 2015  Nechet Oleksandr. All rights reserved.
//

#import "Result.h"

static NSString *const hasMathcesStatusStr = @"Content by this URL conteins search string";
static NSString *const noMathcesStatusStr = @"Content by this URL not conteins search string";
static NSString *const loadingStatusStr = @"Loading data";
static NSString *const waitStatusStr = @"Not processing";

@implementation Result

+ (instancetype)resultWithUrlString:(NSString *)str
{
    return [[Result alloc] initWithUrlString:str];
}

- (instancetype)initWithUrlString:(NSString *)str
{
    self = [super init];
    if (self) {
        _urlString = str;
        _state = WSStateWeitLoading;
    }
    return self;
}

- (NSString *)status
{
    switch (self.state) {
        case WSStateWeitLoading:
            return waitStatusStr;
        case WSStateLoading:
            return loadingStatusStr;
        case WSStateHasMatch:
            return hasMathcesStatusStr;
        case WSStateNoMatches:
            return noMathcesStatusStr;
        case WSStateErrorOccured:
            return [NSString stringWithFormat:@"Error: %@", _errorDescription];
        default:
            return nil;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"URL:%@, \tMatch:%ld", self.urlString, self.state];
}

@end

