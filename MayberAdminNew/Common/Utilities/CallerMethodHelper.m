//
//  CallerMethodHelper.m
//  tradeapp
//
//  Created by Владимир on 30.09.16.
//  Copyright © 2016 Istochnik. All rights reserved.
//

#import "CallerMethodHelper.h"

@implementation CallerMethodHelper
+ (NSString *)findCallerMethod
{
    NSString *callerStackSymbol = nil;
    
    NSArray<NSString *> *callStackSymbols = [NSThread callStackSymbols];
    
    if (callStackSymbols.count >= 2)
    {
        callerStackSymbol = [callStackSymbols objectAtIndex:2];
        if (callerStackSymbol)
        {
            NSInteger idxDash = [callerStackSymbol rangeOfString:@"-" options:kNilOptions].location;
            NSInteger idxPlus = [callerStackSymbol rangeOfString:@"+" options:NSBackwardsSearch].location;
            
            if (idxDash != NSNotFound && idxPlus != NSNotFound)
            {
                NSRange range = NSMakeRange(idxDash, (idxPlus - idxDash - 1)); // -1 to remove the trailing space.
                callerStackSymbol = [callerStackSymbol substringWithRange:range];
                
                return callerStackSymbol;
            }
        }
    }
    
    return (callerStackSymbol) ?: @"Caller not found! :(";
}
@end
