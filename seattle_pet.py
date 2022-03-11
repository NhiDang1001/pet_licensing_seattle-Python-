
def solution(num):
    binum = bin(num).replace("0b,")
    count = 0
    binstore = []
    for num in range(len(binum)):
        if binum[num] == '1':
            binstore.append(count)
            count = 0
        else:
            count += 1
    return max(binstore) 

