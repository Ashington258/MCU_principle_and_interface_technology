; 89C51串行口工作方式3的全双工通信程序
ORG 0H                ; 程序起始地址

DATA_TO_SEND DB 0AAH  ; 发送的数据（用作示例）
RECEIVE_BUFFER DB 0    ; 接收的数据存储区

START:
    MOV TMOD, #20H    ; 配置定时器1，模式2
    MOV TH1, #0C8H    ; 设置波特率为1200 bps
    SETB TR1           ; 启动定时器1

    ; 配置串行口 SCON：工作方式3
    MOV SCON, #B0H     ; 工作方式3，允许接收和发送，第9位为奇偶校验位

    ; 启用全局中断和串行中断
    SETB EA            ; 使能全局中断
    SETB ES            ; 使能串行中断

    ; 主循环
MAIN_LOOP:
    ; 发送数据的程序
    MOV A, DATA_TO_SEND ; 将数据加载到累加器
    CALL CALCULATE_PARITY ; 计算奇偶校验位
    MOV SBUF, A         ; 发送数据（包含奇偶校验位）

WAIT_SEND:
    JNB TI, WAIT_SEND   ; 等待发送完成
    CLR TI               ; 清除发送中断标志

    ; 可以在此添加对接收数据的逻辑，此处简化为只发送数据
    SJMP MAIN_LOOP       ; 返回主循环

; 奇偶校验计算
CALCULATE_PARITY:
    MOV B, A            ; 将数据复制到B
    CLR C               ; 清除进位
    ; 计数，统计A中的1的个数
    PARA_LOOP:
        ANL B, #01H     ; 与1进行与运算
        JZ NOT_PARITY    ; 如果结果为0则跳过
        INC C           ; 计算1的个数
        NOT_PARITY:
        SWAP A          ; 交换A中的高低4位
        ANL A, #0FH     ; 保留低4位
        JNZ PARA_LOOP    ; 如果还有1则继续循环
    ; 检查1的个数
    ANL C, #01H         ; 奇数为1，偶数为0
    JZ EVEN_PARITY       ; 如果是偶数则保持数据不变(保持原来的奇偶校验位)
    SETB ACC.8          ; 设置奇偶校验位（奇数位为1）
    RET

EVEN_PARITY:
    CLR ACC.8           ; 设置奇偶校验位（偶数位为0）
    RET

; 串行中断服务程序
SERIAL_ISR:
    ; 判断是否接收中断
    JB RI, SERIAL_EXIT  ; 如果不是接收中断，退出

    MOV RECEIVE_BUFFER, SBUF ; 将接收到的数据存储到缓冲区
    CLR RI               ; 清除接收中断标志

SERIAL_EXIT:
    RETI                 ; 中断服务程序返回

END