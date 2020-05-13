
Vim plugin to display disassembled code using objdump.

# Usage
To display the disassembled code of the current file, use the following command:

	:Disassemble

To display the disassembled code of any other file, supply the file name to the following command:

	:Disassemble <filename>

e.g.

	:Disassemble myfile.c
	:Disassemble myexecutable
	:Disassemble comp.o

# Installation

To install this plugin, use the following commands:

	$ mkdir -p ~/.vim/pack/downloads/opt
	$ cd ~/.vim/pack/downloads/opt
	$ git clone https://github.com/yegappan/disassemble
	
Add the following line to the ~/.vimrc file:

	packadd disassemble
