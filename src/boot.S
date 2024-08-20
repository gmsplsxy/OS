#include "sysregs.h"
#include "mm.h"

.section ".text.boot"

.globl _start

_start:
  // using only one core
  mrs   x0, mpidr_el1
  and   x0, x0, #0xFF
  cbz   x0, entry
  b halt

entry:
  // check current el
  mrs x0, CurrentEL
  lsr x0, x0, #2
  cmp x0, #3
  bne el2_entry

el3_entry:
  ldr	x0, =SCTLR_VALUE_MMU_DISABLED
  msr	sctlr_el2, x0

  ldr	x0, =HCR_VALUE
  msr	hcr_el2, x0

  ldr	x0, =SCR_VALUE
  msr	scr_el3, x0

  ldr	x0, =SPSR_EL2_VALUE
  msr	spsr_el3, x0

  adr	x0, el2_entry
  msr	elr_el3, x0

  eret

el2_entry:
  ldr	x0, =SCTLR_VALUE_MMU_DISABLED
  msr	sctlr_el1, x0

  ldr	x0, =HCR_VALUE
  msr	hcr_el2, x0

  ldr	x0, =SPSR_EL1_VALUE
  msr	spsr_el2, x0

  adr	x0, el1_entry
  msr	elr_el2, x0

  eret

el1_entry:
  adr x0, __bss_start
  adr x1, __bss_end
  sub x1, x1, x0
  bl  memzero

  mov sp, #LOW_MEMORY
  bl  kernel_main

halt:
  wfe
  b halt
