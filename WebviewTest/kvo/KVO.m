//
//  Facade.m
//  eContact
//
//  Created by zouxu on 14/6/14.
//  Copyright (c) 2014 zouxu. All rights reserved.
//

#import "KVO.h"
#import <libkern/OSAtomic.h>
#import <objc/message.h>
//#import "CommonX.h"

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif


@interface KvoInfo:NSObject
@property(nonatomic, weak)NSObject* objPtr;
@property(nonatomic, copy)NSString* keyPath;
@property(nonatomic, strong)id cnt;
@property(nonatomic, copy)KvoBlk blk;
@end

@implementation KvoInfo
+(id)NewInfo:(NSObject*)objPtr keyPath:(NSString*)keyPath blk:(KvoBlk)blk cnt:(id)cnt{
    KvoInfo* info = KvoInfo.new;
    info.objPtr = objPtr;
    info.keyPath = keyPath;
    info.blk = blk;
    info.cnt = cnt;
    return info;
}
@end

@interface KVO(){
    OSSpinLock lock;
}
@property(atomic, strong)NSMutableDictionary* observes;//keyPath[KvoInfo]
@end

@implementation KVO
+ (KVO *)shared{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject initSth];
    });
    return _sharedObject;
}
-(void)dealloc{
}
-(void)initSth{
    lock = OS_SPINLOCK_INIT;
    [self initData];
}
-(void)initData{
    self.observes = [NSMutableDictionary new];
}
-(void)observeAdd:(id)object keyPath:(NSString*)keyPath blk:(KvoBlk)blk content:(id)content{
    
    OSSpinLockLock(&lock);
    
    NSMutableArray* kvoInfos = self.observes[keyPath];
    if(!kvoInfos){
        kvoInfos = [NSMutableArray new];
        self.observes[keyPath]=kvoInfos;
    }
    KvoInfo * info =[KvoInfo NewInfo:object
                             keyPath:keyPath
                                 blk:blk
                                 cnt:content];
    
    [kvoInfos addObject:info];
    OSSpinLockUnlock(&lock);
    
    NSKeyValueObservingOptions option = NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld;
    
    // add observer
    
  //  dispatch_async(dispatch_get_global_queue(0, 0),^{
        [object addObserver:self  forKeyPath:keyPath options:option context:(__bridge void *)(info)];
  //  });
    
}
-(void)observeRemove:(id)object keyPath:(NSString*)keyPath{
    // unregister info
    
    OSSpinLockLock(&lock);
    NSMutableArray* kvoInfos = self.observes[keyPath];
    if(kvoInfos){
        BOOL delSuc = NO;
        for(int i=(int)kvoInfos.count-1; i>=0; i--){
            KvoInfo* info =kvoInfos[i];
            if([info.objPtr isEqual:object]){
                [object removeObserver:self forKeyPath:keyPath context:(__bridge void *)(info)];
                [kvoInfos removeObject:info];
                if(kvoInfos.count==0){
                    [self.observes removeObjectForKey:keyPath];
                }
                delSuc = YES;
            }
        }
        if(delSuc){
            
        }
    }
    OSSpinLockUnlock(&lock);
    // remove observer
}
-(void)observeRemoveAll:(id)object{
    OSSpinLockLock(&lock);
    NSArray* keys = [self.observes allKeys];
    for (NSString* keyPath in keys) {
        NSMutableArray* kvoInfos = self.observes[keyPath];
        for(int i=(int)kvoInfos.count-1; i>=0; i--){
            KvoInfo* info =kvoInfos[i];
            if(info.objPtr == object || info.objPtr == nil){
                // remove observer
                [object removeObserver:self forKeyPath:info.keyPath context:(__bridge void *)(info)];
                
                [kvoInfos removeObject:info];
            }
        }
        if(kvoInfos.count==0)
            [self.observes removeObjectForKey:keyPath];
    }
     OSSpinLockUnlock(&lock);
}
#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSAssert(0 != keyPath.length, @"missing required parameters observe:%@ keyPath:%@", object, keyPath);
    if (nil == object || 0 == keyPath.length) {
        return;
    }
    
    KvoInfo* info =(__bridge KvoInfo *)(context);

    NSObject* weakPtrHolder = info.objPtr;
    if(!weakPtrHolder){
        OSSpinLockLock(&lock);
        NSMutableArray* kvoInfos = self.observes[keyPath];
        [kvoInfos removeObject:info];
        if(kvoInfos.count==0)
            [self.observes removeObjectForKey:keyPath];
        OSSpinLockUnlock(&lock);
        return;
    }
    
    if(info.blk){
        info.blk(weakPtrHolder, info.keyPath, change, info.cnt);
    }
}


@end



