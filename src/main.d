module main;

import std.stdio;
import std.string;
import std.conv;

import spec.common;

int main(string[] args)
{
	try {
		File file = File(args[1], "r");
		string mutLine;

	    foreach(line; file.byLine){
	    	mutLine = mutable(line);
	        foreach(word; mutLine.split)
	            write('[', word, ']', ' ');
	        writeln();
	    }
	}
	catch (Exception e) {
		stderr.writeln(e.msg);
	}

	return 0;
}

string mutable(char[] str) {
	int size = 0, count = 0, direct = 0, indirect = 0;
	int i = 0, startOperand = 1;

	foreach(word; str.split) {
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

	string result = "0x";
	result = result ~ to!string(size);

	switch (count) {
	case 0:
	case 1:
		result = result ~ to!string(count);
		break;
	case 2:
		result = result ~ to!string(3);
		break;
	case 3:
		result = result ~ to!string(7);
		break;
	case 4:
		result = result ~ 'f';
		break;
	default:
		result = result ~ 'Q';
	}

	switch (direct) {
	case 0:
	case 1:
	case 2:
		result = result ~ to!string(direct);
		break;
	case 3:
		result = result ~ to!string(4);
		break;
	case 4:
		result = result ~ to!string(8);
		break;
	default:
		result = result ~ 'Q';
	}

	switch (indirect) {
	case 0:
	case 1:
	case 2:
		result = result ~ to!string(indirect);
		break;
	case 3:
		result = result ~ to!string(4);
		break;
	case 4:
		result = result ~ to!string(8);
		break;
	default:
		result = result ~ 'Q';
	}

	return result;
}