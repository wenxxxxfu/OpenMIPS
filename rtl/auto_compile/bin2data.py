# bin_to_data.py
import sys

def bin_to_data(bin_file, data_file):
    try:
        with open(bin_file, 'rb') as bf, open(data_file, 'w') as df:
            # 读取二进制文件的内容
            byte = bf.read(4)  # 每次读取4个字节（32位）

            while byte:
                # 将4个字节转换为十六进制字符串
                hex_value = byte.hex()
                df.write(f"{hex_value}\n")  # 每个机器码占一行
                byte = bf.read(4)

            print(f"Data written to {data_file}")

    except FileNotFoundError:
        print(f"Error: File {bin_file} not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python bin_to_data.py <input_binary_file> <output_data_file>")
    else:
        bin_to_data(sys.argv[1], sys.argv[2])
