module main;

import std.stdio;
import std.string;

import spec.common;

int main(string[] args)
{
	File file = File(args[1], "r");
	char[][] wordsLine;
	string line;

	while (!file.eof()) {
		line = chomp(file.readln);
		if (line.length) {
			wordsLine = split(line.dup);
			foreach (char[] curWord; wordsLine) {
				write('[', curWord, ']', ' ');
			}
			writeln();
		}
	}

	return 0;
}
