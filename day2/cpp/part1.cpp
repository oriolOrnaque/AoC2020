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

			int min_ = atoi(entry);

			while(*entry != '-')
				++entry;
			++entry;

			int max_ = atoi(entry);
			++entry;

			while(*entry != ' ')
				++entry;
			++entry;

			//printf("%i %i\n", min_, max_);
			//printf("%c\n", *entry);

			const char letter = *entry;
			entry += 3;

			int counter = 0;
			while(*entry != 0x0)
			{
				if(*entry == letter)
					++counter;
				++entry;
			}

			if(counter >= min_ && counter <= max_)
				++valid_passwords;
			++total_lines;
		}

		printf("valid password: %i/%i\n", valid_passwords, total_lines);

	}

	return 0;
}
