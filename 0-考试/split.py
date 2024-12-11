import json


def split_instruction_set(json_data, output_dir):
    # 遍历每个类别，生成单独的 JSON 文件
    for category, instructions in json_data.items():
        # 使用类别名作为文件名的一部分
        category_id, category_name = category.split(" ", 1)
        output_file = f"{output_dir}/{category_id}_{category_name}.json"

        # 写入到文件
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump({category: instructions}, f, ensure_ascii=False, indent=4)

        print(f"已生成文件: {output_file}")


# 主函数
def main():
    input_file = "instruction_set.json"  # 输入的 JSON 文件
    output_dir = "output"  # 输出目录（确保存在）

    # 从 JSON 文件中加载数据
    with open(input_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    # 按类别拆分并保存为文件
    split_instruction_set(data, output_dir)


if __name__ == "__main__":
    main()
