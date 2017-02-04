'''
Created on Oct 16, 2014

@author: I042416
'''
import sys
import re

def update_count(current):
    global  max_count
    global  min_count
    if current > max_count:
        max_count = current
    if current < min_count:
        min_count = current
    
        
def handleLine(x):
    word_array = x.split(' ')
    
    for word in word_array:
        word = word.strip()
        if word == '':
            continue;
        if word in d:
            d[word] = d[word] + 1
        else:
            d[word] = 1
        update_count(d[word])
        
def print_output():
    most_frequently_used_words = []
    least_frequently_used_words = []
    for each in d:
        value = d.get(each)
        if value == min_count:
            least_frequently_used_words.append(each)
        if value == max_count:
            most_frequently_used_words.append(each)
    print("max count:" , max_count)
    for each in most_frequently_used_words: 
        print(each)
    print("min count", min_count)
    for each in least_frequently_used_words:
        print(each)

        
# 打开txt文件
try:
  # 从命令行参数获取目标文件路径
  try:
    sys.argv.append("test1.txt")

    file_path = sys.argv[1]
  except IndexError as err:
    file_path = " "
    
  d = {}
  max_count = 0;
  min_count = 1;

  f = open(file_path)
  for line in f.readlines():
      line = line.strip('\n')
      handleLine(line)

  f.close()
  print_output()

except IOError as err:
  print(u"请确保在运行本脚本时提供了正确的目标文件地址")



