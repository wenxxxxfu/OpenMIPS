## ori指令
ori进行逻辑“或”运算，指令格式如图：
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/ori/md_images/ori.png)
指令码为001101，处理器通过指令码识别出ori指令

ori指令作用：将16位立即数immediate进行无符号扩展至32位，与rs寄存器里的值进行“或”运算，结果放入rt寄存器中

## OpenMIPS 五级流水线
- **取指阶段**：从指令存储器读出指令，同时确定下一条指令地址
- **译码阶段**：对指令进行译码，从通用寄存器中读出要使用的寄存器的值，如果指令中含有立即数，那么还要将立即数进行符号扩展或无符号扩展。如果是转移指令，并且满足转移条件，那么给出转移目标，作为新的指令地址
- **执行阶段**：按照译码阶段给出的操作数、运算类型，进行运算，给出运算结果。如果是Load/Store指令，那么还会计算Load/Store的目标地址
- **访存阶段**：如果是Load/Store指令，那么在此阶段会访问数据存储器，反之，只是将执行阶段的结果向下传递到回写阶段。同时，在此阶段还要判断是否有异常需要处理，如果有，那么会清楚流水线，然后转移到异常处理例程入口地址处继续执行。
- **回写阶段**：将运算结果保存到目标寄存器

## 五级流水线中的ori指令
**OpenMIPS的原始数据流图**：
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/ori/md_images/MIPS_ORI.png)
ori指令通过原始的数据流图所表示的数据流向即可完成操作。
- 取指：取出指令寄存器中的ori指令，PC值递增，准备取出下一条指令
- 译码：对ori指令译码，从寄存器中取出第一个操作数的值，对立即数进行扩展后作为第二个操作数的值
- 执行：依据译码阶段传来的源操作数和操作码进行运算，即进行ori指令所代表的“或”运算
- 访存：对于ori指令，在访存阶段没有任何操作，直接运算结果传递到回写阶段
- 回写：将运算结果保存到目的寄存器

**原始的OpenMIPS五级流水线系统结构图**：
![image](https://github.com/zach0zhang/Single_instruction_cycle_OpenMIPS/blob/master/ori/md_images/system_struct_ori.png)

## 手动编译
- 编写inst_rom.data以及testbench
- 波形文件保存在./wave文件夹

## 自动编译
 - mips编译器和模拟器/mips GCC编译环境搭建:https://blog.csdn.net/wfxzf/article/details/88974144
 - .bin->.data的工具：bin2data.py以及.exe均可
- 波形文件保存在./wave文件夹
