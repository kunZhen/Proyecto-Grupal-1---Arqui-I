import os
import re


instructionDictionary = {

    'addp': '00000', # Arithmetic
    'subp': '00001',
    'mulp': '00010',
    'divp': '00011',

    'andp': '00100', # Logic
    'orp': '00101',
    'cmpp': '00110',

    'addip': '01000', # Immediate
    'sllip': '01001',
    'srlip': '01010',

    'lbp': '01100', # Memory
    'lwp': '01101',
    'sbp': '10000',
    'swp': '10001',

    'bltp': '10100', # Control
    'bgep': '10101',
    'jump': '10110'

}

arithmeticOps = ['addp', 'subp', 'mulp', 'divp']
logicOps = ['andp', 'orp', 'cmpp']
immOps = ['addip', 'sllip', 'srlip']
I_memOps = ['lbp', 'lwp']
S_memOps = ['sbp', 'swp']
controlOps = ['bltp', 'bgep', 'jump']

controlOpsDictionary = {}

# Memory Initialization File
def romInit(wordSize, depth):

    romDataFile = open("Compiler/rom_data.mif", "r+")
    romDataFile.truncate(0)
    
    romDataFile.write("PISA\n\n")

    romDataFile.write(f'WIDTH={wordSize};\nDEPTH={depth};\n \n')
    romDataFile.write("ADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\n \n")
    romDataFile.write("CONTENT BEGIN\n")
    
    lineCounter = 0

    binaryFile = open('Compiler/binary_out.txt', 'r')
    lastLine = binaryFile.readlines()[-1]
    binaryFile.seek(0)
    for instruction in binaryFile:
        romDataFile.write(f'\t{lineCounter}\t :\t {instruction[:-1]};\n')
        lineCounter += 1

    romDataFile.write(f'\t[{lineCounter}..{depth-1}]\t :\t {0};\n')
    
    romDataFile.write("END;")
    romDataFile.write("\n\nPISA\n\n")
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
    print("Imm: ", imm)
    print("Imm Neg: ", negativeImm)
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

if __name__ == '__main__':
    main()
