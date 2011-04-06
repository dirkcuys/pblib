#! /usr/bin/python
import glob
import os, sys
import Image, ImageChops

class SwfmillResources:
	""" swfmill resources """
	def __init__(self):
		self.bitmaps = list()

	def addBitmapResource(self, name, url):
		self.bitmaps = self.bitmaps[:] + [(name, url)]

	def writeResourceFile(self, outfile):
		""" write the swfml file used by swfmill to generate the resource library """
		outfile.write('<?xml version="1.0" encoding="iso-8859-1" ?>\n')
		outfile.write('<movie width="1024" height="768" framerate="24">\n')
		outfile.write('\t<background color="#000000"/>\n')
		outfile.write('\t<frame>\n')
		outfile.write('\t\t<library>\n')
		for img in self.bitmaps:
			outfile.write('\t\t\t<clip id="{0}" import="{1}"/>\n'.format(img[0], img[1]))
		outfile.write('\t\t</library>\n')
		outfile.write('\t</frame>\n')
		outfile.write('</movie>\n')
		
	def writeClassDefinitions(self, outfile):
		""" writes the haxe class definitions for using the resources """
		for img in self.bitmaps:
			outfile.write('class {0} extends flash.display.Sprite {1}\n'.format(img[0], '{}'))


class Layout:
	""" A layout in haxe """
	def __init__(self):
		self.sprites = list()
		
	def addSprite(self, resourceName, pos):
		self.sprites = self.sprites[:] + [{'name': resourceName, 'position': pos}]
		
	def writeLayoutClass(self, class_name, outfile):
		outfile.write('class {0} extends flash.display.MovieClip\n'.format(class_name))
		outfile.write('{\n')
		for sprite in self.sprites:
			outfile.write('\tpublic var m_{0} : {0};\n'.format(sprite['name']))

		outfile.write('\tpublic function new()\n')
		outfile.write('\t{\n')
		outfile.write('\t\tsuper();\n')
		for sprite in self.sprites:
			sprite_name = sprite['name']
			outfile.write('\t\tm_{0} = new {0}();\n'.format(sprite_name))
			outfile.write('\t\tm_{0}.x = {1};\n'.format(sprite_name, sprite['position'][0]))
			outfile.write('\t\tm_{0}.y = {1};\n'.format(sprite_name, sprite['position'][1]))
			outfile.write('\t\taddChild(m_{0});\n'.format(sprite_name))
			outfile.write('\t\t\n')
		outfile.write('\t}\n')
		outfile.write('}\n')

def background_crop(image_name, new_name, bgcolor):
	""" removes frame of bgcolor from and image and saves the image under new_name """
	print('background_crop:' + image_name)
	image = Image.open(image_name)
	bg = Image.new("RGBA", image.size, bgcolor)
	diff = ImageChops.difference(image, bg)
	bbox = diff.getbbox()
	
	if bbox:
		new_image = image.crop(bbox)
		new_image.save(new_name)
	return bbox

source_path = './' # path where resources are
output_path = './' # path were new resources should be saved

if len(sys.argv) > 1:
	source_path = sys.argv[1]
	
if len(sys.argv) > 2:
	output_path = sys.argv[2]

rsc = SwfmillResources()
layout = Layout()

for filename in glob.glob(source_path + '*.png'):
	new_filename = output_path + 'rsc_' + os.path.basename(filename)
	bbox = background_crop(filename, new_filename, (255,255,255,0))
	
	resource_name = ''.join(os.path.basename(filename).split('.')[:-1]).capitalize()
	layout.addSprite(resource_name, (bbox[0], bbox[1]))
	rsc.addBitmapResource(resource_name, new_filename)
	
with open('gen_dir_resources.swfml', 'w') as f:
	rsc.writeResourceFile(f)
	
with open('gen_dir_resources.hx', 'w') as f:
	rsc.writeClassDefinitions(f)
	
with open('LayoutClass.hx', 'w') as f:
	layout.writeLayoutClass('LayoutClass', f)
