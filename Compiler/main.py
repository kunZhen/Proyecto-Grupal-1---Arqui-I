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
memOps = ['lbp', 'lwp', 'sbp', 'swp']
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
                temp = line[:-2]

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
            if(line.split()[0] in arithmeticOps):
                artimeticInstruction = arithmeticAddressing(line)

            elif (line.split()[0] in logicOps):
                #logicInstruction = logicAddressing(line)
                result = 1

            elif (line.split()[0] in memOps):
                #memInstruction = memoryAddressing(line)
                result = 1

            elif (line.split()[0] in controlOps):
                #controlInstruction = controlAddressing(line, lineCounter)
                result = 1

            binaryFile.write('\n')
            lineCounter += 1
        f.close()

    os.remove("Compiler/intermediate.txt")

#def controlAddressing(syntax, lineCounter):

#def memoryAddressing(syntax):

#def logicAddressing(syntax):

def arithmeticAddressing(syntax):
    instr = syntax.split()
    operation = instr[0]
    
    if operation in instructionDictionary:
        currentFunction = instructionDictionary[operation]
    else:
        pass

    def extract_register(value):
        return '0' if value == 'zero' else re.findall(r'\d+', value)[0]

    rd = extract_register(instr[1])
    rs1 = extract_register(instr[2])
    rs2 = extract_register(instr[3])
    
    value = '1110' + rs1 + rs2 + rd
    return value


def main():
    remove_tags()
    readFile()

if __name__ == '__main__':
    main()
