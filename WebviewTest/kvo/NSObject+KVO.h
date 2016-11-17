//
//  NSObject+Facade.h
//  eContact
//
//  Created by zouxu on 14/6/14.
//  Copyright (c) 2014 zouxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVO.h"

@interface NSObject (KVO)
-(void)kvoAdd:(NSString*)keyPath blk:(KvoBlk)blk content:(id)content;
-(void)kvoAdd:(NSString*)keyPath blk:(KvoBlk)blk;
-(void)kvoRemove:(NSString*)keyPath;
-(void)kvoRemoveAll;
@end
