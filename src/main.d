module main;

import std.stdio;
import std.string;
import std.conv;

import spec.common;

unittest {
	assert(mutable("nop".dup) == 0x0000);
	assert(mutable("not 0x00".dup) == 0x4100);
	assert(mutable("not [0x00]".dup) == 0x4101);
	assert(mutable("udiv 0x00 {0x23FE} 0x04 [0x08]".dup) == 0x4f28);
	assert(mutable("add byte 0x00 0x01 0x02".dup) == 0x1700);
	assert(mutable("sub half [0x34] 0x36 0x38".dup) == 0x2701);
}

int main(string[] args)
{
	try {
		File file = File(args[1], "r");
		int mutLine;

	    foreach(line; file.byLine){
	    	mutLine = mutable(line);
//	        foreach(word; mutLine.split)
			writefln("[%x]", mutLine);
	    }
	}
	catch (Exception e) {
		stderr.writeln(e.msg);
	}

	return 0;
}

int mutable(char[] str) {
	int size = 0, count = 0, direct = 0, indirect = 0;
	int i = 0, startOperand = 1;

	foreach(word; str.split) {
		//if (!i) {
		//	foreach(opCode; OperationCode) {
		//		writeln(opCode);
		//	}
		//}
		if (i == 1) {
			if (word == "byte") {
				size = 1;
			} else if (word == "half") {
				size = 2;
			} else {
				size = 4;
			}
			if (size && size != 4) {
				startOperand = 2;
			}
		}

		if (word[0] == '{' && word[word.length - 1] == '}') {
			direct = i - startOperand + 1;
		}

		if (word[0] == '[' && word[word.length - 1] == ']') {
			indirect = i - startOperand + 1;
		}

		i++;
		//write('[', word, ']', ' ');
	}

	count = i - startOperand;

	auto result = 0x0;
	result += (size * 0x1000);

	switch (count) {
	case 0, 1:
		result += (count * 0x100);
		break;
	case 2:
		result += 0x300;
		break;
	case 3:
		result += 0x700;
		break;
	case 4:
		result += 0xf00;
		break;
	default:
		result += 0;
	}

	switch (direct) {
	case 0, 1, 2:
		result += (direct * 0x10);
		break;
	case 3:
		result += 0x40;
		break;
	case 4:
		result += 0x80;
		break;
	default:
		result += 0x0;
	}

	switch (indirect) {
	case 0, 1, 2:
		result += indirect;
		break;
	case 3:
		result += 0x4;
		break;
	case 4:
		result += 0x8;
		break;
	default:
		result += 0x0;
	}

	//result = result ~ "QQ";



	return result;
}