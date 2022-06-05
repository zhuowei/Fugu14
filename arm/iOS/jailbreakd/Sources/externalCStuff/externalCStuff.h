//
//  externalCStuff.h
//  jailbreakd - externalCStuff
//
//  Created by Linus Henze.
//  Copyright © 2021 Linus Henze. All rights reserved.
//

#ifndef externalCStuff_h
#define externalCStuff_h

#include <sys/snapshot.h>
#include <spawn.h>

#ifdef IOS_BUILD
#include "hfs_mount.h"
#include "CFUserNotification.h"
#endif

typedef struct val_attrs {
    uint32_t          length;
    attribute_set_t   returned;
    uint32_t          error;
    attrreference_t   name_info;
    char              *name;
    fsobj_type_t      obj_type;
} val_attrs_t;

int     posix_spawnattr_set_persona_np(const posix_spawnattr_t * __restrict, uid_t, uint32_t);
int     posix_spawnattr_set_persona_uid_np(const posix_spawnattr_t * __restrict, uid_t);
int     posix_spawnattr_set_persona_gid_np(const posix_spawnattr_t * __restrict, gid_t);

uint64_t reboot3(uint64_t how, uint64_t unk);

#define PROC_ALL_PIDS 1U
int proc_listpids(uint32_t type, uint32_t typeinfo, void *buffer, int buffersize);

extern mach_port_t bootstrap_port;

kern_return_t
bootstrap_register(mach_port_t bp, const char* service_name, mach_port_t sp);

#endif /* externalCStuff_h */
