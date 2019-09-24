# python3 /Users/yiche/Code/downloadDemo/FDKit/FDKit/Shell/AppIconTool/ResizeImage.py  /Users/yiche/Code/downloadDemo/FDKit/FDKit/Shell/AppIconTool/OrangeDragon.png
# python3 ./ResizeImage.py /Users/yiche/Desktop/tempDirectory/icon.png  ./ImageNameToSizeMap.json

import os
import sys
import PIL.Image
import string
import json

def resize_image_with_config(image_dir, config_dir):
    '''
    读取配置文件的设置，导出对应的图片
    param image_dir:原始图片路径
    param config_dir:配置文件路径
    '''
    original_image = PIL.Image.open(image_dir)
    original_image_folder = os.path.split(image_dir)[0]
    # 读取配置文件
    with open(config_dir, 'r', encoding='utf-8') as f:
        image_config_array = json.load(f)
        for image_config in image_config_array:
            output_image = original_image.resize((image_config['width'], image_config['height']), PIL.Image.ANTIALIAS)
            output_path = os.path.join(original_image_folder,image_config['filename'] )
            output_image.save(output_path)
            print('output_path is :{0}'.format(output_path))

def resize_image_with_default_icon_behaviour(image_dir):
    '''
    默认行为，导出固定格式的icon
    :param image_dir:原始图片路径
    '''
    size_list = ['20', '57', '29', '72', '50', '32', '40', '1024', '60', '76']
    multiple_list = [2, 3]
    original_image = PIL.Image.open(image_dir)
    for output_size in size_list:
        file_name = os.path.splitext(image_dir)[0]
        outFile = file_name + '_' + output_size + 'x' + output_size + '.png'
        output_image = original_image.resize((int(output_size), int(output_size)), PIL.Image.ANTIALIAS)
        output_image.save(outFile)
        print('output_path is :{0}'.format(outFile))

        for multiple in multiple_list:
            outFile_x = file_name + '_' + output_size + 'x' + output_size + '@' + str(multiple) + 'x' + '.png'
            output_image_x = original_image.resize((int(output_size) * multiple, int(output_size) * multiple), PIL.Image.ANTIALIAS)
            output_image_x.save(outFile_x)
            print('output_path is :{0}'.format(outFile_x))


if __name__=='__main__':
    print('sys.argv:{0}'.format(sys.argv))
    if 1 == len(sys.argv) :
        sys.exit('please input a image dir at least')

    if 2 == len(sys.argv):
        image_dirctory = sys.argv[1]
        resize_image_with_default_icon_behaviour(image_dirctory)

    if 3 == len(sys.argv):
        image_dirctory = sys.argv[1]
        config_directory = sys.argv[2]
        resize_image_with_config(image_dirctory,config_directory)
