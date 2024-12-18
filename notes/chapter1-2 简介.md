1. 指令集架构：将编程所需要了解的硬件信息从硬件系统中抽象出来，使得软件人员可以面向ISA编程，开发出的软件可以不经修改应用在所有符合该ISA的计算机上。
2. 微架构是ISA的一个实现
3. MIPS：无内锁流水线微处理器
4. MIPS32指令集架构：
	1. 数据类型：bit/byte/half word/word/double word
	2. 除了加载/存储指令，其他都是使用寄存器（通用寄存器GP、特殊寄存器）或者立即数作为操作数的
	3. 包含32个32-bit通用寄存器（$0~$31），$0常用作常量0
	4. 3个特殊寄存器：程序计数器PC、乘除结果高位寄存器HI、乘除结果低位寄存器LO
	5. 字节次序：大端模式（本书采用）、小端模式
	6. 所有指令均为32-bit，格式分为三种类型：<br/>![instruction_format.png](https://github.com/wenxxxxfu/OpenMIPS/blob/main/notes/imgs/instruction_format.png)<br/>
		1. op为指令码，func为功能码
		2. R类型：rs/rt为源寄存器编号，rd是目的寄存器编号，都为5-bit，sa只在移位指令中使用，用来指定移位位数
		3. I类型：低16-bit是立即数，运算时扩展至32-bit，作为其中一个源操作数参与运算
		4. J类型，一般是跳转指令，低26位是字地址，用于产生跳转的目标地址
	7. 指令按照功能分类，有以下类型：
		1. 逻辑操作指令：and/andi/or/ori/xor/xori/nor/lui
		2. 移位操作指令：sll/sllv/sra/srav/srl/srlv
		3. 移动操作指令：movn/movz/mfhi/mthi/mflo/mtlo
		4. 算数操作指令：ass/addi/addiu/addu/sub/subu/clo/clz/slt/slti/sltiu/sltu/mul/mult/multu/madd/maddu/msub/msubu/div/divu
		5. 转移指令：jr/jalr/j/jal/b/bal/beq/bgez/bgezal/bgtz/blez/bltz/bltzal/bne
		6. 加载存储指令：Lb/lbu/lh/lhu/ll/lw/lwl/lwr/sb/sc/sh/sw/swl/swr
		7. 协处理器访问指令：mtc0/mfc0
		8. 异常相关指令：12条自陷指令teq/tge/tgeu/tlt/tltu/tne/teqi/tgei/tgeiu/tlti/tltiu/tnei，系统调用指令syscall，异常返回指令eret
		9. 其余指令：nop/ssnop/sync/pref
	8. 寻址方式：寄存器寻址、立即数寻址、寄存器相对寻址以及PC相对寻址
		1. 寄存器相对寻址主要用于加载/存储指令 <br/>![reg_index.png](https://github.com/wenxxxxfu/OpenMIPS/blob/main/notes/imgs/reg_index.png)<br/>
		2. PC相对寻址主要用于转移指令 <br/>![pc_index.png](https://github.com/wenxxxxfu/OpenMIPS/blob/main/notes/imgs/pc_index.png)<br/>
	9. 协处理器CP0：可选部件，负责处理指令集的某个扩展，拥有与处理器相独立的寄存器，提供了最多4个协处理器 CP0~CP3，其中CP0用于系统控制（配置CPU工作状态、高速缓存控制、异常控制、存储管理单元控制等），CP1/CP3用作浮点处理单元，CP2被保留用于特定实现
	10. 异常：中断、陷阱、系统调用等
	11. 可编程逻辑器件（PLD），按照工艺原理分：
		1. PLA：可编程逻辑阵列
		2. PAL：可编程阵列逻辑
		4. GAL：通用阵列逻辑
		5. PROM：可编程只读存储器
		6. EPLD：可擦除可编程逻辑器件
		7. CPLD：复杂可编程逻辑器件
		8. FPGA：现场可编程门阵列
	12. 可编程逻辑器件（PLD），按照内部结构分：
		1. 基于乘积项结构：任何组合逻辑电路都能化为“与或”，用“与门-或门”两级电路实现，该结构采用与或阵列实现。PROM/PLA/PAL/GAL/EPLD以及绝大多数CPLD都采用该结构，使用EEPROM或Flash工艺，掉电后不会丢失配置数据，器件规模一般小于5000门
		2. 基于查找表结构：基于静态存储器以及数据选择器，通过查表的方式实现函数功能，一般要求输入表量不超过5个，超过的话可以通过组合或级联多个查找表实现。该结构集成度高、逻辑功能强，但是掉电后会丢失配置数据
		
