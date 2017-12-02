#include <iostream>
#include <string>
#include <queue>
using namespace std;

int main()
{
	// variable initialize
	string dictionary = "helloworld myworld\n";
	string search, replace;
	queue<int> begPosition;
	int cnt = 0;
	
    // help show
	cout << dictionary ;
	cout << "String?:";
	// test string
	cin >> search;
	for(int idx = 0; idx < dictionary.size(); idx++)
	{
		if(dictionary[idx] == search[0]) // test whether idx matches
		{
			cnt++;
			int putinIdx = 1;
			for(int firstPos = idx+1; putinIdx < search.size(); )
			{
				if(firstPos == dictionary.size() || dictionary[firstPos] != search[putinIdx])
				{
					cnt--;
					break;
				}
				firstPos++;
				putinIdx++;
			}
			if(putinIdx == search.size())
			{
				begPosition.push(idx);
			}
		}
	}
	if(cnt)
	{
		cout << "matching for " << cnt << "times" << endl;
		cout << "Replace?:";
		cin >> replace;
		for(int idx = 0; idx < dictionary.size() - 1; idx++)
		{
			if(idx == begPosition.front())
			{
				cout << replace;
				idx += search.size() - 1;
			}
			else
			{
				cout << dictionary[idx];
			}
		}
		cout << endl;
	}
	else
	{
		cout << "No match!" << endl;
	}
	return 0;
}
