//
//  FDCAntiDebug.m
//  FatDragonCartoon
//
//  Created by weichao on 2018/5/17.
//  Copyright © 2018年 FatDragon. All rights reserved.
//

#import "FDCAntiDebug.h"
#import <dlfcn.h>
//#import <sys/types.h>
#import <sys/sysctl.h>

typedef int  (*ptrace_ptr)(int request, pid_t pid, caddr_t addr, void* data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif
static int is_debuged(void);


void anti_lldb_debug(){
    /*
    为了方便应用软件的开发和调试，从Unix的早期版本开始就提供了一种对运行中的进程进行跟踪和控制的手段，那就是系统调用ptrace()。
    通过ptrace可以对另一个进程实现调试跟踪，同时ptrace还提供了一个非常有用的参数那就是PT_DENY_ATTACH，这个参数用来告诉系统，阻止调试器依附。
     */
#if RElEASE
    void *handle = dlopen(NULL, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr p_ptr = dlsym(handle, "ptrace");
    p_ptr(PT_DENY_ATTACH,0,0,0);
    dlclose(handle);

    if (is_debuged()) {
        exit(0);
    }
#endif
}

//当一个进程被调试的时候，该进程会有一个标记来标记自己正在被调试，所以可以通过sysctl去查看当前进程的信息，看有没有这个标记位即可检查当前调试状态。


static int is_debuged(){
    //指定查询信息的数组
    int name[4] = {CTL_KERN,KERN_PROC, KERN_PROC_PID,getpid()};
    struct kinfo_proc kproc; //查询的返回结果
    size_t kproc_size = sizeof(kproc);
    
    memset((void *)&kproc, 0, kproc_size);
    if (sysctl(name, 4, &kproc, &kproc_size, NULL, 0) == -1) {
        perror("sysctl error\n");
        exit(-1);
    }
    return ((kproc.kp_proc.p_flag & P_TRACED) != 0);
}

@implementation FDCAntiDebug

@end
