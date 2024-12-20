1. 设计目标：
	1. 五级整数流水线
	2. 哈佛结构，分开的指令、数据接口
	3. 32个32位整数寄存器
	4. 大端模式
	5. 向量化异常处理，支持精确异常处理
	6. 支持6个外部中断
	7. 具有32-bit数据、地址总线宽度
	8. 能实现单周期乘法
	9. 支持延迟转移
	10. 兼容MIPS32 Release1 指令集架构，支持所有整数指令
	11. 大多数指令可以在一个时钟周期内完成
2. 五级流水：
	1. 取指：从指令存储器中读出指令，病确定下一条指令的地址
	2. 译码：对指令译码，从通用寄存器中读出要使用的寄存器的值；对立即数进行符号/无符号扩展；对于转移指令，给出转移目标地址
	3. 执行：运算，对于load/store指令，还会计算目标地址
	4. 访存：load/store指令回访问数据存储器，否则只是向下传递到回写阶段。在此阶段还需要判断是否有异常，如果有，清除流水线，并转移到异常处理例程入口地址处继续执行
	5. 回写：将运算结果保存到目标寄存器
3. 指令执行周期
	1. 除法指令div/divu：36 cycle
	2. 乘累加指令madd/maddu：2 cycle
	3. 乘累减指令msub/msubu：2 cycle
	4. 其余指令：1 cycle
4. 接口描述：<br/>![](https://github.com/wenxxxxfu/OpenMIPS/blob/main/notes/imgs/Pasted%20image%2020241129132636.png)<br/>
<br/>![](https://github.com/wenxxxxfu/OpenMIPS/blob/main/notes/imgs/Pasted%20image%2020241129133253.png)<br/>
5. 文件命名，在后续章节会逐一介绍：<br/>![](https://github.com/wenxxxxfu/OpenMIPS/blob/main/notes/imgs/Pasted%20image%2020241129133446.png)<br/>
   
	
