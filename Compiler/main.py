import os
import re


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

    with open('Compiler/binary_out.txt', 'r') as binaryFile:
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
        lines = f.readlines()
        f.close()

    with open('Compiler/intermediate.txt', 'xt') as f:
        for line in lines:

            # If there is a tag add it to controlOpsDictionary with the line number
            if(line[-2] == ':'):

                # Tag name
                temp = line[:-2] # 2 ':' and '\n'
                # Line number to binary and fill for 24 bits
                lineNumber = bin(lineCounter)[2:].zfill(24)
                controlOpsDictionary[temp] = lineNumber

            else:
                f.write(line)

            lineCounter += 1
        f.close()

def readFile():
    lineCounter = 0
    with open('Compiler/intermediate.txt', 'r') as f:
        f.seek(0)
        binaryFile = open('Compiler/binary_out.txt', 'w')
        
        for line in f:
            instr = line.split()
            instr = [s.rstrip(',') for s in instr] # Remove ","

            # Remove comments
            if '#' in instr: comment_index = instr.index('#')
            clean_instr = instr[:comment_index]

            if instr[0] in (arithmeticOps + logicOps + immOps):
                
                artimeticInstruction = RITypeAddressing(clean_instr)
                binaryFile.write(artimeticInstruction)

            elif (instr[0] in (I_memOps + S_memOps)):
                memInstruction = memoryAddressing(clean_instr)
                binaryFile.write(memInstruction)


            elif (instr[0] in controlOps):
                controlInstruction = controlAddressing(clean_instr, lineCounter)
                binaryFile.write(controlInstruction)

            binaryFile.write('\n')
            lineCounter += 1
        f.close()

    os.remove("Compiler/intermediate.txt")

def controlAddressing(instr, lineCounter):
    operation = instructionDictionary[instr[0]]
    imm = format(lineCounter + 2 - (int(controlOpsDictionary[instr[1]], 2)), 'b').zfill(15)
    negativeImm = format(int(''.join('1' if bit == '0' else '0' for bit in imm), 2) + int('1', 2), 'b')
    value =  imm + operation
    return value


def memoryAddressing(instr):
    
    operation = instructionDictionary[instr[0]]

    # Separate instruction into list elements (remove parentheses)
    instrToList = [instr[0], instr[1]] + instr[2][:-1].split('(')
    instrToList[-1] = instrToList[-1].replace(')', '')

    if instrToList[0] in I_memOps:
        rd = format(int(extract_register(instrToList[1])), 'b').zfill(5)
        rs1 = format(int(extract_register(instrToList[2])), 'b').zfill(5)
        imm = format(int(extract_register(instrToList[3])), 'b').zfill(5)
        value =  imm + rs1 + rd + operation
    else:
        rs1 = format(int(extract_register(instrToList[1])), 'b').zfill(5)
        imm = format(int(extract_register(instrToList[2])), 'b').zfill(5)
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

    if isinstance(value, (int, str)) and str(value).isdigit():
        return str(value)

    if value == 'zero':
        return '0'

    digits = re.findall(r'\d+', value)
    if digits:   
        return digits[0]

def main():
    remove_tags()
    readFile()
    initializeRom(20, 256)

if __name__ == '__main__':
    main()
