//
//  Result.h
//  WebSearcher
//
//  Created by  Nechet Oleksandr on 18.08.15.
//  Copyright (c) 2015  Nechet Oleksandr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WSState)
{
    WSStateWeitLoading = -1,
    WSStateNoMatches = 0,
    WSStateHasMatch = 1,
    WSStateLoading,
    WSStateErrorOccured
};

@interface Result : NSObject
@property (nonatomic, strong) NSString *urlString;
/**
 * if urlString contains search string hasMatch = YES
 */
@property (nonatomic, assign) WSState state;
@property (nonatomic, strong) NSString *errorDescription;

+ (instancetype)resultWithUrlString:(NSString *)str;
- (instancetype)initWithUrlString:(NSString *)str;
- (NSString *)status;
@end
