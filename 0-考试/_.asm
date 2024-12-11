ORG 2000H
START: 
MOV A , 30H ; 加载30H的数据到A A = [(30H)H,(30H)L]
ANL A , 0FH ; 取出低四位数据 A = [0,30H]
MOV 31H , A ; 将A的值保存到31H中 31H = [0,30H]
MOV A , 30H ; 重新加载30H的数据到A A = [(30H)H,(30H)L]
SWAP A      ; 交换A中数据的位置 A = [(30H)L,(30H)H]
ANL A , 0F0H; 取出低四位数据 A = [0,(30H)H]
MOV 32H , A ; 将A的值保存到32H中 32H = [0,(30H)H]

---

ORG 0000H          ; 程序起始地址为 0000H

MOV R0, #41H      ; 将立即数 41H 加载到寄存器 R0，R0 指向被加数的高字节 R0 = [41H]
MOV R1, #43H      ; 将立即数 43H 加载到寄存器 R1，R1 指向加数的高字节 R1 = [43H]

MOV A, @R0        ; 将 R0 指向的内存地址（41H）中的值加载到累加器 A 中（被加数的高字节）A = [(41H)]
ADD A, @R1        ; 将 R1 指向的内存地址（43H）中的值加到 A 中（加数的高字节）A = [(41H)]+[(43H)]
MOV 45H, A       ; 将高字节的和存放到 45H

DEC R0            ; 将 R0 的值减 1，R0 现在指向被加数的低字节（40H）
DEC R1            ; 将 R1 的值减 1，R1 现在指向加数的低字节（42H）

MOV A, @R0        ; 将 R0 指向的内存地址（40H）中的值加载到累加器 A 中（被加数的低字节）
ADDC A, @R1       ; 将 R1 指向的内存地址（42H）中的值加到 A 中，并加上进位（如果有的话）
MOV 44H, A       ; 将低字节的和存放到 44H

SJMP $            ; 死循环，保持程序运行

END                ; 程序结束


    ORG  0H              ; 程序起始地址
START:
    MOV  A, 60H          ; 将内存 60H 中的值（即 x）加载到累加器 A 中
    MOV  R0, A           ; 将 x 的值保存到 R0 中（用于后续比较）
    MOV  A, R0           ; 重新加载 A，准备与 1 比较

    ; 判断 x 是否大于 1
    MOV  B, #01H         ; 将 1 加载到 B 寄存器中
    SUBB A, B            ; A = A - 1 （这里 A 包含 x，B 包含 1）
    JC   x_greater_than_1 ; 如果进位标志为 1，说明 x > 1，跳转到 x_greater_than_1

    ; 判断 x 是否等于 1
    MOV  A, R0           ; 重新加载 A，恢复 x 的原值
    SUBB A, B            ; A = A - 1 （检查 x 是否等于 1）
    JZ   x_equals_1      ; 如果零标志为 1，说明 x = 1，跳转到 x_equals_1

    ; 如果 x < 1
x_less_than_1:
    MOV  A, #0FDH        ; 将 A 设置为 -1（补码表示）
    MOV  61H, A          ; 将 -1 存储到内存 61H（FUNC）中
    SJMP done            ; 跳过剩余的代码

x_equals_1:
    MOV  A, #00H         ; 将 A 设置为 0（因为 x = 1）
    MOV  61H, A          ; 将 0 存储到内存 61H（FUNC）中
    SJMP done            ; 跳过剩余的代码

x_greater_than_1:
    MOV  A, #01H         ; 将 A 设置为 1（因为 x > 1）
    MOV  61H, A          ; 将 1 存储到内存 61H（FUNC）中

done:
    NOP                  ; 程序结束，空操作
    END
