//
//  Util.m
//  libav2
//
//  Created by  stc on 13-5-2.
//
//

#import "Util.h"

@implementation Util

@end

void checkStatus(OSStatus err, NSString *op) {
    if (err) {
        NSLog(@"%@", op);
    }
}