#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main(int argc, char* argv[])
{
    if (argc == 2)
    {
        const string arch_dir = argv[1];
        const string disk_file = arch_dir + "/bin/disk.img";
        fstream fout(disk_file.c_str(), fstream::in | fstream::out | fstream::binary);
        if (!fout.good())
        {
            cerr << "Cannot open " << disk_file << endl;
            return -2;
        }
        const string vbr_file = arch_dir + "/obj/bootloader/vbr_fat16.bin";
        ifstream fin(vbr_file.c_str(), ifstream::binary);
        if (!fin.good())
        {
            cerr << "Cannot open " << vbr_file << endl;
            return -3;
        }
        char* buffer = new char[0x3DC];
        fin.seekg(3);
        fin.read(buffer, 8);
        fout.seekp(0x203);
        fout.write(buffer, 8);

        fin.seekg(0x24);
        fin.read(buffer, 0x3DC);
        fout.seekp(0x224);
        fout.write(buffer, 0x3DC);

        fin.close();
        fout.close();
    }
    else
    {
        cerr << "Not enought arguments!" << endl
             << "insert_vbr_fat16_code [arch]" << endl;
        return -1;
    }
    return 0;
}