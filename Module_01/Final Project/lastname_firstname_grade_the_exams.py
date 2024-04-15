import re
import numpy as np
import sys

# filename = input("Nhập đường dẫn của tệp: ")
filenames = [
    r"Module_01\Final Project\Data Files\class1.txt",
    r"Module_01\Final Project\Data Files\class2.txt",
    r"Module_01\Final Project\Data Files\class3.txt",
    r"Module_01\Final Project\Data Files\class4.txt",
    r"Module_01\Final Project\Data Files\class5.txt",
    r"Module_01\Final Project\Data Files\class6.txt",
    r"Module_01\Final Project\Data Files\class7.txt",
    r"Module_01\Final Project\Data Files\class8.txt",
]

for filename in filenames:
    answer_key = "B,A,D,D,C,B,D,A,C,C,D,B,A,B,A,C,B,D,A,C,A,A,B,D,D"
    lst_answer = answer_key.split(",")

    sum_count = 0
    err_count = 0
    dic_score = {}
    hight_score = 0
    dic_pass = {}
    dic_failed = {}

    try:
        f = open(filename, "r")
    except Exception as e:
        print(f"Không tìm thấy tệp, vui lòng kiểm tra lại!")
        sys.exit()

    with f:
        print("*"*100)
        print(f"Mở file {filename} thành công!")
        print(f"Xử lý file: {filename}")
        for line in f:
            elements = line.strip().split(",")
            # kiểm tra hợp lệ của dòng
            if not (len(elements) == 26 and re.match("^N\d{8}", str(elements[0]))):
                err_count += 1
                print(f"{elements[0]} không hợp lệ!")
            else:
                for index, value in enumerate(elements):
                    # index = 0 là mã của sinh vien
                    if index == 0:
                        dic_score[value] = 0
                        continue

                    # câu trả lời bị bỏ qua
                    if value is None or value == "":
                        dic_score[elements[0]] += 0

                        if str(index) in dic_pass.keys():
                            dic_pass[str(index)] += 1
                        else:
                            dic_pass[str(index)] = 1

                    # câu trả lời đúng
                    elif value == lst_answer[index - 1]:
                        dic_score[elements[0]] += 4
                    # câu trả lời sai
                    elif value != lst_answer[index - 1]:
                        dic_score[elements[0]] -= 1

                        if str(index) in dic_failed.keys():
                            dic_failed[str(index)] += 1
                        else:
                            dic_failed[str(index)] = 1
            sum_count += 1

    print(f"\nTổng số dòng là: {sum_count}\nTổng số dòng lỗi là: {err_count}")
    dic_score_sort = sorted(dic_score.items(), key=lambda x: x[1], reverse=True)

    for k, v in dic_score.items():
        if v > 80:
            hight_score += 1

    print(f"Số lượng học sinh đạt điểm cao là :{hight_score}")
    print(f"Điểm trung bình là: {np.mean(list(dic_score.values()))}")
    print(f"Điểm cao nhất là {dic_score_sort[0][1]}")
    print(f"Điểm thấp nhất là {dic_score_sort[-1][1]}")
    print(f"Miền giá trị là {dic_score_sort[0][1] - dic_score_sort[-1][1]}")
    print(f"Giá trị trung vị là: {np.median(list(dic_score.values()))}")

    # các câu hỏi bị bỏ qua nhiều nhất theo thứ tự:
    # số thứ tự câu hỏi - số lượng học sinh bỏ qua - tỷ lệ bị bỏ qua

    # lấy giá trị max
    max_pass_value = sorted(dic_pass.items(), key=lambda x: x[1], reverse=True)[0][1]
    max_failed_value = sorted(dic_failed.items(), key=lambda x: x[1], reverse=True)[0][1]

    print(f"Giá trị - Số lượng - Tỷ lệ bị bỏ qua là: ")
    for k, v in dict(sorted(dic_pass.items(), key=lambda x: int(x[0]))).items():
        if v == max_pass_value:
            print(f"{k} - {v} - {round(v/sum_count, 3)}")

    print(f"Giá trị - Số lượng - Tỷ lệ bị sai là: ")
    for k, v in dict(sorted(dic_failed.items(), key=lambda x: int(x[0]))).items():
        if v == max_failed_value:
            print(f"{k} - {v} - {round(v/sum_count, 3)}")


    # tạo file kết quả
    file_name_result = (filename.split("\\")[-1]).split(".")[0] + "_grades.txt"
    with open(file_name_result, "w+") as f:
        for k, v in dict(sorted(dic_score.items())).items():
            f.write(f"{k}, {v}\n")