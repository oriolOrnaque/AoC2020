#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>

int main(int argc, char* argv[])
{
	std::string line;
	std::ifstream f("input");
	if(f.is_open())
	{
		int valid_passwords = 0;
		int total_lines = 0;

		while(getline(f, line))
		{
			const char* entry = line.c_str();

			int first_pos = atoi(entry);

			while(*entry != '-')
				++entry;
			++entry;

			int second_pos = atoi(entry);
			++entry;

			while(*entry != ' ')
				++entry;
			++entry;

			const char letter = *entry;
			entry += 3;

			if(entry[first_pos-1] == letter)
				if(entry[second_pos-1] != letter)
					++valid_passwords;
			if(entry[second_pos-1] == letter)
				if(entry[first_pos-1] != letter)
					++valid_passwords;

			++total_lines;
		}

		printf("valid password: %i/%i\n", valid_passwords, total_lines);

	}

	return 0;
}
