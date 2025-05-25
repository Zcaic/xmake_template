#include <iostream>
#include"fmt/color.h"

namespace Mycolors{
    const auto green=fmt::fg(fmt::terminal_color::bright_green)|fmt::emphasis::bold;
    const auto red=fmt::fg(fmt::terminal_color::bright_red)|fmt::emphasis::bold;
    const auto yellow=fmt::fg(fmt::terminal_color::bright_yellow)|fmt::emphasis::bold;
}
int main()
{
    std::cout << "it is test." << std::endl;
    fmt::print(Mycolors::yellow,"it is a test.\n");
}