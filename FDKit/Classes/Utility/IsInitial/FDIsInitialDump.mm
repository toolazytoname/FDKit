//
//  FDIsInitialDump.m
//  FDKit
//
//  Created by Lazy on 2019/9/24.
//

#import "FDIsInitialDump.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>


//参考自 https://www.jianshu.com/p/74db5638f34f
//我们可以自定义一个结构体，如果我们自己写的结构和objc_class真实结构是一样的，那么当我们强制转化的时候，就会一一对应的赋值。此时我们就可以拿到结构体内部的信息。
//
//下列代码是我们仿照objc_class结构体，提取其中需要使用到的信息，自定义的一个结构体。
#define RW_INITIALIZED        (1<<29)
# if __arm64__
#   define ISA_MASK        0x0000000ffffffff8ULL
# elif __x86_64__
#   define ISA_MASK        0x00007ffffffffff8ULL
# endif

#if __LP64__
typedef uint32_t mask_t;
#else
typedef uint16_t mask_t;
#endif
typedef uintptr_t cache_key_t;

struct bucket_t {
    cache_key_t _key;
    IMP _imp;
};

struct cache_t {
    struct bucket_t *_buckets;
    mask_t _mask;
    mask_t _occupied;
};

struct entsize_list_tt {
    uint32_t entsizeAndFlags;
    uint32_t count;
};

struct method_t {
    SEL name;
    const char *types;
    IMP imp;
};

struct method_list_t : entsize_list_tt {
    struct method_t first;
};

struct ivar_t {
    int32_t *offset;
    const char *name;
    const char *type;
    uint32_t alignment_raw;
    uint32_t size;
};

struct ivar_list_t : entsize_list_tt {
    ivar_t first;
};

struct property_t {
    const char *name;
    const char *attributes;
};

struct property_list_t : entsize_list_tt {
    property_t first;
};

struct chained_property_list {
    struct chained_property_list *next;
    uint32_t count;
    struct property_t list[0];
};

typedef uintptr_t protocol_ref_t;
struct protocol_list_t {
    uintptr_t count;
    protocol_ref_t list[0];
};

struct class_ro_t {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;  // instance对象占用的内存空间
#ifdef __LP64__
    uint32_t reserved;
#endif
    const uint8_t * ivarLayout;
    const char * name;  // 类名
    struct method_list_t * baseMethodList;
    struct protocol_list_t * baseProtocols;
    const struct ivar_list_t * ivars;  // 成员变量列表
    const uint8_t * weakIvarLayout;
    struct property_list_t *baseProperties;
};

struct class_rw_t {
    uint32_t flags;
    uint32_t version;
    const struct class_ro_t *ro;
    struct method_list_t * methods;    // 方法列表
    struct property_list_t *properties;    // 属性列表
    const struct protocol_list_t * protocols;  // 协议列表
    Class firstSubclass;
    Class nextSiblingClass;
    char *demangledName;
};

#define FAST_DATA_MASK          0x00007ffffffffff8UL
struct class_data_bits_t {
    uintptr_t bits;
public:
    class_rw_t* data() { // 提供data()方法进行 & FAST_DATA_MASK 操作
        return (class_rw_t *)(bits & FAST_DATA_MASK);
    }
};

/* OC对象 */
struct lazyFake_objc_object {
    void *isa;
};

/* 类对象 */
struct lazyFake_objc_class : lazyFake_objc_object {
    Class superclass;
    cache_t cache;
    class_data_bits_t bits;
public:
    class_rw_t* data() {
        return bits.data();
    }
    
    lazyFake_objc_class* metaClass() { //提供metaClass函数，获取元类对象
        //isa指针需要经过一次 &ISA_MASK操作之后才得到真正的地址
        return (lazyFake_objc_class *)((long long)isa & ISA_MASK);
    }
    bool isInitialized() {
        return metaClass()->data()->flags & RW_INITIALIZED;
    }
};

@implementation FDIsInitialDump
+ (NSArray<NSString *> *)dumpAllRuntimeRegisteredClasses {
    NSMutableArray *allRuntimeRegisteredArray = [[NSMutableArray alloc] init];
    int numClasses;
    Class *classes = NULL ;
    classes = NULL ;
    numClasses = objc_getClassList ( NULL , 0 );
//    NSLog ( @"[lazyDebug] Number of classes: %d" , numClasses);
    if (numClasses > 0 ) {
        classes = ( __unsafe_unretained Class *) malloc ( sizeof (Class) * numClasses);
        numClasses = objc_getClassList (classes, numClasses);
        for ( int i = 0 ; i < numClasses; i++) {
            Class cls = classes[i];
            NSString *classNameString = NSStringFromClass(cls);
            [allRuntimeRegisteredArray addObject:classNameString];
        }
        free (classes);
    }
    return [allRuntimeRegisteredArray copy];
}

+ (NSArray<NSString *> *)dumpInitializedClassesInRuntime {
    NSArray *allRuntimeRegisteredClasses = [self dumpAllRuntimeRegisteredClasses];
    return [self dumpInitializedClassesInArray:allRuntimeRegisteredClasses];
}

+ (NSArray<NSString *> *)dumpInitializedClassesInArray:(NSArray<NSString *> *)classArray {
    if (!classArray || classArray.count == 0) {
        return nil;
    }
    NSMutableArray *initializedArray = [[NSMutableArray alloc] init];
    [classArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class cls = NSClassFromString(obj);
        struct lazyFake_objc_class *objectClass = (__bridge struct lazyFake_objc_class *)cls;
        BOOL isInitial = objectClass->isInitialized();
        if (isInitial) {
            [initializedArray addObject:obj];
        }
    }];
    return initializedArray;
}

+ (NSArray<NSString *> *)dumpNotInitializedClassesInRuntime {
    NSArray *allRuntimeRegisteredClasses = [self dumpAllRuntimeRegisteredClasses];
    return [self dumpNotInitializedClassesInArray:allRuntimeRegisteredClasses];
}

+ (NSArray<NSString *> *)dumpNotInitializedClassesInArray:(NSArray<NSString *> *)classArray {
    if (!classArray || classArray.count == 0) {
        return nil;
    }
    NSMutableArray *initializedArray = [[NSMutableArray alloc] init];
    [classArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class cls = NSClassFromString(obj);
        struct lazyFake_objc_class *objectClass = (__bridge struct lazyFake_objc_class *)cls;
        BOOL isInitial = objectClass->isInitialized();
        if (!isInitial) {
            [initializedArray addObject:obj];
        }
    }];
    return initializedArray;
}
@end
