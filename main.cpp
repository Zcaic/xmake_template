#include "eigen3\Eigen\Dense"
#include "fmt/color.h"
#include "fmt/ostream.h"
#include <iostream>

namespace Mycolors
{
    const auto green = fmt::fg(fmt::terminal_color::bright_green) | fmt::emphasis::bold;
    const auto red = fmt::fg(fmt::terminal_color::bright_red) | fmt::emphasis::bold;
    const auto yellow = fmt::fg(fmt::terminal_color::bright_yellow) | fmt::emphasis::bold;
}

using Eigen::MatrixXd;

int main()
{
    std::cout << "it is test." << std::endl;
    fmt::print(Mycolors::yellow, "it is a test.\n");
    MatrixXd m(3, 3);
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            m(i, j) = i + j;
        }
    }
    fmt::print(Mycolors::green, "{}\n", fmt::streamed(m));
}