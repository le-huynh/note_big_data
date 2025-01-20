
import os

def read_row(file_path, row_num):
    with open(file_path, 'r') as file:
        lines = file.readlines()
        if 0 <= row_num <= len(lines):
            return lines[row_num].strip()
        else:
            return "Row number is out of range."
        
def read_specific_row(file_path, target_row):
    with open(file_path, 'r') as file:
        for current_row, line in enumerate(file, start=0):
            if current_row == target_row:
                return line.strip() 

