import os
import PIL.Image
import string

inFile = 'icon.png'
sizeArray = ['20', '57', '29', '72', '50', '32', '40', '1024', '60', '76']
multipleArray = [2, 3]
for outSize in sizeArray: 
    fileName = os.path.splitext(inFile)[0]
    im = PIL.Image.open(inFile)
    outFile = fileName + '_' + outSize + 'x' + outSize + '.png'
    outImage = im.resize((string.atoi(outSize), string.atoi(outSize)), PIL.Image.ANTIALIAS)
    outImage.save(outFile)

    for multiple in multipleArray:
        outFile_x = fileName + '_' + outSize + 'x' + outSize + '@' + str(multiple) + 'x' + '.png'
        outImage_x = im.resize((string.atoi(outSize) * multiple, string.atoi(outSize) * multiple), PIL.Image.ANTIALIAS)
        outImage_x.save(outFile_x)
