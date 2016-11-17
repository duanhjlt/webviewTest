//
//  NSObject+Facade.m
//  eContact
//
//  Created by zouxu on 14/6/14.
//  Copyright (c) 2014 zouxu. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import "KVO.h"

@implementation NSObject (KVO)


-(void)kvoAdd:(NSString*)keyPath blk:(KvoBlk)blk content:(id)content{
    __weak NSObject* SELF = self;
    [[KVO shared] observeAdd:SELF keyPath:keyPath blk:blk content:content];
}
-(void)kvoAdd:(NSString*)keyPath blk:(KvoBlk)blk{
    __weak NSObject* SELF = self;
    [[KVO shared] observeAdd:SELF keyPath:keyPath blk:blk content:nil];
}
-(void)kvoRemove:(NSString*)keyPath{
      __weak NSObject* SELF = self;
    [[KVO shared] observeRemove:SELF  keyPath:keyPath];
}
-(void)kvoRemoveAll{
    __weak NSObject* SELF = self;
    [[KVO shared] observeRemoveAll:SELF];
}
@end

