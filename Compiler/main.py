import os
import re

register_map = {
    'zero': 0, 'v0': 1,
    'a0': 2, 'a1': 3, 'a2': 4, 'a3': 5,
    's0': 6, 's1': 7, 's2': 8, 's3': 9, 's4': 10, 's5': 11, 's6': 12, 's7': 13, 's8': 14, 's9': 15,
    't0': 16, 't1': 17, 't2': 18, 't3': 19, 't4': 20, 't5': 21, 't6': 22, 't7': 23, 't8': 24, 't9': 25,
    't10': 26, 't11': 27, 't12': 28, 't13': 29, 't14': 30, 't15': 31
}

instructionDictionary = {

    'addp': '00000', # Arithmetic
    'subp': '01000',
    'mulp': '10000',
    'divp': '11000',

    'andp': '00001', # Logic
    'orp': '01001',
    'cmpp': '10001',

    'addip': '00010', # Immediate
    'sllip': '01010',
    'srlip': '10010',

    'lbp': '00011', # Memory
    'lwp': '01011',
    'sbp': '00100',
    'swp': '01100',

    'bltp': '00101', # Control
    'bgep': '01101',
    'jump': '10101'

}

arithmeticOps = ['addp', 'subp', 'mulp', 'divp']
logicOps = ['andp', 'orp', 'cmpp']
immOps = ['addip', 'sllip', 'srlip']
I_memOps = ['lbp', 'lwp']
S_memOps = ['sbp', 'swp']
controlOps = ['bltp', 'bgep', 'jump']

controlOpsDictionary = {}

# Memory Initialization File
def initializeRom(wordSize, depth):
    file_path = "Compiler/rom_data.mif"
    
    try:
        romDataFile = open(file_path, "r+")
        # Clear existing content
        romDataFile.truncate(0)
        
    except FileNotFoundError:
        # If the file doesn't exist, create it
        romDataFile = open(file_path, "w")
    
    # Write initial content
    romDataFile.write("--PISA--\n\n")
    romDataFile.write(f'WIDTH={wordSize};\nDEPTH={depth};\n \n')
    romDataFile.write("ADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\n \n")
    romDataFile.write("CONTENT BEGIN\n")
    
    lineCounter = 0

    with open('Compiler/binary_out.bin', 'r') as binaryFile:
        for instruction in binaryFile:
            romDataFile.write(f'\t{lineCounter}\t :\t {instruction.rstrip()};\n')
            lineCounter += 1

    romDataFile.write(f'\t[{lineCounter}..{depth-1}]\t :\t {0};\n')
    romDataFile.write("END;")
    romDataFile.write("\n\n--PISA--\n\n")
    romDataFile.close()


def remove_tags():
    lineCounter = 0
    with open('Compiler/bilinear_interpolation.txt', 'r') as f:
        # Read all lines, removing empty lines, comments and removing indentation
        lines = [line.strip() for line in f.readlines() if line.strip() and not line.strip().startswith('#') and not line.strip().startswith('.global')]
        f.close()

    with open('Compiler/intermediate.txt', 'xt') as f:
        for line in lines:

            # If there is a tag add it to controlOpsDictionary with the line number
            if ':' in line:

                # Tag name
                line = line.replace(' ', '')
                line = line.replace('\n', '')
                temp = line.replace(':', '')
                # Line number to binary and fill for 20 bits
                lineNumber = bin(lineCounter-len(controlOpsDictionary))[2:].zfill(20)
                controlOpsDictionary[temp] = lineNumber

            else:
                f.write(line + '\n')

            lineCounter += 1
        f.close()


def readFile():
    lineCounter = 0
    binary_lines = []  # List to store binary content
    hex_lines = []  # List to store the content in hexadecimal

    with open('Compiler/intermediate.txt', 'r') as f:
        f.seek(0)
        
        for line in f:
            instr = line.split()
            instr = [s.rstrip(',') for s in instr]  # Remove ","

            # Remove comments
            clean_instr = instr
            if '#' in instr: 
                comment_index = instr.index('#')
                clean_instr = instr[:comment_index]

            if instr[0] in (arithmeticOps + logicOps + immOps):
                artimeticInstruction = RITypeAddressing(clean_instr)
                binary_lines.append(artimeticInstruction)
                hexInstruction = format(int(artimeticInstruction, 2), '05x')
                hex_lines.append(hexInstruction)

            elif instr[0] in (I_memOps + S_memOps):
                memInstruction = memoryAddressing(clean_instr)
                binary_lines.append(memInstruction)
                hexInstruction = format(int(memInstruction, 2), '05x')
                hex_lines.append(hexInstruction)

            elif instr[0] in controlOps:
                controlInstruction = controlAddressing(clean_instr, lineCounter)
                binary_lines.append(controlInstruction)
                hexInstruction = format(int(controlInstruction, 2), '05x')
                hex_lines.append(hexInstruction)

            elif instr[0] == 'nop':
                nopInstruction = ''.zfill(20)
                binary_lines.append(nopInstruction)
                hexInstruction = format(int(nopInstruction, 2), '05x')
                hex_lines.append(hexInstruction)

            elif instr[0] == 'syscall':
                syscallInstruction = ''.zfill(15) + '00110'
                binary_lines.append(syscallInstruction)
                hexInstruction = format(int(syscallInstruction, 2), '05x')
                hex_lines.append(hexInstruction)

            lineCounter += 1

    with open('Compiler/binary_out.bin', 'w') as binaryFile, open('Compiler/hexadecimal_out.hex', 'w') as hexFile:
        for binary_line, hex_line in zip(binary_lines, hex_lines):
            binaryFile.write(binary_line + '\n')
            hexFile.write(hex_line + '\n')

    os.remove("Compiler/intermediate.txt")


def controlAddressing(instr, lineCounter):
    operation = instructionDictionary[instr[0]]
    jumpToLine = int(format(int(controlOpsDictionary[instr[1]], 2)))

    imm = ''
    if jumpToLine < lineCounter:
        positive_binary = bin(lineCounter - jumpToLine)[2:].zfill(15)
        inverted = ''.join('1' if bit == '0' else '0' for bit in positive_binary)
        negative_binary = bin(int(inverted, 2) + 1)[2:]
        imm = negative_binary.zfill(15)
    else:
        imm = bin(jumpToLine - lineCounter)[2:].zfill(15)

    value =  imm + operation
    return value


def memoryAddressing(instr):
    operation = instructionDictionary[instr[0]]

    # Separate instruction into list elements (remove parentheses)
    if operation[2:] == '011': # Load
        temp = instr[2][:-1].split('(')
        instrToList = [instr[0], instr[1]] + [temp[1]] + [temp[0]]
        instrToList[-1] = instrToList[-1].replace(')', '')
    else: # Store
        temp = instr[2][:-1].split('(')
        instrToList = [instr[0]] + [temp[0]] + [temp[1]] + [instr[1]]
        instrToList[-1] = instrToList[-1].replace(')', '')

    if instrToList[0] in I_memOps:
        rd = format(int(extract_register(instrToList[1])), 'b').zfill(5)
        rs1 = format(int(extract_register(instrToList[2])), 'b').zfill(5)
        imm = format(int(extract_register(instrToList[3])), 'b').zfill(5)
        value =  imm + rs1 + rd + operation
    else:
        imm = format(int(extract_register(instrToList[1])), 'b').zfill(5)
        rs1 = format(int(extract_register(instrToList[2])), 'b').zfill(5)
        rs2 = format(int(extract_register(instrToList[3])), 'b').zfill(5)
        value =  rs2 + rs1 + imm + operation
    return value
        
    
def RITypeAddressing(instr):
    operation = instructionDictionary[instr[0]]

    if len(instr) > 3:
        rd = format(int(extract_register(instr[1])), 'b').zfill(5)
        rs1 = format(int(extract_register(instr[2])), 'b').zfill(5)
        rs2 = format(int(extract_register(instr[3])), 'b').zfill(5)
        value =  rs2 + rs1 + rd + operation
    else:
        rs1 = format(int(extract_register(instr[1])), 'b').zfill(5)
        rs2 = format(int(extract_register(instr[2])), 'b').zfill(5)
        value = rs2 + rs1 + '00001' + operation

    return value
    

def extract_register(value):
    # Check if the value is a known registry name
    if value in register_map:
        return register_map[value]
    
    # If it is an immediate number
    if isinstance(value, (int, str)) and str(value).isdigit():
        return str(value)
    

def main():
    remove_tags()
    readFile()
    initializeRom(20, 256)

if __name__ == '__main__':
    main()
