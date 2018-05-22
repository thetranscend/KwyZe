//
//  NSDictionary+Extra.m
//  HungamaMusic
//
//  Created by Mukesh Verma on 01/07/16.
//  Copyright © 2016 Hungama.com. All rights reserved.
//

#import "NSDictionary+Extra.h"

@implementation NSDictionary (Extra)

-(id)ObjectForKeyWithNullChecking:(id)key
{
    return ((![self valueForKey:key]) ||[[self objectForKey:key] isKindOfClass:[NSNull class]] || [self objectForKey:key]==nil)?@"":[self objectForKey:key];
}

-(id)ValueForKeyWithNullChecking:(id)key
{
    return ((![self valueForKey:key]) ||[[self valueForKey:key] isKindOfClass:[NSNull class]] || [self objectForKey:key]==nil )?@"":[self valueForKey:key];
}

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
