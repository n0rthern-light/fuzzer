#!/usr/bin/env python3

import sys
import math
import random
import os

assert len(sys.argv) > 2, "Usage: fuzzer.py <input-file> <out-file>"

file_path = sys.argv[1]
out_path = sys.argv[2]

d = open(file_path, "rb").read()
file_size = len(d)
fuzzed_parts_count = math.ceil(file_size / 0x100)
m = d

print(f"File name: {file_path}")
print(f"File size: 0x{file_size:x}")
print("-" * 64)

for i in range(0, fuzzed_parts_count):
    size = random.randint(0, 8)
    min_index = i * 0x100
    max_index = min((min_index + 0x100), file_size) - size
    if size == 0:
        print(f"{(f"(0x{min_index:x} 0x{max_index:x}): 0x{size:x}"):24}" + " -> skipping...")
        continue
    index = random.randint(min_index, max_index)
    rand_bytes = os.urandom(size)
    m = m[:index] + rand_bytes + m[index + size:]
    print(f"{(f"(0x{min_index:x} 0x{max_index:x}): 0x{size:x}"):24}" + f" -> {' '.join(f"{byte:02x}" for byte in rand_bytes):24} @ 0x{index:x}")

assert len(d) == len(m), "Modified binary size changed"

print("-" * 64)
print(f"Saving as: {out_path}")

with open(out_path, "wb") as f:
    f.write(m)
