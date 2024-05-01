from pwn import *
import yaml

rubrics = yaml.safe_load(open("rubrics.yaml"))

p = process("make qemu-nox".split())

points = 0
errors = []

if b"init: starting sh" not in p.recvuntil(b"init: starting sh\n$", timeout=10):
    print("[!]Failed to start shell")
    print(f"Your score: {points}")
    exit(1)


for rubric in rubrics:
    print(f"[!]Checking [{rubric['name']}]")
    try:
        p.sendline(rubric["cmd"].encode())
        recv = p.recvuntil(rubric["expect"].encode(), timeout=2).decode('latin-1')
        if rubric["expect"] not in recv:
            raise Exception("Wrong output")
        points += rubric["points"]
    except:
        errors.append(rubric["note"])

if errors:
    print("[!]Errors:")
    for error in errors:
        print("    " + error)
else:
    print("[!]All check passed!")
print("=======")
print(f"Your score: {points}")

if errors:
    exit(1)
