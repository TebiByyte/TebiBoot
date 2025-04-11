OUTPUT_FORMAT("binary");
ENTRY(_start);
stage2_loc = 0x8000;

SECTIONS
{
  .text stage2_loc : AT(stage2_loc) {
    code = .;
    *(.text)
    *(.rodata)
  }
  .data : AT(stage2_loc + (data - code))
  {
    data = .;
    *(.data)
  }
  .bss : AT(stage2_loc + (bss - code))
  {
    bss = .;
    *(.bss)
  }
  end = .;
}
