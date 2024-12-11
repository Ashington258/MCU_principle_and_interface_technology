import json
import re


def parse_instruction_set(file_path):
    result = {}
    current_category = None
    category_pattern = r"^##\s+(\d+)\s+(.*)$"
    instruction_pattern = r'^([\w\s"]+),([\w\s".,@#+]+),(.*?),(\d+)$'

    with open(file_path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    for line in lines:
        line = line.strip()
        if not line:
            continue

        # Match category
        category_match = re.match(category_pattern, line)
        if category_match:
            category_id = category_match.group(1).strip()
            category_name = category_match.group(2).strip()
            current_category = f"{category_id} {category_name}"
            result[current_category] = []
            continue

        # Match instruction
        instruction_match = re.match(instruction_pattern, line)
        if instruction_match:
            mnemonic = instruction_match.group(1).strip()
            operand = instruction_match.group(2).strip()
            description = instruction_match.group(3).strip()
            byte_count = int(instruction_match.group(4).strip())

            result[current_category].append(
                {
                    "助记符": mnemonic,
                    "操作数": operand,
                    "功能说明": description,
                    "字节数": byte_count,
                }
            )

    return result


# Main function to read from TXT and save as JSON
def main():
    input_file = "0-考试/指令集.txt"  # Replace with your TXT file path
    output_file = "instruction_set.json"

    # Parse the instruction set
    parsed_data = parse_instruction_set(input_file)

    # Save as JSON file
    with open(output_file, "w", encoding="utf-8") as json_file:
        json.dump(parsed_data, json_file, ensure_ascii=False, indent=4)

    print(f"指令集已成功转换为 JSON 文件：{output_file}")


if __name__ == "__main__":
    main()
